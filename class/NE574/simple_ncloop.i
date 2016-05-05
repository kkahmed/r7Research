[GlobalParams]
  initial_p = 1.0e5
  initial_v = 0.5
  initial_T = 628.15

  stabilization_type = 'NONE'
[]

[Functions]
  [./v_TDJ]
    type = PiecewiseLinear
    x = ' 0 1.0  1.1 1000'
    y = ' 0  0   0.5 0.5'
  [../]
[]

[FluidProperties]
  [./eos]
    type = LinearFluidProperties
    p_0 = 1e5    # Pa
    rho_0 = 865.51   # kg/m^3
    a2 = 5.7837e6  # m^2/s^2
    beta = 2.7524e-4 # K^{-1}
    cv =  1272.0    # at Tavg;
    e_0 = 7.9898e5  # J/kg
    T_0 = 628.15      # K
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
    power = 5.1296e7
  [../]

  # Pipes and CoreChannels
  [./pipe1]
    type = Pipe
    fp = eos
    position = '0 1 0'
    orientation = '0 -1 0'

    A = 0.44934
    Dh = 2.972e-3
    length = 1
    n_elems = 5
    f = 0.001
    Hw = 0.0
  [../]

  [./CH1]
    type = CoreChannel
    fp = eos
    position = '0 0 0'
    orientation = '0 0 1'

    A = 0.44934
    Dh = 2.972e-3
    length = 0.8
    n_elems = 10 #20

    f = 0.022 #Mcadms
    Hw = 8000 #1.6129e5 #liquid metal
    # aw = 1107.8
    Phf = 497.778852000000

    dim_hs = 1
    name_of_hs = 'fuel clad'
    initial_Ts = 628.15
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
    position = '0 0 0.8'
    orientation = '0 0 1'

    A = 0.44934
    Dh = 2.972e-3
    length = 5.18
    n_elems = 5
    f = 0.001
    Hw = 0.0
  [../]

  [./pipe3]
    type = Pipe
    fp = eos
    position = '0 0 5.98'
    orientation = '0 1 0'

    A = 0.44934
    Dh = 2.972e-3
    length = 1
    n_elems = 5
    f = 0.001
    Hw = 0.0
  [../]

  [./IHX]
    type = HeatExchanger
    fp = eos
    fp_secondary = eos
    position = '0 1.0 5.98'
    orientation = '0 0 -1'
    A = 0.44934
    A_secondary = 0.44934
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 3.71
    n_elems = 10

    Hw = 1.6129e5 # the same as the core
    Hw_secondary = 1.6129e5 #the same as the core
    # aw = 729
    # aw_secondary = 729
    Phf = 327.568860000000
    Phf_secondary = 327.568860000000
    f = 0.022
    f_secondary = 0.022

    initial_Twall = 628.15
    wall_thickness = 0.0044

    dim_wall = 1
    material_wall = wall-mat
    n_wall_elems = 2
  [../]

  [./pipe4]
    type = Pipe
    fp = eos
    position = '0 1.0 2.27'
    orientation = '0 0 -1'

    A = 0.44934
    Dh = 2.972e-3
    length = 2.27
    n_elems = 5
    f = 0.001
    Hw = 0.0
  [../]

  [./pipe5]
    type = Pipe
    fp = eos
    position = '0 0 5.98'
    orientation = '0 0 1'

    A =  0.44934
    Dh = 2.972e-3
    length = 0.02
    n_elems = 2
    f = 10
    Hw = 0.0
  [../]


  [./Branch1]
    type = Branch
    inputs = 'pipe1(out)'
    outputs = 'CH1(in) '
    K = '0.5 0.5'
    A_ref = 0.44934
  [../]

  [./Branch2]
    type = Branch
    inputs = 'CH1(out) '
    outputs = 'pipe2(in)'
    K = '0.5 0.5'
    A_ref =  0.44934
  [../]


  [./Branch3]
    type = Branch
    inputs = 'pipe2(out)'
    outputs = 'pipe3(in) pipe5(in)'
    K = '0.0 0.0 0.0'
    A_ref =   0.44934
  [../]

  [./Branch4]
    type = Branch
    inputs = 'pipe3(out)'
    outputs = 'IHX(primary_in)'
    K = '0.1 0.1'
    A_ref = 0.44934
  [../]

  [./Branch5]
    type = Branch
    inputs = 'IHX(primary_out)'
    outputs = 'pipe4(in)'
    K = '0.0 0.0'
    A_ref = 0.44934
  [../]

  [./Branch6]
    type = Branch
    inputs = 'pipe4(out)'
    outputs = 'pipe1(in)'
    K = '0.0 0.0'
    A_ref = 0.44934
  [../]

#Boundary components
  [./pipe6]
    type = Pipe
    fp = eos
    position = '0 1.5 2.27'
    orientation = '0 -1 0'

    A = 0.44934
    Dh = 2.972e-3
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
    A_ref = 0.44934
  [../]

  [./inlet_TDJ]
    type = TimeDependentJunction
    input = 'pipe6(in)'
    v = 0.5
    T = 628.15
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

  #dt = 1e-2
  #dtmin = 1e-10

  # setting time step range
    time_t = '0    0.1    0.11  1.0    1.05  2    2.1  5    1e5'
    time_dt ='1.e-2  1.e-2 1e-2  1.e-2  2e-2  2e-2 2e-2 5e-2   5e-2'

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '300'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 30

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 300 # Number of linear iterations for each Krylov solve

  start_time = 0.0
  num_steps = 6000 # 150 for the establishment of long-term natural circulation
  end_time = 100.


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
