using Godot;
using System;

public partial class MenuScript : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var options = GetNode<Godot.VBoxContainer>("MarginContainer/Options");
		options.Hide();
	}
	
	// MAIN MENU BUTTONS
	private void _on_play_pressed()
	{
		GD.Print("Play button pressed, changing scenes");
		GetTree().ChangeSceneToFile("res://Scenes/Scene1.tscn");
	}


	private void _on_options_pressed()
	{
		GD.Print("Options button pressed");
		var main = GetNode<Godot.VBoxContainer>("MarginContainer/Main");
		var options = GetNode<Godot.VBoxContainer>("MarginContainer/Options");
		main.Hide();
		options.Show();
		// Currently nonfunctional, you would disable the current containers
		//and enable new containers that have the options menu
	}


	private void _on_quit_pressed()
	{
		GD.Print("Quit button pressed");
		GetTree().Quit();
	}
	
	//OPTION MENU BUTTONS/SLIDER
	private void _on_back_pressed()
	{
		GD.Print("Back button pressed");
		//I feel like calling GetNode might be expensive, I would probably only want to do this one time
		//in "_Ready" function, but I don't know how to accomplish that. Same with VolumeLabel.
		Godot.VBoxContainer main = GetNode<Godot.VBoxContainer>("MarginContainer/Main");
		Godot.VBoxContainer options = GetNode<Godot.VBoxContainer>("MarginContainer/Options");
		options.Hide();
		main.Show();
	}
	
	private void _on_volume_slider_value_changed(double value)
	{
		Godot.Label volumeLabel = GetNode<Godot.Label>("MarginContainer/Options/VolumeLabel");
		volumeLabel.Text = "Volume: " + value;
		//Currently also needs to control actual game volume, IDK how to control that yet.
		GD.Print("Volume set to: " + value);
	}
	
}
