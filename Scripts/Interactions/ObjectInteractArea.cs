using Godot;
using System;

public partial class ObjectInteractArea : InteractArea
{
	//This override will be used to remove the object when it is interacted with
	new public void InteractBy(){
		GD.Print("Object picked up");
		//remove object
	}
}
