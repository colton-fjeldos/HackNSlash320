extends Node2D
var inRange = false

signal world_change

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_world = "Scene2"

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
	if inRange:
		if Input.is_action_just_pressed("interact"):
			print("Player Interacted with door!")
			emit_signal("world_change")

func _on_area_2d_body_entered(_body: CharacterBody2D):
	inRange = true

func _on_area_2d_body_exited(body):
	inRange = false


func _on_world_change():
	pass # Replace with function body.
