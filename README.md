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
  - for the testsuite **8123-8124** (http)

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
curl --location http://<docker-host>:8084/fhir/Practitioner/2
curl --location http://<docker-host>:8084/fhir/PractitionerRole/3
curl --location http://<docker-host>:8084/fhir/Patient/4
curl --location http://<docker-host>:8084/fhir/Medication/5
curl --location http://<docker-host>:8084/fhir/MedicationRequest/8
curl --location http://<docker-host>:8084/fhir/MedicationDispense/13
```

Searching by including references in the result:
- Query PractitionerRole with the related Organization

```bash
curl --location http://<docker-host>:8084/fhir/PractitionerRole?_include=PractitionerRole:organization
```

- Query  MedicationRequest with requester (PractitionerRole) and the Organization related to it
```bash
curl --location http://<docker-host>:8084/fhir/MedicationRequest?_include=MedicationRequest:requester&_include:iterate=PractitionerRole:organization
```

## Traffic in Tiger WebUI

The Tiger WebUI is a simple web interface to visualize the traffic between the client and the backend services. The WebUI is accessible via the following URL: [http://\<docker-host\>:8086/webui](http://localhost:8086/webui).

### VAU Handshake & user data decrypted traffic

#### VAU Handshake

The mock application vau-proxy-server sets specific HTTP headers `VAU-DEBUG-S_K1_s2c` and `VAU-DEBUG-S_K1_c2s` in the responses (M2 /M4) to indicate the encrypted data. The tiger-proxy decrypts the data and shows the decrypted data in the request & response body.

> [!IMPORTANT]
> This not specification compliant and is only supported by this mock implementation (vau-proxy-server in combination with the tiger-proxy).

#### User data
The ePA client has to set a specific HTTP header `VAU-nonPU-Tracing` in the request to indicate the encrypted data within nonPU environments ([A_24477](https://gemspec.gematik.de/docs/gemSpec/gemSpec_Krypt/latest/index.html#7.7)). Thus, the tiger-proxy decrypts and shows the decrypted data in the request & response body.

### Information traffic

#### Record Status traffic example
The offline page [./doc/html/InformationRecordStatus.mhtml](./doc/html/InformationRecordStatus.mhtml) shows an example traffic of retrieving the status of a patient health record with information service (mock).

#### Consent Decisions traffic example
The offline page [./doc/html/InformationConsentDecisions.mhtml](./doc/html/InformationConsentDecisions.mhtml) shows an example traffic of retrieving the consent decisions of a patient with information service (mock).

#### VAU and Authorization traffic example
The offline page [./doc/html/VauHandshakeAndUserSession.mhtml](./doc/html/VauHandshakeAndUserSession.mhtml)  shows a decrypted example traffic of the VAU handshake between the client and the VAU Proxy Server as well as the user session creation with authorization service (mock) & IDP (RU).

### Entitlement decrypted traffic

#### New entitlement traffic example
The offline page [./doc/html/SetEntitlement.mhtml](./doc/html/SetEntitlement.mhtml) shows a decrypted example traffic of adding a new entitlement with entitlement service (mock).

### Medication decrypted traffic

#### Electronic Medication List (eML) as PDF/A traffic example
The offline page [./doc/html/MedicationPDF.mhtml](./doc/html/MedicationPDF.mhtml) shows a decrypted example traffic of retrieving the entire medication list as PDF/A document with medication render service (mock).

#### Electronic Medication List (eML) as XHTML traffic example
The offline page [./doc/html/MedicationXHTML.mhtml](./doc/html/MedicationXHTML.mhtml) shows a decrypted example traffic of retrieving the entire medication list as XHTML document with medication render service (mock).

#### Electronic Medication List (eML) as FHIR Resource traffic example
The offline page [./doc/html/MedicationFHIR.mhtml](./doc/html/MedicationFHIR.mhtml) shows a decrypted example traffic of retrieving the entire medication list as FHIR resource with medication service (mock).

## PS-Testsuite

The PS-Testsuite is a test suite to verify specific functionality of a PS application.

### Proxy configuration for PS-Testsuite

As the testsuite container obtains Maven artefacts during execution, the internet must be accessible for the container. If the internet is only accessible via a proxy server, the settings in the [./ps-testsuite/settins.xml](./ps-testsuite/settins.xml) must be adjusted for the execution of the PS-Testsuite container. Please note that the parameter `<active>true</active>` must be set to activate the settings and the docker volume `ps-testsuite-maven` must be deleted to apply the changes.

To do this, the following entries must be adjusted:

```xml
  <proxy>
    <id>optional</id>
    <active>true</active>
    <protocol>https</protocol>
    <host>proxy.example.com</host>
    <port>8080</port>
    <username>user</username>
    <password>password</password>
    <nonProxyHosts>localhost|127.0.0.1</nonProxyHosts>
  </proxy>
