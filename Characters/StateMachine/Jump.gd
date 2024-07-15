extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	player.stats.additional_speed += 1.486
	player.stats.acceleration = 1.2
	player.velocity.y = player.stats.jump_power * 1.1


# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_fall(delta)
	handle_movement(delta)
	handle_wallrun()
	if player.velocity.y <= 0:
		change_state("Air")
	if player.is_on_floor():
		change_state("Air")

# Called when the state machine exits this state.
func on_exit():
	pass

func handle_wallrun():
	var _vel = player.velocity
	_vel.y = 0
	var _len = _vel.length()
	if player.body.is_on_wall():
		# horizontal wallrun
		var _dot = player.body.get_wall_dot()
		if _dot:
			if _dot <= -0.1 and _dot >= -0.85:
				change_state("Wallrun")
			# vertical wallrun
			elif _dot <= -0.85 and _dot >= -1:
				change_state("UpWallrun")
