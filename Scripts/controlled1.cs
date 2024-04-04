using Godot;
using System;
using System.Threading.Tasks;

public partial class controlled1 : CharacterBody2D
{
	//stored float values for easy changing
	public static float movementMax = 350.0f;
	
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
	public int dashLength = 300;
	//length of the overall dash recharge also in milliseconds
	public int dashLongCharge = 5000;
	//facing string for animation useage later
	public string facing;
	//direction vector for normalized dashing movement
	Vector2 direction = Vector2.Zero;
	
	
	//double jump capability. Currently used like a bool
	//but stored as an int in case we want to add conditional triple jump
	public int doubleJump = 1;
	
	//invulnerability is an INT to track stacking amounts of invulnerability
	//see the invulnerability ASYNC function for more information
	public int invulnerable = 0;
	
	//Private interactionmanager field since input is taken care of inside of this script
	[Export]
	private InteractArea playerInteract;
	
	private WeaponManager weaponManager;
	
	//this is the dashBar timer graphical interface
	private TimerBar myTimer;
	
	private int playerHealth = 100;
	private int maxHealth = 100;
	
	private bool playerAlive = true;
	
	//velocity is a shared variable
	Vector2 velocity;


	public override void _Ready()
	{
		//manually set collision values upon ready for portability
		this.SetCollisionMaskValue(3,true);
		this.SetCollisionMaskValue(1,true);
		this.SetCollisionLayerValue(3,true);
		weaponManager = GetNode<WeaponManager>("WeaponManager");
		maxHealth = 100; //modifiers can be added here from skill tree
		playerHealth = maxHealth;
		//create a timerBar and initialize it with player pixel values.
		myTimer = GetNode<TimerBar>("TimerBar");
		myTimer.startFunc(33f,0f);
	}
	
	//The way invulnerability works is that multiple types of invuln don't stack,
	//but they can overlap. So if the player dashes, they are invuln for 300 miliseconds
	//as called by the dash function. The async function increments and then waits for that time
	//to decrement. If something else makes the player invulnerable during this time,
	//then invulnerability is incremented again for the listed time. Making the effective
	//invuln time the higher of either the remaining time of the first effect of the 
	//total time of the new effect. You are invuln if the value of its variable is >0.
	public async Task invulnerability(int time){
		invulnerable++;
		await Task.Delay(TimeSpan.FromMilliseconds(time));
		invulnerable--;
		return;
	}
	
	//Dash recharge rate for overall dash recharge
	public async Task dashBarTimer(){
		await Task.Delay(TimeSpan.FromMilliseconds(dashLongCharge));
		myTimer.updateBar(16.5f,1);
		dashRecharge++;
		return;
	}
	
	//dash refractory period recharge handler
	public async Task dashInstanceTimer(){
		await Task.Delay(TimeSpan.FromMilliseconds(dashLength));
		isDashing = false;
		dashAvailable= true;
		this.SetCollisionMaskValue(3,true);
		return;
	}
	
	//dash function, moves the players, sets bools then calls 
	//timers for dash recharge and refractory period
	public void dashFunc(){
		if ((dashRecharge > 0) 
		&& dashAvailable && playerAlive){
			isDashing = true;
			dashAvailable= false;
			this.SetCollisionMaskValue(3,false);
			velocity = (direction.Normalized() * 1000);
			dashRecharge--;
			invulnerability(dashLength);
			myTimer.updateBar(16.5f,0);
			dashInstanceTimer();
			dashBarTimer();
			
		}
	}
	
	//dash bool check
	public void dashReady(){
		if (dashRecharge==0){
			dashAvailable=false;
		}
		else{
			dashAvailable =true;
		}
	}
	
	//direction setters and velocity return function
	//so that external programs can call these without having to mess
	//with variables directly
	public void setRight(){
		direction = Vector2.Right;
	}
	public void setLeft(){
		direction = Vector2.Left;
	}
	public void setUp(){
		direction = Vector2.Up;
	}
	public void setDown(){
		direction = Vector2.Down;
	}
	public float velocityFunc(){
		float temp = velocity.X;
		return temp;
	}	
	
	//physics for controlled character
	public override void _PhysicsProcess(double delta){
		//if not dashing
		if (!isDashing){
		//set velocity
		Vector2 velocity = Velocity;
		}
		if (!playerAlive){
			return;
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
			setLeft();
			velocity.X = Mathf.Lerp(velocity.X, (-movementMax), (float).08);
		}
		//when moving left, accelerate smoothly to movement max
		else if (Input.IsActionPressed("ui_right")){
			facing = "right";
			setRight();
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
			
			//If our hands are full.
			if (weaponManager.hasWeapon) return;
			InteractArea objectInteract = playerInteract.InteractWith();
			if (objectInteract == null) return;
			PickupResource objectPickup = objectInteract.InteractedBy();
			objectInteract.FreeParent();
			weaponManager.hasWeapon = true;
			GD.Print("Picked up object of itemID" + objectPickup.ID);
			
			weaponManager.Show();
			weaponManager.ChangeSprites(objectPickup.HeldSprite, objectPickup.SwingSprite);
			
		}
	}
	
	//If a projectile hits InteractArea, detects that its in the player group
	//grab that area's parent node, and call the function takeDamage on it.
	public void takeDamage(int damageVal){
		if (damageVal < 0) return;
		//don't take damage in an invulnerability state
		if (invulnerable!=0) return;
		int newHealth = playerHealth - damageVal;
		if (newHealth < 0) newHealth = 0;
		playerHealth = newHealth;
		updateAliveStatus();
	}
	
	public void getHealed(int healVal){
		if (healVal < 0) return;
		if (!playerAlive) return;
		int newHealth = playerHealth + healVal;
		if (newHealth > 100) playerHealth = 100;
		playerHealth = newHealth;
		updateAliveStatus();
	}
	
	private void updateAliveStatus(){
		if (playerHealth <= 0){
			playerAlive = false;
			handleDeath();
			return;
		}
	}
	
	private void handleDeath(){
		GD.Print("TODO Character death");
	}
}
