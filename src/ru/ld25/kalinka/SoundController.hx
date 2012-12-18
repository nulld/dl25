package ru.ld25.kalinka;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.events.Event;

import nme.Assets;
import nme.Lib;
import haxe.Timer;
/**
 * ...
 * @author nulldivide
 */

class SoundController implements IUpdatable
{
	
	var startSound:Sound;
	var loop:Sound;
	var punch:Sound;
	var gameOver:Sound;
	
	var currentChannel:SoundChannel;
	
	var started:Bool;
	
	
	var _timer:Float;
	
	
	var state:Int = 0;

	public function new() 
	{
		startSound = Assets.getSound ("assets/sounds/music_start.mp3");
		loop  = Assets.getSound("assets/sounds/music_loop.mp3");
		punch = Assets.getSound("assets/sounds/punch.mp3");
		gameOver = Assets.getSound("assets/sounds/gameover.mp3");
		started = false;
	}
	
	public function Start():Void
	{
		if (currentChannel != null) currentChannel.stop();
		
		started = true;
		_timer  = 0.0;
		state   = 0;
		
		currentChannel = startSound.play();
	}
	
	public function PlayPunch():Void
	{
		punch.play();
	}
	
	
	public function Stop():Void
	{
		started = false;
		if (currentChannel != null)
		{
			currentChannel.stop();
			currentChannel = null;
		}
	}
	
	public function PlayGameOver():Void
	{
		gameOver.play();
	}
	
	public function update(dt):Void
	{
		//Lib.trace(Main.instance.timer);
		
		if ((Main.instance.timer >= (startSound.length/ 1000.0)) && (state == 0))
		{
			state = 1;
			currentChannel.stop();
			currentChannel = loop.play(0, 999999);
		}
	}
	
}