```

### Running the PS-Testsuite Container in Docker

Start the testsuite container with the following command
```bash
docker-compose -f dc-testsuite.yml up
```

When the container log shows the following message, the testsuite is ready to be used and a webbrowser should call the URL [http://\<docker-host\>:8123](http://localhost:8123) to go on. Otherwise, the timeout will stop the testsuite and the container stops automatically. In this case you have to rerun the testsuite with the command above.
```bash
========================================================================================================================
  ____ _____  _    ____ _____ ___ _   _  ____  __        _____  ____  _  _______ _     _____        __  _   _ ___         
 / ___|_   _|/ \  |  _ \_   _|_ _| \ | |/ ___| \ \      / / _ \|  _ \| |/ /  ___| |   / _ \ \      / / | | | |_ _|        
 \___ \ | | / _ \ | |_) || |  | ||  \| | |  _   \ \ /\ / / | | | |_) | ' /| |_  | |  | | | \ \ /\ / /  | | | || |         
  ___) || |/ ___ \|  _ < | |  | || |\  | |_| |   \ V  V /| |_| |  _ <| . \|  _| | |__| |_| |\ V  V /   | |_| || |   _ _ _ 
 |____/ |_/_/   \_\_| \_\|_| |___|_| \_|\____|    \_/\_/  \___/|_| \_\_|\_\_|   |_____\___/  \_/\_/     \___/|___| (_|_|_)
                                                                                                                          
