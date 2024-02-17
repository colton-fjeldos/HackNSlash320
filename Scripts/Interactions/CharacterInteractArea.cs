using Godot;
using System;

public partial class CharacterInteractArea : InteractArea
{
	//This override will be used to set the characters current weapon, I think.
	public void InteractWith()
	{
		GD.Print("Character interacts with area");
		base.InteractWith();
	}
}
