// GdUnit generated TestSuite
using Godot;
using GdUnit4;

namespace GdUnitDefaultTestNamespace
{
	using static Assertions;
	using static Utils;

	[TestSuite]
	public class CameraControllerTest
	{
		// TestSuite generated from
		private const string sourceClazzPath = "C:/Users/Colton/Documents/TestSuiteHackNSlash/Scripts/CameraController.cs";
		
		//Acceptance test
		[TestCase]
		public void GetOffsetFromCenterWorks()
		{
			
			Rect2 screenRect = new Rect2(0,0,100,100);
			Vector2 testMouse = new Vector2(51,51);
			AssertObject( CameraController.GetOffsetFromCenter(screenRect,testMouse)  ).IsEqual(new Vector2(1,1));
		}
		
		//Acceptance test
		[TestCase]
		public void MoveCameraWorks()
		{
			Vector2 cameraPos = new Vector2(55, 100);
			Vector2 mouseScreenOffset = new Vector2(50,50);
			int cameraRadius = 30;
			int inverseCameraSpeed = 500;
			

			
			AssertObject( CameraController.MoveCamera(cameraPos,mouseScreenOffset,cameraRadius,inverseCameraSpeed)  ).IsEqual(new Vector2(50.221825F, 88.857864F));
		}
	}
}
