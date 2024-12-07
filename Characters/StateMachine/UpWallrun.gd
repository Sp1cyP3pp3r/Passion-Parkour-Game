extends PlayerState

@export var up_curve : Curve

# Called when the state machine enters this state.
func on_enter():
	# ПЕРЕДЕЛАТЬ
	queue_jump = false
	coyote = false
	player.velocity = Vector3.ZERO
	player.velocity.y = 0.01
	i = player.add_speed_ratio
	QT = false
	player.head.do_rotate = false
	var pos = player.global_position - player.climb.current_normal
	player.look_at(pos)
	cam_tween()
	$WallTimer.start()


var normal : Vector3
var i: = 1.0
var QT : = false
var coyote := false
var queue_jump := false
var queue_turn := false

func on_physics_process(delta):
	player.move_and_slide()
	handle_ledgegrab()
	
	i = i - delta / 2
	var sample = up_curve.sample(i)
	if not QT:
		if not coyote:
			player.velocity.y = 5.5 * sample
		else:
			handle_fall(delta / 1.5)
		
		if not player.body.is_on_wall():
			change_state("Air")
		
		
		if Input.is_action_just_pressed("quick_turn"):
			QT = true
			cam_tween_end()
			player.velocity.y = player.velocity.y / 3
			$WallTimer.stop()
			$TurnTimer.start()
		
		if Input.is_action_just_pressed("quick_turn"):
			var tween = create_tween()
			var _to = player.rotation.y - PI
			var time = 0.25
			tween.tween_property(player, "rotation:y", _to, time)
			tween.play()
			queue_turn = true
			await  tween.finished
			tween.kill()
			queue_turn = false
			if queue_jump:
				change_state("UpWallrunJump")
	
	
	if QT:
		if Input.is_action_just_pressed("jump"):
			if queue_turn:
				queue_jump = true
			else:
				change_state("UpWallrunJump")
	
	if player.legs.is_touching_floor():
		change_state("Air")

func on_exit():
	if not QT:
		cam_tween_end()
	player.head.do_rotate = true
	player.add_speed_ratio = 0
	$WallTimer.stop()
	$TurnTimer.stop()
	$CoyoteTimer.stop()

func _on_timer_timeout() -> void:
	change_state("Air")

func _on_walltimer_timeout() -> void:
	coyote = true
	$CoyoteTimer.start()

func cam_tween():
	var tween = create_tween()
	var _to = PI / 2 / 1.2
	var time = 0.28
	tween.tween_property(%Camera, "rotation:x", _to, time)
	tween.play()
	await tween.finished
	tween.kill()

func cam_tween_end():
	var tween = create_tween()
	var _to = 0
	var time = 0.28
	tween.tween_property(%Camera, "rotation:x", _to, time)
	tween.play()
	await tween.finished
	tween.kill()
