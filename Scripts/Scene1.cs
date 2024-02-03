using Godot;
using System;

public partial class Scene1 : Node2D
{
	Godot.VBoxContainer pausemenu;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		pausemenu = GetNode<Godot.VBoxContainer>("PauseMenu");
		pausemenu.Hide();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Input.IsActionPressed("ui_cancel"))
		{
			GD.Print("Read esc input");
			pausemenu.Show();
		}
	}
	private void _on_back_button_pressed()
{
	GD.Print("Back button pressed");
	pausemenu.Hide();
}
	
}



