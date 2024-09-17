extends Node3D

@onready var obstacle_detector: ShapeCast3D = $ObstacleDetector
@onready var obstacle_height: RayCast3D = $ObstacleHeight
@onready var obstacle_obstr: RayCast3D = $ObstacleObstr

var current_position : Vector3
var init_position : Vector3

signal update_ledge(point : Vector3)

func _ready() -> void:
	init_position = position


func is_wall() -> bool:
	if not is_obstacle():
		return false
	if get_obstacle_height() <= 100:
		return false
	return true

func is_obstacle()  -> bool:
	#obstacle_detector.force_shapecast_update()
	if not obstacle_detector.is_colliding():
		return false
	current_position = obstacle_detector.get_collision_point(0)
	return true

func get_obstacle_height() -> float:
	var _temp_y = obstacle_height.global_position.y
	obstacle_height.global_position = current_position
	obstacle_height.global_position += -obstacle_detector.get_collision_normal(0) * 0.01
	obstacle_height.global_position.y = _temp_y
	#obstacle_height.force_raycast_update()
	if not obstacle_height.is_colliding():
		# Is inside a wall
		return 999.9
	var _point : Vector3 = obstacle_height.get_collision_point()
	var _value : float = abs(owner.global_position.y - _point.y)
	print("obstacle height " + str(_value))
	update_ledge.emit(_point)
	return _value
