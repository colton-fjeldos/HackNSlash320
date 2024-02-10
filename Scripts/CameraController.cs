using Godot;
using System;

public partial class CameraController : Camera2D
{
	[ExportGroup("Camera Script Components")]
	[Export]
	bool Moveable_Camera = true; //Whether or not this script will even run.
	[Export(PropertyHint.Range, "1,100,")]
	int Camera_Radius = 75; //Maximum distance from the player that the camera will move
	[Export(PropertyHint.Range, "1,25000,")]
	int Inverse_Camera_Speed = 25000; //The larger this number is, the slower the camera accelerates
	
	Godot.Viewport screen;
	
	
	
	
	public override void _Ready()
	{	
		if (Moveable_Camera) screen = GetViewport();
	}

	public override void _Process(double delta)
	{	
		if (Moveable_Camera){
			Vector2 mouse_coor = screen.GetMousePosition() - screen.GetVisibleRect().Size / 2;
			Position = Position.Lerp(mouse_coor.Normalized() * Camera_Radius, mouse_coor.Length() / Inverse_Camera_Speed);
		}
	}
}
