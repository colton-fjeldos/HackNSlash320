extends GutTest

var enemyScript = load("res://Scripts/Enemy.gd")
var scene = load("res://Scenes/Scene1.tscn")

func test_health():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	
	enemy.updateHealth(7)
	assert_eq(enemy._health, 93)
	
	enemy.updateHealth(100)
	assert_eq(weakref(enemy), null)

func test_attackState():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(10,10)
	player.global_position = Vector2(20,10)
	
	enemy._playerInAttackRange(enemy.global_position, player.global_position)


func test_chaseState():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(20,80)
	player.global_position = Vector2(20,10)
	
	enemy._playerInChaseRange(enemy.global_position, player.global_position)
	
	assert_eq(enemy.state, enemy.States.chasing)


func test_patrolState():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(10,10)
	player.global_position = Vector2(20,200)
	
	enemy._ready()
	
	assert_eq(enemy.state, enemy.States.patrolling)


func test_patrol():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(20,80)
	
	var wSprite = enemy.get_node("Walk")
	var wAnim = enemy.get_node("AnimationPlayer")
	
	enemy._patrol()
	
	assert_eq(enemy.velocity.x, 60)
	assert_true(wSprite.visible)
	assert_eq(wAnim.current_animation, "Walk")
	assert_not_same(enemy.global_position,  Vector2(20,80))


func test_chase():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(20,80)
	
	var rSprite = enemy.get_node("Run")
	var rAnim = enemy.get_node("AnimationPlayer")
	
	enemy._chase()
	
	assert_eq(enemy.velocity.x, 100)
	assert_true(rSprite.visible)
	assert_eq(rAnim.current_animation, "Run")
	assert_not_same(enemy.global_position,  Vector2(20,80))


func test_attack():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	enemy.global_position = Vector2(20,80)
	
	var aSprite = enemy.get_node("Attack")
	var aAnim = enemy.get_node("AnimationPlayer")
	
	enemy._attack()
	
	assert_eq(enemy.velocity.x, 0)
	assert_true(aSprite.visible)
	assert_eq(aAnim.current_animation, "Attack")
	assert_not_same(enemy.global_position,  Vector2(20,80))


func test_playerHealth():
	var sceneIns = scene.instantiate()
	var enemy = sceneIns.get_node("Enemy")
	var player = sceneIns.get_node("controlled1")
	
	enemy.global_position = Vector2(10,10)
	player.global_position = Vector2(9,10)
	
	enemy._on_area_2d_body_entered(player)
	
	assert_eq(player.attacked, true)
