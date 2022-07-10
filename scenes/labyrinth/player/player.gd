extends KinematicBody

# Основа кода взята из репозитория GarbajYT
# https://github.com/GarbajYT/godot_updated_fps_controller/blob/main/FPS_controller_3.3/FPS.gd

enum WalkStates { Walk, Run, Air }
var walk_state = WalkStates.Walk
const AirSpeed = 20
const RunSpeed = AirSpeed / 1.5
const WalkSpeed = AirSpeed / 2.5

var speed
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8 * 3.5
var jump = 5 * 2.25

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

var is_movement_allowed: bool = true

onready var head = $Head
onready var camera = $Head/Camera

func _ready():
	# Скрыть курсор
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Ссылка на игрока
	Core.player = self

func _input(event):
	# Получить ввод с помощью мыши для поворота камеры
	if event is InputEventMouseMotion and is_movement_allowed:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	# Интерполяция физики камеры для уменьшения фазового дрожания на мониторах с высокой частотой обновления
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform

func _physics_process(delta):
	if is_movement_allowed:
		# Ввод с клавиатуры
		direction = Vector3.ZERO
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("backward") - Input.get_action_strength("forward")
		var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
		
		# Прыжок и Гравитация
		if is_on_floor():
			snap = -get_floor_normal()
			accel = ACCEL_DEFAULT
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			accel = ACCEL_AIR
			gravity_vec += Vector3.DOWN * gravity * delta
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
		
		if Input.is_action_pressed("run") and not is_on_floor():
			walk_state = WalkStates.Air
		elif Input.is_action_pressed("run") and is_on_floor():
			walk_state = WalkStates.Run
		else:
			walk_state = WalkStates.Walk
		
		if walk_state == WalkStates.Walk:
			speed = WalkSpeed
		elif walk_state == WalkStates.Air:
			speed = AirSpeed
		else:
			speed = RunSpeed
		
		# Движение
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
		
		movement = move_and_slide_with_snap(movement, snap, Vector3.UP)
