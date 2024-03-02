using Godot;
using System;

[GlobalClass]
public partial class PickupResource : Resource
{
	[Export] public int ID { get; set; }
	[Export] public int Damage { get; set; }
	[Export] public string Name { get; set; }
	[Export] public Texture2D SwingSprite { get; set; }
	[Export] public Texture2D HeldSprite { get; set; }
}
