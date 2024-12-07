extends PlayerState

var _power = 0.01
var can_walljump_in_this_state : bool = false
var can_upwalljump_in_this_state : bool = false

# Called when the state machine enters this state.
func on_enter():
	player.acceleration = 0.8
	match %FiniteStateMachine._previous_state.name:
		"Run", "Idle":
			can_jump_in_this_state = true
			$CoyoteTimer.start()
		"Wallrun":
			can_walljump_in_this_state = true
			$CoyoteTimer.start()
		"UpWallrun":
			can_upwalljump_in_this_state = true
			$CoyoteTimer.start()
		"LedgeGrab":
			can_grab_ledge = false
			$IgnoreLedges.start()

# Called every physics frame when this state is active.
func on_physics_process(delta):
	handle_fall(delta)
	handle_landing()
	handle_movement(delta)
	handle_jump()
	handle_ledgegrab()
	
	if Input.is_action_just_pressed("jump"):
		if can_walljump_in_this_state:
			change_state("WallJump")
		elif can_upwalljump_in_this_state:
			change_state("UpWallrunJump")

# Called when the state machine exits this state.
func on_exit():
	pass

func coyote_disable_jump() -> void :
	can_jump_in_this_state = false
	can_walljump_in_this_state = false
	can_upwalljump_in_this_state = false

func handle_landing():
	if not player.legs.is_touching_floor():
		_power = abs(player.velocity.y / 18)
	else:
		player.add_speed_ratio -= _power
		change_state("Run")


func _on_ignore_ledges_timeout() -> void:
	can_grab_ledge = true
