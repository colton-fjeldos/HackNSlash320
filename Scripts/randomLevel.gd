extends Node2D

var directions = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]
	
func _createWalk(startPos):
	var path
	var currentPos 
	path.push_back(startPos)
	currentPos = startPos

	for i in range(10):
		var direction = _getRandomPt(directions)
		var nextPos = currentPos + direction
		path.push_back(nextPos)
		currentPos = nextPos
	return path

	
func _getRandomPt(array):
	var index = randi() % array.size() 
	return array[index]
	
func _createRooms():
	var numOfRooms
	var currentPos = Vector2.ZERO;
	var mapPoints
	for ii in range (10):
		var path = _createWalk(currentPos)
		mapPoints = mapPoints + path
		currentPos = _getRandomPt(mapPoints)
	
	var tilemap = get_parent().get_node("TileMap")
	var tilePositions 
	for point in mapPoints:
		for direction in directions:
			var neighbour = position + direction;
			if (neighbour in mapPoints):
				tilePositions.push_back(neighbour)
				tilemap.set_cell(0, tilemap.local_to_map(neighbour))

