using Godot;
using System;

public partial class WeaponManager : Node2D
{
	
	Godot.Area2D Hitbox;
	
	public override void _Ready()
	{
		Hitbox = GetNode<Godot.Area2D>("Area2D");
	}
	
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && @event.IsPressed())
		{
			GD.Print("Sword swung, coordinates pressed: ", mouseEvent.Position);
			Hitbox.Show();
		}
	}
}
