extends Control

var pauseMenu
var volumeLabel
var ispaused
var volumestring
var isvisible


# Called when the node enters the scene tree for the first time.
func _ready():
	pauseMenu = $"."
	volumeLabel = $PanelContainer/PauseMenuContainer/VolumeLabel
	ispaused = false
	isvisible = false
	volumestring = ""
	pauseMenu.hide()
	$AnimationPlayer.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		PauseLogic()

func PauseLogic():
	if !Global.is_skill_tree_open:
		if ispaused:
			resume()
			Global.is_pause_menu_open = false
		elif !ispaused:
			pause()
			Global.is_pause_menu_open = true

func _on_back_button_pressed():
	resume()
	Global.is_pause_menu_open = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_volume_slider_value_changed(value):
	set_volumelabel(value)
	volumeLabel.set_text(volumestring)

func _on_reset_button_pressed():
	resume()
	get_tree().reload_current_scene()
	Global.is_pause_menu_open = false

func pause():
	show()
	$AnimationPlayer.play("blur-animation")
	ispaused = true
	get_tree().paused = ispaused

#I set this to false for unit testing
func resume():
	ispaused = false
	get_tree().paused = ispaused
	hide()
	$AnimationPlayer.play_backwards("blur-animation")

#get the value for unit testing
func set_ispaused(value):
	ispaused = value

#check the value for unit testing
func set_volumelabel(value):
	volumestring = ("Volume: " + String.num(value,-1))
