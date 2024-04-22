extends Area2D

var player

func _ready():
	player = get_parent().get_node("controlled1")
	
func move(pos):
	var tween = create_tween ()
	var duration1 = global_position.distance_to(player.global_position)/400 
	
	tween.tween_property(self, "global_position", player.global_position, duration1).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)
	
	await tween.finished
	if(global_position.distance_to(player.global_position) < 10):
		player.takeDamage(50)
	
	queue_free()
