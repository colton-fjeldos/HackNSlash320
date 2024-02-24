using Godot;
using System;

public partial class ObjectInteractArea : InteractArea
{
	[Export]
	private Node2D parentObject;
	
	[Export]
	private int itemID = 1;
	
	private Label pickupLabel;
	
	public override void _Ready(){
		pickupLabel = GetNode<Label>("pickupLabel");
		//Look into settings for what key is designated as interact key
		//set the pickUp label's text to reflect this.
		pickupLabel.Hide();
	}
	
	//This override will be used to remove the object when it is interacted with
	public override int InteractedBy(){
		GD.Print("This item has been picked up");
		return itemID;
	}
	
	public override void AreaEntered(Area2D area)
	{
		GD.Print("ObjectWithinRange");
		curInteraction = (InteractArea) area;
		pickupLabel.Show();
	}
	
	public override void AreaExited(Area2D area)
	{
		if (curInteraction == area) curInteraction = null;
		pickupLabel.Hide();
	}
	
	public override void FreeParent(){ parentObject.QueueFree();}
}
