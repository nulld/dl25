package ru.ld25.kalinka;

import nme.display.FPS;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.events.KeyboardEvent;

/**
 * ...
 * @author nulldivide
 */

class Main extends Sprite 
{
	
	private var izba:Izba;
	
	public static inline var LEFT_KEY:Int = 37;
	public static inline var RIGHT_KEY:Int = 39;
	public static inline var SPACE_KEY:Int = 32;
	
	public static inline var MAX_TICKS:Int = 3;
	public static inline var FPS:Int = 60;
	
	public static var instance:Main;
	
	public var frame:Int;
	public var _lastTickTime:Float;
	public var _tickDt:Float;

	public var _updatable:Array<IUpdatable>;
	
	public function new() 
	{
		
		instance = this;
		frame    = 0;
		_lastTickTime = 0.0;
		_updatable = [];
		_tickDt = 1.0 / FPS;
		
		
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// entry point
		// new to Haxe NME? please read *carefully* the readme.txt file!
		
		startGame();
	}
	
	
	public function startGame():Void
	{
		izba = new Izba();
		izba.x = stage.stageWidth / 2;
		izba.y = stage.stageHeight - 100;
		
		addChild(izba);
		
		addChild(new FPS());
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		frame = 0;
		_lastTickTime = 0.0;

		addEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	public function AddUpdateble(obj:IUpdatable):Void
	{
		_updatable.push(obj);
	}
	
	public function RemoveUpdateble(obj:IUpdatable):Void
	{
		_updatable.remove(obj);
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void
	{
		var code:Int = e.keyCode;
		
		if (code == LEFT_KEY)
		{
			izba.LeftPunch();
		}
		
		else if (code == RIGHT_KEY)
		{
			izba.RightPunch();
		}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void
	{
		
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	public function onFrame(e:Event):Void
	{

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
