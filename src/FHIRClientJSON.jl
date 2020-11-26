module FHIRClientJSON

import Base64
import HTTP
import JSON3

include("types.jl")

include("credentials.jl")
include("headers.jl")
include("requests.jl")

end # end module FHIRClientJSON
