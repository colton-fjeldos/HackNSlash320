using Godot;
using System;



public partial class SkillButton : TextureButton
{
	private Panel panel;
	private Label label;
	private Line2D line2D;

	private int level = 0;

	public override void _Ready()
	{
		if (GetParent() is SkillNode)
		{
			line2D.AddPoint(GlobalPosition + RectSize / 2);
			line2D.AddPoint(GetParent().GlobalPosition + RectSize / 2);
		}
	}

	public int Level
	{
		get => level;
		set
		{
			level = value;
			label.Text = level + "/3";
		}
	}

	public override void _OnPressed()
	{
		Level = Mathf.Min(level + 1, 3);
		panel.ShowBehindParent = true;

		line2D.DefaultColor = new Color(1, 1, 0.24705882370472);

		foreach (Node skill in GetChildren())
		{
			if (skill is SkillNode && level == 3)
			{
				((SkillNode)skill).Set("disabled", false);
			}
		}
	}
}
