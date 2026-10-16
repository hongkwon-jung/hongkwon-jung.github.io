#define W_g_c_ [비공개]
#define W_g_v_ [비공개]
#define W_mt_e_ [비공개]
#define W_mt_h_ [비공개]

#define I_g_c_ [비공개]
#define I_g_v_ [비공개]
#define I_mt_e_ [비공개]
#define I_mt_h_ [비공개]

#define C_g_c_ [비공개]
#define C_g_v_ [비공개]
#define C_mt_e_ [비공개]
#define C_mt_h_ [비공개]

#define ACd   @[expr {pow(@IACd@, 3.0/2.0)/1e+@COR@}]@
#define DCd   @[expr {pow(@IDCd@, 3.0/2.0)/1e+@COR@}]@
#define IDDC  @[expr {pow(@DDC@, 2.0/3.0)/1e+@COR_D@}]@

#define WAC   @[expr {pow(@WIAC@, 3.0/2.0)/1e+@COR@}]@
#define WACd  @[expr {pow(@WIACd@, 3.0/2.0)/1e+@COR@}]@
#define WDC   @[expr {pow(@WIDC@, 3.0/2.0)/1e+@COR@}]@
#define WDCd  @[expr {pow(@WIDCd@, 3.0/2.0)/1e+@COR@}]@
#define WIAAC @[expr {pow(@WAAC@, 2.0/3.0)/1e+@COR_D@}]@

#define WIIAC  @[expr {(@IAC@+@WIAC@)/2}]@
#define WIIAM  [비공개]
#define WIIAS  @[expr {([비공개] + @WIAS@)/2}]@
#define WIIACd @[expr {(@IACd@+@WIACd@)/2}]@
#define WIIAMd @[expr {(@IAMd@+@WIAMd@)/2}]@
#define WIIASd @[expr {(@IASd@+@WIASd@)/2}]@
#define WIIDC  @[expr {(@IDC@+@WIDC@)/2}]@
#define WIIDM  [비공개]
#define WIIDS  @[expr {(@s_d_e@+@WIDS@)/2}]@
#define WIIDCd @[expr {(@IDCd@+@WIDCd@)/2}]@
#define WIIDMd @[expr {(@IDMd@+@WIDMd@)/2}]@
#define WIIDSd @[expr {(@IDSd@+@WIDSd@)/2}]@

File {
  Grid= "@tdr@"
  Parameter= "@parameter@"
  PMIPath = "@pwd@/lib"
  Current= "@plot@"
  Plot= "@tdrdat@"
  Output= "@log@"
  TrappedCarPlotFile="n@node@_trap"
  NonLocalPlot= "n@node@_NonLocal"	
}

Electrode {
  { Name="sss" Voltage=0. material="Aluminum" Schottky }
  { Name="ddd" Voltage=0. material="Gold" Schottky }
  { Name="ggg" Voltage=0. Workfunction=[비공개]}
}

Physics {
  Temperature = 300.00
  AreaFactor = 6e+02
  Fermi
  EffectiveIntrinsicDensity(noBandGapNarrowing)
  Recombination(SRH)
    eBarrierTunneling "NLM_Source" 
    hBarrierTunneling "NLM_Source" 
    eBarrierTunneling "NLM_Drain"
    hBarrierTunneling "NLM_Drain"
    eBarrierTunneling "NLM_channel" (Band2Band=Full)
    hBarrierTunneling "NLM_channel" (Band2Band=Full)
}

Physics (material="aIGZO") {
  BandTailDOS(Exponent)
  Mobility ( 
    ConstantMobility
    eHighFieldSaturation
    Enormal(
      pmi_percolationmobility3
    )
  )
  Traps(
    (Acceptor Gaussian    fromCondBand Conc=ACd    EnergyMid=@IAMd@ EnergySig=@IASd@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Gaussian    fromValBand  Conc=DCd    EnergyMid=@IDMd@ EnergySig=@IDSd@
      eXsection=[비공개] hXsection=[비공개] )

    (Donor    Gaussian    fromValBand  Conc=@DDC@  EnergyMid=@DDM@ EnergySig=@DDS@
      eXsection=[비공개] hXsection=[비공개] )
  )
}

Physics (MaterialInterface="aIGZO/AluminumOxide" ) { 
  Traps( 
    (Acceptor Exponential fromCondBand Conc=@IAC@  EnergyMid=@IAM@  EnergySig=@IAS@
      eXsection=[비공개] hXsection=[비공개] )
    (Acceptor Gaussian    fromCondBand Conc=@IACd@ EnergyMid=@IAMd@ EnergySig=@IASd@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Exponential fromValBand  Conc=@IDC@  EnergyMid=@IDM@  EnergySig=@IDS@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Gaussian    fromValBand  Conc=@IDCd@ EnergyMid=@IDMd@ EnergySig=@IDSd@
      eXsection=[비공개] hXsection=[비공개] )

    (Donor    Gaussian    fromValBand  Conc=IDDC   EnergyMid=@DDM@ EnergySig=@DDS@
      eXsection=[비공개] hXsection=[비공개] )

    (FixedCharge Conc=@IFC@)
  )
}

