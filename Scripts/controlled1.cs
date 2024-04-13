using Godot;
using System;
using System.Threading.Tasks;
using System.Collections.Generic;

public partial class controlled1 : CharacterBody2D
{
	private Dictionary<string, Dictionary<string, object>> Skills;
	
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
	
	private int playerHealth = 100;
	private int maxHealth = 100;
	
	private bool playerAlive = true;
	
	//velocity is a shared variable
	Vector2 velocity;
	
	// Exported dictionary for skills
	//[Export]
	//public Dictionary<string, Dictionary<string, object>> Skills { get; set; }
	
	// Define variables for each skill node
	private bool healthBoostUnlocked = false;
	private int healthBoostLevel = 0;
	
	private bool speedBoostUnlocked = false;
	private int speedBoostLevel = 0;
	
	private bool damageBoostUnlocked = false;
	private int damageBoostLevel = 0;

	


	public override void _Ready()
	{
		//manually set collision values upon ready for portability
		this.SetCollisionMaskValue(3,true);
		this.SetCollisionMaskValue(1,true);
		this.SetCollisionLayerValue(3,true);
		weaponManager = GetNode<WeaponManager>("WeaponManager");
		maxHealth = 100; //modifiers can be added here from skill tree
		playerHealth = maxHealth; 
		
		// Get a reference to the SkillTree node path
		Node skillTree = GetNode<Node>("/root/Node2D/CanvasLayer2/SkillTree");
		
		// Check if the reference to the SkillTree node is not null
		if (skillTree != null)
		{
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
			
			// Skip the skill if it is the "level" property
			if (skillName.Equals("level", StringComparison.OrdinalIgnoreCase))
			{
				continue;
			}
			
			// Extract properties
			string[] properties = parts[1].Split(',');
			
			// Initialize unlock status
			bool unlock = false;
			
			// Iterate over properties to find the unlock status
			foreach (string prop in properties)
			{
				if (prop.Trim().Equals("unlock: true", StringComparison.OrdinalIgnoreCase))
				{
					unlock = true;
					break;
				}
			}
			
			// Update the variables for each skill node based on its status
			 if (skillName == "Health Boost")
			{
				if (unlock)
				{
					GD.Print("Health Boost unlocked!");
				}
				 healthBoostUnlocked = unlock;
			}
			else if (skillName == "Speed Boost")
			{
				if (unlock && !speedBoostUnlocked)
				{
					GD.Print("Speed Boost unlocked!");
				}
				speedBoostUnlocked = unlock;
			}
			else if (skillName == "Damage Boost")
			{
				if (unlock && !damageBoostUnlocked)
				{
					GD.Print("Damage Boost unlocked!");
				}
				damageBoostUnlocked = unlock;
			}
			
			// Print the extracted information
			GD.Print("Skill:", skillName);
			GD.Print("Unlock:", unlock);
		}
	}
}
