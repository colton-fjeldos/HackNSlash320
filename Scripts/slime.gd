extends CharacterBody2D


const SPEED = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("/root/Node2D/controlled1")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	position += ((player.position - position)/SPEED) * delta * 75

	move_and_slide()

