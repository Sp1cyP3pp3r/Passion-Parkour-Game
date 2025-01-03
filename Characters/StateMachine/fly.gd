extends PlayerState

func on_enter():
	#%StandCollision.disabled = true
	#%CrouchCollision.disabled = true
	pass

func on_physics_process(delta):
	
	if Input.is_action_just_pressed("noclip"):
		change_state("Idle")
	
	var speed
	if Input.is_key_label_pressed(KEY_SHIFT):
		speed = 16
	else:
		speed = 5
	
	if Input.is_action_pressed("jump"):
		player.global_position.y += 5 * delta * speed
	if Input.is_key_label_pressed(KEY_CTRL):
		player.global_position.y -= 5 * delta * speed + 1
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = input_dir.rotated(-player.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	
	player.global_position += direction * delta * 10 * speed
	
	
	
func on_exit():
	#%StandCollision.disabled = false
	#%CrouchCollision.disabled = true
	pass
