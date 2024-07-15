extends CharacterBody3D
class_name Player

@export var legs : Node3D
@export var head : Node3D
@export var body : Node3D

@export var stats : PlayerStats

func _physics_process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	if Input.is_key_pressed(KEY_SHIFT):
		velocity.y = -20
	%Label2.text = str($FiniteStateMachine.current_state.name)
	%Label4.text = str(snapped(Vector3(velocity.x, 0, velocity.z).length(), 0.001)) + " " + str(snapped(stats.speed, 0.1)) + " " + str(snapped(stats.additional_speed, 0.1))
