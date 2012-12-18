package ru.ld25.kalinka;
import format.swf.MovieClip;
import nme.display.Sprite;

/**
 * ...
 * @author nulldivide
 */

import com.eclecticdesignstudio.motion.Actuate;

class Bang extends Animation
{
	
	public function new() 
	{
		super(new McBang());
		
		addAnimation("go", 1, 10);
		Main.instance.AddUpdateble(this);
		
		//Actuate.tween(layout, 0.7, { "alpha" : 0.0 } );
		
		playAnimation( "go"
					 , function():Void 
					 { 
						layout.parent.removeChild(layout); 
						Main.instance.RemoveUpdateble(this);
					 } );
	}
	
}