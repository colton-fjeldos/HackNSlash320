// GdUnit generated TestSuite
using Godot;
using GdUnit4;

namespace GdUnitDefaultTestNamespace
{
	using static Assertions;
	using static Utils;

	[TestSuite]
	public class controlled1Test
	{
		// TestSuite generated from
		private const string sourceClazzPath = "C:/Users/Colton/Documents/TestSuiteHackNSlash/Scripts/controlled1.cs";
		
		//Acceptance Test
		[TestCase]
		public void canCreate()
		{
			var testChar = new controlled1();
			AssertObject(testChar).IsNotNull();
			testChar.Free();
		}
		
		//Acceptance Test
		[TestCase]
		public void canDamage()
		{
			var testChar = new controlled1();
			testChar.takeDamage(30);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(70);
		}
		
		//Acceptance Test
		[TestCase]
		public void noNegativeDamage()
		{
			var testChar = new controlled1();
			testChar.takeDamage(-30);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(100);
		}
		
		//Acceptance Test
		[TestCase]
		public void noOverDamage()
		{
			var testChar = new controlled1();
			testChar.takeDamage(150);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(0);
		}
		
		//Acceptance Test
		[TestCase]
		public void canHeal()
		{
			var testChar = new controlled1();
			testChar.takeDamage(70);
			testChar.getHealed(50);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(80);
		}
		
		//Acceptance Test
		[TestCase]
		public void noNegativeHeal()
		{
			var testChar = new controlled1();
			testChar.getHealed(-50);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(100);
		}
		
		//Acceptance Test
		[TestCase]
		public void noOverHeal()
		{
			var testChar = new controlled1();
			testChar.getHealed(50);
			var health = testChar.playerHealth;
			testChar.Free();
			AssertInt(health).IsEqual(100);
		}
		
		//canDie is a whitebox test, almost provides full coverage.
		//Along with canSurviveSomeDamage, provides full coverage
		
		//Here are the functions both of these tests rely on
		/*
		public void takeDamage(int damageVal){
			int newHealth = playerHealth - damageVal;
			if (newHealth < 0) newHealth = 0;
			playerHealth = newHealth;
			updateAliveStatus();
		}
		
		and
		
		public void updateAliveStatus(){
			if (playerHealth <= 0){
				playerAlive = false;
				handleDeath();
				return;
			}
			playerAlive = true;
		}
		
	*/
		[TestCase]
		public void canDie()
		{
			var testChar = new controlled1();
			testChar.takeDamage(100);
			var alive = testChar.playerAlive;
			testChar.Free();
			AssertBool(alive).IsEqual(false);
		}
		
		//canSurviveSomeDamage is another whitebox test, and it provides some coverage
		//Along with canDie, provides full coverage
		[TestCase]
		public void canSurviveSomeDamage()
		{
			var testChar = new controlled1();
			testChar.takeDamage(30);
			var alive = testChar.playerAlive;
			testChar.Free();
			AssertBool(alive).IsEqual(true);
		}
		
		//Acceptance test
		[TestCase]
		public void cantRessurect()
		{
			var testChar = new controlled1();
			testChar.takeDamage(100);
			testChar.getHealed(30);
			var alive = testChar.playerAlive;
			testChar.Free();
			AssertBool(alive).IsEqual(false);
		}
	}
}
