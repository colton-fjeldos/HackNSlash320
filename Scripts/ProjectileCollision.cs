using Godot;
using System;

public partial class ProjectileCollision : RigidBody2D
{
	public int weaponDamage = 0;
	
	private void _on_body_entered(Node body)
	{
		GD.Print(body);
		if (body.IsInGroup("stage")){
			QueueFree();
		}
		
		if (body.IsInGroup("Enemy")){
			body.Call("updateHealth", 50);
			
			QueueFree();
		}
	}
}
