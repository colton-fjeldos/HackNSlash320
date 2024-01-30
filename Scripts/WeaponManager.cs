using Godot;
using System;

public partial class WeaponManager : Node2D
{
	
	Godot.Area2D Hitbox;
	Godot.Node2D WeaponSprite;
	Godot.Viewport Viewport;
	
	public override void _Ready()
	{
		Hitbox = GetNode<Godot.Area2D>("Area2D"); //Used to draw the hitbox when clicked
		WeaponSprite = GetNode<Godot.Node2D>("WeaponSprites"); //Used to rotate weapon sprite
		Viewport = GetViewport(); //Used to get the screen width for drawing sword sprite
	}
	
	public override void _Process(double delta){
		//This value only needs to be calculated dynamically if we allow the player to change screen size, unless we need to store this globally
		float halfWidth = Viewport.GetVisibleRect().Size.X / 2;
		float mouseX = Viewport.GetMousePosition().X;
		
		Vector2 globalMousePos = GetGlobalMousePosition();
		Vector2 spritePos = WeaponSprite.GlobalPosition;
		
		if (mouseX > halfWidth){ //Is the mouse on the right side of the screen?
			WeaponSprite.Scale = new Vector2(1,1);
			WeaponSprite.LookAt(globalMousePos);
		} else { //Left side?
			WeaponSprite.Scale = new Vector2(-1,1);
			WeaponSprite.LookAt(spritePos * 2 - globalMousePos);
		}
		

		//string message = halfWidth + " compared to " + mouseX;
		//GD.Print(message);
		
	}
	
	
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && @event.IsPressed())
		{
			LookAt(GetGlobalMousePosition());
			Hitbox.Show();
		}
	}
}
