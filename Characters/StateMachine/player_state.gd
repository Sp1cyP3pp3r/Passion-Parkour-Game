extends StateMachineState
class_name PlayerState

@onready var player = get_owner() as Player
@export var can_jump_in_this_state : bool = true
@export var can_crouch_in_this_state : bool = true
var snap_margin = 0.01
var accel_curve : Curve = preload("res://Characters/run_curve.tres")
var is_player_on_stairs : bool = false

func catch_movement():
	if Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_forward") or \
	Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		change_state("Run")

func catch_no_movement():
	if player.velocity.is_equal_approx(Vector3.ZERO):
		change_state("Idle")

func handle_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = input_dir.rotated(-player.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	var _dot = direction.dot(-player.global_transform.basis.z)
	var _dot_p = _dot * 0.25 + 0.75
	
	var additional_speed = player.speed * accel_curve.sample(player.add_speed_ratio) / 2 * 1.2
	var total_speed = player.speed + additional_speed
	player.velocity.x = lerp(player.velocity.x, direction.x * total_speed * _dot_p, player.acceleration * delta)
	player.velocity.z = lerp(player.velocity.z, direction.z * total_speed * _dot_p, player.acceleration * delta)
	if direction.is_equal_approx(Vector3.ZERO) and state_machine.current_state.name == "Run":
		change_state("Idle")
	player.move_and_slide()


func slopes_and_stairs(delta):
	if player.legs.is_on_slope():
		snap_to_floor(delta)
		#%Label5.text = "slopes!"
		is_player_on_stairs = false
	
	elif player.legs.is_on_stairs():
		handle_stairs(delta)
		#%Label5.text = "stairs!"
		is_player_on_stairs = true
	
	elif not player.legs.is_stairs_beneath():
		snap_to_floor(delta)
		is_player_on_stairs = false
		#%Label5.text = "floor (no stairs beneath)!"
		#
	#elif not player.legs.is_stair_near():
		#snap_to_floor(delta)
		#%Label5.text = "floor (wrtf)!"
		

func snap_to_floor(delta):
	if player.legs.is_ray_floor() and player.velocity.y >= 0:
		player.global_position.y = player.legs.get_floor_point().y - snap_margin

func handle_stairs(delta):
	var _point = player.legs.get_staircase_point()
	if player.head.head_free_space():
		if not _point.is_equal_approx(Vector3.ZERO):
			player.global_position.y = _point.y - snap_margin

func handle_no_floor():
	if not player.legs.is_ray_floor():
		change_state("Air")

func handle_fall(delta):
	player.velocity.y -= player.gravity * delta


func handle_jump():
	if Input.is_action_just_pressed("jump"):
		if can_jump():
			change_state("Jump")

func smooth_landing(delta):
	if player.velocity.y > 0:
		player.velocity.y = -0.01
	if player.velocity.y <= 0:
		player.velocity.y = lerp(player.velocity.y, 0.0, delta)

func can_jump() -> bool:
	if can_jump_in_this_state: #and player.head.head_free_space():
		return true
	return false

func handle_crouch():
	if Input.is_action_just_pressed("crouch"):
		if can_crouch_in_this_state:
			if player.add_speed_ratio >= 0.2:
				change_state("Slide")
			else:
				change_state("Crouch")

func tween_camera_crouch():
	var _tween := create_tween()
	var _position : float = 0.55
	var _time : float = 0.32
	_tween.tween_property(player.head, "position:y", _position, _time)
	_tween.play()
	await  _tween.finished
	_tween.kill()
	
func tween_camera_uncrouch():
	var _tween := create_tween()
	var _position : float = 1.5
	var _time : float = 0.41
	_tween.tween_property(player.head, "position:y", _position, _time)
	_tween.play()
	await  _tween.finished
	_tween.kill()

func handle_uncrouch():
	if Input.is_action_just_pressed("crouch") or Input.is_action_just_pressed("jump"):
		if player.head.head_free_space():
			change_state("Run")
