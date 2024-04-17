using Godot;
using System;

public partial class WeaponManager : Node2D
{
	[Export]
	int thrownSpeed = 500;
	
	int weaponDamage = 25;
	public bool hasWeapon = false;
	
	Godot.Node2D WeaponSpriteWrapper;
	Godot.Sprite2D SwingSprite;
	
	Godot.Area2D Hitbox;
	Godot.CollisionShape2D HitboxArea;
	Godot.Sprite2D WeaponSprite;
	Godot.Timer HitboxTimer;
	
	Godot.Viewport Viewport;
	PackedScene thrownScene;
	Node2D root;
	
	


	
	public override void _Ready()
	{
		Hitbox = GetNode<Godot.Area2D>("WeaponHitbox"); //Used to draw the hitbox when clicked
		WeaponSpriteWrapper = GetNode<Godot.Node2D>("WeaponSpriteWrapper"); //Used to rotate weapon sprite
		WeaponSprite = GetNode<Godot.Sprite2D>("%WeaponSprite");
		SwingSprite = GetNode<Godot.Sprite2D>("%SwingSprite");
		HitboxTimer = GetNode<Godot.Timer>("HitboxTimer");
		HitboxArea = GetNode<Godot.CollisionShape2D>("WeaponHitbox/CollisionShape2D");
		
		thrownScene = GD.Load<PackedScene>("res://Scenes/Subscenes/Character/Projectiles/ThrownWeapon.tscn");
		root = (Node2D) GetTree().Root.GetChild(-1);
		Viewport = GetViewport(); //Used to get the screen width for drawing sword sprite
		SwingSprite.Hide();
		HitboxArea.Disabled = true;
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
		if (Input.IsActionJustPressed("attack") && hasWeapon)
		{
			NodeLookAtMouse(Hitbox);
			SwingSprite.Show();
			HitboxTimer.Start();
			HitboxArea.Disabled = false;
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
				WeaponSprite.Texture = null;
				SwingSprite.Texture = null;
			}
		}
	}
	
	private void OnHitboxTimerTimeout()
	{
		SwingSprite.Hide();
		HitboxArea.Disabled = true;
	}
	
	public void ChangeSprites(Texture2D hSprite, Texture2D sSprite){
		WeaponSprite.Texture = hSprite;
		SwingSprite.Texture = sSprite;
	}
	
	private void _on_weapon_hitbox_body_entered(Node2D body)
	{
		GD.Print("Body entered " + body);
		if (body.IsInGroup("Enemy")) {
			GD.Print("Damaging enemy!");
			body.Call("updateHealth", weaponDamage);
			
			//calculate knockback direction
			Vector2 direction = GlobalPosition.DirectionTo(body.GlobalPosition);
			float knockbackStrength = 10;
			Vector2 knockback = direction * knockbackStrength;
			
			//apply knockback to enemy
			body.Call("applyKnockback", knockback);
		}
	}

}





