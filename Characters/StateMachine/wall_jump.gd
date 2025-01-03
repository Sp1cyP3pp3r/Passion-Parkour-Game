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

# Called when the state machine exits this state.
func on_exit():
	pass
