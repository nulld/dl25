package ru.ld25.kalinka;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.events.Event;

import nme.Assets;
import haxe.Timer;
/**
 * ...
 * @author nulldivide
 */

class SoundController 
{
	
	var startSound:Sound;
	var loop:Sound;
	
	var currentChannel:SoundChannel;
	
	var started:Bool;
	
	

	public function new() 
	{
		startSound = Assets.getSound ("assets/sounds/music_start.mp3");
		loop = Assets.getSound("assets/sounds/music_loop.mp3");
		started = false;
	}
	
	public function Start():Void
	{
		if (currentChannel != null) currentChannel.stop();
		
		started = true;
		
		currentChannel = startSound.play();
		
		Timer.delay( function() 
				    {
					   if (started) currentChannel = loop.play(0, 999999);
					}, Math.floor(startSound.length) );
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
	
}