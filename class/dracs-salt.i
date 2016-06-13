[GlobalParams]
  initial_p = 1.0e5
  initial_v = 0.1285049
  initial_T = 950

  #scaling_factor_1phase = '1e4 1e1 1e-2'
  #scaling_factor_temperature = 1e-2
  #stabilization_type = 'LAPIDUS'

  stabilization_type = 'NONE'
[]

[FluidProperties]
  [./eos]
    type = LinearFluidProperties
    p_0 = 1e5    # Pa
    rho_0 = 1949.62   # kg/m^3
    a2 = 8.382e6  # m^2/s^2
    beta = 2.5037e-4 # K^{-1}
    cv =  2415.78    # at Tavg;
    e_0 = 2.295e6  # J/kg
    T_0 = 950      # K
  [../]
  [./eos2]
    type = LinearFluidProperties
    p_0 = 1e5    # Pa
    rho_0 = 0.5959   # kg/m^3
    a2 = 1.834e5  # m^2/s^2
    beta = 0.00289 # K^{-1}
    cv =  2076.069    # at Tavg;
    e_0 = 7.7645e5  # J/kg
    T_0 = 374      # K
  [../]

[]

[HeatStructureMaterials]
  [./fuel-mat]
    type = SolidMaterialProperties
    k = 29.3
    Cp = 191.67
    rho = 1.4583e4
  [../]
  [./clad-mat]
    type = SolidMaterialProperties
    k = 26.3
    Cp = 638
    rho = 7.646e3
  [../]

  [./wall-mat]
    type = SolidMaterialProperties
    k = 26.3
    rho = 7.646e3
    Cp = 638
  [../]
[]

[Components]
  [./reactor]
    type = Reactor
    power = 2.36e6
  [../]

  # Pipes and CoreChannels
  [./pipe1]
    type = Pipe
    fp = eos
    position = '0 1 0'
    orientation = '0 -1 0'

    A = 0.01767146
    Dh = 0.15
    length = 1
    n_elems = 5
    f = 0.03903
    Hw = 0.0
  [../]

  [./CH1]
    type = CoreChannel
    fp = eos
    position = '0 0 0'
    orientation = '0 0 1'

    A = 0.09182015
    Dh = 0.0109
    length = 2.5
    n_elems = 25 #20

    f = 1.00156 
    #f = 0.346  #Darcy
    Hw = 1.6129e5 #liquid metal still
    # aw = 1107.8
    Phf = 33.6955
    initial_v = 0.0247317

    dim_hs = 1
    name_of_hs = 'fuel clad'
    initial_Ts = 1000
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348  0.00052'
    elem_number_of_hs = '4 1'
    material_hs = 'fuel-mat clad-mat'
    #peak_power = '1.3366e8 0.'
    power = reactor:power
    power_fraction = '1.0 0.0'
  [../]

  [./pipe2]
    type = Pipe
    fp = eos
    position = '0 0 2.5'
    orientation = '0 0 1'

    A = 0.01767146
    Dh = 0.15
    length = 5
    n_elems = 5
    f = 0.03903
    Hw = 0.0
  [../]

  [./pipe3]
    type = Pipe
    fp = eos
    position = '0 0 7.5'
    orientation = '0 1 0'

    A = 0.01767146
    Dh = 0.15
    length = 1
    n_elems = 5
    f = 0.03903
    Hw = 0.0
  [../]

  [./IHX]
    type = HeatExchanger
    hs_type = cylinder
    fp = eos
    fp_secondary = eos2
    position = '0 1.1 7.5'
    orientation = '0 0 -1'
    A = 0.0218353
    A_secondary = 0.18391
    Dh = 0.0109
    Dh_secondary = 0.0129
    length = 24
    n_elems = 48

    Hw = 1.6129e5 # the same as the core
    Hw_secondary = 22.6 #the same as the core
    #aw = 192.312
    #aw_secondary = 192.312
    Phf = 8.013
    Phf_secondary = 9.483275
    f = 0.238
    #f = 0.0915
    f_secondary = 0.045
    initial_v = 0.104

    initial_Twall = 800
    wall_thickness = 0.001

    dim_wall = 1
    material_wall = wall-mat
    n_wall_elems = 2
  [../]

  [./pipe4]
    type = Pipe
    fp = eos
    position = '0 1.0 5'
    orientation = '0 0 -1'

    A = 0.01767146
    Dh = 0.15
    length = 5
    n_elems = 5
    f = 0.03903
    Hw = 0.0
  [../]

  [./pipe5]
    type = Pipe
    fp = eos
    position = '0 0 7.5'
    orientation = '0 0 1'
    #initial_v = 0

    A =  0.01767146
    Dh = 0.15
    length = 0.02
    n_elems = 2
    f = 390
    Hw = 0.0
  [../]


  [./Branch1]
    type = Branch
    inputs = 'pipe1(out)'
    outputs = 'CH1(in) '
    #K = '0.5 0.5'
    K = '0.0 0.0'
    A_ref = 0.01767146
  [../]

  [./Branch2]
    type = Branch
    inputs = 'CH1(out) '
    outputs = 'pipe2(in)'
    #K = '0.5 0.5'
    K = '0.0 0.0'
    A_ref =  0.01767146
  [../]


  [./Branch3]
    type = Branch
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    K = '0.0 0.0 0.0'
    A_ref =   0.01767146
  [../]

  [./Branch4]
    type = Branch
    inputs = 'pipe3(out)'
    outputs = 'IHX(primary_in)'
    #K = '0.1 0.1'
    K = '0.0 0.0'
    A_ref = 0.01767146
  [../]

  [./Branch5]
    type = Branch
    inputs = 'IHX(primary_out)'
    outputs = 'pipe4(in)'
    K = '0.0 0.0'
    A_ref = 0.01767146
  [../]

  [./Branch6]
    type = Branch
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    K = '0.0 0.0'
    A_ref = 0.01767146
  [../]