Physics (MaterialInterface="WSe2/aIGZO" ) { 
  HeteroInterface
  Thermionic

  Traps( 
    (Acceptor Exponential fromCondBand Conc=WIIAC   EnergyMid=WIIAM  EnergySig=WIIAS
      eXsection=[비공개] hXsection=[비공개] )
    (Acceptor Gaussian    fromCondBand Conc=WIIACd  EnergyMid=WIIAMd EnergySig=WIIASd
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Exponential fromValBand  Conc=WIIDC   EnergyMid=WIIDM  EnergySig=WIIDS
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Gaussian    fromValBand  Conc=WIIDCd  EnergyMid=WIIDMd EnergySig=WIIDSd
      eXsection=[비공개] hXsection=[비공개] )
  )
}

Physics (material="WSe2") {
  Mobility(
    ConstantMobility
    eHighFieldSaturation
    Enormal(
      pmi_percolationmobility3
    )
  )
  Traps( 
    (Acceptor Exponential fromCondBand Conc=WAC     EnergyMid=@WIAM@  EnergySig=@WIAS@
      eXsection=[비공개] hXsection=[비공개] )
    (Acceptor Gaussian    fromCondBand Conc=WACd    EnergyMid=@WIAMd@ EnergySig=@WIASd@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Exponential fromValBand  Conc=WDC     EnergyMid=@WIDM@  EnergySig=@WIDS@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Gaussian    fromValBand  Conc=WDCd    EnergyMid=@WIDMd@ EnergySig=@WIDSd@
      eXsection=[비공개] hXsection=[비공개] )

    (Acceptor Gaussian    fromCondBand Conc=@WAAC@  EnergyMid=@WAAM@  EnergySig=@WAAS@
      eXsection=[비공개] hXsection=[비공개] )
  )
}

Physics (MaterialInterface="WSe2/AluminumOxide" ) { 
  Traps( 
    (Acceptor Exponential fromCondBand Conc=@WIAC@  EnergyMid=@WIAM@  EnergySig=@WIAS@
      eXsection=[비공개] hXsection=[비공개] )
    (Acceptor Gaussian    fromCondBand Conc=@WIACd@ EnergyMid=@WIAMd@ EnergySig=@WIASd@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Exponential fromValBand  Conc=@WIDC@  EnergyMid=@WIDM@  EnergySig=@WIDS@
      eXsection=[비공개] hXsection=[비공개] )
    (Donor    Gaussian    fromValBand  Conc=@WIDCd@ EnergyMid=@WIDMd@ EnergySig=@WIDSd@
      eXsection=[비공개] hXsection=[비공개] )

    (Acceptor Gaussian    fromCondBand Conc=WIAAC   EnergyMid=@WAAM@ EnergySig=@WAAS@
      eXsection=[비공개] hXsection=[비공개] )

    (FixedCharge Conc=@WIFC@)
  )
}

TrappedCarDistrPlot {
  Material="aIGZO" {( 17.5 0.095 )}
  MaterialInterface="aIGZO/AluminumOxide" {( 17.5 0.09 )}
  Material="WSe2" {( 42.5 0.0925 )}
  MaterialInterface="WSe2/AluminumOxide" {( 42.5 0.09 )}
  MaterialInterface="WSe2/aIGZO" {( 30 0.0925 )}
  MaterialInterface="WSe2/aIGZO" {( 29 0.1 )}
  MaterialInterface="WSe2/aIGZO" {( 25.5 0.1 )}
  MaterialInterface="WSe2/aIGZO" {( 25 0.1 )}
}

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

NonLocalPlot ((2.5 0.1 0) (2.5 0.095 0) (57.5 0.095 0) (57.5 0.0925 0) (29.95 0.0925 0) (30.05 0.0925 0)) { 
   eDensity hDensity
   ConductionBandEnergy ValenceBandEnergy eQuasiFermiEnergy hQuasiFermiEnergy
   eBarrierTunneling hBarrierTunneling
   ElectrostaticPotential
   CBBarrierLowering VBBarrierLowering
   CBEnergywithLowering VBEnergywithLowering
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
  TrapDLN=64
  -FermiBandTailStatistics
  SimpleBandTailIntegration
  -CheckRhsAfterUpdate

    NonLocal "NLM_Source" (
        Electrode = "sss"
        Length = 5e-7
        Digits = 3
        EnergyResolution = 0.002
    )

    NonLocal "NLM_Drain" (
        Electrode = "ddd"
        Length = 5e-7
        Digits = 3
        EnergyResolution = 0.002
    )

    NonLocal "NLM_channel" (
        MaterialInterface="aIGZO/WSe2"
        Length = 5e-7
        Digits = 3
        EnergyResolution = 0.002
    )
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

