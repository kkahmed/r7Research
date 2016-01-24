[GlobalParams]
  gravity = '0 0 0'

  initial_T_liquid = 558.980022806
  initial_T_vapor  = 558.980022806
  initial_p_liquid = 7.0e6
  initial_p_vapor  = 7.0e6
  initial_v_liquid = 12.5
  initial_v_vapor  = 12.5
  initial_volume_fraction_vapor = 0.01

  scaling_factor_2phase = '1e4
                           1e1 1e-1 1e-5
                           1e3 1e0  1e-4'

  # 7 eqn global parameters
  phase_interaction = true
  pressure_relaxation = true
  velocity_relaxation = true
  interface_transfer = true
  wall_mass_transfer = false

  stabilization_type = ENTROPY_VISCOSITY
  stabilization_entropy_viscosity_use_first_order_liquid = false
  stabilization_entropy_viscosity_use_first_order_vapor = false
  stabilization_entropy_viscosity_use_first_order_vf = false
  stabilization_entropy_viscosity_use_jump_liquid = true
  stabilization_entropy_viscosity_use_jump_vapor = true
  stabilization_entropy_viscosity_use_jump_vf = true
  stabilization_entropy_viscosity_Cjump_liquid = 4.
  stabilization_entropy_viscosity_Cjump_vapor = 4.
  stabilization_entropy_viscosity_Cjump_vf = 4.

  specific_interfacial_area_max_value = 180.
  explicit_acoustic_impedance = true
[]

[FluidProperties]
  [./eos]
    type = IAPWS957EqnFluidProperties
  [../]
[]

[Components]
  [./pipe]
    type = Pipe
    fp = eos
    # geometry
    position = '0 0 0'
    orientation = '1 0 0'
    A = 1.907720E-04
    Dh = 1.698566E-02
    length = 10.
    f = 0.
    f_interface = 0
    Hw_liquid = 20000.0
    Hw_vapor = 20000.0
    Phf = 0.0489623493599166
    Tw = 550
    n_elems = 500
  [../]

  [./inlet]
    type = SolidWall
    input = 'pipe(in)'
  [../]

  [./outlet]
    type = SolidWall
    input = 'pipe(out)'
  [../]
[]

[AuxVariables]
  [./kappa_max_liq_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./kappa_liq_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./kappa_max_vap_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./kappa_vap_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./beta_max_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./beta_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./kappa_max_liq_ak]
    type = MaterialRealAux
    variable = kappa_max_liq_aux
    property = evm:visc_max_liquid
  [../]

  [./kappa_liq_ak]
    type = MaterialRealAux
    variable = kappa_liq_aux
    property = evm:kappa_liquid
  [../]

  [./kappa_max_vap_ak]
    type = MaterialRealAux
    variable = kappa_max_vap_aux
    property = evm:visc_max_vapor
  [../]

  [./kappa_vap_ak]
    type = MaterialRealAux
    variable = kappa_vap_aux
    property = evm:kappa_vapor
  [../]

  [./beta_ak]
    type = MaterialRealAux
    variable = beta_aux
    property = evm:beta
  [../]

  [./beta_max_ak]
    type = MaterialRealAux
    variable = beta_max_aux
    property = evm:beta_max
  [../]
[]

[Preconditioning]
  [./pc]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    line_search = basic
  [../]
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'
  dt = 1.e-6
  dtmin = 1.e-7

  [./TimeStepper]
    type = FunctionDT
    time_t = '0            1.e-4     .01 	'
    time_dt ='1.e-5        5.e-5     5.e-5 	'
  [../]

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-4
  nl_max_its = 10

  l_tol = 1e-3
  l_max_its = 30

  start_time = 0.0
  end_time = .01

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
