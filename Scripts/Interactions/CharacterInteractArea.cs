using Godot;
using System;

public partial class CharacterInteractArea : InteractArea
{
	public override InteractArea InteractWith()
	{
		if (curInteraction != null) {
			GD.Print("Character interacts with area");
			//pickupResource = curInteraction.InteractedBy();
			//curInteraction.FreeParent();
			//GD.Print("Picked up object of itemID" + pickupResource.ID);
			return curInteraction;
		}
		GD.Print("No object to pickup in range");
		return null;
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
}
