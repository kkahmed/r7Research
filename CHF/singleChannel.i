[GlobalParams]
  initial_p = 8.566e6
  initial_v = 0.725
  initial_T = 387.3

  scaling_factor_1phase = '1e4 1e1 1e-2'
  scaling_factor_temperature = 1e-2
  stabilization_type = 'SUPG'
[]


[FluidProperties]
  [./fp]
    type = IAPWS95LiquidFluidProperties
  [../]
[]

 [Functions]
  active = 'cospower'
  [./cospower]
    type = PiecewiseLinear
    axis = 0
    x = '0  0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0'
    y = '0.3 0.422 0.567 0.727 0.893 1.054 1.201 1.326 1.421 1.480 1.5 1.480 1.421 1.326 1.201 1.054 0.893 0.727 0.567 0.422 0.3'
  [../]
[]

[HeatStructureMaterials]
  [./fuel-mat]
    type = SolidMaterialProperties
    k = 21
    Cp = 440
    rho = 8.430e2
  [../]
  [./gap-mat]
    type = SolidMaterialProperties
    k = 21
    Cp = 440
    rho = 8.430e3
  [../]
  [./clad-mat]
    type = SolidMaterialProperties
    k = 21
    Cp = 440
    rho = 8.430e3
  [../]
[]

[Components]
  [./reactor]
    type = Reactor
    power = 5.8496e4
  [../]

  [./CH1]
    type = CoreChannel
    fp = fp
    position = '0 0 0'
    orientation = '0 0 1'

    A = 4.319e-04
    Dh = 7.63e-3     # Hydraulic diameter
    length = 2.0
    n_elems = 20

    f = 0.025
    # Hw = 4214 # 7992
    Phf = 0.1194 # 0.04546     # Heated perimeter

    dim_hs = 1
    name_of_hs = 'fuel gap clad'
    initial_Ts = 387.3
    n_heatstruct = 3
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00089 0.00038'
    elem_number_of_hs = '20 2 2'
    material_hs = 'fuel-mat gap-mat clad-mat'
    power = reactor:power
    power_fraction = '1.0 0.0 0.0'
    power_shape_function = cospower
  [../]

#Boundary components
  [./inlet]
    type = TimeDependentJunction
    input = 'CH1(in)'
    v = 0.725
    T = 387.3
  [../]
  [./outlet]
    type = TimeDependentVolume
    input = 'CH1(out)'
    p = '8.566e6'
    T = 487.3
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'

  [./SMP_PJFNK]
    type = SMP
    full = true

    # Preconditioned JFNK (default)
    solve_type = 'PJFNK'

    petsc_options_iname = '-mat_fd_type  -mat_mffd_type'
    petsc_options_value = 'ds             ds'
  [../]
[] # End preconditioning block


[Executioner]
  type = Transient
  scheme = 'implicit-euler'
  dt = 1e-2
  dtmin = 1e-7

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '300'

  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-7
  nl_max_its = 40

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 50 # Number of linear iterations for each Krylov solve

  start_time = 0.0
  num_steps = 2000
  end_time = 200000.


  [./Quadrature]
    type = TRAP
    order = FIRST
  [../]
[] # close Executioner section

[Outputs]
  [./out_displaced]
    type = Exodus
    use_displaced = true
    sequence = false
  [../]
[]

