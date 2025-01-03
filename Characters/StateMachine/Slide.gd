extends PlayerState


var is_crouching : bool = false
var to_crouch : bool = false
@export var crouch_node : StateMachineState

# Called when the state machine enters this state.
func on_enter():
	do_uncrouch = false
	$EnterState.start()
	player.acceleration = 1
	if not is_crouching:
		player.head.head_free_space_cast.target_position.y = 0.9
		%CrouchCollision.disabled = false
		%StandCollision.disabled = true
	tween_camera_crouch()
	
	player.speed = 2
	player.add_speed_ratio += 0.05
	to_crouch = false
	is_crouching = false
	crouch_node.is_crouching = true
	_i = 0
	

# Called every physics frame when this state is active.
func on_physics_process(delta):
	slope(delta)
	handle_no_floor()
	slopes_and_stairs(delta)


# Called when the state machine exits this state.
func on_exit():
	if not to_crouch:
		%CrouchCollision.disabled = true
		%StandCollision.disabled = false
		tween_camera_uncrouch()
		crouch_node.is_crouching = false
		
		player.head.head_free_space_cast.target_position.y = 0.45
	

var _i : float = 0
@export var _curve : Curve
func flow_speed(delta) -> void:
	_i += delta / 5
	_i = clamp(_i, 0, 1)
	var _value = 1 - _curve.sample(_i)
	player.add_speed_ratio = player.add_speed_ratio * _value
	handle_movement(delta)

var do_uncrouch := false
func _on_enter_state_timeout() -> void:
	do_uncrouch = true


func slope(delta):
	var _dot = player.legs.get_floor_dot()
	if _dot < 0.9:
		_i += delta / 2
		var _value = _curve.sample(_i)
		player.add_speed_ratio = _value
		
		var direction = player.legs.get_floor_forward()
		var additional_speed = player.speed * accel_curve.sample(player.add_speed_ratio) / 2 * 1.2
		var total_speed = player.speed + additional_speed
		player.velocity.x = lerp(player.velocity.x, direction.x * total_speed, player.acceleration * delta)
		player.velocity.z = lerp(player.velocity.z, direction.z * total_speed, player.acceleration * delta)
		player.move_and_slide()
		
		handle_jump()
		
	else:
		flow_speed(delta)
		if snapped(player.add_speed_ratio, 0.01) <= 0.0:
			crouch_node.is_crouching = true
			to_crouch = true
			change_state("Crouch")
		if do_uncrouch:
			handle_uncrouch()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
