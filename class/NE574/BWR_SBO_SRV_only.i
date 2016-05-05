[GlobalParams]
  # these initial values will be used for all the fluid models and will be overrode by local initial values if provided
  # if not provided, these default values will be used
  initial_p = 7.e6
  initial_v = 1.
  initial_T = 517.
  initial_volume_fraction_vapor = 0.01

  # scaling factors for flow equations
  scaling_factor_1phase   = '1e-3 1e-5 1e-8'
  scaling_factor_2phase = '1
                               1e-3 1e-5 1e-8
                               1    1e-3 1e-5'
  scaling_factor_temperature = '1e-4'

  gravity = '0 0 -9.8'

  stabilization_type = 'LAPIDUS'
  stabilization_lapidus_cl_liquid = 2
  stabilization_lapidus_cl_vapor = 2

  heat_flux_partitioning_model = simple
  wall_boiling_model = simple

  # 7 eqn global parameters
  phase_interaction = true
  pressure_relaxation = true
  velocity_relaxation = true
  interface_transfer = true
  wall_mass_transfer = true

  specific_interfacial_area_max_value = 10
  explicit_acoustic_impedance = true
[]

[FluidProperties]
  [./two_phase_eos]
    type = StiffenedGasHEMFluidProperties
  [../]

  [./eos]
    type = StiffenedGas7EqnFluidProperties
  [../]

  [./vapor_phase_eos]
    type = StiffenedGasFluidProperties
    gamma = 1.43
    q = 2030e3
    q_prime = -23e3
    p_inf = 0
    cv = 1040
  [../]

  [./liquid_phase_eos]
    type = StiffenedGasFluidProperties
    gamma = 2.35
    q = -1167e3
    q_prime = 0
    p_inf = 1.e9
    cv = 1816
  [../]

  [./eos_nc]
    type = N2FluidProperties
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
    rho = 6.551400e3
  [../]
[]

[Functions]
  [./power_curve]
    type = PiecewiseLinear
    x = '-200 -190
         -100    0.0     0.1     0.2     0.3     0.4     0.5     0.6     0.7     0.8     0.9      1.0      1.5      2.0
          3.0     4.0     5.0     6.0     8.0     10.0    15.0    20.0    30.0    40.0     50.0     60.0     80.0
          100.0   125.0   150.0   200.0   300.0   400.0   500.0   600.0   800.0   1000.0   1250.0   1500.0   2000.0
          2500.0  3000.0  3500.0  4000.0  5000.0  6000.0  7000.0  8000.0  9000.0  10000.0  15000.0  20000.0  800000.0'
    y = '0    0
         1.0      1.0     0.8382  0.572   0.3806  0.2792  0.2246  0.1904  0.1672  0.1503  0.1376   0.1275   0.1032   0.09884
         .09209  .0869   .08271  .07922  .07375  .06967  .06251  .05751  .05060  .04591   .04246   .03977   .03604
         .03357  .03145  .02997  .02798  .02565  .02418  .02307  .02217  .02073  .01959   .01844   .01749   .01600
         .01489  .01401  .01331  .01274  .01185  .01118  .01067  .01025  .009895 .009596  .008553  .007902   2.31e-3'
  [../]

  [./inlet_mass_flow_rate_func]
    type = PiecewiseLinear
    x = '0      50      47347200'
    y = '7000   12277   12277'
  [../]
[]

