extends Control

var isSkillTreeVisible
var skillTree
signal skill_pressed1


func _ready():
	skillTree = $"."
	isSkillTreeVisible = false
	skillTree.hide()
	$AnimationPlayer.play("RESET")

<<<<<<< Updated upstream
var Skills: Dictionary = {
	"Health Boost":{
=======
@export var Skills: Dictionary = {
	"Jump Boost":{
>>>>>>> Stashed changes
		"unlock": false,
	},
	"Speed Boost":{
<<<<<<< Updated upstream
		"unclock": false,
		"level": 0
	},
	"Damage Boost":{
		"unclock": false,
		"level": 0
=======
		"unlock": false,
	},
	"Health Boost":{
		"unlock": false,
	},
	"Triple jump":{
		"unlock":false,
	},
	"Dash Length":{
		"unlock":false,
>>>>>>> Stashed changes
	}
}


func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = true
<<<<<<< Updated upstream
		Skills[skill]["level"] = level
		
func checkSKill(skill: String) -> bool:
	return Skills[skill]["unlock"]
=======
		#Skills[skill]["level"] = level
		emit_signal("skill_pressed1")
		#

func setLock(skill: String):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = false
		#Skills[skill]["level"] = 0
		emit_signal("skill_pressed1")

func checkSkill(skill: String) -> bool:
	if skill in Skills:
		return Skills[skill]["unlock"]
	else:
		print("Skill not found:", skill)
		return false


#func checkSkill(skillName: String):
#	var unlocked = checkSkillInternal(skillName)
#	emit_signal("skill_checked", skillName, unlocked)


#func checkSkillInternal(skill: String) -> bool:
#	return Skills[skill]["unlock"]

>>>>>>> Stashed changes
	
	

func _process(delta):
	if Input.is_action_just_pressed("SkillTree"): 
		toggleSkillTree()

func toggleSkillTree():
	if !Global.is_pause_menu_open:
		isSkillTreeVisible = !isSkillTreeVisible
		if isSkillTreeVisible:
			skillTree.show()
			get_tree().paused = true # Pause the game when the skill tree is open 
			Global.is_skill_tree_open = true
			$AnimationPlayer.play("blur")
		else:
			skillTree.hide()
			get_tree().paused = false # Unpause the game when the skill tree is closed 
			Global.is_skill_tree_open = false
			$AnimationPlayer.play_backwards("blur")


func _on_skill_pressed_1():
	print("Skill pressed signal emitted.")
