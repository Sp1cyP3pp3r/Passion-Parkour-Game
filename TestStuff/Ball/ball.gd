extends RigidBody3D

#var local_collision_pos

#func _integrate_forces(state):
	#if state.get_contact_count() >= 1:
		#local_collision_pos = state.get_contact_local_pos(0)


func _on_body_entered(body: Node) -> void:
	apply_impulse(Vector3.UP * 8.5)
