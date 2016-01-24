[GlobalParams]
  gravity = '0 0 0'

  initial_T = 517.252072255516
  initial_v = 0

  stabilization_type = 'NONE'

  scaling_factor_1phase = '1.e0 1.e0 1.e-2'
[]

[FluidProperties]
  [./eos]
    type = StiffenedGasFluidProperties
    gamma = 2.35
    q = -1167e3
    q_prime = 0
    p_inf = 1.e9
    cv = 1816
  [../]
[]


[Functions]
  [./p_fn]
    type = PiecewiseConstant
    axis = 0
    x = '0      0.5    1'
    y = '7.5e6  6.5e6  6.5e6'
  [../]
[]

[Components]
  [./pipe1]
    type = Pipe
    fp = eos
    # geometry
    position = '0 0 0'
    orientation = '1 0 0'
    length = 1
    n_elems = 200

    A = 1.907720E-04
    Dh = 1.698566E-02
    f = 0.
    Hw = 0.
    Phf = 0.0489623493599166

    P_func = p_fn
  [../]

  # BCs
  [./left]
    type = SolidWall
    input = 'pipe1(in)'
  [../]

  [./right]
    type = SolidWall
    input = 'pipe1(out)'
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
  dt = 1e-5
  dtmin = 1.e-7

  nl_rel_tol = 1e-9
  nl_abs_tol = 1e-9
  # nl_abs_step_tol = 1e-15
  nl_max_its = 10

  l_tol = 1e-3
  l_max_its = 100

  start_time = 0.0
  num_steps = 10

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
