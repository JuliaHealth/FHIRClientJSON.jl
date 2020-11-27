@testset "Basic reading" begin
    recordings_directory = joinpath(@__DIR__, "recordings")
    mkpath(recordings_directory)
    BrokenRecord.configure!(; path = recordings_directory)

    anonymous_auth = FHIRClientJSON.AnonymousAuth()
    oauth2_auth = FHIRClientJSON.OAuth2()
    FHIRClientJSON.set_token!(oauth2_auth, "helloworld")
    jwt_auth = FHIRClientJSON.JWTAuth()
    FHIRClientJSON.set_token!(jwt_auth, "helloworld")
    username_password_auth_1 = FHIRClientJSON.UsernamePassAuth("helloworld")
    FHIRClientJSON.set_password!(username_password_auth_1, "helloworld")
    username_password_auth_2 = FHIRClientJSON.UsernamePassAuth(; username = "helloworld")
    FHIRClientJSON.set_password!(username_password_auth_2, "helloworld")
    auths = [
        anonymous_auth,
        oauth2_auth,
        jwt_auth,
        username_password_auth_1,
        username_password_auth_2,
    ]

    for (i, auth) in enumerate(auths)
        base_url = FHIRClientJSON.BaseURL("https://hapi.fhir.org/baseR4")
        client = FHIRClientJSON.Client(base_url, auth)
        @test FHIRClientJSON.get_base_url(client) == base_url
        search_request_path = "/Patient?given=Jason&family=Argonaut"
        response_search_results_bundle = BrokenRecord.playback(() -> FHIRClientJSON.request(client, "GET", search_request_path), "recording-$(i)-1.bson")
        patient_id = response_search_results_bundle.entry[1].resource.id
        patient_request = "/Patient/$(patient_id)"
        patients = [
            BrokenRecord.playback(() -> FHIRClientJSON.request(client, "GET", patient_request), "recording-$(i)-2.bson")
            BrokenRecord.playback(() -> FHIRClientJSON.request(client, "GET", patient_request; body = JSON3.read("{}")), "recording-$(i)-3.bson")
            BrokenRecord.playback(() -> FHIRClientJSON.request(client, "GET", patient_request; query = Dict{String, String}()), "recording-$(i)-4.bson")
            BrokenRecord.playback(() -> FHIRClientJSON.request(client, "GET", patient_request; body = JSON3.read("{}"), query = Dict{String, String}()), "recording-$(i)-5.bson")
        ]
        for patient in patients
            @test patient isa AbstractDict
            @test only(patient.name).use == "usual"
            @test only(patient.name).text == "Jason Argonaut"
            @test only(patient.name).family == "Argonaut"
            @test only(only(patient.name).given) == "Jason"
            @test patient.birthDate == "1985-08-01"
        end
        Base.shred!(auth)
        Base.shred!(client)
    end

    for i in 1:length(auths)
        Base.shred!(auths[i])
    end
end
