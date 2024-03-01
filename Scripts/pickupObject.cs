using Godot;
using System;

public partial class pickupObject : RigidBody2D
{
	[Export(PropertyHint.ResourceType, "PickupResource")]
	public PickupResource pickupResource;
	
	private Label pickupLabel;
	private ObjectInteractArea interactArea;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		pickupLabel = GetNode<Label>("InteractArea/pickupLabel");
		interactArea = GetNode<ObjectInteractArea>("InteractArea");
		
		//Look into settings for what key is designated as interact key
		//set the pickUp label's text to reflect this.
		
		pickupLabel.Text = "Press [E] to pickup [" + pickupResource.Name + "]";
		
		interactArea.pickupResource = pickupResource;
	}
}
