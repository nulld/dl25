package ru.ld25.kalinka;
import format.swf.MovieClip;
import nme.display.Sprite;
import nme.events.Event;

import com.eclecticdesignstudio.motion.Actuate;
import haxe.Timer;  

import ru.ld25.kalinka.Animation;
import nme.display.Bitmap;
import nme.Assets;

/**
 * ...
 * @author nulldivide
 */



class Izba extends Sprite
{
	
	public var layout:MovieClip;
	public var anim:Animation;
	public var nogi:Bitmap;
	//public var legLeft:Animation;
	//public var legRight:Animation;

	
	public var fps:Int = 12;
	
	public var locked:Bool;
	

	public function new() 
	{
		super();
		
		layout = new McIzba();
		
		anim = new Animation(layout);
		
		anim.addAnimation("idle", 1, 66,8,true);
		anim.addAnimation("leftPunch", 67, 73, 6);
		anim.addAnimation("rightPunch", 74, 80, 6);
		anim.addAnimation("bothPunch", 81, 87, 6);
		anim.addAnimation("death", 88, 93, 4);
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
		
		nogi = new Bitmap(Assets.getBitmapData("img/cutlegs.png"));
		nogi.visible = false;
		nogi.x = -nogi.width / 2;
		addChild(nogi);
		
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
	
	public function BothPunch():Void
	{
		anim.playAnimation("bothPunch" 
						   , function():Void 
						   { 
								 anim.playAnimation("idle"); 
						   });
	}
	
	public function Death(cb:Void->Void):Void
	{
		anim.playAnimation( "death"
						   , cb);
		nogi.visible = true;
		nogi.alpha = 0;
		Actuate.tween(nogi, 1.0, { alpha : 1 } );
	}
	
	private function enterFrame(e:Event):Void
	{
		
		
	}
	
	
	
	
}