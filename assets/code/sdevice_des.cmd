# Material parameters, physical models, trap and tunneling settings are not published.

File {
  Grid= "@tdr@"
  Parameter= "@parameter@"
  Current= "@plot@"
  Plot= "@tdrdat@"
  Output= "@log@"
}

Electrode {
  { Name="sss" Voltage=0. material="Aluminum" Schottky }
  { Name="ddd" Voltage=0. material="Gold" Schottky }
  { Name="ggg" Voltage=0. Workfunction=[REDACTED]}
}

# Physics { ... }  [REDACTED]

Plot {
  Potential eQuasiFermi hQuasiFermi
  eDensity hDensity
  Current eCurrent hCurrent
  ElectricField SpaceCharge
  eMobility  hMobility
  eVelocity  hVelocity
  Doping DonorConcentration AcceptorConcentration
  EffectiveIntrinsicDensity IntrinsicDensity
  Current/Vector eCurrent/Vector hCurrent/Vector
  CurrentPotential
  ElectricField/Vector
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  LatticeTemperature eTemperature hTemperature
  SRHRecombination AugerRecombination RadiativeRecombination
  Band2BandGeneration TotalRecombination SurfaceRecombination
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  BandGap BandGapNarrowing ElectronAffinity
  ConductionBandEnergy ValenceBand
  eQuantumPotential hQuantumPotential
  eTrappedCharge hTrappedCharge
  eInterfaceTrappedCharge hInterfaceTrappedCharge
  TotalTrapConcentration TotalInterfaceTrapConcentration
  eGapStatesRecombination hGapStatesRecombination
  lHeatFlux TotalHeat eJouleHeat hJouleHeat
  PeltierHeat ThomsonHeat RecombinationHeat
  DissipationRateDensity
  ThermalConductivity LatticeHeatCapacity
  Potential eQuasiFermi hQuasiFermi
  eDensity hDensity SpaceCharge
  Current eCurrent hCurrent CurrentPotential
  ElectricField SemiconductorElectricField InsulatorElectricField
  eMobility hMobility
  eVelocity hVelocity
  Doping DonorConcentration AcceptorConcentration
  Current/vector eCurrent/vector hCurrent/vector
  DisplacementCurrent/vector
  ElectricField/vector eGradQuasiFermi/vector hGradQuasiFermi/vector
  eVelocity/vector hVelocity/vector
  eDriftVelocity/vector hDriftVelocity/vector
  eTrappedCharge hTrappedCharge
  eInterfaceTrappedCharge hInterfaceTrappedCharge
  TotalTrapConcentration TotalInterfaceTrapConcentration
  eGapStatesRecombination hGapStatesRecombination
  DeepLevels
  TrappingRates
  LatticeTemperature eTemperature hTemperature
  lHeatFlux TotalHeat
  eJouleHeat hJouleHeat JouleHeat
  PeltierHeat ThomsonHeat RecombinationHeat
  DissipationRateDensity
  OpticalAbsorptionHeat
  ThermalConductivity LatticeHeatCapacity
  eThermoElectricPower hThermoElectricPower
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  eAlphaAvalanche hAlphaAvalanche
  eIonIntegral hIonIntegral MeanIonIntegral
  ConductionBandEnergy ValenceBandEnergy
  ElectronAffinity
  BandGap EffectiveBandGap BandGapNarrowing
  QCEffectiveBandGap
  xMolefraction yMolefraction
  SRH SurfaceRecombination
  Auger eAugerRecombination hAugerRecombination
  Radiative
  eLifeTime hLifeTime
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  TotalRecombination
  
}

Math {
  NumberOfThreads=4
  ParallelLicense (Wait)
  Wallclock
  Digits=7
  Iterations=60
  Extrapolate
  Transient=BE
  ComputeGradQuasiFermiAtContacts=UseQuasiFermi
  ExitOnFailure
  RefDens_eGradQuasiFermi_ElectricField_HFS=1.000e+12
  RefDens_hGradQuasiFermi_ElectricField_HFS=1.000e+12
  Method=Blocked
  SubMethod=ParDiSo()
  RHSMaxQ=1e30
  RHSMin=1e-100
  RHSMax=1e30
  RHSFactor=1e100
#  CNormPrint
  AutoCNPMinStepFactor=0.0 
  AutoNPMinStepFactor=0.0 
  -PlotLoadable
  -CheckRhsAfterUpdate

}

Solve {
  Coupled (Iterations= 300){Poisson}
  Coupled (Iterations= 300){Poisson Electron Hole}

  Plot(FilePrefix="n@node@_ini")

Quasistationary(
    InitialStep=1e-3
    MinStep=1e-6
    MaxStep=0.5
    Goal { Name="ddd" Voltage=@V_WSe2@ }
  ) {
    Coupled { Poisson Electron Hole }
  }
Plot(FilePrefix="n@node@_0")

  Quasistationary(
    InitialStep=1e-6
    MinStep=1e-10
    MaxStep=0.5
    Goal { Name="ggg" Voltage=-10 }
  ) {
    Coupled { Poisson Electron Hole }
  }
  Plot(FilePrefix="n@node@_negative10")


 NewCurrentFile="IdVg_"

  Quasistationary(
    InitialStep=1e-2
    MinStep=1e-10
    MaxStep=0.5
    Goal { Name="ggg" Voltage=-0.6 }
  ) {
    Coupled { Poisson Electron Hole }
  }
Plot(FilePrefix="n@node@_negative_0_6")

  Quasistationary(
    InitialStep=1e-2
    MinStep=1e-10
    MaxStep=0.5
    Goal { Name="ggg" Voltage=0.7 }
  ) {
    Coupled { Poisson Electron Hole }
  }
Plot(FilePrefix="n@node@_positive_0_7")

  Quasistationary(
    InitialStep=1e-2
    MinStep=1e-10
    MaxStep=0.5
    Goal { Name="ggg" Voltage=2.8 }
  ) {
    Coupled { Poisson Electron Hole }
  }
Plot(FilePrefix="n@node@_positive_2_8")


  Quasistationary(
    InitialStep=1e-2
    MinStep=1e-10
    MaxStep=0.5
    Goal { Name="ggg" Voltage=10 }
  ) {
    Coupled { Poisson Electron Hole }
    CurrentPlot (Time=(range=(0. 1.) intervals=75))
  }
  
 Plot(FilePrefix="n@node@_positive10")

}

