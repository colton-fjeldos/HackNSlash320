extends GutTest
#
#var mainScreen = Control.new()
#mainScreen.set_script(load("res://Scripts/sceneScripts/pausemenu.gd"))
var pauseScript = load("res://Scripts/sceneScripts/pausemenu.gd")
var pauseScene = load("res://Scenes/PauseMenu.tscn")
var _sender = InputSender.new(Input)
var _script

func before_all():
	pass
	#pauseScene.set_script("res://Scripts/sceneScripts/pausemenu.gd")
	#var a = pauseScene.instantiate()
	#pauseScene.PanelContainer = $PanelContainer/PauseMenuContainer
	#pauseScene.VolumeLabel = $PanelContainer/PauseMenuContainer/VolumeLabel
	#_pauseScript = double(pauseScript).new()
	#stub(_pauseScript, "pause").to_return(true)
	#stub(_pauseScript, "resume").to_return(false)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_pause_menu_hidden_by_default():
	var _pauseMenu = pauseScene.instantiate()
	assert_false(_pauseMenu.isvisible)

func test_toggle_pause_menu_with_cancel_key():
	var pause1 = pauseScene.instantiate()
	var pause = pauseScript.new()
	pause1._ready()
	
	#_sender.action_down("ui_cancel").hold_for(.2)
	#pause1._process(1)
	pause1.pause()
	#simulate(pause, 1, 1)
	assert_true(pause1.ispaused)
	pause1.resume()
	assert_false(pause1.ispaused)
	#_sender.action_down("ui_cancel").hold_for(.2)
	#assert_true(pause1.ispaused)
	#_pauseScript.instantiate()
	#_sender.action_down("ui_cancel").hold_for(.2)
	#assert_true(_pauseScript)
	#assert_called(_pauseScript, 'paused')
	#_sender.action_down("ui_cancel").hold_for(.2)
	#assert_called(_pauseScript, 'resume')

func test_press_back_button_resumes_game():
	var _pauseMenu = pauseScene.instantiate()
	_pauseMenu._on_back_button_pressed()
	assert_false(_pauseMenu.ispaused)

#func test_press_quit_button_quits_game():
	#var _pauseMenu = pauseScene.instantiate()
	#_pauseMenu._on_quit_button_pressed()
	#assert_called(_pauseMenu, 'get_tree().quit')

func test_volume_changed():
	var pause = pauseScene.instantiate()
	pause.set_volumelabel(50)
	assert_eq(pause.volumestring, "Volume: 50", "The volume is set to 50")
