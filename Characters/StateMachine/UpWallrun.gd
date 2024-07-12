extends PlayerState


# Called when the state machine enters this state.
func on_enter():
	pass

# Called every physics frame when this state is active.
func on_physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		player.velocity = -player.body.get_wall_normal() / 2
		player.velocity.y = 8
		change_state("Air")

# Called when the state machine exits this state.
func on_exit():
	pass

