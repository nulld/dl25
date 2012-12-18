package ru.ld25.kalinka;

import format.swf.MovieClip;
import ru.ld25.kalinka.IUpdatable;

/**
 * ...
 * @author Null/
 */

 
typedef TAnimation = {
	var frameStart:Int;
	var frameEnd:Int;
	var fps:Int;
	var loop:Bool;
}

typedef TAnimationState = {
	var currentAnimation:TAnimation;
	var timer:Float;
	var currentFrame:Int;
	var completeCb:Void->Void;

}

class Animation implements IUpdatable
{

	public var animations:Hash<TAnimation>;
	public var state:TAnimationState;
	public var valid:Bool;
	public var currentAnimationName:String;
	
	public var layout:MovieClip;

	public var currentFrame(_getCurrentFrame, null):Int;

	public function new(mc:MovieClip) 
	{
		layout = mc;
		mc.stop();
		animations = new Hash<TAnimation>();
		valid = true;
		currentAnimationName = "";
	}

	public function addAnimation(name:String, frameStart:Int, frameEnd:Int, ?fps:Int = 12, ?loop:Bool = false):Void
	{
		animations.set(name, { frameStart : frameStart
							 , frameEnd   : frameEnd
							 , "fps" : cast fps
							 , "loop" : cast loop } );
	}

	public function playAnimation(name:String, ?onComplete:Void->Void):Void
	{
		if (!animations.exists(name)) return;
		
		state = {
			currentAnimation : animations.get(name)
			, timer : 0.0
			, currentFrame: -1
			, completeCb : onComplete 
		};
		currentAnimationName = name;
		update(0.0);
	}

	private function _getCurrentFrame():Int
	{
		if (state == null) return 0;
		if (state.currentFrame < 0) return 0;

		return state.currentAnimation.frameStart + state.currentFrame;
	}

	public function update(dt:Float):Void
	{
		if (state == null) return;

		state.timer += dt;

		var frame:Int = Math.floor(state.timer * state.currentAnimation.fps);
		if (frame > state.currentFrame)
		{
			if (frame > (state.currentAnimation.frameEnd - state.currentAnimation.frameStart))
			{
				if (state.currentAnimation.loop)
				{
					state.currentFrame = 0;
					state.timer = 0.0;
				}
				else
				{
					var cb:Void->Void = state.completeCb;
					state = null;
					if (cb != null)
					{
						cb();
					}
					
					return;
				}
			}
			else
			{
				state.currentFrame = frame;
			}
			valid = false;
			Draw();
		}
	}
	
	public function Draw():Void
	{
		layout.gotoAndStop(currentFrame);
	}

}