using Godot;
using System;

public partial class WeaponManager : Node2D
{
	
	Godot.Area2D Hitbox;
	Godot.Node2D WeaponSpriteWrapper;
	Godot.Viewport Viewport;
	Godot.Timer HitboxTimer;
	Godot.Sprite2D WeaponSprite;
	Godot.Sprite2D SwingSprite;
	
	public override void _Ready()
	{
		Hitbox = GetNode<Godot.Area2D>("Area2D"); //Used to draw the hitbox when clicked
		WeaponSpriteWrapper = GetNode<Godot.Node2D>("WeaponSpriteWrapper"); //Used to rotate weapon sprite
		WeaponSprite = GetNode<Godot.Sprite2D>("%WeaponSprite");
		SwingSprite = GetNode<Godot.Sprite2D>("%SwingSprite");
		Viewport = GetViewport(); //Used to get the screen width for drawing sword sprite
		HitboxTimer = GetNode<Godot.Timer>("HitboxTimer");
	}
	
	public override void _Process(double delta){
		//This value only needs to be calculated dynamically if we allow the player to change screen size, unless we need to store this globally
		float halfWidth = Viewport.GetVisibleRect().Size.X / 2;
		float mouseX = Viewport.GetMousePosition().X;
		
		Vector2 globalMousePos = GetGlobalMousePosition();
		Vector2 spritePos = WeaponSpriteWrapper.GlobalPosition;
		
		if (mouseX > halfWidth){ //Is the mouse on the right side of the screen?
			WeaponSpriteWrapper.Scale = new Vector2(1,1);
			WeaponSpriteWrapper.LookAt(globalMousePos);
		} else { //Left side?
			WeaponSpriteWrapper.Scale = new Vector2(-1,1);
			WeaponSpriteWrapper.LookAt(spritePos * 2 - globalMousePos);
		}
		

		//string message = halfWidth + " compared to " + mouseX;
		//GD.Print(message);
		
	}
	
	
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && @event.IsPressed())
		{
			LookAt(GetGlobalMousePosition());
			HitboxTimer.Start();
			Hitbox.Show();
		}
	}
	
	private void OnHitboxTimerTimeout()
	{
		Hitbox.Hide();
	}
	
	public void ChangeSprites(Texture2D hSprite, Texture2D sSprite){
		WeaponSprite.Texture = hSprite;
		SwingSprite.Texture = sSprite;
	}
}



