package ru.ld25.kalinka;
import format.swf.MovieClip;

/**
 * ...
 * @author nulldivide
 */

class Utils 
{

	public function new() 
	{
		
	}
	
	public static function getFrameByLabel(mc:MovieClip, frameLabel: String ):Int
    {
       var scene:Scene = mc.currentScene;

       var frameNumber:int = -1;

	   for (i in 0...scene.labels.length)
       {
            if( scene.labels[i].name == frameLabel )
                frameNumber = scene.labels[i].frame;
       }

       return frameNumber;
  }
	
}