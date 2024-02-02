using Godot;
using System;

public partial class CameraController : Camera2D
{
	Godot.Viewport screen;
	public override void _Ready()
	{
		screen = GetViewport();
	}

	public override void _Process(double delta)
	{	
		Vector2 mouse_coor = screen.GetMousePosition() - screen.GetVisibleRect().Size / 2;
		Position = Position.Lerp(mouse_coor.Normalized() * 75, mouse_coor.Length() / 5000);
	}
}
