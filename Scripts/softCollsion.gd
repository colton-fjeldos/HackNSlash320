extends Area2D

# https://www.youtube.com/watch?v=2LBuO7lbeAE
func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas ()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		var random_dir_change = -1 if randf() < 0.5 else 1
		push_vector = area.global_position.direction_to(global_position).rotated(random_dir_change * PI/4)
		push_vector = push_vector.normalized()
	return push_vector
