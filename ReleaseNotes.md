<img align="right" width="200" height="37" src="Gematik_Logo_Flag_With_Background.png" alt="Gematik Logo"/> <br/>

# Release notes epa-deployment for ePA 3.x and above
## Release 1.0.19 (ePA 3.0.x)
- Updated version of entitlement service to 1.0.9
  - fixed decoding of hcv in jwt
- Updated version of ps-testsuite to 1.0.18
  - fixed hcv regex in entitlement testcase
  
## Release 1.0.18 (ePA 3.0.x)
- Updated version of tiger to 3.6.1 (information service / tiger-proxy)
- Updated version of entitlement service to 1.0.8
  - improve error handling and messaging for pruefziffer validation
- Fixed spaces around the equals sign in Docker Compose environment variables
- Updated version of ps-testsuite to 1.0.17
  - fixed entitlement test case

## Release 1.0.17 (ePA 3.0.x)
- Updated version of tiger to 3.6.0 (information service / tiger-proxy)
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated version of ps-testsuite to 1.0.16
  - added check for HTTP Header `x-useragent` in outer HTTP request (not VAU encrypted part) within KOB and optional testcase
  - added regex check for HTTP Header `x-useragent` in inner HTTP request within optional testcases
  - checking HTTP header field name `x-useragent`, `x-insurantid` & `VAU-nonPU-Tracing` is now case-insensitive (as in standard RFC-9110 Section-5.1 )
  - added regex check for hcv and auditEvidence in jwt of inner entitlement request
- Updated version of entitlement service to 1.0.7
  - Updated setEntitlementsPs - C_12143 support for VSDM-Prüfziffer Version 2

