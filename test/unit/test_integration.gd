extends GutTest

var scene = load("res://Scenes/Scene1.tscn")

func test_connections():
	var sceneIns = scene.instantiate()
	var tMap = sceneIns.get_node("TileMap")
	var finder = sceneIns.get_node("Pathfinder")
	var connectionCount = 0
	
	finder._createMap(tMap)
	finder._connectPoint(tMap)
	
	for point in finder.aStar.get_point_ids():
		var connections = finder.aStar.get_point_connections(point)
		connectionCount += connections.size()
	
	assert_eq(connectionCount, 26)
