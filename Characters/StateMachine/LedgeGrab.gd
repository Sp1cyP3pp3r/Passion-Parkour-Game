extends PlayerState

var ledge_point : Vector3
var no_action : bool = false

# Called when the state machine enters this state.
func on_enter():
	player.head.do_rotate_owner = false
	cam_tween()

# Called every physics frame when this state is active.
func on_physics_process(delta):
	if not no_action:
		if Input.is_action_just_pressed("jump"):
			#player.velocity = -player.global_basis.z * 2
			#player.velocity.y = 10
			change_state("Mantle")

# Called when the state machine exits this state.
func on_exit():
	%Mantle.mantle_point = ledge_point
	player.global_rotation.y = player.head.camera.global_rotation.y
	player.head.camera.rotation.y = 0
	player.head.do_rotate_owner = true

func cam_tween():
	var tween = create_tween()
	var _from : Vector3 = %Camera.global_position + -%Camera.global_basis.z
	var _to : Vector3 = owner.global_position + -owner.global_basis.z
	_to.y = ledge_point.y + 1
	var time = 0.08 # 10 * _to.angle_to(_from)
	tween.tween_method(Callable(%Camera, "look_at"), _from, _to, time)
	no_action = true
	tween.play()
	await tween.finished
	no_action = false
	tween.kill()


func _on_climb_update_ledge(point: Vector3) -> void:
	ledge_point = point