## Release 1.0.16 (ePA 3.0.x)
- Updated version of asforepa (authorization-service) to 3.0.1
  - see [release notes](https://github.com/gematik/app-asforepa/blob/main/ReleaseNotes.md) for details
  e.g. add validation for length of client attest signature
- Updated version of vau-proxy-server to 1.0.16
- Updated version of ps-testsuite to 1.0.14
  - fix for the scope check in the OIDC flow
  - select & execute test cases via webpage
  - validations of reason phrase in HTTP responses are now case-insensitive 
- Updated version of entitlement service to 1.0.6
  - updated TSL to support new SMCBs with actual issuer CAs
  - updated OpenAPI to latest ePA 3.0.x version
- Updated version of tiger to 3.4.6 (information service / tiger-proxy)
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated version of HAPI FHIR (medication service) to 7.6.0
- Minor changes in the documentation
  - test case selection and execution via webpage (instead of environment variable)

## Release 1.0.15
- Updated version of medication-render service to 1.0.6
- Updated version of vau-proxy-server to 1.0.11
- Updated information and entitlement services

## Release 1.0.14

### updated
- Updated version of tiger-proxy to 3.3.0 & tiger-zion (information-service) to 3.3.0
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated version of ps-testsuite to 1.0.11
  - slightly modified ‘accept’ HTTP header checks so that it is proven that the expected content type is part of it
  - additional checks of JWT 'alg' header parameter to exists and is 'ES256' or 'PS256' when  communicating with the ePA authorization service
  - updated to tiger-lib version 3.3.0
- Updated version of vau-proxy-server to 1.0.10
  - fixed response body of `/{cid}/restart` containing CBOR encoded data without VAU encryption
- Updated ReadMe
  - update RBEL traffic examples showing raw (encoded/encrypted) data as well as HTTP request and responses
  - update RBEL traffic of VAU handshake and user session showing the IDP communication as it is needed for OIDC flow

## Release 1.0.13

### updated
- Updated certificate for tiger-proxy
- Updated version of medication-render to 1.0.5
- Added more medication samples
- Updated testsuite to 1.0.9

## Release 1.0.12

### updated
- Updated version of entitlement-service to 1.0.3
  - updated server web interface to release version of ePA 3.0.2 (OpenAPI I_Entitlement_Management.yaml)
- Updated version of vau-proxy-server to 1.0.9
  - updated to lib-vau 1.0.12
    - Extended trace logging for received encrypted VAU messages (user data)
    - Error message with more details in case of an exception during the VAU decryption process
  - VAU-DEBUG-S_K2_c2s_keyConfirmation base64 encoding (instead of base64url encoding)
  - DER coded Komponenten-PKI-CA is given back when /CertData is called (valid until 08/2025)
  - UnknownKeyIdException includes the unknown key id in the error message (not in HEX Format)
- Update ReadMe
  - how to enable lib-vau TRACE logging for troubleshooting
  - correct HTTP status code docu returned by information-service (204)

## Release 1.0.11

### updated

- Updated version of tiger-proxy to 3.1.3 & tiger-zion (information-service) to 3.1.3
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated version of entitlement-service to 1.0.2
  - updated pattern for x-useragent validation
- Updated version of authorization-service to 2.0.3
  - see [release notes](https://github.com/gematik/app-asforepa/blob/main/ReleaseNotes.md) for details
   e.g. updated pattern for x-useragent validation
   e.g. send matching ErrorResponse with ErrorCode as defined in OpenAPI for Authorization Service
- Update version of ps-testsuite to 1.0.8
  - updated plugin to validate FHIR resources against epa-medication 3.0.2
- Updated version of vau-proxy-server to 1.0.8
  - update parameter name "Connection-Start" in Response of /Vau-Status following the specification (typo correction)
  - added `/{cid}/restart` to destroy a VAU session
    - the CID will be released
    - the state machines will be destroyed
    - a new VAU session will NOT be created
- Update ReadMe
  - maven proxy configuration for ps-testsuite to access the internet
  - introduce FAQ section (finding during support)
  - update examples for information service due to insurant parameter change

## Release 1.0.10

### updated
- Updated version of medication-render to 1.0.3
  - internal updates due to FHIR sample fixes
- Updated version of authorization-service to 2.0.1
  - see [release notes](https://github.com/gematik/app-asforepa/blob/main/ReleaseNotes.md) for details
    e.g. bug fix in send_authcode_sc response (JSON structure for HTTP CODE 2xx)
- Updated VauHandshakeAndUserSessionCreation example due to authorization-service fix

### fixed
- Fixed some FHIR sample for PractitionerRole

## Release 1.0.9

### updated
- Updated version of tiger-proxy to 3.1.2 & tiger-zion (information-service) to 3.1.2
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated version of medication-render to 1.0.2
  - modified code to work with the new referencing structure inside medication requests
- Updated version of HAPI FHIR server (medication-service) to HAPI 7.2.0
- Updated version of ps-testsuite to 1.0.7
  - added testcase for medication retrieving an eML as PDF/A
  - added testcase for medication retrieving an eML as XHTML
  - added testcase for medication retrieving an eML as FHIR resource/bundle
  - added testcase for record status retrieval
  - added testcase for consent decision retrieval

## added
- example traffic for retrieving a medication as FHIR resource/bundle
- example traffic for retrieving the record status
- example traffic for retrieving the consent decision

### fixed
- Fixed some FHIR examples
  - Medication Request sample
    - Fixed patient & requester reference
    - Fixed authoredOn
  - Medication Dispense sample
    - Fixed patient reference
    - Fixed profile url
    - Fixed whenHandedOver date
  - Patient sample
    - Fixed identifier system url

## Release 1.0.8

### updated
- Updated configuration of information-service
  - return codes for getRecordStatus & userexperience are changed from 200 to 204 and 201 resp.
  - use header variable `x-insurantid` to address the health record instead of path variable (C_11834)
- Updated medication dispense samples
  - added a sample with substitution
- Updated version of vau-proxy-server to 1.0.7
  - updated to lib-vau 1.0.11
  - added route definition with asterix wildcard for vau-proxy-server
  - added exception logging in case of VAU handshake errors
  - fixed handling of hex string with leading zero in sha256 path variable for /CertData.{sha256}-{version}

### fixed
- Fixed medication reference in the related samples

### added
- example traffic for retrieving a medication as PDF/A
- example traffic for retrieving a medication as XHTML

## Release 1.0.7

### updated
- Updated version of vau-proxy-server to 1.0.6
  - updated to lib-vau 1.0.10 
    - Corrected 8 byte request counter using type long (8 bytes) instead of type int (4 bytes)
- Updated version of authorization-service to 2.0.0
  - see [release notes](https://github.com/gematik/app-asforepa/blob/main/ReleaseNotes.md) for details
- Updated version of ps-testsuite to 1.0.4
  - added testcase for login (user session creation) with authorization-service (mock) & IDP (RU)
  - added testcase to set an entitlement with entitlement-service (mock)
- Updated version of tiger-proxy to 3.0.5 & tiger-zion (information-service) to 3.0.5
  - see [release notes](https://github.com/gematik/app-Tiger/blob/master/ReleaseNotes.md) for details
- Updated documentation
  - how to select the testcase when running the testsuite (ps-testsuite container)
  - example traffic for adding a new entitlement
  - curl example to get a list of existing entitlements within the mock service

## Release 1.0.6

### fixed
- Updated version of vau-proxy-server to 1.0.5
  - fixed issue with encrypted response from medication-render service replying with an eML as PDF/A (content-length != payload size)

### added
- .env file to set the environment variables for the services (e.g. change exposed ports on docker-host)
- initial entitlement-service mock
  - started with all other mock services via dc-mocks.yaml
  - processes & validates incoming new entitlement request (see README.md)

## Release 1.0.5

### added
- Initial setup to run a PS testsuite
  - Added docker-compose file to run the PS-Testsuite
  - Added documentation to run the PS-Testsuite
  - Includes test case for VAU handshake

### updated
- Updated used docker image version of information-service to 3.0.4
- Updated version of tiger-proxy to 3.0.4

## Release 1.0.4

### updated
- Updated version of vau-proxy-server to 1.0.4
  - updated to lib-vau 1.0.9

## added
- Documentation updates
  - Added information about limitations of the authorization mock services
  - Added information about the necessary HTTP headers for the VAU handshake and user data decryption in tiger-proxy
  - Added example traffic of the VAU handshake and the user session creation with authorization service (mock) & IDP (RU)

## Release 1.0.3

### fixed
- Updated version of vau-proxy-server to 1.0.3
  - updated to lib-vau 1.0.8
  - replaced manual HTTP message handling with Netty library implementation
- Documentation updates
  - Added information about the required applications, ports & resources
  - Added information about the supported use cases and restrictions

## Release 1.0.2

### fixed
- Updated versions of mock services

## Release 1.0.1

### fixed
- Optimized release process

## Release 1.0.0
- Initial version
- Available functionalities:
  - vau encryption/decryption
  - login use case (with IDP and Authorization service)
