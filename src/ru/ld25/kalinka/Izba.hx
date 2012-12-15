package ru.ld25.kalinka;
import format.swf.MovieClip;
import nme.display.Sprite;
import nme.events.Event;

import com.eclecticdesignstudio.motion.Actuate;
import haxe.Timer;  

import ru.ld25.kalinka.Animation;

/**
 * ...
 * @author nulldivide
 */



class Izba extends Sprite
{
	
	public var layout:MovieClip;
	
	public var legLeft:Animation;
	public var legRight:Animation;

	
	public var fps:Int = 12;

	public function new() 
	{
		super();
		
		layout = cast new McIzba();
		layout.stop();
		
		legLeft  = new Animation(cast layout.getChildByName("leftLeg"));
		legLeft.addAnimation("idle", 1, 1 );
		legLeft.addAnimation("punch", 1, 5 );
		
		
		legRight = new Animation(cast layout.getChildByName("rightLeg"));
		legRight.addAnimation("idle", 1, 1 );
		legRight.addAnimation("punch", 1, 5 );
		
		Main.instance.AddUpdateble(legLeft);
		Main.instance.AddUpdateble(legRight);
		
		addChild(layout);
		
	}
	
	public function LeftPunch():Void
	{
		
		legLeft.playAnimation("punch");
	
		
	/*	
		_currentAnimation = {
			frameStart : Utils.getFrameByLabel(legLeft, "punch");
			, frameEnd : legLeft.totalFrames
			, timer    : 0.0
			, currentFrame : 0
			, fps : 12
		}
	*/	
		//Actuate.tween(legLeft, 0.5, { "currentFrame" : 10 } );
	}
	
	
	public function RightPunch():Void
	{
		legRight.playAnimation("punch");
	}
	
	private function enterFrame(e:Event):Void
	{
		
		
	}
	
	
	
	
}