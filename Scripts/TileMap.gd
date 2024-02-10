extends Node2D

var _walkPoint = preload("res://Scenes/walkpoints.tscn")
var jumpHeight = 0
var aStar = AStar2D.new()
var tileMap

func _ready():
	pass

func _process(delta):
	tileMap = get_parent().get_node("TileMap")
	_createMap()
	_connectPoint()
	
func _createMap():
	var state = get_world_2d().direct_space_state
	var queryRight
	var queryLeft
	var result 
	
	for cell in tileMap.get_used_cells(0):
		if not ((cell + Vector2i.UP) in tileMap.get_used_cells(0)):
			if not (cell + Vector2i.LEFT) in tileMap.get_used_cells(0) and not (cell + Vector2i.RIGHT) in tileMap.get_used_cells(0):
				_createPoint(tileMap.map_to_local(cell + Vector2i.UP))
				
				queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT) + Vector2(0, 100))
				queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT) + Vector2(0, 100))

				result = state.intersect_ray(queryLeft)
				if(result):
					_createPoint(result.position - Vector2(0,7))
			
				result = state.intersect_ray(queryRight)
				if(result):
					_createPoint(result.position - Vector2(0,7))

			elif not (cell + Vector2i.LEFT) in tileMap.get_used_cells(0) and (cell + Vector2i.RIGHT) in tileMap.get_used_cells(0):
				if not (cell + Vector2i.LEFT + Vector2i.UP) in tileMap.get_used_cells(0) and not (cell + Vector2i.RIGHT + Vector2i.UP) in tileMap.get_used_cells(0):
					_createPoint(tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT))
				else:
					_createPoint(tileMap.map_to_local(cell + Vector2i.UP))

			elif not(cell + Vector2i.RIGHT) in tileMap.get_used_cells(0) and (cell + Vector2i.LEFT) in tileMap.get_used_cells(0):
				if not (cell + Vector2i.RIGHT + Vector2i.UP) in tileMap.get_used_cells(0) and not (cell + Vector2i.LEFT + Vector2i.UP) in tileMap.get_used_cells(0):
					_createPoint(tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT))
				else:
					_createPoint(tileMap.map_to_local(cell + Vector2i.UP))

func _createPoint(pos):

	if not aStar.get_point_position(aStar.get_closest_point(pos)) == pos:
		var instance = _walkPoint.instantiate()
		add_child(instance)
		instance.position = pos
		aStar.add_point(aStar.get_available_point_id(), instance.position)

func _connectPoint():
	pass
