extends Node3D

@export var player : Player
@export var world_scale : float = 200
@onready var camera : Camera3D = %SkyboxCamera3D
@onready var sub_viewport: SubViewport = %SubViewport

var orig_position : Vector3

func _ready() -> void:
	change_res()
	visible = true
	orig_position = camera.global_position

func change_res(x = get_viewport().size.x, y = get_viewport().size.y):
	sub_viewport.size = Vector2(x, y)

func _process(delta: float) -> void:
	camera.global_position = orig_position + player.head.camera.global_position / world_scale
	camera.global_basis = player.head.camera.global_basis
	camera.fov = player.head.actual_camera.fov