#Boundary components
  [./pipe6]
    type = Pipe
    fp = eos2
    position = '0 1.5 2.27'
    orientation = '0 -1 0'

    A = 0.01767146
    Dh = 0.15
    length = 0.3
    n_elems = 5
    f = 0.001
    Hw = 0.0
  [../]

  [./Branch7]
    type = Branch
    inputs = 'pipe6(out)'
    outputs = 'IHX(secondary_in)'
    K = '0.0 0.0'
    A_ref = 0.01767146
  [../]

  [./inlet_TDJ]
    type = TimeDependentJunction
    input = 'pipe6(in)'
    v = 114.46
    T = 374
  [../]
  [./outlet_TDV]
    type = TimeDependentVolume
    input = 'IHX(secondary_out)'
    p = '1.0e5'
    T = 761.15
  [../]

  [./TDV_p]
    type = TimeDependentVolume
    input = 'pipe5(out)'
    p = '1e5'
    T = 783.15
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true

    # Preconditioned JFNK (default)
    solve_type = 'PJFNK'

    petsc_options_iname = '-mat_fd_type -mat_mffd_type'
    petsc_options_value = 'ds ds'
  [../]
[]


[Executioner]
  type = Transient
  scheme = 'implicit-euler'

  dt = 1e-2
  dtmin = 1e-8

 #  setting time step range
 #   time_t = '0    0.1    0.11  1.0    1.05  2    2.1  5    1e5'
 #   time_dt ='1.e-2  1.e-2 5e-2  5.e-2  1e-1  1e-1 0.5 1     1.'

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '300'

  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-5
  nl_max_its = 30

  l_tol = 1e-4 # Relative linear tolerance for each Krylov solve
  l_max_its = 300 # Number of linear iterations for each Krylov solve

  start_time = 0.0
  num_steps = 15000 #for the establishment of long-term natural circulation
  end_time = 200


   [./Quadrature]
      type = TRAP

      # Specify the order as FIRST, otherwise you will get warnings in DEBUG mode...
      order = FIRST
   [../]
[] # close Executioner section

[Outputs]
  # postprocessor_csv = true
  # num_checkpoint_files = 1
  # xda = true
  [./out_displaced]
    type = Exodus
    use_displaced = true
    sequence = false
  [../]
  [./console]
    type = Console
    perf_log = true
  [../]
[]
