
#
# Flow through one core channel
# Data comes from NEA-NRC BWR TT Benchmark (NEA/NSC/DOC(2001)1)
#
# Phase 1: reactor startup
# - ramp up the reactor power over 1.5 days to 50e3 kW
# - normal operation over 1.5 year
#

[GlobalParams]
#  stabilization_type = 'ENTROPY_VISCOSITY'
#  stabilization_entropy_viscosity_use_jump = true
#  stabilization_entropy_viscosity_use_first_order = true

  stabilization_type = 'LAPIDUS'
  stabilization_lapidus_cl_liquid = 2
  stabilization_lapidus_cl_vapor = 2

  initial_p = 7.0e6
  initial_v = 0
  initial_T = 517.252072497525546
  initial_volume_fraction_vapor = 0.01

  # 7 eqn global parameters
  phase_interaction = true
  pressure_relaxation = true
  velocity_relaxation = true
  interface_transfer = true
  wall_mass_transfer = true

  specific_interfacial_area_max_value = 250
  explicit_acoustic_impedance = true
  bounds_alpha = '0.001 0.999'
  wall_boiling_model = 'simple'
  heat_flux_partitioning_model = 'linear'
#  heat_exchange_coef_liquid = 3000
#  heat_exchange_coef_vapor  = 3000

  # scaling factors for flow equations
  scaling_factor_2phase = '1e2
                               1e2 1e+1 1e-2
                               1e2 1e+2 1e-2'
  scaling_factor_temperature = 1.e-3

  gravity = '-9.81 0.0 0.0'
[]

[Functions]
  [./power_curve]
    type = PiecewiseLinear
    x = '-150 -100    0.0     0.1     0.2     0.3     0.4     0.5     0.6     0.7     0.8     0.9      1.0      1.5      2.0
         3.0     4.0     5.0     6.0     8.0     10.0    15.0    20.0    30.0    40.0     50.0     60.0     80.0
         100.0   125.0   150.0   200.0   300.0   400.0   500.0   600.0   800.0   1000.0   1250.0   1500.0   2000.0
         2500.0  3000.0  3500.0  4000.0  5000.0  6000.0  7000.0  8000.0  9000.0  10000.0  15000.0  20000.0  800000.0'
    y = '0.   1.0      1.0     0.8382  0.572   0.3806  0.2792  0.2246  0.1904  0.1672  0.1503  0.1376   0.1275   0.1032   0.09884
         .09209  .0869   .08271  .07922  .07375  .06967  .06251  .05751  .05060  .04591   .04246   .03977   .03604
         .03357  .03145  .02997  .02798  .02565  .02418  .02307  .02217  .02073  .01959   .01844   .01749   .01600
         .01489  .01401  .01331  .01274  .01185  .01118  .01067  .01025  .009895 .009596  .008553  .007902   2.31e-3'
  [../]  # close Functions section
[]

[FluidProperties]
  [./eos]
    type = StiffenedGas7EqnFluidProperties
  [../]
[]

[HeatStructureMaterials]
  [./fuel-mat]
    type = SolidMaterialProperties
    k = 3.7
    Cp = 3.e2
    rho = 10.42e3
  [../]
  [./gap-mat]
    type = SolidMaterialProperties
    k = 0.7
    Cp = 5e3
    rho = 1.0
  [../]
  [./clad-mat]
    type = SolidMaterialProperties
    k = 16
    Cp = 356.
    rho = 6.551400E+03
  [../]
[]

[Components]
  [./reactor]
    type = Reactor
    power = 50.e3
    #decay_heat = power_curve
  [../]

  [./pipe1]
    type = Pipe
    # geometry
    position = '0 0 0'
    orientation = '1 0 0'
    length = 1
    n_elems = 25

    A = 1.907720E-04
    Dh = 1.698566E-02
    Phf = 4.4925e-2

    f = 0.
    f_interface = 0
    Hw_liquid = 0
    Hw_vapor  = 0

    Tw = 517.25

    fp = eos
  [../]

  [./jct1]
    type = SimpleJunction

    inputs = 'pipe1(out)'
    outputs = 'core(in)'
    scaling_factor = 1e-0

    fp = eos
  [../]

  [./core]
    type = CoreChannel
    # geometry
    position = '1 0 0'
    orientation = '1 0 0'
    length = 3.66
    n_elems = 100

    A = 1.907720E-04
    Dh = 1.698566E-02
    Phf = 4.4925e-2

    f = 0.05
    Hw_liquid = 25000
    Hw_vapor  = 2500

    initial_Ts = 517.25

    # fuel-gap-clad
    fuel_type = cylinder
    dim_hs = 2
    n_elems_hs = 100
    n_heatstruct = 3
    name_of_hs =  'FUEL GAP CLAD'
    width_of_hs = '6.057900E-03  1.524000E-04  9.398000E-04'
    elem_number_of_hs = '5 1 2'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power = reactor:power
    power_fraction = '1.0 0.0 0.0'

    fp = eos
  [../]

  [./jct2]
    type = SimpleJunction

    inputs = 'core(out)'
    outputs = 'pipe2(in)'
    scaling_factor = 1e-0

    fp = eos
  [../]

  [./pipe2]
    type = Pipe
    # geometry
    position = '4.66 0 0'
    orientation = '1 0 0'
    length = 1
    n_elems = 25

    A = 1.907720E-04
    Dh = 1.698566E-02
    Phf = 4.4925e-2

    f = 0.
    f_interface = 0
    Hw_liquid = 0
    Hw_vapor  = 0

    Tw = 517.25

    fp = eos
  [../]

  [./inlet]
    type = Inlet
    input = 'pipe1(in)'

    # u = 4 m/s, T = 517, p = 7.e6, alpha = 0.01
    H_liquid =  1040432.94355763879138976336
    rhou_liquid =  3176.73946024684437361429
    H_vapor =  2799265.28185840277001261711
    rhou_vapor =  121.04766968193573006829
    # u = 2 m/s, T = 517, p = 7.e6, alpha = 0.01
#    H_liquid =  1040426.94355763867497444153
#    rhou_liquid =  1588.24907709208969208703
#    H_vapor =  2799259.28185840277001261711
#    rhou_vapor =  60.52358023578023704658
    # u = 1 m/s, T = 517, p = 7.e6, alpha = 0.01
#    H_liquid =  1040425.44459044025279581547
#    rhou_liquid =  794.10442933594697478838
#    H_vapor =  2799257.78221831982955336571
#    rhou_vapor =  30.26174766953343109321
    volume_fraction_vapor =  0.01
  [../]

  [./outlet]
    type = Outlet
    input = 'pipe2(out)'

    p_liquid = 7e6
    p_vapor = 7e6
  [../]
[]

[Postprocessors]
  [./reactor_power]
    type = ScalarVariable
    variable = reactor:power
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    line_search = basic
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'
  dtmin = 1.e-6
  dtmax = 1.e+6

  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    percent_change = 0.2
    dt = 1e-3
  [../]

  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-6
  nl_max_its = 30

  l_tol = 1e-3
  l_max_its = 100

  start_time = -150
  end_time = 1000000

  [./Quadrature]
    type = TRAP
    order = FIRST
  [../]
[]

[Outputs]
  [./out_displaced]
    type = Exodus
    use_displaced = true
    sequence = false
  [../]
[]

[Debug]
#  show_var_residual_norms = true
[]
