[GlobalParams]
  gravity = '0 0 0'

  initial_T_liquid = 558 #K
  initial_T_vapor  = 558
  initial_p_liquid = 7.0e6 		#Pa
  initial_p_vapor  = 7.0e6
  initial_v_liquid = 7.672 		#m/s
  initial_v_vapor  = 7.672		#Based on 3m drop height 
  initial_volume_fraction_vapor = 0.000001

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
  [./liquid_eos]
    type = StiffenedGasFluidProperties
    gamma = 2.35
    q = -1167e3
    q_prime = 0
    p_inf = 1.e9
    cv = 1816
  [../]
[]

[Components]
  [./pipe]
    type = Pipe
    fp = eos
    # geometry
    position = '0.6 0 0'
    orientation = '1 0 0'
    A = 2.265973E-04 		#2.265973 cm2 flow area
    Dh = 1.698566E-02		#1.698566 cm hydraulic diameter
    length = 10. 			#m
    f = 0.
    f_interface = 0
    Hw_liquid = 0.0
    Hw_vapor = 0.0
    Phf = 0.0  			#Heat flux perimeter 
    Tw = 558				#Initial pipe wall temp
    n_elems = 500
  [../]
  [./pipe_in]
    type = Pipe
    fp = eos
    # geometry
    position = '0 0 0'
    orientation = '1 0 0'
    A = 2.265973E-04 		#2.265973 cm2 flow area
    Dh = 1.698566E-02		#1.698566 cm hydraulic diameter
    length = 0.5 			#m
    f = 0.
    f_interface = 0
    Hw_liquid = 0.0
    Hw_vapor = 0.0
    Phf = 0.0  			#Heat flux perimeter 
    Tw = 558				#Initial pipe wall temp
    n_elems = 500
  [../]
  [./pipe_out]
    type = Pipe
    fp = eos
    # geometry
    position = '10.7 0 0'
    orientation = '1 0 0'
    A = 2.265973E-04 		#2.265973 cm2 flow area
    Dh = 1.698566E-02		#1.698566 cm hydraulic diameter
    length = 0.5 			#m
    f = 0.
    f_interface = 0
    Hw_liquid = 0.0
    Hw_vapor = 0.0
    Phf = 0.0  			#Heat flux perimeter 
    Tw = 558				#Initial pipe wall temp
    n_elems = 500
  [../]

  #[./inlet]
  #  type = SolidWall
  #  input = 'pipe(in)'
  #[../]

  #[./outlet]
  #  type = SolidWall
  #  input = 'pipe(out)'
  #[../]

#Boundary components
  [./inlet]
    type = TimeDependentJunction
    input = 'pipe_in(in)'
    v = 7.672
    T = 558
  [../]
  [./outlet]
    type = TimeDependentVolume
    input = 'pipe_out(out)'
    p = '6.9e6'
    T = 558
  [../]
  [./valve1]
    type = Valve
    fp = liquid_eos
    center = '0.55 0.0 0.0'
    inputs = 'pipe_in(out)'
    outputs = 'pipe(in)'
    K = '0.0 0.0'
    volume = 2.265973E-05
    A_ref = 2.265973E-04
    initial_T = 558.0
    #initial_p = 7.0e6
    #initial_v = 7.762
    #initial_volume_fraction_vapor = 1.0e-6
    initial_status = open
    trigger_time = 1.0
    response_time = 0.01
    scale_factors = '1.0E-4 1.0E-8' # rho, rhoE
  [../]
  [./valve2]
    type = Valve
    fp = liquid_eos
    center = '10.65 0.0 0.0'
    inputs = 'pipe(out)'
    outputs = 'pipe_out(in)'
    K = '0.0 0.0'
    volume = 2.265973E-05
    A_ref = 2.265973E-04
    initial_T = 558.0
    #initial_p = 7.0e6
    #initial_v = 7.762
    #initial_volume_fraction_vapor = 1.0e-6
    initial_status = open
    trigger_time = 1.0
    response_time = 0.01
    scale_factors = '1.0E-4 1.0E-8' # rho, rhoE
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
  dt = 1.e-5
  dtmin = 1.e-7

  [./TimeStepper]
    type = FunctionDT
    time_t = '0 		0.99		1.0001     .03 	'
    time_dt ='1.e-2 	1.e-5     5.e-5     5.e-5 	'
  [../]

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-4
  nl_max_its = 10

  l_tol = 1e-3
  l_max_its = 30

  start_time = 0.0
  end_time = .1

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
