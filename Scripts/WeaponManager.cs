using Godot;
using System;

public partial class WeaponManager : Node2D
{
	[Export]
	int thrownSpeed = 500;
	
	Godot.Area2D Hitbox;
	Godot.Node2D WeaponSpriteWrapper;
	Godot.Viewport Viewport;
	Godot.Timer HitboxTimer;
	Godot.Sprite2D WeaponSprite;
	Godot.Sprite2D SwingSprite;
	public bool hasWeapon;
	PackedScene thrownScene;
	Node2D root;
	
	public override void _Ready()
	{
		hasWeapon = false;
		Hitbox = GetNode<Godot.Area2D>("WeaponHitbox"); //Used to draw the hitbox when clicked
		WeaponSpriteWrapper = GetNode<Godot.Node2D>("WeaponSpriteWrapper"); //Used to rotate weapon sprite
		WeaponSprite = GetNode<Godot.Sprite2D>("%WeaponSprite");
		SwingSprite = GetNode<Godot.Sprite2D>("%SwingSprite");
		Viewport = GetViewport(); //Used to get the screen width for drawing sword sprite
		HitboxTimer = GetNode<Godot.Timer>("HitboxTimer");
		thrownScene = GD.Load<PackedScene>("res://Scenes/Subscenes/Character/Projectiles/ThrownWeapon.tscn");
		root = (Node2D) GetTree().Root.GetChild(-1);
	}
	
	public override void _Process(double delta){
		NodeLookAtMouse(WeaponSpriteWrapper);
	}
	
	public void NodeLookAtMouse(Node2D node){
		//This value only needs to be calculated dynamically if we allow the player to change screen size, unless we need to store this globally
		float halfWidth = Viewport.GetVisibleRect().Size.X / 2;
		float mouseX = Viewport.GetMousePosition().X;
		
		Vector2 globalMousePos = GetGlobalMousePosition();
		Vector2 spritePos = node.GlobalPosition;
		
		if (mouseX > halfWidth){ //Is the mouse on the right side of the screen?
			node.Scale = new Vector2(1,1);
			node.LookAt(globalMousePos);
		} else { //Left side?
			node.Scale = new Vector2(-1,1);
			node.LookAt(spritePos * 2 - globalMousePos);
		}
	}
	
	
	public override void _Input(InputEvent @event)
	{
		if (Input.IsActionJustPressed("attack"))
		{
			NodeLookAtMouse(Hitbox);
			HitboxTimer.Start();
			Hitbox.Show();
		}
		
		if (Input.IsActionJustPressed("throw"))
		{
			if (hasWeapon){
				var screen = GetViewport();
				RigidBody2D thrownItem = (RigidBody2D) thrownScene.Instantiate();
				thrownItem.Position = GlobalPosition;
				NodeLookAtMouse(thrownItem);
				thrownItem.Rotation += 45;
				Sprite2D thrownSprite = (Sprite2D) thrownItem.GetNode("Sprite");
				thrownSprite.Texture = WeaponSprite.Texture;
				
				
				root.AddChild(thrownItem);
				thrownItem.ApplyImpulse((screen.GetMousePosition() - screen.GetVisibleRect().Size / 2).Normalized() * thrownSpeed);
				//create projectile at mouse angle
				hasWeapon = false;
				this.Hide();
			}
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



