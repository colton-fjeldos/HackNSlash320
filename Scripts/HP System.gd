extends Node

@export var MaxHP = 10

var alive = true as bool
var currentHP = float(MaxHP)
var immortal = false

func aliveStatus():
	if immortal == true:
		alive = true
		return true
	
	if currentHP > 0:
		alive = true
		return true
	
	alive = false
	return false
	
func damage(amount: float):
	if(alive == true):
		currentHP -= max(amount,0)
	aliveStatus()
