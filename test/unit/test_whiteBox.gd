extends GutTest

var tileScript = load("res://Scripts/TileMap.gd")
var scene = load("res://Scenes/Scene1.tscn")

func test_closestPoint():
	var aStarIns = AStar2D.new()
	var scriptIns = tileScript.new()
	
	aStarIns.add_point(1, Vector2(1,1))
	aStarIns.add_point(2, Vector2(1,5))
	aStarIns.add_point(3, Vector2(2,10))
	aStarIns.add_point(4, Vector2(1,2))
	
	var result = scriptIns._getClosetPoint(aStarIns, Vector2(1, 3))
	assert_eq(result, 1, "Should be 1")

func test_type():
	var count = 0
	var sceneIns = scene.instantiate()
	var scriptIns = tileScript.new()
	var tMap = sceneIns.get_node("TileMap")
	
	for cell in tMap.get_used_cells(0):
		var result = scriptIns._cellType(tMap, cell)
		if (result == true):
			count = count + 1
	
	assert_eq(count, 8, "Should be 8")

func test_createMap():
	var sceneIns = scene.instantiate()
	var scriptIns = tileScript.new()
	var tMap = sceneIns.get_node("TileMap")
	
	var result = scriptIns._createMap(tMap)
	assert_eq(result, 18, "Should be false")

