package ru.ld25.kalinka;

import format.swf.MovieClip;
import haxe.Timer;
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
import nme.geom.Rectangle;

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
	
	private var _startTime:Int;
	
	public var timer:Float;
	private static inline var startIzbaFps:Int = 6;

	public var _updatable:Array<IUpdatable>;
	
	public var snd:SoundController;
	public var babySpawner:BabySpawner;
	
	
	private var _scoresTF:TextField;
	private var _livesTF:TextField;
	private var _gameOverTF:TextField;
	
	private var gameOverLabel:Bitmap;
	
	
	private var _score:Int;
	public  var score(getScore, setScore):Int;
	
	private var _lives:Int;
	public  var lives(getLives, setLives):Int;
	
	public var splash:Sprite;
	
	public var leftLegHitArea:Rectangle;
	public var rightLegHitArea:Rectangle;

	
	public var leftKeyDown:Bool;
	public var rightKeyDown:Bool;
	
	public var lbutt1:Bitmap;
	public var rbutt1:Bitmap;
	public var lbutt2:Bitmap;
	public var rbutt2:Bitmap;
	
	public var isGameOver:Bool;
	
	
	public function new() 
	{
		
		instance = this;
		frame    = 0;
		_updatable = [];
		_tickDt = 1.0 / FPS;
		
		
		
		super();
		#if iphone
		//Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		snd = new SoundController();
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
			//gameOver();
			return 0;
		}
		_livesTF.text = "Lives: " + Std.string(val);
		return val;
	}
	
	public function gameOver():Void
	{
		if (isGameOver) return;
		isGameOver = true;
		
		snd.PlayGameOver();
		
		Timer.delay(gameOverAnimationComplete, 3000);
		
		gameOverLabel.visible = true;
		
		snd.Stop();
		RemoveUpdateble(snd);
		
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		izba.Death(function() { 
			Actuate.reset();
			removeEventListener(Event.ENTER_FRAME, onFrame);
			babySpawner.Stop();
			babySpawner.cleanup();
			for (entity in _updatable)
			{
				RemoveUpdateble(entity);
			}
		} );
		//removeEventListener(Event.ENTER_FRAME, onFrame);
//		removeChild(izba);
//		izba = null;
		_gameOverTF.visible = true;
		
		
		
		
		//izba = null;
	/*	
		
	*/	
		
		
		_gameOverTF.text = "Game Over. Your score: " + Std.string(_score);
		_gameOverTF.visible = false;
		
		
		
		//Actuate.reset();
		
		
		
	}
	
	private function gameOverAnimationComplete():Void
	{
		
		stage.addEventListener( KeyboardEvent.KEY_DOWN
								, _gameOverKeyDown);
	}
	
	private function _gameOverKeyDown(e:Event):Void
	{
		if (izba == null) return;
		
		stage.removeEventListener (KeyboardEvent.KEY_DOWN, _gameOverKeyDown);
		removeChild(izba);
		izba = null;
		gameOverLabel.visible = false;
									
		startGame();
	}
	

	private function init(e) 
	{
		// entry point
		// new to Haxe NME? please read *carefully* the readme.txt file!
		
		leftLegHitArea  =  new Rectangle(220 , 320, 100, 100);
		rightLegHitArea = new Rectangle(580 , 320, 100, 100);
		
		graphics.beginFill(0xff00000);
		graphics.drawRect(leftLegHitArea.x, leftLegHitArea.y, leftLegHitArea.width, leftLegHitArea.height);
		graphics.endFill();
		
		
		
		
		lbutt1 = new Bitmap(Assets.getBitmapData("img/button_left0.png"));
		lbutt1.scaleX = lbutt1.scaleY = 0.5;
		lbutt2 = new Bitmap(Assets.getBitmapData("img/button_left1.png"));
		lbutt2.visible = false;
		
		graphics.beginFill(0xff00000);
		graphics.drawRect(rightLegHitArea.x, rightLegHitArea.y, rightLegHitArea.width, rightLegHitArea.height);
		graphics.endFill();
		
		rbutt1 = new Bitmap(Assets.getBitmapData("img/button_right0.png"));
		rbutt2 = new Bitmap(Assets.getBitmapData("img/button_right1.png"));
		rbutt2.visible = false;
		
		lbutt1.scaleX = lbutt1.scaleY = lbutt2.scaleX = lbutt2.scaleY = rbutt1.scaleX = rbutt1.scaleY = rbutt2.scaleX = rbutt2.scaleY =0.5;
		
		
		
		
		var back:Bitmap = new Bitmap(Assets.getBitmapData("img/back.jpg"));
		addChild(back);
		
		
		
		var moon:MovieClip = new McMoon1();

		moon.x = 500;
		moon.y = 200;
		
		//addChild(moon);
		
		addChild(lbutt1);
		lbutt1.x = leftLegHitArea.x + leftLegHitArea.width/2 - lbutt1.width/2;
		lbutt1.y = 460;
		addChild(lbutt2);
		lbutt2.x = lbutt1.x;
		lbutt2.y = lbutt1.y;
		
		
		addChild(rbutt1);
		rbutt1.x = rightLegHitArea.x + rightLegHitArea.width / 2 - rbutt1.width / 2;
		rbutt1.y = 460;
		addChild(rbutt2);
		rbutt2.x = rbutt1.x;
		rbutt2.y = rbutt1.y;
		
		_scoresTF = new TextField();
		addChild(_scoresTF);
		_scoresTF.defaultTextFormat = new TextFormat("Arial", 24.0, 0xFFFFFF, true);
		_scoresTF.width = 400;
		_scoresTF.text = "Score: 0";
		
		_livesTF = new TextField();
		addChild(_livesTF);
		_livesTF.defaultTextFormat = new TextFormat("Arial", 24.0, 0xFFFFFF, true);
		_livesTF.x = stage.stageWidth - 200;
		_livesTF.text = "Lives: 0";
		_livesTF.visible = false;
		
		
		
		_gameOverTF = new TextField();
		_gameOverTF.visible = false;
		addChild(_gameOverTF);
		_gameOverTF.width = 400;
		_gameOverTF.defaultTextFormat = new TextFormat("Arial", 28.0, 0xFFFFFF, true);
		_gameOverTF.x = stage.stageWidth / 2 - _gameOverTF.width / 2;
		_gameOverTF.y = stage.stageHeight / 2 - _gameOverTF.height / 2;
		
		babySpawner = new BabySpawner();
		
		var moon:Bitmap = new Bitmap(Assets.getBitmapData("img/moon.png"));
		addChild(moon);
		moon.x = 600;
		moon.y = 40;
		
		
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/splash.jpg"));
		splash = new Sprite();
		splash.addChild(b);
		addChild(splash);
		splash.addEventListener(MouseEvent.CLICK
							   , onSplashSkip );
							   
		stage.addEventListener( KeyboardEvent.KEY_DOWN
								, onSplashSkip );
								
		gameOverLabel = new Bitmap(Assets.getBitmapData("img/gameover.png"));
		addChild(gameOverLabel);
		gameOverLabel.x = 300;
		gameOverLabel.y = -40;
		gameOverLabel.visible = false;
		
		
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
		lives = 300;
		isGameOver = false;
		
		_startTime = Lib.getTimer();
		
		izba = new Izba();
		izba.locked = false;
		izba.x = 450;
		izba.y = 440;
		
		addChild(izba);
		
		//addChild(new FPS());
		
		leftKeyDown  = false;
		rightKeyDown = false;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		frame = 0;
		
		timer        = 0.0;
		
		snd.Start();
		AddUpdateble(snd);
		AddUpdateble(babySpawner);
		babySpawner.Start();
		

		_lastTickTime = 0.0;
		addEventListener(Event.ENTER_FRAME, onFrame);
		
		//gameOver();

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
		
		return (b.direction == PrettyChild.LEFT2RIGHT) ? leftLegHitArea.contains(b.x, b.y) : rightLegHitArea.contains(b.x, b.y);
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void
	{
		var code:Int = e.keyCode;
		
		if (code == LEFT_KEY)
		{
			leftKeyDown  = true;
		}
		else if (code == RIGHT_KEY)
		{
			rightKeyDown = true;
		}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void
	{
		if (e.keyCode == LEFT_KEY)
		{
			leftKeyDown  = false;
		}
		else if (e.keyCode == RIGHT_KEY)
		{
			rightKeyDown = false;
		}
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	private function checkBabiesToKickOff(direction:Int)
	{
		for (b in babySpawner.babies)
			{
				if ( (b.direction == direction) &&
					  isIzbaIntersects(b))
				{
					b.KickOff();
					score++;
					var bng = new Bang();
					addChild(bng.layout);
					snd.PlayPunch();
					var r:Rectangle = b.getRect(this);
					bng.layout.x = r.x + r.width / 2;
					bng.layout.y = r.y + r.height / 2;
				}
			}
	}
	
	private function validateTips():Void
	{
		lbutt2.visible = false;
		rbutt2.visible = false;
		for (b in babySpawner.babies)
		{
			if ( isIzbaIntersects(b))
			{
				if (b.direction == PrettyChild.LEFT2RIGHT)
				{
					lbutt2.visible = true;
				}
				if (b.direction == PrettyChild.RIGHT2LEFT)
				{
					rbutt2.visible = true;
				}
			}
	}
			
	}
	
	
	
	public function punch():Void
	{
		
		if ((leftKeyDown) && (rightKeyDown))
		{
			izba.BothPunch();
			checkBabiesToKickOff(PrettyChild.LEFT2RIGHT);
			checkBabiesToKickOff(PrettyChild.RIGHT2LEFT);
		}
		else if (leftKeyDown)
		{
			izba.LeftPunch();
			checkBabiesToKickOff(PrettyChild.LEFT2RIGHT);
		}
		else if (rightKeyDown)
		{
			izba.RightPunch();
			checkBabiesToKickOff(PrettyChild.RIGHT2LEFT);
		}
	}
	
	public function onFrame(e:Event):Void
	{
		validateTips();
		if (izba.anim.currentAnimationName == "idle")
		{
			punch();
		}
		else
		{
			leftKeyDown = false;
			rightKeyDown = false;
		}

		var ltimer:Int =   Lib.getTimer();
		timer     = (ltimer - _startTime) / 1000.0;

		
		var frames:Int = 0;
		if (_lastTickTime > 0.0)
		{
			frames = Math.floor((ltimer - _lastTickTime)  / (_tickDt));
		}
		else
		{
			frames = 1;
		}
		
		if (frames > 0)
		{
			_lastTickTime = Lib.getTimer() / 1000.0 ;
		}

		
		frame  += frames;
		
		
		if (frames > MAX_TICKS) 
		{
			frames = MAX_TICKS;
		}

		for (i in 0...frames)
		{
			for (entity in _updatable)
			{
				entity.update(_tickDt);
			}
		}
		
	}
	
}
