extends Node2D

var _walkPoint = preload("res://Scenes/walkpoints.tscn")
var aStar = AStar2D.new()
@onready var tileMap = get_parent().get_node("TileMap")
var _processCount = 0
var _rayHeight = 20
var _player
var _enemy
var playerBuffer
var enemyBuffer
var pathIteration = 0


func _ready():
	_enemy = get_parent().get_node("Enemy")
	_player = get_parent().get_node("controlled1")

func _process(delta):
	if (_processCount == 0):
		_createMap()
		_processCount = _processCount + 1

func getPath(start, end): 
	if(pathIteration == 0):
		playerBuffer = end.y - aStar.get_point_position(aStar.get_closest_point(end)).y
		enemyBuffer = start.y - aStar.get_point_position(aStar.get_closest_point(start)).y
		pathIteration = 1
		print(playerBuffer, " ", enemyBuffer)
	start.y = start.y -  enemyBuffer
	end.y = end.y -  playerBuffer
	
	var p1 = _getClosestPoint(start)
	var p2 = _getClosestPoint(end)
		
	var path = aStar.get_point_path(aStar.get_closest_point(start), aStar.get_closest_point(end))

	return path
	
func _getClosestPoint(point):
	var closestPoint = null
	var state = get_world_2d().direct_space_state
	
	for currentPoint in aStar.get_point_ids():
		var pointPosition =  aStar.get_point_position(currentPoint)
		if (pointPosition.y >= (point.y - 1)) and (pointPosition.y <= (point.y + 1)):
			var query = PhysicsRayQueryParameters2D.create (pointPosition, point)
			query.exclude = [_enemy, _player]
			var result = state.intersect_ray(query)
			if !result:
				if(closestPoint == null or (pointPosition.distance_to(point) < closestPoint.distance_to(point))):
					closestPoint = pointPosition
	
	return closestPoint
		
		
		
func _createMap():
	# Gets every cell with a tile
	for cell in tileMap.get_used_cells(0):
		
		# Gets rid of cells that are under another cell.
		if not (cell + Vector2i.UP) in tileMap.get_used_cells(0) or _cellType(cell + Vector2i.UP):
			if tileMap.get_cell_tile_data(0, cell).get_custom_data('Decor') != 'Decoration': 
			
				var cellType = tileMap.get_cell_tile_data(0, cell)
				if(cellType and cellType.get_custom_data('Type') != 'Edge'):
					
					var leftCellType = _cellType(cell + Vector2i.LEFT)
					var rightCellType = _cellType(cell + Vector2i.RIGHT)
				
				# Edge Points
					if not (cell + Vector2i.LEFT) in tileMap.get_used_cells(0) or leftCellType:
					# A point is created on top a cell if the cell has nothing to its right or left (Edge piece 1)
						if not (cell + Vector2i.RIGHT) in tileMap.get_used_cells(0) or rightCellType:
							_createPoint(tileMap.map_to_local(cell + Vector2i.UP))
							_getFallPoints(cell, true, true)

					# A point is created on top a cell if the cell has something to its right but nothing to its left (Edge piece 3)
						elif (cell + Vector2i.RIGHT) in tileMap.get_used_cells(0) and !rightCellType:
								_createPoint(tileMap.map_to_local(cell + Vector2i.UP))
								_getFallPoints(cell, true, false)

				# A point is created on top a cell if the cell has nothing to its right but something to its left (Edge piece 3)
					elif not (cell + Vector2i.RIGHT) in tileMap.get_used_cells(0) or rightCellType:
						if (cell + Vector2i.LEFT) in tileMap.get_used_cells(0) and !leftCellType:
							_createPoint(tileMap.map_to_local(cell + Vector2i.UP))
							_getFallPoints(cell, false, true)

				# Corner Points
					elif (cell + Vector2i.RIGHT + Vector2i.UP) in tileMap.get_used_cells(0) and (cell + Vector2i.LEFT + Vector2i.UP) in tileMap.get_used_cells(0):
						_createPoint(tileMap.map_to_local(cell + Vector2i.UP))

					elif (cell + Vector2i.RIGHT + Vector2i.UP) in tileMap.get_used_cells(0) and not (cell + Vector2i.LEFT + Vector2i.UP) in tileMap.get_used_cells(0):
						_createPoint(tileMap.map_to_local(cell + Vector2i.UP))

					elif not (cell + Vector2i.RIGHT + Vector2i.UP) in tileMap.get_used_cells(0) and (cell + Vector2i.LEFT + Vector2i.UP) in tileMap.get_used_cells(0):
						_createPoint(tileMap.map_to_local(cell + Vector2i.UP))
	_connectPoint()
	_draw()
	queue_redraw()


func _cellType(cell):
	var cellType = tileMap.get_cell_tile_data(0, cell)
	if(cellType and cellType.get_custom_data('Type') == 'Edge'):
		return true
	else:
		return false

