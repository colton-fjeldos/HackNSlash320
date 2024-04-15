extends AnimationPlayer
var player
var root
var bigBox
var smolBoxes
var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"."
	player.play('RESET')
	#loadResources()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if (!loaded):
		#loadResources()

func change_scene(target: String, type: String):
	if (type == 'fade'):
		transitionFade(target)
	if (type == 'slide'):
		transitionSlide(target)
	pass

func transitionSlide(target: String):
	#if (!loaded):
		#loadResources()
	#if (loaded):
	player.play('SlideIn')
	await(player)
	get_tree().change_scene_to_file(target)
	player.play('SlideOut')

func transitionFade(target: String):
	player.play('FadeIn')
	await(player)
	get_tree().change_scene_to_file(target)
	player.play('FadeOut')

#func loadResources():
	#player = $AnimationPlayer
	#root = $"."
	#bigBox = $AnimationPlayer/ColorRect
	#smolBoxes = $AnimationPlayer/ColorRect2
	#await(player)
	#await(smolBoxes)
	#await(bigBox)
	#if ((bigBox == $AnimationPlayer/ColorRect) and (smolBoxes == $AnimationPlayer/ColorRect2) and (player == $AnimationPlayer)):
		#loaded = true


func _on_animation_finished(anim_name):
	pass # Replace with function body.
