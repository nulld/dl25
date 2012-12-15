package ru.ld25.kalinka;
import format.swf.MovieClip;
import nme.display.Sprite;
import nme.events.Event;

/**
 * ...
 * @author nulldivide
 */

typedef TAnimationState = {
	var startFrame:Int;
	var endFrame:Int;
	var currentFrame:Int;
	var timer:Float;
	var cb:Void->Void;
}

class Animation extends Sprite;
{
	private var _fps:Int;
	public var layout;

	private var _lastTickTime:Float;
	private var _tickDt:Float;
	
	public var currentAnimation:TAnimationState;
	
	public function new(layout:MovieClip, fps:Int = 12) 
	{
		_fps = fps;
		_tickDt = 1.0 / fps;
		addChild(layout);
		addEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	
	public function PlayAnimation(start:Int, stop:Int, ?complete_cb:Void->Void):Void
	{
		if (currentAnimation != null)
		{
		}
		
		currentAnimation = {
			startFrame : start
			, endFrame : stop
			, timer    : Lib.getTimer()
			, currentFrame  : -1
			, cb       : complete_cb
		};
	}
	
	
	public function onFrame(e:Event):Void
	{
		
		if (currentAnimation == null) return;

		var timer:Float =  Lib.getTimer();

		var frames:Int = 0;
		if (_lastTickTime > 0.0)
		{
			frames = Math.floor((timer - _lastTickTime) / _tickDt);
		}
		else
		{
			frames = 1;
		}

		_lastTickTime = timer;
		frame += frames;
		if (frames > MAX_TICKS) frames = MAX_TICKS;

		for (i in 0...frames)
		{
			for (entity in _updatable)
			{
				entity.update(_tickDt);
			}
		}
	}

	
}