func _getFallPoints(cell, right, left):
	
	var state = get_world_2d().direct_space_state
	var result 
	
	if (right and left):
	
		var queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i(0, _rayHeight)))
		var queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i(0, _rayHeight)))

		result = state.intersect_ray(queryLeft)
		if(result):
			_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
		else:
			queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i.LEFT + Vector2i(0, _rayHeight)))
			result = state.intersect_ray(queryLeft)
			if(result):
				_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
			else:
				queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i.LEFT + Vector2i.LEFT + Vector2i(0, _rayHeight)))
				result = state.intersect_ray(queryLeft)
				if(result):
					_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))

		result = state.intersect_ray(queryRight)
		if(result):
			_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
		else:
			queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i(0, _rayHeight)))
			result = state.intersect_ray(queryRight)
			if(result):
				_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
			else:
				queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP +  Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP +  Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i(0, _rayHeight)))
				result = state.intersect_ray(queryRight)
				if(result):
					_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
	
	elif (right and !left):
		
		var queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i(0, _rayHeight)))
		result = state.intersect_ray(queryLeft)
		
		if(result):
			_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
		else:
			queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i.LEFT + Vector2i(0, _rayHeight)))
			result = state.intersect_ray(queryLeft)
			if(result):
				_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
			else:
				queryLeft = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT + Vector2i.LEFT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT + Vector2i.LEFT + Vector2i.LEFT + Vector2i(0, _rayHeight)))
				result = state.intersect_ray(queryLeft)
				if(result):
					_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.LEFT  + Vector2i.LEFT + Vector2i.LEFT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))


			
	elif (!right and left):
		var queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i(0, _rayHeight)))
		
		result = state.intersect_ray(queryRight)
		if(result):
			_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
		else:
			queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i(0, _rayHeight)))
			result = state.intersect_ray(queryRight)
			if(result):
				_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
			else:
				queryRight = PhysicsRayQueryParameters2D.create (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i(0, _rayHeight)))
				result = state.intersect_ray(queryRight)
				if(result):
					_createFallPoint (tileMap.map_to_local(cell + Vector2i.UP + Vector2i.RIGHT + Vector2i.RIGHT + Vector2i.RIGHT), tileMap.map_to_local(tileMap.local_to_map(result.position) + Vector2i.UP))
	

func _createPoint(pos):
	if not aStar.get_point_position(aStar.get_closest_point(pos)) == pos:
		var instance = _walkPoint.instantiate()
		add_child(instance)
		instance.position = pos
		aStar.add_point(aStar.get_available_point_id(), pos)


func _createFallPoint(pos1, pos2):
	
	if not aStar.get_point_position(aStar.get_closest_point(pos2)) == pos2:
		var instance = _walkPoint.instantiate()
		add_child(instance)
		instance.position = pos2
		aStar.add_point(aStar.get_available_point_id(), pos2)
		
	if not aStar.get_point_position(aStar.get_closest_point(pos1)) == pos1:
		var instance = _walkPoint.instantiate()
		add_child(instance)
		instance.position = pos1
		aStar.add_point(aStar.get_available_point_id(), pos1)
		

	pos1 = aStar.get_closest_point(pos1)
	pos2 = aStar.get_closest_point(pos2)
		
	aStar.connect_points(pos1, pos2)
	

func _connectPoint():
	for currentPoint in aStar.get_point_ids():
		var neighbhour = -1
		var mapPosition =  tileMap.local_to_map(aStar.get_point_position(currentPoint)) + Vector2i.RIGHT + Vector2i.DOWN
		var state = get_world_2d().direct_space_state

		for connectingPoint in aStar.get_point_ids():
			if aStar.get_point_position(connectingPoint)[1] == aStar.get_point_position(currentPoint)[1]:
				if aStar.get_point_position(connectingPoint)[0] > aStar.get_point_position(currentPoint)[0]:
					if (neighbhour == -1 or ((aStar.get_point_position(connectingPoint)[0] - aStar.get_point_position(currentPoint)[0]) < (aStar.get_point_position(neighbhour)[0] - aStar.get_point_position(currentPoint)[0]))):
						var query = PhysicsRayQueryParameters2D.create (aStar.get_point_position(currentPoint), aStar.get_point_position(connectingPoint))
						query.exclude = [_enemy, _player]
						var result = state.intersect_ray(query)
						if !result:
							neighbhour = connectingPoint

		if (neighbhour != -1):
			aStar.connect_points(currentPoint, neighbhour)



func _draw():
	
	var array = aStar.get_point_ids()
	
	for i in range(array.size()):
		for j in range(i + 1, array.size()):
			if aStar.are_points_connected(array[i], array[j]):
				draw_line(aStar.get_point_position(array[i]), aStar.get_point_position(array[j]), Color(255, 0, 0), 1)
	

