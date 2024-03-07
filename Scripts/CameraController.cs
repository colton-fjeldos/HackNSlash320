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
			Vector2 offset = GetOffsetFromCenter(screen.GetVisibleRect(), screen.GetMousePosition());
			Position = MoveCamera(Position, offset, Camera_Radius, Inverse_Camera_Speed);
		}
	}
	
	//Gets new camera coordinates
	public static Vector2 MoveCamera(Vector2 pos, Vector2 offset, int cameraRadius, int inverseCameraSpeed){
		return pos.Lerp(offset.Normalized() * cameraRadius, offset.Length() / inverseCameraSpeed);
	}
	
	//Gets the mouse position relative to the center of the screen
	public static Vector2 GetOffsetFromCenter(Rect2 screenRect, Vector2 mouseScreenPos){
		return mouseScreenPos - screenRect.Size / 2;
	}
	
	
}
