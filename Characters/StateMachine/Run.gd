extends PlayerState

@export var running_curve : Curve
var i : float = 0
var speed : float
var previous_yaw : Vector3

func on_enter():
	player.speed = 6
	player.acceleration = 30
	previous_yaw = -player.global_basis.z
	i = 0

func on_physics_process(delta):
	player.add_speed_ratio += delta / 4.23
	player.add_speed_ratio = clamp(player.add_speed_ratio, 0, 1)
	
	if player.body.is_on_wall():
		var _dot = player.body.get_wall_dot()
		if  _dot < -0.3 and _dot >= -1:
			player.add_speed_ratio = 0
	
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	catch_no_movement()
	smooth_landing(delta)
	handle_crouch()
	handle_jump()
	camera_yaw()
	
	$"../../MeshInstance3D".global_position = player.global_position + previous_yaw + Vector3(0, 1, 0)

func on_input(event: InputEvent):
	pass

func on_exit():
	pass

func camera_yaw():
	var _dot = previous_yaw.dot(-player.global_basis.z)
	#_dot = max(_dot, 0)
	player.add_speed_ratio = player.add_speed_ratio * _dot
	

func update_yaw():
	previous_yaw = -player.global_basis.z
