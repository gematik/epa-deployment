<img align="right" width="200" height="37" src="Gematik_Logo_Flag_With_Background.png" alt="Gematik Logo"/> <br/>

# Release notes epa-deployment for ePA 3.x and above

## Release 1.0.10
- Updated version of medication-render to 1.0.3
  - internal updates due to FHIR sample fixes
- Updated version of authorization-service to 2.0.1
  - see [release notes](https://github.com/gematik/app-asforepa/blob/main/ReleaseNotes.md) for details
    e.g. bug fix in send_authcode_sc response (JSON structure for HTTP CODE 2xx)t
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
