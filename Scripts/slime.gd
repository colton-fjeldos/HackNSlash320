extends CharacterBody2D


const SPEED = 100
var _health = 100
var knockback = Vector2.ZERO
var knockback_strength = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("/root/Node2D/controlled1")
@onready var healthbar = $HealthBar

func _ready():
	healthbar.init_health(_health)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	position += (((player.position - position)/SPEED) * delta * 75) + knockback #update position based on getting hit

	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 0.1) #reset knockback over 0.1 seconds
	

func updateHealth(damage):
	_health = _health - damage
	healthbar.health = _health
	if _health <= 0:
		queue_free()
		
func applyKnockback(knockback_force: Vector2):
	knockback += knockback_force

func _on_hit_body_entered(body):
	if "player" in body.name:
		var direction = global_position.direction_to(body.global_position)
		var force = -direction * knockback_strength
		body.knockback = force

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
