extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$".".hide()
	pass # Replace with function body.


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
	$".".show()
	$AnimationPlayer.play('SlideIn')
	await($AnimationPlayer)
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play('SlideOut')
	$".".hide()

func transitionFade(target: String):
	$".".show()
	$AnimationPlayer.play('FadeIn')
	await($AnimationPlayer)
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play('FadeOut')
	$".".hide()
