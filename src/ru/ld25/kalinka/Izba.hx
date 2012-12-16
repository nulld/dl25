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
	public var anim:Animation;
	
	//public var legLeft:Animation;
	//public var legRight:Animation;

	
	public var fps:Int = 12;
	

	public function new() 
	{
		super();
		
		layout = new McIzba();
		
		anim = new Animation(layout);
		
		anim.addAnimation("idle", 1, 67,12,true);
		anim.addAnimation("leftPunch", 22, 33);
		anim.addAnimation("rightPunch", 33, 45);
		anim.playAnimation("idle");
/*		
		legLeft  = new Animation(cast layout.getChildByName("leftLeg"));
		legLeft.addAnimation("idle", 1, 1 );
		legLeft.addAnimation("punch", 1, 5 );
		
		
		legRight = new Animation(cast layout.getChildByName("rightLeg"));
		legRight.addAnimation("idle", 1, 1 );
		legRight.addAnimation("punch", 1, 5 );
		
		Main.instance.AddUpdateble(legLeft);
		Main.instance.AddUpdateble(legRight);
*/		
		
		Main.instance.AddUpdateble(anim);
		addChild(layout);
		
	}
	
	public function LeftPunch():Void
	{
		
		anim.playAnimation( "leftPunch"
							 , function():Void 
							 { 
								anim.playAnimation("idle");  
							 });
	
		
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
		anim.playAnimation("rightPunch" 
							   , function():Void 
							   { 
								 anim.playAnimation("idle"); 
							   });
							   
		
	}
	
	private function enterFrame(e:Event):Void
	{
		
		
	}
	
	
	
	
}