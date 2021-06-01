# Geant4 Builder: Builds Geant4 deb packages for Ubuntu using Docker
[Geant4](http://geant4.web.cern.ch/) unfortunately does not provide compiled packages.
Here, a Docker container with the required dependencies is created that will compile and build Geant4 deb packages for Ubuntu 20.04 LTS (focal).
This is useful for testing Geant4 applications (like [G4Horus](https://github.com/janmayer/G4Horus)) on CI Systems like Github Actions and Travis-CI.


## Requirements
- Docker on any host operating system


## Usage
### On Linux:
```bash
docker build -t geant4-builder .
docker run --rm -v $(pwd):/io -e G4=geant4.10.05.p01 geant4-builder
docker run --rm -v $(pwd):/io -e G4=geant4.10.06.p03 geant4-builder
docker run --rm -v $(pwd):/io -e G4=geant4.10.07.p01 geant4-builder
```

### On Windows
Note: To use the run.ps1 script, you'll need to enable scripts first - or just run the commands manually
```powershell
docker build -t geant4-builder .
docker run --rm -v ${PWD}:/io -e G4=geant4.10.05.p01 geant4-builder
docker run --rm -v ${PWD}:/io -e G4=geant4.10.06.p03 geant4-builder
docker run --rm -v ${PWD}:/io -e G4=geant4.10.07.p01 geant4-builder
```
