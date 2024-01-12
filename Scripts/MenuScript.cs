using Godot;
using System;

public partial class MenuScript : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}
	
	private void _on_play_pressed()
	{
		GD.Print("Play button pressed");
		GetTree().ChangeSceneToFile("res://Scenes/Scene1.tscn");
	}


	private void _on_options_pressed()
	{
		GD.Print("Options button pressed");
		// Currently nonfunctional, you would disable the current containers
		//and enable new containers that have the options menu
	}


	private void _on_quit_pressed()
	{
		GD.Print("Quit button pressed");
		GetTree().Quit();
	}
}
