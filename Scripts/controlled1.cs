using Godot;
using System;

public partial class controlled1 : CharacterBody2D
{
	public float movement = 150.0f;
	public float jump = 400.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	int doubleJump = 1;
	
	//placeholder
	public override void _Ready()
	{
		
	}
	public override void _PhysicsProcess(double delta){
		Vector2 velocity = Velocity;
		
		if (!IsOnFloor()){
			velocity.Y += gravity * (float)delta;
			if (Input.IsActionJustPressed("ui_up") && doubleJump ==1){
				doubleJump = 0;
				velocity.Y = (float)-(jump*1.1);
			}
			
		}
		if (Input.IsActionJustPressed("ui_up") && IsOnFloor()){
				velocity.Y = -jump;
				doubleJump = 1;
				
		}

		
		velocity.X = 0;
		if (Input.IsActionPressed("ui_left")){
			velocity.X = -movement;
		}
		else if (Input.IsActionPressed("ui_right")){
			velocity.X = movement;
		}
		
		Velocity = velocity;
		MoveAndSlide();
		
	}
}
