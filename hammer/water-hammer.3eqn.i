[GlobalParams]
  gravity = '0 0 0'

  initial_T = 517.252072255516
  initial_p = 7.0e6
  initial_v = 12.5

  scaling_factor_1phase = '1e-2 1e-4 1e-7'

  stabilization_type = ENTROPY_VISCOSITY
  stabilization_entropy_viscosity_use_first_order = false
  stabilization_entropy_viscosity_use_jump = false
  stabilization_entropy_viscosity_Cjump = .9
[]

[FluidProperties]
  [./eos]
    type = IAPWS95LiquidFluidProperties
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
    f = 0.01
    Hw = 0.
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
  [./kappa_max_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./kappa_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]

  [./mu_aux]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./kappa_max_ak]
    type = MaterialRealAux
    variable = kappa_max_aux
    property = evm:visc_max
  [../]

  [./kappa_ak]
    type = MaterialRealAux
    variable = kappa_aux
    property = evm:kappa
  [../]

  [./mu_ak]
    type = MaterialRealAux
    variable = mu_aux
    property = evm:mu
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

#  [./TimeStepper]
#    type = SolutionTimeAdaptiveDT
#    dt = 1e-3
#  [../]
  [./TimeStepper]
    type = FunctionDT
    time_t = '0            1.e-4     0.04 	0.08'
    time_dt ='1.e-6        1.e-5     1.e-5	1.e-4'
  [../]

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_max_its = 5

  l_tol = 1e-3
  l_max_its = 30

  start_time = 0.0
  end_time = 0.08

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
