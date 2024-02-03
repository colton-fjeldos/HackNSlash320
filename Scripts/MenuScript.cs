using Godot;
using System;

public partial class MenuScript : Control
{
	
	Godot.VBoxContainer optionsVBox;
	Godot.VBoxContainer mainVBox;
	Godot.Label volumeLabel;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		optionsVBox = GetNode<Godot.VBoxContainer>("MarginContainer/Options");
		mainVBox = GetNode<Godot.VBoxContainer>("MarginContainer/Main");
		volumeLabel = GetNode<Godot.Label>("MarginContainer/Options/VolumeLabel");
		optionsVBox.Hide();
		mainVBox.Show();
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
		mainVBox.Hide();
		optionsVBox.Show();
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
		optionsVBox.Hide();
		mainVBox.Show();
	}
	
	private void _on_volume_slider_value_changed(double value)
	{
		GD.Print("Volume set to: " + value);
		volumeLabel.Text = "Volume: " + value;
		//Currently also needs to control actual game volume, IDK how to control that yet
	}
}
