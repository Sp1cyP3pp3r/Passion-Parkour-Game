extends PlayerState

var is_crouching : bool = false
@export var slide_node : StateMachineState

# Called when the state machine enters this state.
func on_enter():
	if is_crouching == false:
		player.head.head_free_space_cast.target_position.y = 0.9
		%CrouchCollision.disabled = false
		%StandCollision.disabled = true
		tween_camera_crouch()
	player.additional_speed -= 3
	player.acceleration = 50
	
	is_crouching = true


# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	handle_uncrouch()
	


# Called when the state machine exits this state.
func on_exit():
	%CrouchCollision.disabled = true
	%StandCollision.disabled = false
	tween_camera_uncrouch()
	is_crouching = false
	player.head.head_free_space_cast.target_position.y = 0.45



