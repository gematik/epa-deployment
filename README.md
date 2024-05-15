# ePA-deployment

## Motivation

The project is intended to provide a simple way to run the ePA backend services in a local docker environment and includes docker-compose and other relevant files. This should help to get a better understanding of the ePA services and should help to develop & test **ePA 3.0.x** for PS applications.

> [!IMPORTANT]
> This project uses mock implementations based on the ePA specification and focuses on some selected backend services. The mock implementations try to realize many aspects of the specification, but are not 1:1 equivalent to a productive environment. The specification is always leading and should be used as a reference.

In particular, the following uses cases are covered:

- Perform VAU handshake and send and receive encrypted data
- Create a user session with the ePA authorization service and IDP (RU)
- Create an entitlement **(not included yet)**
- Get the medication list (eML) for a patient as XHTML and PDF/A document

## Setup

### Prerequisites

You the following tools to run the services:

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Curl](https://curl.se/)

You need the following system resources to run the services:

- at least 4 GB of RAM
- the following ports should be available:
  - for the ePA backend services **443** (https)
  - port range to directly access the mock services via the exposed ports (**8081-8090**)

### Running the services with docker-compose

Start the mock services with the following command

```bash
docker-compose -f dc-mocks.yml up
```

Stop these services with the following command

```bash
docker-compose -f dc-mocks.yml down
```

### Importing default data to the Medication Service

To import medications related data to the medication-service execute the following script from the medication folder:

```bash
cd medication
./import.sh
```

After successful import the data can be accessed via the following curl commands (placeholder <docker-host> have to be replaced with the actual host IP or name):

```bash
curl --location http://<docker-host>:8084/fhir/Organization/1
curl --location http://<docker-host>:8084/fhir/PractitionerRole/2
curl --location http://<docker-host>:8084/fhir/Practitioner/3
curl --location http://<docker-host>:8084/fhir/Patient/4
curl --location http://<docker-host>:8084/fhir/Medication/5
curl --location http://<docker-host>:8084/fhir/MedicationRequest/8
curl --location http://<docker-host>:8084/fhir/MedicationDispense/13
```

## Traffic in Tiger WebUI

The Tiger WebUI is a simple web interface to visualize the traffic between the client and the backend services. The WebUI is accessible via the following URL: [http://<docker-host>:8086/webui](http://<docker-host>:8086/webui).

### VAU Handshake & user data decrypted traffic

#### VAU Handshake

The mock application vau-proxy-server sets specific HTTP headers `VAU-DEBUG-S_K1_s2c` and `VAU-DEBUG-S_K1_c2s` in the responses (M2 /M4) to indicate the encrypted data. The tiger-proxy decrypts the data and shows the decrypted data in the request & response body.

> [!IMPORTANT]
> This not specification compliant and is only supported by this mock implementation (vau-proxy-server in combination with the tiger-proxy).

#### User data
The ePA client has to set a specific HTTP header `VAU-nonPU-Tracing` in the request to indicate the encrypted data within nonPU environments ([A_24477](https://gemspec.gematik.de/docs/gemSpec/gemSpec_Krypt/latest/index.html#7.7)). Thus, the tiger-proxy decrypts and shows the decrypted data in the request & response body.

The following screenshot shows the decrypted traffic of the VAU handshake between the client and the VAU Proxy Server:

In file [./doc/html/VauHandshakeAndUserSession.mhtml](./doc/html/VauHandshakeAndUserSession.mhtml) you can find an example traffic of the VAU handshake and the user session creation with authorization service (mock) & IDP (RU).

## Overview of the backend mock services

### Using the services

The services can be accessed directly by using the exposed ports.
The following table shows the services and the related ports and protocols.
This should also give an overview of the ports to be opened in your setup.


| Service                   | Port | Protocol |
| ------------------------- | ---- | -------- |
| tiger-proxy               | 443  | https    |
| vau-proxy-server          | 8081 | http     |
| information-service       | 8082 | http     |
| authorization-service     | 8083 | http     |
| medication-service        | 8084 | http     |
| medication-render-service | 8085 | http     |
| tiger-proxy (admin)       | 8086 | http     |

![epa-deployment.png](/doc/img/draw-io/epa-deployment.png)

> [!IMPORTANT]
> Please use the already existing TI services through the connector e.g. to access the IDP (RU) using the following URL:
> https://idp-ref.zentral.idp.splitdns.ti-dienste.de

### Tiger Proxy (tiger-proxy)

The tiger proxy is a reverse proxy which is used to route the incoming requests to the correct service. It is accessible via port 443 as it is using TLS/SSL. The proxy is also doing the SSL termination for the services. The configuration of the proxy is done in the `/tiger-proxy/application.yaml` file.

#### Limitations:

* server certificate is generated on-the-fly using the `/tiger-proxy/ca.p12` as authority chain
* OCSP stabling is currently not supported

### VAU Proxy Server (vau-proxy-server)

By specification some services inside the ePA has to be encrypted/decrypted by the VAU. The VAU Proxy Client handles the VAU handshake for a given PS instance. This handshake enables the VAU Proxy Client to encrypt messages which can be decrypted by the VAU Proxy Server before the messages are passed onto ePA services.

#### Limitations:

* interface operation/path to request the status of user authentication is not fully supported (A_25143) > `/VAU-Status as HTTP-GET`
  * "User-Authentication" is always "None"
  * "Connnection-Start" is the timestamp when M3 message of VAU handshake was successfully validated & completed on backend side (typo in gemSpec_Krypt <= 2.32.0)
* interface operation/path to request AUT-VAU certificate + certificate chain via /CertData as HTTP-GET is not fully supported (A_24957) *
  * rch_chain uses certificates from https://download.tsl.ti-dienste.de as array content (> RCA5)

### Information Service (information-service)

This service provides information about the health record of a patient. The capabilities of the service are described detailed in following openAPI specification: [InformationService](https://github.com/gematik/ePA-Basic/blob/ePA-3.0/src/openapi/I_Information_Service.yaml).

#### Limitations:

* for consent decisions it will always send "permit" for "medication" as well as "erp-submission"
* for record status it will always send HTTP code 200 (OK)
* false case for both operations:
  * to get HTTP code 404 use insurantId "X000000404" as path parameter
  * to get HTTP code 409 use insurantId "X000000409" as path parameter
* for user experience it is checked that the header x-useragent is set, otherwise HTTP code 409 is given

#### Direct example request:

To retrieve the consent decisions of a patient execute the following curl command:

```bash
curl --location --request GET http://<docker-host>:8082/information/api/v1/ehr/Z1234567891/consentdecisions
```

To retrieve the health record status of a patient execute the following curl command:

```bash
curl --location --request GET http://<docker-host>:8082/information/api/v1/ehr/Z1234567891
```

### Authorization Service (authorization-service)

The authorization service is a component which is known from OAuth2.
Together with the IDP server it is responsible for the authentication and authorization of the user (User of a PS).
The authentication flow is described here: [Authentication Flow](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/#3.4.2).
As IDP the reference IDP is used which is addressed by the following URL: [https://idp-ref.app.ti-dienste.de](https://idp-ref.app.ti-dienste.de).
All necessary configurations like clientID are already set in the IDP.

#### Limitations:

* It will not end user session after 20 Min. (A_25006)
* The validation of the client attest signature is not specification-compliant. Signatures based on Brainpool curves with the algorithm identifier "ES256" are currently rejected as invalid (A_24886)

### Medication Service (medication-service)

The medication service is a HAPI FHIR server which provides the medication relevant data. The details about ePA Medication can be found in the related repository: [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0).

### Medication Render Service (medication-render-service)

The medication render service is responsible for rendering the medication list (eML) data in a human-readable form.
The service is described in the following openAPI specification: [MedicationRenderService](https://github.com/gematik/ePA-Medication/blob/ePA-3.0/src/openapi/I_Medication_Service_eML_Render.yaml).

#### Direct example request:

To retrieve the eML as XHTML execute the following curl command:

```bash
curl --location --request GET http://<docker-host>:8085/epa/medication/render/v1/eml/xhtml --header 'Accept: text/html' --header 'x-insurantid: Z1234567891'
```

To retrieve the same eML as PDF/A document execute the following curl command:

```bash
curl --location --request GET http://<docker-host>:8085/epa/medication/render/v1/eml/pdf --header 'Accept: application/pdf' --header 'x-insurantid: Z1234567891' --output eml.pdf
```

## Resources

- [ePA Implementation Guide](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/index.html)
- [ePA-Basic](https://github.com/gematik/ePA-Basic/tree/ePA-3.0.1)
- [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0)
