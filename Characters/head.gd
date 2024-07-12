extends Node3D

var mouse_sensitivity = 0.15

@onready var head_free_space_cast = $HeadFreeSpaceCast
@onready var camera = $Camera



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		owner.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.x -= event.relative.y * mouse_sensitivity

func _physics_process(delta):
	rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

func head_free_space() -> bool:
	head_free_space_cast.force_shapecast_update()
	if not head_free_space_cast.is_colliding():
		return true
	return false
