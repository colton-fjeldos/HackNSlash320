extends Control

var pauseMenu
var volumeLabel
var ispaused
# Called when the node enters the scene tree for the first time.
func _ready():
	pauseMenu = $"."
	volumeLabel = $PanelContainer/PauseMenu/VolumeLabel
	pauseMenu.hide()
	$AnimationPlayer.play("RESET")
	ispaused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		PauseLogic()

func PauseLogic():
	if ispaused:
		resume()
	elif !ispaused:
		pause()

func _on_back_button_pressed():
	resume()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_volume_slider_value_changed(value):
	volumeLabel.set_text("Volume: " + String.num(value,-1))

func _on_reset_button_pressed():
	resume()
	get_tree().reload_current_scene()

func pause():
	pauseMenu.show()
	$AnimationPlayer.play("blur-animation")
	ispaused = !ispaused
	get_tree().paused = ispaused
	
func resume():
	ispaused = !ispaused
	get_tree().paused = ispaused
	pauseMenu.hide()
	$AnimationPlayer.play_backwards("blur-animation")
