using Godot;
using System;

public partial class controlled1 : CharacterBody2D
{
	//stored float values for easy changing
	public static float baseSpeed = 150.0f;
	public static float movementMax = 400.0f;
	
	//Basic movement variables
	public float movement = baseSpeed;
	public float jump = 400.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	
	//double jump capability. Currently used like a bool
	//but stored as an int in case we want to add conditional triple jump
	public int doubleJump = 1;
	
	//placeholder
	public override void _Ready()
	{
		
	}
	//physics for controlled character
	public override void _PhysicsProcess(double delta){
		//set velocity
		Vector2 velocity = Velocity;
		
		//if its in the air fall, or check for DJ
		if (!IsOnFloor()){
			velocity.Y += gravity * (float)delta;
			if (Input.IsActionJustPressed("ui_up") && doubleJump ==1){
				doubleJump = 0;
				velocity.Y = (float)-(jump*1.1);
			}
			
		}
		//if its on the ground jump when up is pressed
		if (Input.IsActionJustPressed("ui_up") && IsOnFloor()){
				velocity.Y = -jump;
				doubleJump = 1;
				
		}

		//set our x velocity to zero
		velocity.X = 0;
		
		//when moving left, accelerate taking the maximum of -movement and -max
		if (Input.IsActionPressed("ui_left")){
			movement+=2;
			velocity.X = Mathf.Max((-movement), -movementMax);
			
		}
		//when moving right, accelerate taking the minimum of movement and max
		else if (Input.IsActionPressed("ui_right")){
			movement+=2;
			velocity.X = Mathf.Min(movement, movementMax);
			
		}
		//when they are released, reset the speed to its static value
		if (Input.IsActionJustReleased("ui_left") || Input.IsActionJustReleased("ui_right")){
			movement = baseSpeed;
		}
		//then set velocity and move
		Velocity = velocity;
		MoveAndSlide();
		
	}
}
