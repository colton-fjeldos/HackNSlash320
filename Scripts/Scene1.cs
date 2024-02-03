using Godot;
using System;

public partial class Scene1 : Node2D
{
	Godot.VBoxContainer pausemenu;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		pausemenu = GetNode<Godot.VBoxContainer>("MarginContainer/PauseMenu");
		pausemenu.Hide();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Input.IsActionPressed("ui_cancel"))
		{
			GD.Print("Read esc input");
			//flip the visibility of the ui here with show and hide
		}
	}
}
