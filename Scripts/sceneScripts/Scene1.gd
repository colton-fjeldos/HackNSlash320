extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var menu = 0

func _process(delta):
	if Input.is_action_just_pressed("SkillTree"):
		print("SKILL!")
		get_tree().paused = true
		Global.is_skill_tree_open = true
		menu = 1
	if Input.is_action_just_pressed("ui_cancel"):
		print("Pause!")
		get_tree().paused = true
		Global.is_pause_menu_open = true
