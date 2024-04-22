extends CharacterBody2D

var _player
var _health = 100
var _inChase = false
var _chaseCount = 0
var _pathfinder
var isJumping = false
var processCount = 0
var second = Vector2.ZERO
var fallSecond = Vector2.ZERO
var buffer
var isFalling = false
var isJumping2 = false
var onDescent = false
var heightReached = false
var _enemyMovement = []
var attackRange = false

enum States {idle, patrolling, chasing, attacking}
var state = States.patrolling

func _ready():
	_stateUpdate()
	_player = get_parent().get_node("controlled1")
	_pathfinder = get_parent().get_node("Pathfinder")
	

func _physics_process(delta):
	if(heightReached and !onDescent and velocity.y > 0 and (velocity.x == 20 or velocity.x == -20)):
		onDescent = true
	
	if(onDescent and is_on_floor_only() and isJumping):
		onDescent = false
		heightReached = false
		isJumping = false
	
	if(!is_on_floor()):
		velocity.y += 480 * delta
		move_and_slide()
	elif (isJumping2 and is_on_floor()):
		isJumping2 = false
		
	if(global_position.y > 630):
		queue_free()
	
	if (_inChase == false):
		if (_playerInChaseRange(global_position, _player.global_position)):
			_chase()
			_inChase = true
		else:
			_patrol()
		
	else:
		if (_playerInAttackRange(global_position, _player.global_position) and _player.is_on_floor_only() and _chaseCount != 0):
			_attack()
		else:
			state = States.chasing
			_stateUpdate()
			_chase()
			_chaseCount = 1
			
	if state == States.attacking:
		_player.takeDamage(0.5)
		

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
	var chaseSpeed = 100
	var ii = 0
	
	
	if (processCount == 0 and !_player.is_on_floor()):
		if (_player.global_position.x <= global_position.x):
			$Run.flip_h = true
		else:
			$Run.flip_h = false
		return
		
	var _enemyMovement = _pathfinder.getPath(global_position, _player.global_position)
	_enemyMovement.push_back(_player.global_position)

	
	var nextPos = _enemyMovement[ii]
	
	if (processCount == 0 and is_on_floor()):
			buffer = global_position.y - _enemyMovement[0].y
			processCount = 1

	if(_enemyMovement.size() > 1):
		if _enemyMovement[0].y == _enemyMovement[1].y or _enemyMovement.size() == 2:
			if (abs(_enemyMovement[0].x - global_position.x) < abs(_enemyMovement[0].x - _enemyMovement[1].x)):
				ii += 1
				nextPos = _enemyMovement[1]
				
		elif (nextPos.y >= (global_position.y - buffer - 1)) and (nextPos.y <= (global_position.y - buffer + 1)) and _player.is_on_floor() and is_on_floor():
			if (abs (nextPos.x - global_position.x) <= 3):
				ii += 1
				nextPos = _enemyMovement[1]

		if (nextPos.y + 1 < (global_position.y - buffer - 1)) and _player.is_on_floor() and is_on_floor() and !isJumping and _enemyMovement.size() > (ii+1) and !isFalling:
			
			isJumping = true
			var secondPos = _enemyMovement[ii + 1]
			secondPos.y = secondPos.y + buffer
			nextPos.y = nextPos.y + buffer
			second = secondPos
			
			if (secondPos.x <= nextPos.x):
				$Run.flip_h = true
			else:
				$Run.flip_h = false
			_jump(nextPos, secondPos)
		
		if ((_enemyMovement.size() > 2 or( _enemyMovement.size() > 2 and _player.is_on_floor_only())) and !isFalling and !isJumping):
			if (_enemyMovement[0].y >= (global_position.y - buffer - 1)) and (_enemyMovement[0].y <= (global_position.y - buffer + 1)) and is_on_floor():
				
				var secondPos = _enemyMovement[1]
				if (secondPos.y > _enemyMovement[0].y):
					
					isFalling = true

					_enemyMovement[0].y = _enemyMovement[0].y + (buffer)
					secondPos.y = secondPos.y + (buffer)
					fallSecond = secondPos
					
					if (_enemyMovement[0].x <= global_position.x):
						$Run.flip_h = true
					else:
						$Run.flip_h = false
						
					_fall(_enemyMovement[0], secondPos)

		elif (isFalling):
			print(global_position.distance_to(fallSecond))
			if (global_position.distance_to(fallSecond) < 5 and is_on_floor()):
				isFalling = false
		
		if(!isJumping and !isFalling):
			var jumpForce = abs(global_position.x - nextPos.x) * -1.5

			if (nextPos.x <= global_position.x):
				$Run.flip_h = true
				velocity.x = -1 * chaseSpeed
				if !$LeftRaycast.is_colliding() and is_on_floor_only() and $RightRaycast.is_colliding() and !isFalling and !isJumping and !isJumping2:
					var g = global_position.y - buffer
					if(_enemyMovement.size() == (ii + 2) and (abs(global_position.x - _player.global_position.x) < 18)):
						velocity = Vector2.ZERO
					
					elif (_enemyMovement.size() > (ii + 2)):
						var secondPos = _enemyMovement[ii + 1]
						if (secondPos.y <= (g + 1) and secondPos.y >= (g - 1)):
							isJumping2 = true
							velocity.y = jumpForce
					else:
						if(_player.is_on_floor()):
							isJumping2 = true
							velocity.y = jumpForce
						else:
							velocity = Vector2.ZERO
				
			else:
				$Run.flip_h = false
				velocity.x = chaseSpeed
				if !$RightRaycast.is_colliding() and is_on_floor() and $LeftRaycast.is_colliding and !isFalling and !isJumping and !isJumping2: 
					var g = global_position.y - buffer
					if(_enemyMovement.size() == (ii + 2) and (abs(global_position.x - _player.global_position.x) < 5)):
						velocity = Vector2.ZERO
					
					elif (_enemyMovement.size() > (ii + 2)):
						var secondPos = _enemyMovement[ii + 1]
						if (secondPos.y <= (g + 1) and secondPos.y >= (g - 1)):
							isJumping2 = true
							velocity.y = jumpForce
						
					else:
						if(_player.is_on_floor()):
							isJumping2 = true
							velocity.y = jumpForce
						
						else:
							velocity = Vector2.ZERO
	move_and_slide()


func _jump(pos1, pos2):

	var tween = create_tween()
	var duration1 = pos1.distance_to(global_position)/300
	
	tween.tween_property(self, "global_position", pos1, duration1).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)
	
	await tween.finished
	heightReached = true

	var jumpForce = abs(global_position.x - pos2.x) * -1.5

	velocity.y = -90
	if (pos2.x > global_position.x):
		velocity.x = 20
	else:
		velocity.x = -20
	move_and_slide()
	processCount += 1
	
func _fall(pos1, pos2):

	var tween = create_tween ()
	var duration1 = 0.2
	
	tween.tween_property(self, "global_position", pos1, duration1).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)
	
	var duration2 = pos2.distance_to(global_position)/400
	tween.tween_property(self, "global_position", pos2, duration2).set_trans(Tween.TRANS_LINEAR)
	tween.set_ease( Tween.EASE_IN_OUT)


func _attack():
	
	if (_player.global_position.x <= global_position.x):
		$Attack.flip_h = true
	else:
		$Attack.flip_h = false
	
	if(!isJumping and !isJumping2 and velocity.y != 0):
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

