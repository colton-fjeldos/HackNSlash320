extends CharacterBody2D


var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _walkPoint = preload("res://Scenes/walkpoints.tscn")
var _player
var _health = 100
var _inChase = false
var _pathfinder
var isJumping = false
var processCount = 0
var buffer

enum States {idle, patrolling, chasing, attacking}
var state = States.patrolling

func _ready():
	
	_stateUpdate()
	_player = get_parent().get_node("controlled1")
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
			state = States.chasing
			_stateUpdate()
			_chase()
			
	if state == States.attacking:
		_giveDamage()


func _stateUpdate():
	if(state == States.patrolling):
		$Attack.visible = false
		$Walk.visible = true
		$Run.visible = false
		$AnimationPlayer.play("Walk")
		
	elif (state == States.chasing):
		$Attack.visible = false
		$Walk.visible = false
		$Run.visible = true
		$AnimationPlayer.play("Run")
	
	else:
		$Walk.visible = false
		$Run.visible = false
		$Attack.visible = true
		$AnimationPlayer.play("Attack")
		

func _patrol():
	var patrolSpeed = 30

	if (!$LeftRaycast.is_colliding() or !$RightRaycast.is_colliding()):
		if ($Walk.flip_h == true):
			$Walk.flip_h = false
			velocity.x = patrolSpeed
		else:
			$Walk.flip_h = true
			velocity.x = -1 * patrolSpeed
	move_and_slide()

func _chase():
	var chaseSpeed = 70
	var jumpForce = -200
	var ii = 0
	
	
	var _enemyMovement = _pathfinder.getPath(global_position, _player.global_position)
	_enemyMovement.push_back(_player.global_position)
	var nextPos = _enemyMovement[ii]
	
	if (processCount == 0):
			buffer = global_position.y - _enemyMovement[0].y
			processCount = 1
			
	
	#print (_enemyMovement[0])
	print(_player.global_position)
	
	if(_enemyMovement.size() > 1):
		if _enemyMovement[0].y == _enemyMovement[1].y or _enemyMovement.size() == 2:
			if (abs(_enemyMovement[0].x - global_position.x) < abs(_enemyMovement[0].x - _enemyMovement[1].x)):
				ii += 1
				nextPos = _enemyMovement[1]
				#print (" 1 ", _enemyMovement)
				#print()
		elif (nextPos.y >= (global_position.y - buffer - 1)) and (nextPos.y <= (global_position.y + buffer + 1)) and _player.is_on_floor() and is_on_floor():
			if (abs (nextPos.x - global_position.x) <= 1):
				ii += 1
				nextPos = _enemyMovement[1]
				#print (" 2 ", _enemyMovement)
				#print()
		#print(nextPos, " ", global_position.x, ",", (global_position.y - buffer))

		if !(nextPos.y + 1 >= (global_position.y - buffer)) and _player.is_on_floor() and is_on_floor():
			isJumping = true
			nextPos.y = nextPos.y + buffer
			var secondPos = _enemyMovement[ii + 1]
			secondPos.y = secondPos.y + buffer
			_jump(nextPos, secondPos)
		else:
			isJumping = false
		
	if (nextPos.x <= global_position.x):
		$Run.flip_h = true
		velocity.x = -1 * chaseSpeed
		if !$LeftRaycast.is_colliding() and is_on_floor() and !isJumping:
			velocity.y = jumpForce
		
	else:
		$Run.flip_h = false
		velocity.x = chaseSpeed
		if !$RightRaycast.is_colliding() and is_on_floor() and !isJumping: 
			velocity.y = jumpForce
			
	move_and_slide()


func _jump(pos1, pos2):
	var tween = create_tween ()
	var duration1 = pos1.distance_to(global_position)/100
	
	tween.tween_property(self, "global_position", pos1, duration1).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)
	
	var duration2 = pos2.distance_to(global_position)/100
	tween.tween_property(self, "global_position", pos2, duration2).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)
	
	#if !tween.is_running():
	#tween.tween_property(self, "global_position", pos1, 1)
	#tween.tween_property(self, "global_position", pos2, 1)
	
	
	
func _attack():
	
	if (_player.global_position.x <= global_position.x):
		$Attack.flip_h = 	true
	else:
		$Attack.flip_h = false
	
	velocity = Vector2.ZERO
	move_and_slide()


func _playerInChaseRange(enemyPos, playerPos):
	if (enemyPos.distance_to(playerPos) < 100 and enemyPos.distance_to(playerPos) > 10):
		state = States.chasing
		_stateUpdate()
		return true
	return false


func _playerInAttackRange(enemyPos, playerPos):
	if (enemyPos.distance_to(playerPos) < 15):
		state = States.attacking
		_stateUpdate()
		return true
	return false



func updateHealth(damage):
	_health = _health - damage
	if _health <= 0:
		queue_free()
		
		
func _giveDamage():
	#_player.takeDamage(1)
	pass
	#print (_player.playerHealth)



