```@meta
CurrentModule = FHIRClientJSON
```

# Examples

## Basic example

```@repl
using FHIRClientJSON
base_url = FHIRClientJSON.BaseURL("https://hapi.fhir.org/baseR4")
auth = FHIRClientJSON.AnonymousAuth()
client = FHIRClientJSON.Client(base_url, auth)
bundle = FHIRClientJSON.request_json(client, "GET", "/Patient?given=Jason&family=Argonaut")
patients = bundle.entry;
patient_id = patients[1].resource.id
patient = FHIRClientJSON.request_json(client, "GET", "/Patient/$(patient_id)")
patient.name
patient.address
```
