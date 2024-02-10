extends CharacterBody2D

var _SPEED = 100
var jumpForce = 100
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _leftRay
var _rightRay
var _player
var _animation
var health = 100

# State variables
enum States {idle, patrolling, chasing, attacking}
var state

func _ready():
	_leftRay = $LeftRaycast
	_rightRay = $RightRaycast
	_player = get_parent().get_node("Player")
	state = States.patrolling 
	_animation = $AnimationPlayer
	velocity.x = _SPEED

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y = _gravity * delta
		move_and_slide()

	if (_playerInAttackRange()):
		_attack()
	
	elif (_playerInChaseRange()):
		_chase()
	else :
		_patrol()

func _patrol():
	$Attack.visible = false
	$Walk.visible = true
	$Run.visible = false
	_animation.play("Walk")

	if (!_leftRay.is_colliding() or !_rightRay.is_colliding()):
		if ($Walk.flip_h == true):
			$Walk.flip_h = false
		else:
			$Walk.flip_h = true
			
			var vel = velocity.x
			velocity.x = -1 * vel
	
	move_and_slide()

func _chase():
	var vel
	$Attack.visible = false
	$Walk.visible = false
	$Run.visible = true
	_animation.play("Run")
	
	$NavigationAgent2D.set_target_position(_player.global_position)
	
	if (_player.global_position.x < global_position.x):
		if ($Run.flip_h == false):
			vel = velocity.x
			velocity.x = -1 * vel
			$Run.flip_h = 	true
		
	else:
		if ($Run.flip_h == true):
			vel = velocity.x
			velocity.x = -1 * vel
			$Run.flip_h = 	false
	
	move_and_slide()
	
	#$NavigationAgent2D.set_target_position(_player.global_position)
	
	#if not $NavigationAgent2D.is_navigation_finished():
	#	var nextPos = $NavigationAgent2D.get_next_path_position()
	#	var dir = global_position.direction_to(_player.global_position)
	#	velocity = dir * _SPEED
	#	move_and_slide()
	
func _attack():
	$Walk.visible = false
	$Run.visible = false
	$Attack.visible = true
	
	if (_player.global_position.x < global_position.x):
		$Attack.flip_h = 	true
	else:
		$Attack.flip_h = false
	_animation.play("Attack")
	
	velocity = Vector2.ZERO
	move_and_slide()

func _playerInChaseRange():
	if (global_position.distance_to(_player.global_position) < 200 and global_position.distance_to(_player.global_position) > 80):
		state = States.chasing
		return true
	else:
		return false

func _playerInAttackRange():
	if (global_position.distance_to(_player.global_position) < 80):
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
