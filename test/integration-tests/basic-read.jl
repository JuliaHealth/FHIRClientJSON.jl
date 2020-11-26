@testset "Basic reading" begin
    anonymous_auth = FHIRClientJSON.AnonymousAuth()
    oauth2_auth = FHIRClientJSON.OAuth2()
    FHIRClientJSON.set_token!(oauth2_auth, "helloworld")
    jwt_auth = FHIRClientJSON.JWTAuth()
    FHIRClientJSON.set_token!(jwt_auth, "helloworld")
    username_password_auth_1 = FHIRClientJSON.UsernamePassAuth("helloworld")
    FHIRClientJSON.set_password!(username_password_auth_1, "helloworld")
    username_password_auth_2 = FHIRClientJSON.UsernamePassAuth(; username = "helloworld")
    FHIRClientJSON.set_password!(username_password_auth_2, "helloworld")
    all_auths = [
        anonymous_auth,
        oauth2_auth,
        jwt_auth,
        username_password_auth_1,
        username_password_auth_2,
    ]
    for auth in all_auths
        base_url = FHIRClientJSON.BaseURL("https://hapi.fhir.org/baseR4")
        client = FHIRClientJSON.Client(base_url, auth)
        @test FHIRClientJSON.get_base_url(client) == base_url
        search_request_path = "/Patient?given=Jason&family=Argonaut"
        response_search_results_bundle = FHIRClientJSON.request(client, "GET", search_request_path)
        patient_id = response_search_results_bundle.entry[1].resource.id
        patient_request = "/Patient/$(patient_id)"
        patients = [
            FHIRClientJSON.request(client, "GET", patient_request),
            FHIRClientJSON.request(client, "GET", patient_request; body = JSON3.read("{}")),
            FHIRClientJSON.request(client, "GET", patient_request; query = Dict{String, String}()),
            FHIRClientJSON.request(client, "GET", patient_request; body = JSON3.read("{}"), query = Dict{String, String}())
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
    for i in 1:length(all_auths)
        Base.shred!(all_auths[i])
    end
end
