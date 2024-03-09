extends GutTest

var script1 = load("res://Scripts/sceneScripts/Scene1.gd")
var scene1 = load("res://Scenes/Scene1.tscn")
var pauseScript = load("res://Scripts/sceneScripts/pausemenu.gd")
var pauseScene = load("res://Scenes/PauseMenu.tscn")
var door1Script = load("res://Scripts/sceneScripts/doorscene1.gd")
var door2Script = load("res://Scripts/sceneScripts/doorscene2.gd")
var _sender = InputSender.new(Input)

func before_all():
	pass

func after_each():
	_sender.release_all()
	_sender.clear()

#acceptance test
func test_pause_menu_hidden_by_default():
	var _scene = pauseScene.instantiate()
	_scene._ready()
	assert_false(_scene.isvisible)

#acceptance test
func test_not_null_scene():
	var _scene = pauseScene.instantiate()
	_scene._ready()
	assert_not_null(_scene)

#acceptance test
func test_not_null_volumelabel():
	var _scene = pauseScene.instantiate()
	_scene._ready()
	assert_not_null(_scene.volumeLabel)

#acceptance test
func test_not_null_collisionShape():
	var a = scene1.instantiate()
	var collshape = a.get_node("Area2D/CollisionShape2D")
	assert_not_null(collshape)

#acceptance test
func test_door1_range_detection():
	var doorscript = door1Script.new()
	var a = scene1.instantiate()
	var dummybody = a.get_node("controlled1")
	doorscript._on_body_entered(dummybody)
	assert_true(doorscript.inRange)

#acceptance test
func test_door2_range_detection():
	var doorscript = door2Script.new()
	var a = scene1.instantiate()
	var dummybody = a.get_node("controlled1")
	doorscript._on_body_entered(dummybody)
	assert_true(doorscript.inRange)

#whiteboxtest
#func _process(delta):
	#if inRange:
		#if Input.is_action_just_pressed("interact"):
			#get_tree().change_scene_to_file("res://Scenes/Scene2.tscn")
func test_scene1_transition():
	var doorscript = door1Script.new()
	var a = scene1.instantiate()
	add_child(a)
	var dummybody = a.get_node("controlled1")
	doorscript._on_body_entered(dummybody)
	_sender.action_down("interact").hold_for(.2)
	assert_called(a, 'get_tree().change_scene_to_file("res://Scenes/Scene2.tscn")')

#whiteboxtest
#func _process(delta):
	#if inRange:
		#if Input.is_action_just_pressed("interact"):
			#get_tree().change_scene_to_file("res://Scenes/Scene1.tscn")
func test_scene2_transition():
	var doorscript = door2Script.new()
	var a = scene1.instantiate()
	add_child(a)
	var dummybody = a.get_node("controlled1")
	doorscript._on_body_entered(dummybody)
	_sender.action_down("interact").hold_for(.2)
	assert_called(a, 'get_tree().change_scene_to_file("res://Scenes/Scene1.tscn")')

#Integration test where it will call the get_tree() function to call scene1
#	and get the data from it
func test_toggle_pause_menu():
	var a = scene1.instantiate()
	var _scene = a.get_node("CanvasLayer/PauseMenu")
	add_child(a)
	_scene.PauseLogic()
	assert_eq(a.get_tree().paused,false)
	assert_true(_scene.ispaused)
	_scene.PauseLogic()
	assert_false(_scene.ispaused)

#This is a whitebox test that checks to see if the button calls the resume
# function correctly
#func _on_back_button_pressed():
	#resume()
#func resume():
	#ispaused = false
	#get_tree().paused = ispaused
	#hide()
	#$AnimationPlayer.play_backwards("blur-animation")
func test_press_back_button_resumes_game():
	var _scene = pauseScene.instantiate()
	_scene._ready()
	_scene._on_back_button_pressed()
	assert_false(_scene.ispaused)

#whitebox test
#fails to run because it cannot check get_tree().quit
#func _on_quit_button_pressed():
	#get_tree().quit()
func test_press_quit_button_quits_game():
	var _pauseMenu = double(pauseScene).instantiate()
	_pauseMenu._on_quit_button_pressed()
	assert_called(_pauseMenu, 'get_tree().quit')

#whiteboxtest 
#func _on_volume_slider_value_changed(value):
	#var str = set_volumelabel(value)
	#volumeLabel.set_text(str)
#func set_volumelabel(value):
	#volumestring = ("Volume: " + String.num(value,-1))
func test_volume_changed():
	var _scene = pauseScene.instantiate()
	_scene._ready()
	_scene._on_volume_slider_value_changed(50.02)
	assert_eq(_scene.volumestring, "Volume: 50", "The volume is set to 50")
