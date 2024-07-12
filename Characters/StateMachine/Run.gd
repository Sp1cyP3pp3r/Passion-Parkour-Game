extends PlayerState

@export var running_curve : Curve
var i : float = 0
var speed : float

func on_enter():
	player.additional_speed += 0
	player.acceleration = 30
	speed = player.additional_speed
	i = 0

func on_physics_process(delta):
	i += delta / 50
	i = clamp(i, 0, 1)
	var _sample = running_curve.sample(i)
	player.additional_speed = speed * _sample
	
	handle_movement(delta)
	handle_no_floor()
	slopes_and_stairs(delta)
	catch_no_movement()
	smooth_landing(delta)
	handle_crouch()
	handle_jump()

func on_input(event: InputEvent):
	pass

func on_exit():
	pass

