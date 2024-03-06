using Godot;
using System;
using System.Threading.Tasks;

public partial class controlled1 : CharacterBody2D
{
	//stored float values for easy changing
	//public static float baseSpeed = 150.0f;
	public static float movementMax = 400.0f;
	
	//Basic movement variables
	//public float movement = baseSpeed;
	public float jump = 400.0f;
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();
	
	//dash recharge variable for dash bar
	public int dashRecharge = 2;
	
	
	//dash availability for refractory period
	public bool dashAvailable = true;
	
	//is dashing for eventual state checking
	public bool isDashing = false;
	//length of the dash state in milliseconds
	public int dashLength = 320;
	//length of the overall dash recharge also in milliseconds
	public int dashLongCharge = 5000;
	//facing string for animation useage later
	public string facing;
	//direction vector for normalized dashing movement
	Vector2 direction = Vector2.Zero;
	
	
	//double jump capability. Currently used like a bool
	//but stored as an int in case we want to add conditional triple jump
	public int doubleJump = 1;
	
	//Private interactionmanager field since input is taken care of inside of this script
	[Export]
	private InteractArea playerInteract;
	
	private WeaponManager weaponManager;
	
	public int playerHealth = 100;
	
	public bool playerAlive = true;
	
	//velocity is a shared variable
	Vector2 velocity;
	//placeholder
	public controlled1(){
		GD.Print("Nothing");
	}
	
	public override void _Ready()
	{
		weaponManager = GetNode<WeaponManager>("WeaponManager");
	}
	
	//Dash recharge rate for overall dash recharge
	public async Task dashBarTimer(){
		await Task.Delay(TimeSpan.FromMilliseconds(dashLongCharge));
		dashRecharge++;
		return;
	}
	
	//dash refractory period recharge handler
	public async Task dashInstanceTimer(){
		await Task.Delay(TimeSpan.FromMilliseconds(dashLength));
		isDashing = false;
		dashAvailable= true;
		return;
	}
	
	//dash function, moves the players, sets bools then calls 
	//timers for dash recharge and refractory period
	public void dashFunc(){
		if ((dashRecharge > 0) 
		&& dashAvailable){
			isDashing = true;
			dashAvailable= false;
			velocity = (direction.Normalized() * 1000);
			//GD.Print(velocity);
			dashRecharge--;
			dashInstanceTimer();
			dashBarTimer();
			
		}
	}
	
	//physics for controlled character
	public override void _PhysicsProcess(double delta){
		//if not dashing
		if (!isDashing){
		//set velocity
		Vector2 velocity = Velocity;
		}
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
		if (Input.IsActionJustPressed("ui_down")){
			dashFunc();
		}
		
		//when moving left, accelerate smoothly to movement max
		if (Input.IsActionPressed("ui_left")){
			facing = "left";
			direction = Vector2.Left;
			velocity.X = Mathf.Lerp(velocity.X, (-movementMax), (float).08);
		}
		//when moving left, accelerate smoothly to movement max
		else if (Input.IsActionPressed("ui_right")){
			facing = "right";
			direction = Vector2.Right;
			velocity.X = Mathf.Lerp(velocity.X, (movementMax), (float).08);

			
		}
		//when they are released, reset the speed to its static value
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
			PickupResource pickupResource = playerInteract.InteractWith();
			//use objectID to get weapon sprite & attack animation sprite
			if (pickupResource.ID != 0) 
				weaponManager.Show();
				weaponManager.ChangeSprites(pickupResource.HeldSprite, pickupResource.SwingSprite);
		}
	}
	
	
	public void takeDamage(int damageVal){
		int newHealth = playerHealth - damageVal;
		if (newHealth < 0) newHealth = 0;
		playerHealth = newHealth;
		updateAliveStatus();
	}
	
	public void getHealed(int healVal){
		if (!playerAlive) return;
		int newHealth = playerHealth + healVal;
		if (newHealth > 100) playerHealth = 100;
		playerHealth = newHealth;
		updateAliveStatus();
	}
	
	public void updateAliveStatus(){
		if (playerHealth <= 0){
			playerAlive = false;
			handleDeath();
			return;
		}
		playerAlive = true;
	}
	
	public void handleDeath(){
		GD.Print("TODO Character death");
	}
}
