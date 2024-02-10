extends CharacterBody2D

var _SPEED = 30
var jumpForce = 100
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _leftRay
var _rightRay
var _player
var _animation
var health = 100
var inChase = false

# State variables
enum States {idle, patrolling, chasing, attacking}
var state

func _ready():
	_leftRay = $LeftRaycast
	_rightRay = $RightRaycast
	_player = get_parent().get_node("controlled1")
	state = States.patrolling 
	_animation = $AnimationPlayer
#	velocity.x = _SPEED

func _physics_process(delta):

	if (inChase == false):
		if (_playerInChaseRange()):
			_chase()
			inChase = true
		else:
			_patrol()
	
	else:
		if (_playerInAttackRange()):
			_attack()
		else:
			_chase()

func _patrol():
	$Attack.visible = false
	$Walk.visible = true
	$Run.visible = false
	_animation.play("Walk")


	if (!_leftRay.is_colliding() or !_rightRay.is_colliding()):
		if ($Walk.flip_h == true):
			$Walk.flip_h = false
			velocity.x = _SPEED
		else:
			$Walk.flip_h = true
			velocity.x = -1 * _SPEED

	move_and_slide()

func _chase():
	#var vel
	$Attack.visible = false
	$Walk.visible = false
	$Run.visible = true
	_animation.play("Run")

	if (_player.global_position.x <= global_position.x):
		if ($Run.flip_h == false):
			$Run.flip_h = true
			
		velocity.x = -1 * _SPEED
		move_and_slide()
		
	else:
		if ($Run.flip_h == true):
			$Run.flip_h = false
		velocity.x = _SPEED
		move_and_slide()
	

	
func _attack():
	$Walk.visible = false
	$Run.visible = false
	$Attack.visible = true
	
	if (_player.global_position.x <= global_position.x):
		$Attack.flip_h = 	true
	else:
		$Attack.flip_h = false
	_animation.play("Attack")
	
	velocity = Vector2.ZERO
	move_and_slide()

func _playerInChaseRange():
	if (global_position.distance_to(_player.global_position) < 100 and global_position.distance_to(_player.global_position) > 40):
		state = States.chasing
		return true
	else:
		return false

func _playerInAttackRange():
	if (global_position.distance_to(_player.global_position) < 40):
		state = States.attacking
		return true
		
	else:
		return false

func _on_area_2d_body_entered(body):
	print(body.name)

func updateHealth():
	health = health - 20
	if health <= 0:
		queue_free()
