<img align="right" width="200" height="37" src="Gematik_Logo_Flag_With_Background.png" alt="Gematik Logo"/> <br/>

# Release notes epa-deployment for ePA 3.x and above

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
