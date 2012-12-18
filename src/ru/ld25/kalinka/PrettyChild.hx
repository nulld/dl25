package ru.ld25.kalinka;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author nulldivide
 */

class PrettyChild extends Sprite
{
	public static inline var LEFT2RIGHT:Int = 1;
	public static inline var RIGHT2LEFT:Int = 2;
	
	
	public var direction:Int;
	public var duration:Float;
	
	public function new(direction:Int=1, duration:Float=3.0) 
	{
		super();
		
		this.direction = direction;
		this.duration  = duration;
		
		var ind:Int = Math.floor(Math.random() * 1.5);
		var choice:Array<String> = ["boy", "girl"];
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/" + choice[ind] + Std.string(direction) + ".png"));
		b.scaleX = b.scaleY = 0.7;
		b.y = -b.height + 30;
		
		y = 200;
		
		b.x = (direction == LEFT2RIGHT) ?  -b.width + 30 : -30;
		addChild(b);

		x = (direction == LEFT2RIGHT) ? 0 : Main.instance.stage.stageWidth;
		rotation = (direction == LEFT2RIGHT) ? 35: -35;
	}
	
	public function StartMoving():Void
	{
		var ha:Rectangle = (direction == LEFT2RIGHT) ? Main.instance.leftLegHitArea : Main.instance.rightLegHitArea;
		
		var targetX:Float =  (direction == LEFT2RIGHT) ? ha.right : ha.left;
		var targetY:Float  =  ha.bottom;

		Actuate.tween(this, duration, { y : targetY, x : targetX } ).ease (Cubic.easeIn).onComplete(killIzba);
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
	
	private function killIzba():Void
	{
		var targetX:Float = x + ((direction == LEFT2RIGHT) ? 200 : - 200);
		Actuate.tween(this, 0.5, { x : targetX, rotation : 0, y : y + 100 } );
		Actuate.tween(this, 1.0, { alpha : 0.0 }, false );
		Main.instance.gameOver();
		//Main.instance.gameOver();
		//Lib.trace("KILL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	}
	
	
	
}