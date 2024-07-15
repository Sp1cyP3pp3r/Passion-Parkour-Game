extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	player.stats.additional_speed += 0
	player.stats.acceleration = 0.8
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


func handle_landing():
	if player.legs.is_touching_floor():
		#player.stats.additional_speed -= 2
		effects_list[0].add_effects(player)
		change_state("Run")
