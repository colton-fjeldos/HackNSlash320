extends Node

var next_world
var current_world
var player

signal world_change

func _ready():
	player = $AnimationScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func proccess_world_change():
	var next_world_name: String
	var animation_name: String
	current_world = Global.current_world
	match current_world:
		"Scene1":
			#next_world = load("res://Scenes/Scene2.tscn")
			animation_name = "SlideIn"
		"Scene2":
			#next_world = load("res://Scenes/Scene1.tscn")
			animation_name = "FadeIn"
		_:
			return
	#next_world.z_index = -1
	#add_child(next_world)
	player.play(animation_name)
	#next_world.connect("world_change", self, "proccess_world_change")


func _on_animation_scene_animation_finished(anim_name):
	var last = 0
	match anim_name:
		"FadeIn":
			#current_world.queue_free()
			#current_world = next_world
			#current_world.z_index = 0
			#next_world = null
			player.play("FadeOut")
		"SlideIn":
			#current_worled.queue_free()
			#current_world = next_world
			#current_world.z_index = 0
			#next_world = null
			player.play("SlideOut")
		"FadeOut":
			last = 1
		"SlideOut":
			last = 1
	if (last == 1):
		print(current_world)
		match current_world:
			"Scene1":
				get_tree().change_scene_to_file("res://Scenes/Scene2.tscn")
			"Scene2":
				get_tree().change_scene_to_file("res://Scenes/Scene1.tscn")


func _on_scene_1_world_change():
	proccess_world_change()
