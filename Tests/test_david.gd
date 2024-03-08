extends GutTest

var pauseScript = load("res://Scripts/sceneScripts/pausemenu.gd")
var pauseScene = load("res://Scenes/PauseMenu.tscn")
var _sender = InputSender.new(Input)
var _pauseScript

func before_all():
	_pauseScript = double(pauseScript).new()
	stub(_pauseScript, "pause").to_return(true)
	stub(_pauseScript, "resume").to_return(false)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_pause_menu_hidden_by_default():
	var _pauseMenu = pauseScene.instantiate()
	assert_false(_pauseMenu.ispaused)

#func test_toggle_pause_menu_with_cancel_key():
	#var _pauseMenu = pauseScene.instantiate()
	#_sender.action_down("ui_cancel").hold_for(.2)
	#assert_called(_pauseMenu, 'paused')
	#_sender.action_down("ui_cancel").hold_for(.2)
	#assert_called(pauseScript, 'resume')
#
#func test_press_back_button_resumes_game():
	#var _pauseMenu = pauseScene.instantiate()
	#_pauseMenu._on_back_button_pressed()
	#
	#assert_called(_pauseMenu, 'resume')

#func test_press_quit_button_quits_game():
	#_pauseMenu._on_quit_button_pressed()
	#assert_called(_pauseMenu, 'get_tree().quit')

func test_volume_changed():
	var pause = pauseScene.instantiate()
	pause.set_volumelabel(50)
	assert_eq(pause.volumestring, "Volume: 50", "The volume is set to 50")
