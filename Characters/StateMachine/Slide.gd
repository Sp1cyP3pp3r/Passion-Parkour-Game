extends PlayerState


var is_crouching : bool = false
var to_crouch : bool = false
@export var crouch_node : StateMachineState

# Called when the state machine enters this state.
func on_enter():
	player.stats.additional_speed += 1
	player.stats.acceleration = 1
	if not is_crouching:
		player.head.head_free_space_cast.target_position.y = 0.9
		%CrouchCollision.disabled = false
		%StandCollision.disabled = true
	tween_camera_crouch()
	
	to_crouch = false
	is_crouching = false
	crouch_node.is_crouching = true
	_i = 0
	

# Called every physics frame when this state is active.
func on_physics_process(delta):
	flow_speed(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	handle_uncrouch()
	if snapped(player.stats.additional_speed, 0.01) <= 0.3:
		crouch_node.is_crouching = true
		to_crouch = true
		change_state("Crouch")


# Called when the state machine exits this state.
func on_exit():
	if not to_crouch:
		%CrouchCollision.disabled = true
		%StandCollision.disabled = false
		tween_camera_uncrouch()
		crouch_node.is_crouching = false
		
		player.head.head_free_space_cast.target_position.y = 0.45
	player.stats.additional_speed += 1
	

var _i : float = 0
@export var _curve : Curve
func flow_speed(delta) -> void:
	_i += delta / 5
	var _value = 1 - _curve.sample(_i)
	player.stats.additional_speed = player.stats.additional_speed * _value
	handle_movement(delta)
	#player.velocity = player.velocity * _value
	#player.move_and_slide()
	
	
	
	
	
	
	
	
