docker build -t geant4-builder .
docker run --rm -v ${PWD}:/io -e G4=geant4.10.05.p01 geant4-builder
docker run --rm -v ${PWD}:/io -e G4=geant4.10.06.p03 geant4-builder
docker run --rm -v ${PWD}:/io -e G4=geant4.10.07.p01 geant4-builder
