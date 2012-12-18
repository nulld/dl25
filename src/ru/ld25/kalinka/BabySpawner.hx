package ru.ld25.kalinka;

/**
 * ...
 * @author nulldivide
 */

import nme.display.Stage;
import nme.geom.Rectangle;
import ru.ld25.kalinka.PrettyChild;

class BabySpawner implements IUpdatable 
{
	
	public static inline var EOF:Int = -1;

	private var _timer:Float;
	public  var active:Bool;
	private var _nextBabySpawnTime:Float;

	
	public var babies:Array<PrettyChild>;
	
	private var leftTrack:Array<Int>;
	private var leftTrackInd:Int;
	private var rightTrack:Array<Int>;
	private var rightTrackInd:Int;
	
	private var k:Int = 10000;
	
	public  var movingDuration:Float;
	
	public function new() 
	{
		_timer = 0.0;
		babies = [];
		
		leftTrack  = [6000, 16500, 22700, 26400, 28100,31300,33700, 34300];
		rightTrack = [11500, 20700, 24600, 25600, 29800, 32400, 34300];
		
		for (i in 0...10000)
		{
			leftTrack.push(leftTrack[leftTrack.length - 1] + Math.floor(Math.max(1500, (Math.random() * 10000))));
			rightTrack.push(rightTrack[rightTrack.length - 1] + Math.floor(Math.max(1500, (Math.random() * 10000))));
		}
		
		leftTrack.push( EOF );
		rightTrack.push( EOF );
		
		
		
		active = false;
	}
	
	public function Start():Void
	{
		cleanup();
		active = true;
		
		leftTrackInd = 0;
		rightTrackInd = 0;
		
		movingDuration = 3.0;
		
		
		_timer = 0.0;

		_nextBabySpawnTime = Math.random() * 2.0;
	}
	
	public function Stop():Void
	{
		active = false;
	}
	
	public function ___spawnBaby():Void
	{
		var direction:Int = 1 + Math.floor((Math.random() * 1.2));
		
		_nextBabySpawnTime = Math.max(Math.random() * k, 0.3);
		_timer = 0.0;
		
		
	}
	
	
	public function update(dt:Float):Void
	{
		var currTMs:Float = Main.instance.timer * 1000;
		k--;
		
		var nextLeftSpawnTime:Int = leftTrack[leftTrackInd];
		var nextRightSpawnTime:Int = rightTrack[rightTrackInd];
		
		if ((nextLeftSpawnTime != EOF) && (nextLeftSpawnTime - (movingDuration * 1000) <= currTMs))
		{
			spawnBaby(PrettyChild.LEFT2RIGHT);
			leftTrackInd++;
		}
		else 
		{
		
		}
		
		if ((nextRightSpawnTime != EOF) && (nextRightSpawnTime - (movingDuration * 1000) <= currTMs))
		{
			spawnBaby(PrettyChild.RIGHT2LEFT);
			rightTrackInd++;
		}
		
	}
	
	private function spawnBaby(direction:Int):Void
	{
		var b:PrettyChild = new PrettyChild(direction);
		Main.instance.addChild(b);
		b.StartMoving();
		babies.push(b);
	}
	
	public function cleanup():Void
	{
		for (b in babies)
		{
			b.cleanup();
			babies.remove(b);
		}
	}
	
}