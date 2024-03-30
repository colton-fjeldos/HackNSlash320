using Godot;
using System;

public partial class ProjectileCollision : RigidBody2D
{
	private void _on_body_entered(Node body)
	{
		if (body.IsInGroup("stage")){
			QueueFree();
		}
	}
}
