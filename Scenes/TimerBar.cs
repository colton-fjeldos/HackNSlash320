using Godot;
using System;

public partial class TimerBar : Line2D
{
	//base vector that sets its original position
	private Vector2 point1 = new Vector2(0f,0f);
	//second adjustable point
	private Vector2 point2;
	//bar starts at 33 pixels, current length of character model
	private float bar = 33.0f;
	
	
	//set starting values for an instance of the TimerBar
	public void startFunc(float x, float y){
		point2 = new Vector2(x,y);
		//line point 1 is 0,0 to start at its default position of placement on the map
		this.AddPoint(point1);
		//line point 2 is adjustable in length, set y as 0 for horizontal bar.
		this.AddPoint(point2);
	}
	
	
	//updates the bar with a value assumed to be positive
	//Behavior of bar can be strange when adjusted by a negative value
	//used primarily by dashFunc and dashBarTimer in order to have
	//a visual indication of when the player can dash again.
	public void updateBar(float adjustBy, int addorsub){
		//change bar value by amount
		if (addorsub==1){
			bar = bar + adjustBy;
		}
		else{
			bar = bar - adjustBy;
		}
		//set new bar position
		SetPointPosition(1,new Vector2(bar,0f));
		
	}
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		/* Example starting values. Can be called from here if the object is indpendent
		or from the startFunc method
		AddPoint(point1);
		AddPoint(point2);
		GD.Print(GetPointPosition(1).X);
		*/
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//for timer bars where they update every frame.
		//SetPointPosition(1,new Vector2(bar,0f));
		
	}
}
