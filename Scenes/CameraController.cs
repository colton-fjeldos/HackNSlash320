using Godot;
using System;

public partial class CameraController : Camera2D
{
	Godot.CharacterBody2D PlayerBody;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		PlayerBody = GetNode<Godot.CharacterBody2D>("..");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
	}
}
