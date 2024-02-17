using Godot;
using System;

public partial class controlled1 : CharacterBody2D
{
	//stored float values for easy changing
	//public static float baseSpeed = 150.0f;
	public static float movementMax = 400.0f;
	
	//Basic movement variables
	//public float movement = baseSpeed;
	public float jump = 400.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	
	//double jump capability. Currently used like a bool
	//but stored as an int in case we want to add conditional triple jump
	public int doubleJump = 1;
	
	//Private interactionmanager field since input is taken care of inside of this script
	[Export]
	private InteractArea playerInteract;
	
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

		
		//when moving left, accelerate
		if (Input.IsActionPressed("ui_left")){
			velocity.X = Mathf.Lerp(velocity.X, (-movementMax), (float).08);
		}
		//when moving right, accelerate
		else if (Input.IsActionPressed("ui_right")){
			velocity.X = Mathf.Lerp(velocity.X, (movementMax), (float).08);
			
		}

		//when they are released, move velocity towards 0
		else{
			if (Mathf.Abs(velocity.X)<.00001){
				//do nothing, this stops it from infinitely calculating lerp
				//when the model is basically moving at speed 0.
				velocity.X=0;
			}
			else{
				velocity.X = Mathf.Lerp(velocity.X, (0), (float).2);
				
			}

		}
		//then set velocity and move
		Velocity = velocity;
		MoveAndSlide();
		
	}
	
	public override void _UnhandledInput(InputEvent @event){
		if (Input.IsActionJustPressed("interact")){
			playerInteract.InteractWith();
		}
	}
}
