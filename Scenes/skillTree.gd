extends Control

var isSkillTreeVisible
var skillTree
signal skill_checked


func _ready():
	skillTree = $"."
	isSkillTreeVisible = false
	skillTree.hide()
	#$AnimationPlayer.play("RESET")
	print(get_path())

@export var Skills: Dictionary = {
	"Health Boost":{
		"unlock": false,
		"level": 0
	},
	"Speed Boost":{
		"unlock": false,
		"level": 0
	},
	"Damage Boost":{
		"unlock": false,
		"level": 0
	}
}



func setUnlock(skill: String, level: int):
	if skill in Skills.keys():
		Skills[skill]["unlock"] = true
		Skills[skill]["level"] = level
		

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
