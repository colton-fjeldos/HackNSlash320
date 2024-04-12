extends CanvasLayer
var player
var root
var bigBox
var smolBoxes

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $SlideAnimation/AnimationPlayer
	root = $SlideAnimation
	root.hide()
	player.play("RESET")
	bigBox = $SlideAnimation/AnimationPlayer/ColorRect
	smolBoxes = $SlideAnimation/AnimationPlayer/ColorRect2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_scene(target: String, type: String):
	if (type == 'fade'):
		transitionFade(target)
	if (type == 'slide'):
		transitionSlide(target)
	pass

func transitionSlide(target: String):
	root.show()
	bigBox.show()
	smolBoxes.show()
	player.play('SlideIn')
	await(player)
	get_tree().change_scene_to_file(target)
	player.play('SlideOut')
	bigBox.hide()
	smolBoxes.hide()
	root.hide()

func transitionFade(target: String):
	root.show()
	bigBox.show()
	player.play('FadeIn')
	await(player)
	get_tree().change_scene_to_file(target)
	player.play('FadeOut')
	bigBox.hide()
	root.hide()
