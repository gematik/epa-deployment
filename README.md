# ePA-deployment

![epa-deployment.png](/doc/img/draw-io/epa-deployment.png)
### Project includes docker-compose and other relevant files to run all relevant mock services for ePA in a docker environment.

#### Overview of the services

##### Tiger Proxy (tiger-proxy)
The tiger proxy is a reverse proxy which is used to route the incoming requests to the correct service. It is accessible via port 443 as it is using TLS/SSL. The proxy is also doing the SSL termination for the services. The configuration of the proxy is done in the `/tiger-proxy/application.yaml` file.

##### VAU Proxy Server (vau-proxy-server)
By specification some services inside the ePA has to be encrypted/decrypted by the VAU. The VAU Proxy Client handles the VAU handshake for a given PS instance. This handshake enables the VAU Proxy Client to encrypt messages which can be decrypted by the VAU Proxy Server before the messages are passed onto ePA services. 

##### Information Service (information-service)
This service provides information about the health record of a patient. The capabilities of the service are described detailed in following openAPI specification: [InformationService](https://github.com/gematik/ePA-Basic/blob/ePA-3.0/src/openapi/I_Information_Service.yaml).

##### Authorization Service (authorization-service)
The authorization service is a component which is known from OAuth2. 
Together with the IDP server it is responsible for the authentication and authorization of the user (User of a PS). 
The authentication flow is described here: [Authentication Flow](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/#3.4.2). 
As IDP the reference IDP is used which is addressed by the following URL: [IDP](https://idp-ref.app.ti-dienste.de). 
All necessary configurations like clientID are already set in the IDP.

##### Medication Render Service (medication-render-service)
The medication render service is responsible for rendering the medication list (eML) data in a human readable form. 
The service is described in the following openAPI specification: [MedicationRenderService](https://github.com/gematik/ePA-Medication/blob/ePA-3.0/src/openapi/I_Medication_Service_eML_Render.yaml).

##### Medication Service (medication-service)
The medication service is a HAPI FHIR server which provides the medication relevant data. The details about ePA Medication can be found in the related repository: [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0).

#### Using the services
The services can be accessed directly by using the exposed ports. 
The following table shows the services and the related ports and protocols.
This should also give an overview of the ports to be opened in your setup. 

| Service                   | Port | Protocol |
|---------------------------|------|----------|
| tiger-proxy               | 443  | https    |
| vau-proxy-server          | 8081 | http     |
| information-service       | 8082 | http     |
| authorization-service     | 8083 | http     |
| medication-service        | 8084 | http     |
| medication-render-service | 8085 | http     |

#### Running the services
Start the services with the following command
```bash
docker-compose -f dc-mocks.yml up
```
Stop these services with the following command
```bash
docker-compose -f dc-mocks.yml down
```

Accessing the services directly via the exposed ports.

##### Medication Service
To import medications related data to the medication-service execute the following script from the medication folder:
```bash
cd medication
./import.sh
```

After successful import the data can be accessed via the following curl commands:
```bash
curl --location http://<docker-host>:8084/fhir/Organization/1
```

```bash
curl --location http://<docker-host>:8084/fhir/PractitionerRole/2
```

```bash
curl --location http://<docker-host>:8084/fhir/Practitioner/3
```

```bash
curl --location http://<docker-host>:8084/fhir/Patient/4
```

```bash
curl --location http://<docker-host>:8084/fhir/Medication/5
```

```bash
curl --location http://<docker-host>:8084/fhir/MedicationRequest/8
```

```bash
curl --location http://<docker-host>:8084/fhir/MedicationDispense/13
```

##### Medication Render Service
To retrieve the eML as XHTML execute the following curl command:
```bash
curl --location --request GET http://<docker-host>:8085/epa/medication/render/v1/eml/xhtml --header 'Accept: text/html' --header 'x-insurantid: Z1234567891'
```
To retrieve the same eML as PDF/A document execute the following curl command:
```bash
curl --location --request GET http://<docker-host>:8085/epa/medication/render/v1/eml/pdf --header 'Accept: application/pdf' --header 'x-insurantid: Z1234567891' --output eml.pdf
```

##### Information Service
To retrieve the consent decisions of a patient execute the following curl command:
```bash
curl --location --request GET http://<docker-host>:8082/information/api/v1/ehr/Z1234567891/consentdecisions
```

To retrieve the health record status of a patient execute the following curl command:
```bash
curl --location --request GET 'http://<docker-host>:8082/information/api/v1/ehr/Z1234567891'
```

#### Resources
- [ePA Implementation Guide](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/index.html)
- [ePA-Basic](https://github.com/gematik/ePA-Basic/tree/ePA-3.0.1)
- [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0)
