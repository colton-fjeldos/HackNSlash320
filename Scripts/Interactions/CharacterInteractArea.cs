using Godot;
using System;

public partial class CharacterInteractArea : InteractArea
{
	public override int InteractWith()
	{
		int interactID;
		if (curInteraction != null) {
			GD.Print("Character interacts with area");
			interactID = curInteraction.InteractedBy();
			curInteraction.FreeParent();
			GD.Print("Picked up object of itemID" + interactID);
			return interactID;
		}
		GD.Print("No object to pickup in range");
		return 0;
	}
	
	public override void AreaEntered(Area2D area)
	{
		GD.Print("CharacterInArea");
		curInteraction = (InteractArea) area;
	}
	
	public override void AreaExited(Area2D area)
	{
		if (curInteraction == area) curInteraction = null;
	}
	public override void FreeParent() {GD.Print("This function should literally never be called, how did you call it");}
}
