extends PlayerState

@export var running_curve : Curve
var i : float = 0
var speed : float

func on_enter():
	player.stats.additional_speed += 0
	player.stats.acceleration = 30
	speed = player.stats.additional_speed #+ player.stats.speed
	i = 0

func on_physics_process(delta):
	i += delta / 10
	i = clamp(i, 0, 1)
	var _sample = running_curve.sample(i)
	var _t_speed = speed + (speed * _sample)
	player.stats.additional_speed = _t_speed
	
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

