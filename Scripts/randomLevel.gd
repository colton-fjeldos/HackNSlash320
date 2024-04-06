extends Node2D

var LR = preload("res://Scenes/Rooms/LR room.tscn")
var LRB = preload("res://Scenes/Rooms/LRB room.tscn")
var LRT = preload("res://Scenes/Rooms/LRT room.tscn")
var LRBT = preload("res://Scenes/Rooms/LRBT room.tscn")
var rooms = [LR, LRB, LRT, LRBT]

func _ready():
	var startNode = get_node("StartPositions")
	var startPositions = startNode.get_children()
	var startingPos = []

	
	for i in range (len(startPositions)):
		startingPos.push_back(startPositions[i].global_position)
	
	var startPoint = _getRandomPt(startingPos)
	
func _getRandomPt(array):
	var index = randi() % array.size() 
	return array[index]
