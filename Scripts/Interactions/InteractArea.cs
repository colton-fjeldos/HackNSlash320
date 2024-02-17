using Godot;
using System;

public partial class InteractArea : Area2D
{
	public InteractArea curInteraction;
	
	//When another InteractArea enters this interact area, save it in field
	public void AreaEntered(Area2D area)
	{
		curInteraction = (InteractArea) area;
	}

	//When that same interactarea exits this interactarea, clear the field
	public void AreaExited(Area2D area)
	{
		if (curInteraction == area) curInteraction = null;
	}
	
	//This is a function that will be called when a player wants to interact with another object
	public void InteractWith()
	{
		if (curInteraction != null) curInteraction.InteractedBy();
	}
	
	//This is the function that will be called when something ELSE interacts with this interact area
	public void InteractedBy()
	{
		GD.Print("This object has been interacted by some other object");
	}
}



