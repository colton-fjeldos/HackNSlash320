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
			print("Running global function!")
			GlobalAnimation.change_scene("res://Scenes/Scene2.tscn","slide")
	pass


func _on_body_entered(_body: CharacterBody2D):
	inRange = true


func _on_body_exited(_body):
	inRange = false
