extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	print("\n JUMPED")
	player.add_speed_ratio += 0.2
	player.acceleration = 1.2
	player.velocity.y = player.jump_power * 1.1


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


func handle_climbing():
	var _height = player.climb.get_obstacle_height()
	
	pass
