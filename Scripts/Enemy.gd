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
	
	if(global_position.y > 630):
		queue_free()
	
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
	_SPEED = 30
	$Attack.visible = false
	$Walk.visible = true
	$Run.visible = false
	$AnimationPlayer.play("Walk")

	if (!$LeftRaycast.is_colliding() or !$RightRaycast.is_colliding()):
		if ($Walk.flip_h == true):
			$Walk.flip_h = false
			velocity.x = _SPEED
		else:
			$Walk.flip_h = true
			velocity.x = -1 * _SPEED
	move_and_slide()

func _chase():
	_SPEED = 70
	$Attack.visible = false
	$Walk.visible = false
	$Run.visible = true
	$AnimationPlayer.play("Run")
	var jumpForce = -200
	var isJumping
	var reachPoint = -1
	
	
	_enemyMovement = _pathfinder.getPath(global_position, _player.global_position)
	_enemyMovement.push_back(_player.global_position)
	var nextPos = _enemyMovement[0]
	#print (_enemyMovement)
	#print ("nextPos: ", nextPos, " enemyPos: ", global_position, "vel: ", velocity.x)
	#print()
	#print ("playerPos: ", _player.global_position)
	
	if(_enemyMovement.size() > 1):
		if _enemyMovement[0].y == _enemyMovement[1].y or _enemyMovement.size() == 2 :
			if (abs(_enemyMovement[0].x - global_position.x) < abs(_enemyMovement[0].x - _enemyMovement[1].x)):
				nextPos = _enemyMovement[1]


	if (nextPos.x <= global_position.x + 2):
		$Run.flip_h = true
		velocity.x = -1 * _SPEED
		if !_leftRay.is_colliding() and is_on_floor():
			velocity.y = jumpForce

	else:
		$Run.flip_h = false
		velocity.x = _SPEED
		
		if !_rightRay.is_colliding() and is_on_floor():
			velocity.y = jumpForce
	
	
	if ((nextPos.y + 8) < (global_position.y) and _player.is_on_floor() and is_on_floor()):
		var y = (global_position.y - nextPos.y) * jumpForce
		velocity.y = jumpForce
	
	move_and_slide()


func _attack():
	$Walk.visible = false
	$Run.visible = false
	$Attack.visible = true
	
	if (_player.global_position.x <= global_position.x):
		$Attack.flip_h = 	true
	else:
		$Attack.flip_h = false
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
	return false


func _on_area_2d_body_entered(body):
	var _player = get_parent().get_node("controlled1")
	_player.takeDamage(20)


func updateHealth(damage):
	_health = _health - damage
	if _health <= 0:
		queue_free()