========================================================================================================================
09:21:12.065 [main ] INFO  d.g.t.t.l.TigerDirector - Waiting for workflow Ui to fetch status...
09:21:12.065 [main ] INFO  d.g.t.t.l.TigerDirector - Workflow UI http://localhost:8123
```

Stop the testsuite container with the following command
```bash
docker-compose -f dc-testsuite.yml down
```

### Execute the testcases

After calling the URL [http://\<docker-host\>:8123](http://localhost:8123) in a webbrowser, the workflowUI will be shown. 
As depicted in [Waiting WorkflowUI](./doc/img/testsuite/workflowUI%20-%20start%20and%20wait.png) the testcase for VAU handshake is automatically selected. Now, the testsuite will trace any traffic flow between the client and the mock services on [https://\<docker-host\>:443](https://localhost:443).
On the bottom of the page you can see the request to trigger a specific functionality within your PS application. Do so and after the finished execution click on the "Continue" button on the bottom of the page.

Now, the traffic will be analyzed and the results will be shown in the workflowUI. If everything is fine, the testcase will be marked as successful as depicted in [Successful WorkflowUI](./doc/img/testsuite/workflowUI%20-%20successful%20finished.png). 

If the testcase failed, the testcase will be marked as failed as depicted in [Failed WorkflowUI](./doc/img/testsuite/workflowUI%20-%20failed%20finished.png) and you can analyze the reason for the failure e.g. within message flow traced during the execution. Click in the upper right corner button to open the "Rbel Log Details" to have a closer look on the messages itself.

### Choose a testcase
By default, the execution of the VAU handshake test case is selected. To select a different test case, you must configure it via the .env file, in which you must adjust the value for ‘PS_TESTSUITE_TESTS’ accordingly.

### Testcases

#### Record Status
The testcase verifies the message with the information service (mock) necessary to retrieve the status of a patient health record. The testcase will be successful if the record status is successfully retrieved with the GET message.

#### Consent Decisions
The testcase verifies the message with the information service (mock) necessary to retrieve the consent decisions of a patient. The testcase will be successful if the consent decisions are successfully retrieved with the GET message.

#### VAU Handshake
The testcase verifies the VAU handshake between the client and the VAU Proxy Server (mock). The testcase will be successful if the VAU handshake is successfully completed with messages M1 to M4.

#### User Session (login)
The testcase verifies the message with the authorization service (mock) necessary to create a user session, but **NOT** the messages with the IDP (RU). The testcase will be successful if the user session is successfully created with messages `getNonce`, `send_authorization_request_sc` and `send_authcode_sc`.

#### Entitlement
The testcase verifies the message with the entitlement service (mock) necessary to create an entitlement. The testcase will be successful if the entitlement is successfully created with the POST message.

#### Medication List (eML) as PDF/A
The testcase verifies the message with the medication render service (mock) necessary to retrieve the entire medication list as PDF/A document. The testcase will be successful if the medication list is successfully retrieved with the GET message.

#### Medication List (eML) as XHTML
The testcase verifies the message with the medication render service (mock) necessary to retrieve the entire medication list as XHTML document. The testcase will be successful if the medication list is successfully retrieved with the GET message.

#### Medication List (eML) as FHIR Resource
The testcase verifies the message with the medication service (mock) necessary to retrieve the entire medication list as FHIR resource. The testcase will be successful if the medication list is successfully retrieved with the GET message.

## Overview of the backend mock services

### Using the services

The services can be accessed directly by using the exposed ports.
The following table shows the services and the related ports and protocols.
This should also give an overview of the ports to be opened in your setup.

| Service                                | Port | Protocol |
|----------------------------------------| ---- |----------|
| ePA health record system (tiger-proxy) | 443  | https    |
| vau-proxy-server                       | 8081 | http     |
| information-service                    | 8082 | http     |
| authorization-service                  | 8083 | http     |
| medication-service                     | 8084 | http     |
| medication-render-service              | 8085 | http     |
| tiger-proxy (admin)                    | 8086 | http     |
| entitlement-service                    | 8087 | http     |

> [!NOTE]
> Please feel free to modify the exposed ports in the '.env' file in order to meet your own requirements.
> The docker container internal ports are not affected by this change as well as the docker network communication.

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
  * to get HTTP code 404 use "X000000404" as header parameter 'x-insurantid'
  * to get HTTP code 409 use "X000000409" as header parameter 'x-insurantid'
* for user experience it is checked that the header x-useragent is set, otherwise HTTP code 409 is given

#### Direct example request:

To retrieve the consent decisions of a patient execute the following curl command:

```bash
curl -H "x-insurantid: Z1234567890" --location --request GET http://<docker-host>:8082/information/api/v1/ehr/consentdecisions
```

To retrieve the health record status of a patient execute the following curl command:

```bash
curl -H "x-insurantid: Z1234567890"  --location --request GET http://<docker-host>:8082/information/api/v1/ehr
```

### Authorization Service (authorization-service)

The authorization service is a component which is known from OAuth2.
Together with the IDP server it is responsible for the authentication and authorization of the user (User of a PS).
The authentication flow is described here: [Authentication Flow](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/#3.4.2).
As IDP the reference IDP is used which is addressed by the following URL: [https://idp-ref.app.ti-dienste.de](https://idp-ref.app.ti-dienste.de).
All necessary configurations like clientID are already set in the IDP.

#### Limitations:

* It will not end user session after 20 Min. (A_25006)

### Medication Service (medication-service)

The medication service is a HAPI FHIR server which provides the medication relevant data. The details about ePA Medication can be found in the related repository: [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0).

#### Limitations:
- Currently, the HAPI FHIR does not support searching resources by logical references. Therefore, the medication service does not support searching for medication requests by the patient reference. A request like `GET /MedicationRequest?subject:identifier=....` will return an error message, that it is not supported. There is already an open issue in the HAPI FHIR repository: [Issue 4723](https://github.com/hapifhir/hapi-fhir/issues/4723).

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

To retrieve the eML as FHIR Resource execute the following curl command:

```bash
curl --location http://localhost:8084/fhir/Medication?status=active
```

### Entitlement Service (entitlement-service)
The entitlement Service is responsible for managing entitlements. 
The service is described in the following openAPI specification: [EntitlementService](https://github.com/gematik/ePA-Basic/blob/ePA-3.0.1/src/openapi/I_Entitlement_Management.yaml).

The entitlement service is NOT linked with the other services, and therefore, if an entitlement is missing, no error message is returned by the other services.

#### Direct example request:

Adding a new entitlement:
```bash
curl --location --request POST \
  'http://<docker-host>:8087/epa/basic/api/v1/ps/entitlements' \
  -H 'accept: application/json' \
  -H 'x-insurantid: Z123456789' \
  -H 'x-useragent: CLIENTID1234567890AB/2.1.12-45' \
  -H 'Content-Type: application/json' \
  -d '{"jwt": "<your valid jwt>"}'
```

List all existing entitlements stored within the service (only available with the mock service)

> [!IMPORTANT]
> This is only available with the mock services. In production only the patient and its representative has access to this interface method.

```bash
curl --location 'http://localhost:8087/epa/basic/api/v1/entitlements' \
  -H 'x-insurantid: X110435031' \
  -H 'x-useragent: CLIENTID1234567890AB/2.1.12-45'
```

#### Limitations
- No JWT signature verification
- No OCSP check during the validation of the client certificate
- HMAC validation work only with gematik test cards

## Troubleshooting / FAQs

### VAU-Proxy-Server

#### Response with Transcript Error (5)

The decryption of the incoming message was faulty. In this case, a look at the logs from the VAU proxy server can help. Additional information about the exact cause of the error should be written in the log.

If this does not help, please send us the log file in a service ticket.

```bash
docker logs vau-proxy-server > vau-proxy-server.log
```

### IDP

#### IDP sends HTTP Response Code 403

Please make sure that you use HTTP/1.1 when communicating with the IDP. 

## Resources

- [ePA Implementation Guide](https://gemspec.gematik.de/docs/gemILF/gemILF_PS_ePA/latest/index.html)
- [ePA-Basic](https://github.com/gematik/ePA-Basic/tree/ePA-3.0.1)
- [ePA-Medication](https://github.com/gematik/ePA-Medication/tree/ePA-3.0)
