extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	player.additional_speed += 0
	player.acceleration = 0.8
	if %FiniteStateMachine._previous_state.name == "Run"  or %FiniteStateMachine._previous_state.name == "Idle":
		can_jump_in_this_state = true
		$CoyoteTimer.start()

# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_fall(delta)
	handle_movement(delta)
	handle_landing()
	handle_jump()

# Called when the state machine exits this state.
func on_exit():
	pass

func coyote_disable_jump() -> void :
	can_jump_in_this_state = false
