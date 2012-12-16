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

	private var _timer:Float;
	public  var active:Bool;
	private var _nextBabySpawnTime:Float;
	public var k:Float;
	
	public var babies:Array<PrettyChild>;
	
	public function new() 
	{
		_timer = 0.0;
		babies = [];
		active = false;
	}
	
	public function Start():Void
	{
		cleanup();
		active = true;
		_timer = 0.0;
		k = 5.0;
		_nextBabySpawnTime = Math.random() * 2.0;
	}
	
	public function Stop():Void
	{
		active = false;
	}
	
	public function SpawnBaby():Void
	{
		var direction:Int = 1 + Math.floor((Math.random() * 1.2));
		
		_nextBabySpawnTime = Math.max(Math.random() * k, 0.3);
		_timer = 0.0;
		
		var b:PrettyChild = new PrettyChild(direction);
		Main.instance.addChild(b);
		b.StartMoving();
		babies.push(b);
	}
	
	
	
	public function update(dt:Float):Void
	{
		if (!active) return;
		
		_timer += dt;
		
		var stage:Stage = Main.instance.stage;
		var r:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		
		if (_timer >= _nextBabySpawnTime) SpawnBaby();
		
		//check out of scene
		for (b in babies)
		{
			if (((b.y > 100) || (b.y < -200)) && (!b.getRect(Main.instance).intersects(r)))
			{
								
				b.cleanup();
				babies.remove(b);
				if (b.y > Main.instance.stage.stageHeight) 
				{
					Main.instance.lives--;
					if (Main.instance.lives <= 0) return;
				}

			}
		}
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