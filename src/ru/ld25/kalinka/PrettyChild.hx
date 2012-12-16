package ru.ld25.kalinka;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;

/**
 * ...
 * @author nulldivide
 */

class PrettyChild extends Sprite
{
	public static inline var LEFT2RIGHT:Int = 1;
	public static inline var RIGHT2LEFT:Int = 2;
	
	
	public var direction:Int;
	
	public function new(direction:Int=1) 
	{
		super();
		
		this.direction = direction;
		var ind:Int = Math.floor(Math.random() * 1.5);
		var choice:Array<String> = ["boy", "girl"];
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/" + choice[ind] + Std.string(direction) + ".png"));
		//b.y = b.height;
		
		if (direction == LEFT2RIGHT) b.x =  -b.width;
		addChild(b);
		
		x = (direction == LEFT2RIGHT) ? 0 : Main.instance.stage.stageWidth;
		rotation = (direction == LEFT2RIGHT) ? 30: -30;
	}
	
	public function StartMoving():Void
	{
		var tartgetX:Float =  Main.instance.stage.stageWidth / 2;
		tartgetX += (direction == LEFT2RIGHT) ? 200 : -200;
		Actuate.tween(this, 5, { y : Main.instance.stage.stageHeight + 100, x : tartgetX } ).ease (Cubic.easeIn);
	}
	
	public function KickOff():Void
	{
		var targetX:Float = Main.instance.stage.stageWidth / 2;
		targetX += (direction == LEFT2RIGHT) ? -200 * Math.random() : 200 * Math.random();
		Actuate.tween(this, 5, { rotation : 500, x : targetX, y : -500 } );
	}
	
	public function cleanup():Void
	{
		Actuate.stop(this);
		parent.removeChild(this);
		
	}
	
	
}