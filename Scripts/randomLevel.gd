extends Node2D

@export var texture : NoiseTexture2D
var width = 50
var height = 50
var noiseGrid = []
var iterations = 2

func _ready():
	_generateNoise()
	#_generateMap()
	_drawMap()

func _generateNoise():
	var noise = texture.noise
	noise.set_noise_type(noise.TYPE_PERLIN)
	noise.set_frequency (.3)
	
	for y in range(height):
		#var row = []
		for x in range (width):
			#print(x, " ", y)
			if noise.get_noise_2d(y,x) >= 0:
				$TileMap.set_cell(0, Vector2(y, x), 0, Vector2i(5,1))
			#else:
				#row.push_back(false)
		#noiseGrid.push_back(row)
				
# Not my code
# https://www.youtube.com/watch?v=slTEz6555Ts

#func _generateMap():
	#for ii in range(iterations):  
		#var tempGrid = noiseGrid
		#for jj in range(height):
			#for kk in range(width): 
				#var neighbour = 0
				#for y in range(jj - 1, jj + 2):
					#for x in range(kk - 1, kk + 2): 
						#if inRange(x, y):
							#if y != jj or x != kk:
								#if tempGrid[y][x]:
									#neighbour += 1
						#else:
							#neighbour += 1
				#if neighbour > 4:
					#noiseGrid[jj][kk] = true
				#else:
					#noiseGrid[jj][kk] = false

func inRange(x, y):
	if x >= 0 and x < width and y >= 0 and y < height:
		return true
	return false

func _drawMap():
	
	for ii in range (iterations):
		for cell in $TileMap.get_used_cells(0):
			if not (cell + Vector2i.UP) in $TileMap.get_used_cells(0) and not (cell + Vector2i.RIGHT) in $TileMap.get_used_cells(0) and (cell + Vector2i.UP + Vector2i.RIGHT) in $TileMap.get_used_cells(0):
				$TileMap.set_cell(0, cell, -1)
			elif not (cell + Vector2i.UP) in $TileMap.get_used_cells(0) and not (cell + Vector2i.LEFT) in $TileMap.get_used_cells(0) and (cell + Vector2i.UP + Vector2i.LEFT) in $TileMap.get_used_cells(0):
				$TileMap.set_cell(0, cell, -1)
			elif not (cell + Vector2i.DOWN) in $TileMap.get_used_cells(0) and not (cell + Vector2i.LEFT) in $TileMap.get_used_cells(0) and (cell + Vector2i.DOWN + Vector2i.LEFT) in $TileMap.get_used_cells(0):
				$TileMap.set_cell(0, cell, -1)
			elif not (cell + Vector2i.DOWN) in $TileMap.get_used_cells(0) and not (cell + Vector2i.RIGHT) in $TileMap.get_used_cells(0) and (cell + Vector2i.DOWN + Vector2i.RIGHT) in $TileMap.get_used_cells(0):
				$TileMap.set_cell(0, cell, -1)
		
		for cell in $TileMap.get_used_cells(0):
			if not (cell + Vector2i.UP) in $TileMap.get_used_cells(0) and not (cell + Vector2i.DOWN) in $TileMap.get_used_cells(0) and not (cell + Vector2i.RIGHT) in $TileMap.get_used_cells(0) and not (cell + Vector2i.LEFT) in $TileMap.get_used_cells(0):
				$TileMap.set_cell(0, cell, -1)
