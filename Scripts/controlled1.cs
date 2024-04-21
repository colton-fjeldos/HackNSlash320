using Godot;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;





public partial class controlled1 : CharacterBody2D
{
	private Dictionary<string, Dictionary<string, object>> Skills;
	public Timer _timer;
	private int timerCounter = 0;

	
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
	//starting values for health
	private float playerHealth = 100.0f;
	private int maxHealth = 100;
	
	private bool playerAlive = true;
	
	//velocity is a shared variable
	Vector2 velocity;
	
	PackedScene deathScene;
	Node2D root;


	//ready sets:
	//collision masks, initializes weapon manager, 
	//health, the death scene and dashBar
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
		
		deathScene = GD.Load<PackedScene>("res://Scenes/Subscenes/Character/Projectiles/DeathScene.tscn");
		GD.Print(deathScene);
		
		root = (Node2D) GetTree().Root.GetChild(-1);
		UpdateSkillsDictionary();
		
		// Create a new timer
		_timer = new Timer();
		// Set the wait time (in seconds)
		_timer.WaitTime = 1.0f; // 1 second
		
		_timer.Connect("timeout", GetUpdateSkillsCallable());
		//_timer.Connect(0, this, nameof(OnTimerTimeout));
		
		 AddChild(_timer);
		// Start the timer
		_timer.Start();
		
	}
	
	// Method called when the timer times out
	private void OnTimerTimeout()
	{
		GD.Print("Timer expired!");
		timerCounter++;
		GD.Print("Timer Counter: ", timerCounter);
		
		UpdateSkillsDictionary();
	}
	
	private Godot.Callable GetUpdateSkillsCallable()
	{
		Godot.Callable callable = new Godot.Callable(this, nameof(OnTimerTimeout));
		GD.Print("Callable: ", callable);
		return callable;
	}
	
	
	 public void UpdateSkillsDictionary()
	{
		Node skillTree = GetNode<Node>("/root/Node2D/CanvasLayer2/SkillTree");
		
		if (skillTree != null)
		{
			
			//skillTree.Connect("skill_pressed1", this, nameof(OnSkillPressed));
			
			
			// Get the exported Skills dictionary from the SkillTree node
			object skillsVariant = skillTree.Get("Skills");
			string skillsString = skillsVariant.ToString();
			
			GD.Print("Skills Dictionary:", skillsVariant);
			
			
			
			// Parse the string to extract skill information
			ParseSkillsString(skillsString);
		}
		else
		{
			GD.Print("Failed to obtain reference to SkillTree node.");
		}
	}
	
	private void _on_control_skill_pressed_1()
	{
		GD.Print("Skill pressed.");
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
		//Await 5 seconds for recharge
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
		//dash if we have charges, araen't dashing, and alive
		if ((dashRecharge > 0) 
		&& dashAvailable && playerAlive){
			//isDashing to track dash time
			isDashing = true;
			//dash availablility for any states that might stop dash, such as already dashing
			dashAvailable= false;
			//change collision mask to move through enemies
			this.SetCollisionMaskValue(3,false);
			//check direction and move rapidly in that direction
			velocity = (direction.Normalized() * 1000);
			//one less dash for long dash charge, if 0 cannot dash.
			dashRecharge--;
			//be invulnerable for the dash length and half the bar
			invulnerability(dashLength);
			myTimer.updateBar(16.5f,0);
			//call await function
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
	//grab velocity value for analysis of movement functionality
	public float velocityFunc(){
		float temp = velocity.X;
		return temp;
	}	
	
	//physics for controlled character
	//uses the character functions for dash, jump, and directional setters
	//also useable for any function that needs to be checked every frame
	public override void _PhysicsProcess(double delta){
		//if not dashing, set velocity (to avoid velocity conflicts)
		if (!isDashing){
		Vector2 velocity = Velocity;
		}
		if (!playerAlive){
			return;
		}
		//if its in the air fall, or check for DJ
		if (!IsOnFloor()){
			//if not on the floor, set the gravity
			velocity.Y += gravity * (float)delta;
			if (Input.IsActionJustPressed("ui_up") && doubleJump ==1){
				doubleJump = 0;
				//the second jump is slightly higher than the first
				velocity.Y = (float)-(jump*1.1);
			}
			
		}
		
		
		//if its on the ground jump when up is pressed
		if (Input.IsActionJustPressed("ui_up") && IsOnFloor()){
				velocity.Y = -jump;
				doubleJump = 1;
				
		}
		//call the dash function
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
				//smooth slide stop
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
			weaponManager.SetWeaponDamage(objectPickup.Damage);
			
		} else if (Input.IsActionJustPressed("testdeath")){
			handleDeath();
		}
	}
	
	//If a projectile hits InteractArea, detects that its in the player group
	//grab that area's parent node, and call the function takeDamage on it.
	public void takeDamage(float damageVal){
		if (damageVal < 0) return;
		if (!playerAlive) return;
		//don't take damage in an invulnerability state
		if (invulnerable != 0) return;
		float newHealth = playerHealth - damageVal;
		if (newHealth < 0) newHealth = 0;
		playerHealth = newHealth;
		GD.Print("Player took " + damageVal + " damage, now has " + playerHealth + " health");
		updateAliveStatus();
	}
	
	public void getHealed(float healVal){
		if (healVal < 0) return;
		if (!playerAlive) return;
		float newHealth = playerHealth + healVal;
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

		Vector2 deathVelocity = new Vector2(velocity.X, -500);
		var random = new RandomNumberGenerator();
		random.Randomize();
		RigidBody2D deadBody = (RigidBody2D) deathScene.Instantiate();
		deadBody.Position = GlobalPosition;
		
		root.AddChild(deadBody);
		deadBody.LinearVelocity = deathVelocity;
		deadBody.AngularVelocity = random.Randfn() * 15;
		this.Hide();
		this.ProcessMode = (ProcessModeEnum) 4;
		
		//Probably open a pause menu, or some menu to restart level, or something!
		

		GD.Print("TODO Character death");
	}
	
	
	public bool jumpBoostApplied = false;
	public bool HealthBoostApplied = false;
	public bool jump3BoostApplied = false;
	public bool dashBoostApplied = false;
	public bool speedBoostApplied = false;
	// Method to parse the string representation of the skills dictionary
	private void ParseSkillsString(string skillsString)
	{
		
		// Remove unwanted characters from the string
		skillsString = skillsString.Replace("{", "").Replace("}", "").Replace("\"", "").Trim();
		
		// Split the string by comma to get individual skill entries
		string[] skillEntries = skillsString.Split(',');
		
		// Iterate over each skill entry
		foreach (string entry in skillEntries)
		{
			// Split the entry by colon to separate skill name and properties
			string[] parts = entry.Split(':');
					
			// Extract skill name
			string skillName = parts[0].Trim();
			
			string skillNames = parts[2].Trim();
			
			// Extract properties
			string[] properties = parts[1].Split(',');
			
			
			// Initialize unlock status
			bool unlock = false;
			
			// Iterate over properties to find the unlock status
			foreach (string prop in properties)
			{
				string[] keyValue = prop.Trim().Split(':');
				
				
				// Skip the "level" property
				if (keyValue[0].Equals("level", StringComparison.OrdinalIgnoreCase))
				{
					continue;
				}
				
				if (keyValue[0].Equals("unlock", StringComparison.OrdinalIgnoreCase))
				{
					
					if (skillNames.Equals("true", StringComparison.OrdinalIgnoreCase))
					{
						unlock = true;
						//GD.Print("Unlock set to true for", skillName);
					}
					else if (skillNames.Equals("false", StringComparison.OrdinalIgnoreCase))
					{
						unlock = false;
						//GD.Print("Unlock set to false for", skillName);
					}
					
				}
			}
			
			// Apply or remove effects based on skill unlock status
			switch (skillName)
			{
				case "Jump Boost":
					if (unlock)
					{
						if (!jumpBoostApplied)
						{
							
							jumpBoostApplied = true;
							//jumpBoostUnlocked = true;
							jump += 100.0f;
						}
					}
					else
					{
						if (jumpBoostApplied)
						{
							jump -= 100.0f;
							jumpBoostApplied = false;
						}
					}
					break;

				case "Speed Boost":
					if (unlock)
					{
						if (!speedBoostApplied)
						{
							
						
							speedBoostApplied = true;
							//speedBoostUnlocked = true;
							movementMax += 300.0f;
						}
					}
					else
					{
						if (speedBoostApplied)
						{
							speedBoostApplied = false;
							movementMax -= 300.0f;
						}
					}
					break;

				case "Health Boost":
					if (unlock)
					{
						if(!HealthBoostApplied)
						{
							
							HealthBoostApplied = true;
							maxHealth += 10;
							//GD.Print("Health:", maxHealth);
						}
					}
					else
					{
						if(HealthBoostApplied)
						{
							maxHealth -= 10;
							HealthBoostApplied = false;
							//GD.Print("Health:", maxHealth);
						}
					}
					break;
				
				case "Triple jump":
					if (unlock)
					{
						if(!jump3BoostApplied)
						{
							
							jump3BoostApplied = true;
						}
					}
					else
					{
						if(jump3BoostApplied)
						{
							jump3BoostApplied = false;
						}
					}
					break;
				
				case "Dash Length":
					if (unlock)
					{
						if(!dashBoostApplied)
						{
							
							dashBoostApplied = true;
						}
					}
					else
					{
						if(dashBoostApplied)
						{
							dashBoostApplied = false;
						}
					}
					break;
					
				default:
					// Handle other skills if needed
					break;
			}

			
			// Print the extracted information
			//GD.Print("Skill:", skillName);
			//GD.Print("Unlock:", unlock);
		}
		
	}
	
	
	
	
}









