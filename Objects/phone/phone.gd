extends Node3D

var phone_opened : bool = false
@onready var screen: SubViewport = $Screen


signal opened_menu
signal closed_menu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		if not phone_opened:
			opened_menu.emit()
			phone_opened = true
		else:
			closed_menu.emit()
			phone_opened = false
	
#func _input(event: InputEvent) -> void:
	#if event is InputEventAction:
		#if event.action == "exit":
			#if not phone_opened:
				#opened_menu.emit()
				#phone_opened = true
			#else:
				#closed_menu.emit()
				#phone_opened = false


func enable_phone():
	screen.gui_disable_input = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func disable_phone():
	screen.gui_disable_input = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
