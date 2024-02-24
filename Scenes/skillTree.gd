extends Control


var Skills: Dictionary = {
	"Health Boost":{
		"unlock": false,
		"level": 0
	},
	"Speed Boost":{
		"unclock": false,
		"level": 0
	},
	"Damage Boost":{
		"unclock": false,
		"level": 0
	}
}


func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = true
		Skills[skill]["level"] = level
		
#func checkSKill(skill: String) -> bool:
#	return Skills[skill]["unlock"]
	
