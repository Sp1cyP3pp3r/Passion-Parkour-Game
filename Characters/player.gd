extends CharacterBody3D
class_name Player

@export var speed : float
var additional_speed : float = 2
@export var acceleration: float
@export var gravity : float = 10
@export var jump_power : float = 6.598

@export var legs : Node3D
@export var head : Node3D
@export var body : Node3D

func _physics_process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	if Input.is_key_pressed(KEY_SHIFT):
		velocity.y = -20
	%Label2.text = str($FiniteStateMachine.current_state.name)
	%Label4.text = str(snapped(Vector3(velocity.x, 0, velocity.z).length(), 0.001)) + " " + str(snapped(speed, 0.1)) + " " + str(snapped(additional_speed, 0.1))
