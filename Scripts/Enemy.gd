extends CharacterBody2D

var _SPEED = 60
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _leftRay
var _rightRay
var _player
var _animation
var _health = 100
var _inChase = false
var _enemyMovement
var _pathfinder


# State variables
enum States {idle, patrolling, chasing, attacking}
var state

func _ready():
	_leftRay = $LeftRaycast
	_rightRay = $RightRaycast
	_player = get_parent().get_node("controlled1")
	state = States.patrolling 
	_animation = $AnimationPlayer
	_pathfinder = get_parent().get_node("Pathfinder")

func _physics_process(delta):
	
	if(!is_on_floor()):

		velocity.y += _gravity * delta
		move_and_slide()
	
	if (_inChase == false):
		if (_playerInChaseRange(global_position, _player.global_position)):
			_chase()
			_inChase = true
		else:
			_patrol()

	else:
		if (_playerInAttackRange(global_position, _player.global_position)):
			_attack()
		else:
			_chase()

func _patrol():
	$Attack.visible = false
	$Walk.visible = true
	$Run.visible = false
	$AnimationPlayer.play("Walk")

	if (!$LeftRaycast.is_colliding() or $RightRaycast.is_colliding()):
		if ($Walk.flip_h == true):
			$Walk.flip_h = false
			velocity.x = _SPEED
		else:
			$Walk.flip_h = true
			velocity.x = -1 * _SPEED

	move_and_slide()

func _chase():
	_SPEED = 100
	$Attack.visible = false
	$Walk.visible = false
	$Run.visible = true
	$AnimationPlayer.play("Run")
	var jumpForce = -295
	var isJumping
	var reachPoint = -1
	
	
	#_enemyMovement = _pathfinder.getPath(global_position, _player.global_position)
	#_enemyMovement.push_back(_player.global_position)
	#var nextPos = _enemyMovement[0]
#
	#
	#if(_enemyMovement.size() > 1):
		#if _enemyMovement[0].y == _enemyMovement[1].y or _enemyMovement.size() == 2 :
			#if (abs(_enemyMovement[0].x - global_position.x) < abs(_enemyMovement[0].x - _enemyMovement[1].x)):
				#nextPos = _enemyMovement[1]
#
#
		#if (nextPos.x <= global_position.x):
			#$Run.flip_h = true
			#velocity.x = -1 * _SPEED
			#
			#if !_leftRay.is_colliding() and is_on_floor():
				#velocity.y = jumpForce
				#
			#move_and_slide()
#
		#else:
#
			#$Run.flip_h = false
			#velocity.x = _SPEED
			#
			#if !_rightRay.is_colliding() and is_on_floor():
				#velocity.y = jumpForce
			#move_and_slide()
			##########comment
	
func _jump():
	pass
	
func _attack():
	$Walk.visible = false
	$Run.visible = false
	$Attack.visible = true
	
	#if (_player.global_position.x <= global_position.x):
		#$Attack.flip_h = 	true
	#else:
		#$Attack.flip_h = false
	$AnimationPlayer.play("Attack")
	
	velocity = Vector2.ZERO
	move_and_slide()

func _playerInChaseRange(enemyPos, playerPos):
	if (enemyPos.distance_to(playerPos) < 100 and enemyPos.distance_to(playerPos) > 40):
		state = States.chasing
		return true
	return false

func _playerInAttackRange(enemyPos, playerPos):
	if (enemyPos.distance_to(playerPos) < 40):
		state = States.attacking
		return true
		
#func _playerInAttackRange():
	#if (global_position.distance_to(_player.global_position) < 40):
		#state = States.attacking
		#return true
	return false

func _on_area_2d_body_entered(body):
	var _player = get_parent().get_node("controlled1")
	_player.attackSignal()

func updateHealth(damage):
	_health = _health - damage
	if _health <= 0:
		queue_free()
