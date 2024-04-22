extends CharacterBody2D

var _player
var _targetFound = false
var speed = 200
var bullet = preload("res://Scenes/Bullet.tscn")


func _ready():
	_player = get_parent().get_node("controlled1")
#	await get_tree().idle_frame
	
func _physics_process(delta):
		
	if !_targetFound:
		return
	
	if(!_player.playerAlive):
		return
	
	$NavigationAgent2D.target_position = _player.global_position
	var nextPos = $NavigationAgent2D.get_next_path_position()
	velocity = global_position.direction_to(nextPos) * speed
	
	if(_player.global_position.x < global_position.x):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	#if(global_position.distance_to(_player.global_position) < 30):
		#velocity = Vector2.ZERO
	
	var direction = global_position.direction_to(_player.global_position).angle()
	$RayCast2D.rotation = direction
	
	if $RayCast2D.is_colliding():
		if( $RayCast2D.get_collider().name == 'controlled1'):
			if($RayCast2D/ReloadTimer.is_stopped()):
				shoot()
				
				#
	if(global_position.distance_to(_player.global_position) < 30):
		velocity = Vector2.ZERO
	if $SoftCollsion.is_colliding():
		velocity += $SoftCollsion.get_push_vector() * 4000
		
	move_and_slide()

func shoot():
	
	$RayCast2D.enabled = false
	var b = bullet.instantiate()
	get_parent().add_child(b)
	b.global_position = global_position
	
	b.move(_player.global_position)
	#b.global_rotation = $RayCast2D.global_rotation
	
	$RayCast2D/ReloadTimer.start()
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	_targetFound = true


func _on_reload_timer_timeout():
	$RayCast2D.enabled = true
