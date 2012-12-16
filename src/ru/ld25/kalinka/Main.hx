package ru.ld25.kalinka;

import nme.display.Bitmap;
import nme.display.FPS;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;
import nme.events.KeyboardEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import ru.ld25.kalinka.Bang;
import nme.Assets;
import nme.events.MouseEvent;
import com.eclecticdesignstudio.motion.Actuate;

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
	
	private var _timer:Float;
	private static inline var startIzbaFps:Int = 6;

	public var _updatable:Array<IUpdatable>;
	
	public var snd:SoundController;
	public var babySpawner:BabySpawner;
	
	
	private var _scoresTF:TextField;
	private var _livesTF:TextField;
	private var _gameOverTF:TextField;
	
	
	private var _score:Int;
	public  var score(getScore, setScore):Int;
	
	private var _lives:Int;
	public  var lives(getLives, setLives):Int;
	
	public var splash:Sprite;
	
	
	public function new() 
	{
		
		instance = this;
		frame    = 0;
		_lastTickTime = 0.0;
		_updatable = [];
		_tickDt = 1.0 / FPS;
		
		snd = new SoundController();
		
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}
	
	private function getScore():Int
	{
		return _score;
	}
	
	private function setScore(val:Int):Int
	{
		_score = val;
		_scoresTF.text = "Score: " + Std.string(val);
		return val;
	}
	
	private function getLives():Int
	{
		return _lives;
	}
	
	private function setLives(val:Int):Int
	{
		_lives = val;
		if (_lives < 0) 
		{
			gameOver();
			return 0;
		}
		_livesTF.text = "Lives: " + Std.string(val);
		return val;
	}
	
	private function gameOver():Void
	{
		_gameOverTF.visible = true;
		
		removeEventListener(Event.ENTER_FRAME, onFrame);
		removeChild(izba);
		snd.Stop();
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		izba = null;
		
		for (entity in _updatable)
		{
			RemoveUpdateble(entity);
		}
		
		
		_gameOverTF.text = "Game Over. Your score: " + Std.string(_score);
		
		babySpawner.Stop();
		babySpawner.cleanup();
		
		Actuate.reset();
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN
								, function(e:Event) 
								{
									if (izba != null) return;
									_gameOverTF.visible = false;
									startGame();
								    
								});
		
	}
	

	private function init(e) 
	{
		// entry point
		// new to Haxe NME? please read *carefully* the readme.txt file!
		
		_scoresTF = new TextField();
		addChild(_scoresTF);
		_scoresTF.defaultTextFormat = new TextFormat("Arial", 24.0, 0xFFFFFF, true);
		_scoresTF.text = "Score: 0";
		
		_livesTF = new TextField();
		addChild(_livesTF);
		_livesTF.defaultTextFormat = new TextFormat("Arial", 24.0, 0xFFFFFF, true);
		_livesTF.x = stage.stageWidth - 200;
		_livesTF.text = "Lives: 0";
		
		_gameOverTF = new TextField();
		addChild(_gameOverTF);
		_gameOverTF.width = 400;
		_gameOverTF.defaultTextFormat = new TextFormat("Arial", 28.0, 0xFFFFFF, true);
		_gameOverTF.x = stage.stageWidth / 2 - _gameOverTF.width / 2;
		_gameOverTF.y = stage.stageHeight / 2 - _gameOverTF.height / 2;
		
		babySpawner = new BabySpawner();
		
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/splash.jpg"));
		splash = new Sprite();
		splash.addChild(b);
		addChild(splash);
		splash.addEventListener(MouseEvent.CLICK
							   , onSplashSkip );
							   
		stage.addEventListener( KeyboardEvent.KEY_DOWN
								, onSplashSkip );
		
		
		//startGame();
	}
	
	private function onSplashSkip(e:Event):Void
	{
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onSplashSkip);
		splash.removeEventListener(MouseEvent.CLICK, onSplashSkip );
		
		if (izba != null) return;
		removeChild(splash);
		startGame();
	}
	
	
	
	
	public function startGame():Void
	{
		score = 0;
		lives = 3;
		
		izba = new Izba();
		izba.x = stage.stageWidth / 2;
		izba.y = stage.stageHeight - 100;
		
		addChild(izba);
		
		addChild(new FPS());
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		frame = 0;
		_lastTickTime = 0.0;
		
		snd.Start();
		AddUpdateble(babySpawner);
		babySpawner.Start();

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
	
	private function isIzbaIntersects(b:PrettyChild):Bool
	{
		var eps:Float = 22.0;
		return (Math.abs(b.y - (izba.y)) < eps);
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void
	{
		var code:Int = e.keyCode;
		
		if (code == LEFT_KEY)
		{
			izba.LeftPunch();
			for (b in babySpawner.babies)
			{
				if ( (b.direction == PrettyChild.LEFT2RIGHT) &&
				     isIzbaIntersects(b))
					//&& (b.getRect(this).intersects(izba.legLeft.layout.getRect(this))))
					//(b.getRect(this).intersects(izba.layout.getRect(this))))
				{
					b.KickOff();
					score++;
					var bng = new Bang();
					addChild(bng.layout);
					var r:Rectangle = b.getRect(this);
					bng.layout.x = r.x + r.width / 2;
					bng.layout.y = r.y + r.height / 2;
					
				}
			}
		}
		
		else if (code == RIGHT_KEY)
		{
			izba.RightPunch();
			for (b in babySpawner.babies)
			{
				if ( (b.direction == PrettyChild.RIGHT2LEFT) &&
					//&& (b.getRect(this).intersects(izba.legRight.layout.getRect(this))))
					//(b.getRect(this).intersects(izba.layout.getRect(this))))
					isIzbaIntersects(b))
				{
					b.KickOff();
					score++;
					var bng = new Bang();
					addChild(bng.layout);
					var r:Rectangle = b.getRect(this);
					bng.layout.x = r.x + r.width / 2;
					bng.layout.y = r.y + r.height / 2;
				}
			}
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
				_timer += _tickDt;
				entity.update(_tickDt);
			}
		}
		
		
	}
	
}
