extends PlayerState

var direction : Vector3

# Called when the state machine enters this state.
func on_enter():
	player.add_speed_ratio += 0.15
	player.acceleration = 1.1
	
	direction = direction + -player.global_basis.z * 2
	player.velocity = direction.normalized() * (3.3 + 4 * player.add_speed_ratio)
	player.velocity.y = player.jump_power * 1.125


# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_fall(delta)
	handle_movement(delta)
	handle_ledgegrab()
	handle_wallrun()
	if player.velocity.y <= 0:
		change_state("Air")
	if player.is_on_floor():
		change_state("Air")


func handle_wallrun():
	var _vel = player.velocity
	_vel.y = 0
	var _len = _vel.length()
	if player.body.is_on_wall():
		# horizontal wallrun
		var _dot = player.body.get_wall_dot()
		if _dot:
			if _dot <= -0.1 and _dot >= -0.85:
				if player.body.is_upper_head_colliding():
					change_state("Wallrun")
			# vertical wallrun
			elif _dot <= -0.85 and _dot >= -1:
				if player.climb.is_wall():
					change_state("UpWallrun")

# Called when the state machine exits this state.
func on_exit():
	pass