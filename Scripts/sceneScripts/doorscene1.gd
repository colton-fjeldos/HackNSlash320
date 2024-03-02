extends Area2D
var inRange

# Called when the node enters the scene tree for the first time.
func _ready():
	inRange = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inRange:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://Scenes/Scene2.tscn")
	pass


func _on_body_entered(_body: PhysicsBody2D):
	inRange = true


func _on_body_exited(_body):
	inRange = false
