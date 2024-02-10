extends Control
var pauseMenu
var paused
var volumeLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pauseMenu = $PauseMenu
	volumeLabel = $PauseMenu/VolumeLabel
	paused = false
	pauseMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		PauseLogic()

func PauseLogic():
	if paused:
		pauseMenu.hide()
		Engine.time_scale = 1
	else:
		pauseMenu.show()
		Engine.time_scale = 0
	paused = !paused


func _on_back_button_pressed():
	pauseMenu.hide()
	Engine.time_scale = 1


func _on_quit_button_pressed():
	get_tree().quit()


func _on_volume_slider_value_changed(value):
	volumeLabel.set_text("Volume: " + String.num(value,-1))


func _on_reset_button_pressed():
	get_tree().reload_current_scene()
	Engine.time_scale = 1
