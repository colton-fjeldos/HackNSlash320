using Godot;
using System;

public partial class ObjectInteractArea : InteractArea
{
	[Export]
	private Node2D parentObject;
	
	public PickupResource pickupResource;
	
	private Label pickupLabel;
	
	public override void _Ready(){
		pickupLabel = GetNode<Label>("pickupLabel");
		pickupLabel.Visible = false;
	}
	
	//This override will be used to remove the object when it is interacted with
	public override PickupResource InteractedBy(){
		GD.Print("This item has been picked up");
		return pickupResource;
	}
	
	public override void AreaEntered(Area2D area)
	{
		GD.Print("ObjectWithinRange");
		curInteraction = (InteractArea) area;
		pickupLabel.Visible = true;
	}
	
	public override void AreaExited(Area2D area)
	{
		if (curInteraction == area) curInteraction = null;
		pickupLabel.Visible = false;
	}
	
	public override void FreeParent(){ parentObject.QueueFree();}
}
