extends TextureButton
class_name SkillNode
signal checkSkill(skillName)



@onready var panel = $Panel
@onready var label = $MarginContainer/Label
@onready var line_2d = $Line2D

@export var SkillName: String

func _ready():
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/1"

func _on_pressed():
	if is_inside_tree() or (get_parent() is SkillNode and get_parent().level == 1):
		if level == 0:
			level = min( level+1, 1)
			panel.show_behind_parent = true
			
			var SkillTree = get_tree().get_first_node_in_group("SkillTree")
			SkillTree.setUnlock(SkillName, level)
			print(SkillName)
			print("Unlocked:", SkillTree.checkSkill(SkillName));
			
			#var unlock: bool = SkillTree.checkSkill("Health Boost")
			#match unlock:
			#	true:
			#		print("You Got A Health Boost!")
			#	false:
			#		print("Nope")
		
			line_2d.default_color = Color(0.47926771640778, 0.85250693559647, 0.26897257566452)
	
			var skills = get_children()
			for skill in skills:
				if skill is SkillNode and level == 1:
					skill.disabled = false
					
					
					
		else: 
			level = 0
			panel.show_behind_parent = false
			line_2d.default_color = Color(1, 1, 1)
			
			
			var SkillTree = get_tree().get_first_node_in_group("SkillTree")
			SkillTree.setLock(SkillName)
			
			print(SkillName)
			print("Unlocked:", SkillTree.checkSkill(SkillName));
		
			var skills = get_children()
			for skill in skills:
				if skill is SkillNode:
					skill.disabled = true
					skill.line_2d.default_color = Color(1, 1, 1)
					skill.panel.show_behind_parent = false
					skill.level = 0
					
					disable_skills_recursive(self)
					
					# Recursive function to disable skills and their children
func disable_skills_recursive(node):
	for skill in node.get_children():
		if skill is SkillNode:
			skill.disabled = true
			skill.line_2d.default_color = Color(1, 1, 1)
			skill.panel.show_behind_parent = false
			skill.level = 0
			disable_skills_recursive(skill)
			

