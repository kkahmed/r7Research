[GlobalParams]
  initial_p = 15.17e6
  initial_v = 1
  initial_T = 564.15

  scaling_factor_1phase      = '1e0 1e0 1e0'
  scaling_factor_temperature = '1e0'

  stabilization_type = 'NONE'
[]

[FluidProperties]
  [./eos]
    type = LinearFluidProperties
    p_0 = 15.17e6     # Pa
    rho_0 = 738.350   # kg/m^3
    a2 = 1.e7      # m^2/s^2
    beta = .46e-3  # K^{-1}
    cv =  5.832e3   # J/kg-K
    e_0 = 3290122.80  # J/kg
    T_0 = 564.15      # K
    mu = 1.e-3
    k = 0.6
    Pr = 7.
  [../]
[]

[HeatStructureMaterials]
  [./fuel-mat]
    type = SolidMaterialProperties
    k = 3.7
    Cp = 3.e2
    rho = 1.412e2
  [../]
  [./gap-mat]
    type = SolidMaterialProperties
    k = 1.084498
    Cp = 1.0
    rho = 1.0
  [../]
  [./clad-mat]
    type = SolidMaterialProperties
    k = 16
    Cp = 356.
    rho = 6.6e1
  [../]
[]

[Components]
  [./reactor]
    type = Reactor
    power = 6.696946e4
  [../]

  [./pipe_bottom]
    type = Pipe
    position = '0 0 0.0'
    orientation = '0  0  1'
    A = 0.1
    Dh = 0.01
    length = 0.1
    n_elems = 2
    f = 0.1
    Hw = 0.0
    Tw = 600.0
    fp = eos
  [../]

  [./sub]
    type = Subchannel
    fp = eos
    position = '0 0 0.2'
    orientation = '0 0 1'
    length = 3.66
    rod_diameter = .010928
    side_gap_width = 0.003
    corner_radius = 0.010
    internal_gap_width = 0.004
    n_elems = 10
    lattice = '2 1' # n x m lattice of fuel rods

    Hw = 5.33e4
    f = 0.01
    mu = 9.63e-5
    K_G = 0.5
    initial_Ts = 564.15
    fuel_type = cylinder
    dim_hs = 1
    n_heatstruct = 3
    name_of_hs =  'FUEL GAP CLAD'
    width_of_hs = '0.0046955  0.0000955  0.000673'
    elem_number_of_hs = '3 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power = reactor:power
    power_fraction = '0.125 0.0 0.0'
  [../]

  [./pipe_top]
    type = Pipe
    position = '0 0 3.96'
    orientation = '0  0  1'
    A = 0.1
    Dh = 0.01
    length = 0.1
    n_elems = 2
    f = 0.1
    Hw = 0.0
    Tw = 600.0
    fp = eos
  [../]

  [./sub_branch_bottom]
    type = SubchannelBranch
    fp = eos
    center = '0.0  0.0  0.15'
    inputs = 'pipe_bottom(out)'
    outputs = 'sub(in)'
    K = '1.0 1.0'
    volume = 0.001
    A_ref = 1.0e-2
    scale_factors = '1e0 1e0 1e0'
    initial_v = 0
  [../]

  [./sub_branch_top]
    type = SubchannelBranch
    fp = eos
    center = '0.0  0.0  3.91'
    inputs = 'sub(out)'
    outputs = 'pipe_top(in)'
    K = '1.0 1.0'
    volume = 0.001
    A_ref = 1.0e-2
    scale_factors = '1e0 1e0 1e0'
    initial_v = 0
  [../]

  [./inlet]
    type = TDM
    input = 'pipe_bottom(in)'
    #p = 15.17e6
    T = 564.15
    massflowrate = 0.4
  [../]

  [./outlet]
    type = TimeDependentVolume
    input = 'pipe_top(out)'
    p = '15.13e6'
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    line_search = basic
#    petsc_options_iname = '-mat_fd_type -mat_mffd_type'
#    petsc_options_value = 'ds           ds'
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'
  dt = 0.01
  dtmin = 1e-10

  [./TimeStepper]
    type = FunctionDT
    time_t= ' 0    1.0   10.   400'
    time_dt= '1e-2 1e-2 1e-1 5.0e-1'
  [../]

  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_factor_shift_type  -pc_factor_shift_amount'
  petsc_options_value = '300 lu NONZERO 1e-10'

  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-6
  nl_max_its = 15

  l_tol = 1e-6
  l_max_its = 30

  start_time = 0.0
  num_steps = 5
  end_time = 150.

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
