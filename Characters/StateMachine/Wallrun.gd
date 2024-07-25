extends PlayerState

@export var speed_curve : Curve 
@export var wall_curve : Curve 
var i : float = 0.0
var speed : float = 0

# should remove when make real walljump code
var _do_wallrun = true

# Called when the state machine enters this state.
func on_enter():
	player.add_speed_ratio += -0.2
	player.speed = 5
	i = 0
	_do_wallrun = true
	speed = player.speed


# Called every physics frame when this state is active.
func on_physics_process(delta):
	i += delta / 1.1
	player.add_speed_ratio -= delta / 10
	
	if _do_wallrun:
		var additional_speed = player.speed * accel_curve.sample(player.add_speed_ratio) / 2
		var _total_speed = player.speed + additional_speed
		player.velocity.x = (-player.body.get_wall_normal() * 1.25 + \
		player.body.get_wall_forward() * _total_speed).x
		player.velocity.z = (-player.body.get_wall_normal()  * 1.25 + \
		player.body.get_wall_forward() * _total_speed).z
	
		var _wall_grav = wall_curve.sample(i)
		player.velocity.y -= player.gravity * delta
		player.velocity.y -= (player.velocity.y * _wall_grav)
		
		if i > 1.5:
			change_state("Air")
	
	camera_tilt(delta)
	
	player.move_and_slide()
	
	if player.legs.is_floor_raycast() and not player.legs.is_on_slope():
		change_state("Idle")
	
	if not player.body.is_on_wall():
		change_state("Air")
	
	if Input.is_action_just_pressed("jump"):
		_do_wallrun = false
		player.velocity += player.body.get_wall_normal() * 4
		change_state("Jump")



# Called when the state machine exits this state.
func on_exit():
	camera_tween_end() 
	#player.head.camera.rotation_degrees.z = 0

func camera_tilt(delta):
	var sign_direction = player.body.get_wall_sign_direction()
	var _dot = abs(player.body.get_wall_dot())
	var cam_tilt : float = 12 * -sign_direction
	cam_tilt = cam_tilt - (cam_tilt * _dot)
	player.head.camera.rotation_degrees.z = lerp(player.head.camera.rotation_degrees.z, cam_tilt, delta)

func camera_tween_end():
	var _tween : Tween = create_tween()
	var sign_direction = player.body.get_wall_sign_direction()
	var cam_tilt = 0
	_tween.tween_property(player.head.camera, "rotation_degrees:z", cam_tilt, 0.24)
	_tween.play()
	await _tween.finished
	_tween.kill()