[Components]
  [./reactor]
    type = Reactor
    power = 3293.0e6
    #decay_heat = power_curve
  [../]

  # pipe to lower plenum
  [./pipe_pump_to_LP]
    type = Pipe
    position = '0.0  2.75  1.60'
    orientation = '0  0  -1'
    A = 8.55
    Dh = 1.0
    length = 0.5
    n_elems = 50
    f = 0.1
    Hw = 0.0
    Phf = 3420.
    Tw = 600.0
    fp = liquid_phase_eos
  [../]


  [./lowerplenum]
    type = VolumeBranch
    fp = liquid_phase_eos
    center = '0.0  0.0  2.64'
    inputs = 'pipe_pump_to_LP(out)'
    outputs = 'pipe_lp(in)'
    K = '1.0 20.0'
    volume = 6.0
    Area = 11.64
    initial_T = 517.0
    scale_factors = '1.0E-3  1.0E-9  1.0E-0' # rho, rhoE, vel
  [../]


  [./pipe_lp]
    type = Pipe

    # geometry
    position =    '0 0 5.28'
    orientation = '0 0 1'
    A = 7.8
    Dh = 1.
    length = 0.10
    n_elems = 10

    f = 0.01
    Hw = 0.
    Tw = 600.
    fp = two_phase_eos
    initial_volume_fraction_vapor = 0.0
  [../]

  [./twophasejunction1]
    type = TwoPhaseJunction
    fp_HEM = two_phase_eos
    fp = eos

    inputs = 'pipe_lp(out)'
    outputs = 'pipe_lp1(in)'
    volume_fraction_cutoff_limit = 0.01
  [../]


   [./pipe_lp1]
    type = Pipe

    # geometry
    position =    '0 0 5.38'
    orientation = '-1 0 0'
    A = 7.8
    Dh = 1.
    length = 1
    n_elems = 100

    f = 0.01
    f_interface = 0
    Hw_liquid = 0.
    Hw_vapor = 0.

    Tw = 600.
    fp = eos
    initial_volume_fraction_vapor = 0.01
  [../]

  [./br1]
    type = SimpleJunction
    inputs = 'pipe_lp1(out)'
    outputs = 'ch1(in)'
    fp = eos
  [../]


  [./ch1]
    type = CoreChannel
    fp = eos
    position = '-1.0 0.0  5.38'
    orientation = '0 0 1'
    A = 7.8
    Dh = 1.3597E-02
    length = 3.46
    n_elems = 200
    f = 0.2
    Hw_liquid = 1.0e4
    Hw_vapor = 1500.0
    Phf = 1836.84
    initial_Ts = 517.
    fuel_type = cylinder
    dim_hs = 2
    n_heatstruct = 3
    name_of_hs =  'FUEL GAP CLAD'
    width_of_hs = '6.057900e-3  1.524000e-4  9.398000e-4'
    elem_number_of_hs = '3 1 2'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power = reactor:power
    power_fraction = '1.0 0.0 0.0'
  [../]

   [./pipe_up1]
    type = Pipe

    # geometry
    position =    '0 0 8.84'
    orientation = '-1 0 0'
    A = 7.8
    Dh = 1.
    length = 1
    n_elems = 100

    f = 0.01
    f_interface = 0
    Hw_liquid = 0.
    Hw_vapor = 0.

    Tw = 600.
    fp = eos
    initial_volume_fraction_vapor = 0.01
  [../]

  [./twophasejunction2]
    type = TwoPhaseJunction
    fp_HEM = two_phase_eos
    fp = eos
    volume_fraction_cutoff_limit = 0.01
    inputs = 'pipe_up1(out)'
    outputs = 'pipe_up(in)'
  [../]


  [./pipe_up]
    type = Pipe

    # geometry
    position =    '0 0 8.84'
    orientation = '0 0 1'
    A = 7.8
    Dh = 1.
    length = 0.1
    n_elems = 10

    f = 0.01
    Hw = 0.
    Tw = 600.
    fp = two_phase_eos
    initial_volume_fraction_vapor = 0.01
  [../]


  [./br2]
    type = SimpleJunction
    inputs = 'ch1(out)'
    outputs = 'pipe_up1(in)'
    fp = eos
  [../]

  [./upperplenum]
    type = VolumeBranch
    fp = two_phase_eos
    center = '0.0  0.0  9.88'
    inputs = 'pipe_up(out)'
    outputs = 'rising_pipe(in)'
    K = '1.0 1.0'
    volume = 26.99
    Area = 14.36
    initial_T = 517.0
    scale_factors = '1.0E-3  1.0E-8  1.0E-0'
  [../]

  # rising pipe
  [./rising_pipe]
    type = Pipe
    position =    '0.0 0.0 10.82'
    orientation = '0 0 1'
    A = 3.93  # PI/4 * (0.01)**2
    Dh = 1.0
    length = 2.72
    n_elems = 27
    f = 0.1
    Hw = 0.
    Phf = 1572.
    Tw = 600
    fp = two_phase_eos
  [../]


  [./SeparatorDryer]
    type = SeparatorDryer
    fp = two_phase_eos
    center = '0.0 0.0 14.48'
    inputs = 'rising_pipe(out)'
    outputs = 'pipe_to_dome(in)  pipe_dryer_to_downcommer(in)'
    K = '1.0  1.0  5.0'
    volume = 19.30
    Area = 10.27
    initial_T = 517.0
    initial_volume_fraction_vapor = 0.9
    scale_factors = '1.0E-3  1.0E-9  1.0E-0'  # rho, rhoE, vel
  [../]

  # to steam dome
  [./pipe_to_dome]
    type = Pipe
    position = '0.0  0.0  15.42'
    orientation = '0  0  1'
    A = 3.93
    Dh = 1.0
    length = 0.1
    n_elems = 10
    f = 0.1
    Hw = 0.0
    Phf = 1572.
    Tw = 600
    fp = vapor_phase_eos
  [../]

  [./Dome]
    type = VolumeBranch
    fp = vapor_phase_eos
    center = '0.0  0.0  18.92'
    inputs = 'pipe_to_dome(out)'
    outputs = 'pipe_out_of_dome(in)'
    K = '1.0 10.0' #'1.0 1.0'
    volume = 178.19
    Area = 26.19
    scale_factors = '1.0E-3  1.0E-8  1.0E-0'
  [../]

  #----Main steam line

  [./pipe_out_of_dome]
    # main steam line coming out of dome
    type = Pipe
    position = '0.0  3  18.92'
    orientation = '0 1 0'
    A = 3.14
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.1
    Hw = 0.0
    Phf = 1256.
    Tw = 600
    fp = vapor_phase_eos
  [../]

  [./SteamLineBranch1]
    type = VolumeBranch
    fp = vapor_phase_eos
    center = '0.0  4  18.92'
    inputs = 'pipe_out_of_dome(out)'
    outputs = 'pipe_MS_1(in) pipe_srv_in1(in)'
    K = '0.0 0.0  0'
    volume = 1.256
    Area = 3.14
    initial_T = 517.0
    scale_factors = '1.0E-4 1.0E-8 1.0'
  [../]

  [./pipe_MS_1]
    # main steam line to MIV
    type = Pipe
    position = '0.0  4  18.92'
    orientation = '0 1 0'
    A = 3.14
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.0
    Hw = 0.0
    Phf = 1256.
    Tw = 600
    fp = vapor_phase_eos
  [../]

  [./pipe_srv_in1]
    type = Pipe
    fp = vapor_phase_eos
    # geometry
    position = '0  4  18.92'
    orientation = '0 0 -1'
    A =  1.2566 # group 10 srv lines
    Dh = 0.4 #0.8
    f = 0.01
    Hw = 0.0
    Phf = 100.
    Tw = 300.
    length = 2
    n_elems = 200

    initial_p = 7e6
    initial_v = 0.
    initial_T = 517.
  [../]

  [./relief_valve1]
    type = CompressibleValve
    inputs = 'pipe_srv_in1(out)'
    outputs = 'pipe_srv_out1(in)'
    fp = vapor_phase_eos

    center = '0 4 16.92'
    volume = 0

    initial_v = 0
    initial_p = 7e6
    initial_T = 517

    is_actuated_by_physics = true
    is_actuated_by_pressure_difference = 'false'
    initial_status = 'CLOSE'
    valve_action = 'NO_ACTION'
    response_time_open = 0.3 #0.02 #3
    response_time_close = 1.5
    delta_p_open = 8.17e6
    delta_p_close = 6.38e6
    Area = 0.11 # group 10 SRVs
    K = '0  0'

    scale_factors = '1e-1  1e0  1e-3'  # inlet pressure, outlet pressure, outlet total enthalpy
  [../]

  [./pipe_srv_out1]
    type = Pipe
    fp = vapor_phase_eos
    # geometry
    position = '0  4  16.92'
    orientation = '0 0 -1'
    A = 5.0264
    Dh = 0.4 #0.8
    f = 0.01
    Hw = 0.0
    Phf = 100.
    Tw = 300.
    length = 1
    n_elems = 100

    initial_p = 1e5
    initial_v = 0.
    initial_T = 300.
  [../]

  [./TDV1]
    type = TimeDependentVolume
    input = 'pipe_srv_out1(out)'
    p = 1e5
    T = 300
    fp = vapor_phase_eos
  [../]


  [./MainIsolationValve]
    type = Valve
    fp = vapor_phase_eos
    center = '0.0  5.0  18.92'
    inputs = 'pipe_MS_1(out)'
    outputs = 'pipe_steam_turbine(in)'
    K = '0.0 0.0'
    volume = 1.32
    Area = 3.14
    initial_T = 517.0
    initial_status = 'OPEN'
    trigger_time = 1
    response_time = 3
    scale_factors = '1.0E-4  1.0E-11'  # rho, rhoE
  [../]


  [./pipe_steam_turbine]
    # main steam line to TDV
    type = Pipe
    position = '0.0  5  18.92'
    orientation = '0 1 0'
    A = 3.14
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.0
    Hw = 0.0
    Phf = 1256.
    Tw = 600
    fp = vapor_phase_eos
  [../]

  [./outlet1]
    type = TimeDependentVolume
    input = 'pipe_steam_turbine(out)'
    p = 7.0e6
    T = 517
    fp = vapor_phase_eos
  [../]


  # separated water return line

  # discharge water line from SeparatorDryer
  [./pipe_dryer_to_downcommer]
    type = Pipe
    position = '0.0  2.0  14.48'
    orientation = '0  1  0'
    A = 3.93
    Dh = 1.0
    length = 0.5
    n_elems = 50
    f = 0.1
    Hw = 0.0
    Phf = 1572.
    Tw = 600
    fp = liquid_phase_eos
  [../]

  [./DownComer]
    type = DownComer
    fp = liquid_phase_eos
    dome_eos = vapor_phase_eos
    center = '0.0  2.75  9.81' #'0.0  4.0  9.81'
    inputs = 'pipe_dryer_to_downcommer(out) pipe_feedwater3(out)'
    outputs = 'pipe_downcommer_to_pump(in)'
    K = '1.0 10.0 1.0'
    volume = 201.3 #171.3
    Area = 15
    initial_level = 11.42 #13.42
    initial_T = 517.0
    dome_component = 'Dome'
    scale_factors = '1.0E-4  1.0E-10  1.0E-2'  # mass, energy, and level
  [../]

  # downcomer pipe
  [./pipe_downcommer_to_pump]
    type = Pipe
    position = '0.0  2.75  2.10' #'0.0  5.0  4.10'
    orientation = '0  0  -1'
    A = 8.55
    Dh = 1.0
    length = 0.5
    n_elems = 50
    f = 0.1
    Hw = 0.0
    Phf = 3420.
    Tw = 600
    fp = liquid_phase_eos
  [../]

  [./Pump]
    type = Pump
    fp = liquid_phase_eos
    inputs = 'pipe_downcommer_to_pump(out)'
    outputs = 'pipe_pump_to_LP(in)'
    Area = 3.0
    initial_pressure = 7.3e6
    Head = 40
    K_reverse = '10. 10.'
  [../]

  # pipe to lower plenum
  [./pipe_pump_to_LP]
    type = Pipe
    position = '0.0  2.75  1.60' #'0.0  5.0  3.60'
    orientation = '0  0  -1'
    A = 8.55
    Dh = 1.0
    length = 0.5
    n_elems = 50
    f = 0.1
    Hw = 0.0
    Phf = 3420.
    Tw = 600.0
    fp = liquid_phase_eos
  [../]

  # feed water line

  [./inlet]
    type = TimeDependentVolume
    input = 'pipe_feedwater1(in)'
    p = 7.1e6
    T =  508. #517.5
    volume_fraction_vapor = 0.00
    fp = liquid_phase_eos
  [../]

  # feedwater line from TDV
  [./pipe_feedwater1]
    type = Pipe
    position = '0.0  6.0  12.52'
    orientation = '0  -1  0'
    A = 1.32
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.01
    Hw = 0.
    Phf = 528.
    Tw = 600.0
    fp = liquid_phase_eos
  [../]


  [./FeedWaterValve]
    type = Valve
    fp = liquid_phase_eos
    center = '0.0  5.0  12.52'
    inputs = 'pipe_feedwater1(out)'
    outputs = 'pipe_feedwater2(in)'
    K = '0.0 0.0'
    volume = 1.32
    Area = 1.32
    initial_T = 517.0
    initial_status = 'OPEN'
    trigger_time = 1
    response_time = 1
    scale_factors = '1.0E-4  1.0E-11'  # rho, rhoE
  [../]


  [./pipe_feedwater2]
    #feedwater line from feed water valve
    type = Pipe
    position = '0.0  5.0  12.52'
    orientation = '0  -1  0'
    A = 1.32
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.01
    Hw = 0.
    Phf = 528.
    Tw = 600.0
    fp = liquid_phase_eos
  [../]

  [./branch_feedwater_line]
    type = VolumeBranch
    fp = liquid_phase_eos
    center = '0.0  4.0  12.52'
    inputs = 'pipe_feedwater2(out)'
    outputs = 'pipe_feedwater3(in)'
    K = '0  0'
    volume = 1.32
    Area = 1.32
    initial_T = 517.0
    scale_factors = '1.0E-4 1.0E-8 1.0'
  [../]

  # feedwater line to downcomer
  [./pipe_feedwater3]
    type = Pipe
    position = '0.0  4.0  12.52'
    orientation = '0  -1  0'
    A = 1.32
    Dh = 1.0
    length = 1.0
    n_elems = 100
    f = 0.01
    Hw = 0.
    Phf = 528.
    Tw = 600.0
    fp = liquid_phase_eos
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    solve_type = 'PJFNK'
    full = true
    line_search = basic
    petsc_options_iname = '-mat_fd_type -mat_mffd_type'
    petsc_options_value = 'ds ds'
  [../]
[]


[Executioner]
  type = ControlLogicExecutioner
  scheme = 'bdf2'

  dtmin = 1.e-6
  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 5e-6
  [../]

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 10

  l_tol = 1e-3
  l_max_its = 30

  start_time = -200
  end_time = 24000

  [./Quadrature]
    type = TRAP
    order = FIRST
  [../]
[]

[Outputs]
  [./out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end final'
    sequence = false
    output_failed = true
  [../]

  [./console]
    type = Console
    perf_log = true
  [../]

  [./csv]
    type = CSV
    execute_on = 'initial timestep_end final'
    sequence = false
    output_failed = true
  [../]
[]

[Debug]
#  show_var_residual_norms = true
[]

[Controlled]
  control_logic_input = BWR_SBO_SRV_only

  [./head_pump]
    component_name = Pump
    property_name = Head
    data_type = double
    print_csv = true
  [../]
[]

[Monitored]
  [./PCT]
    operator =  NodalMaxValue
    path =  CLAD:TEMPERATURE
    data_type =  double
    component_name =  ch1
    print_csv = true
  [../]
[]
