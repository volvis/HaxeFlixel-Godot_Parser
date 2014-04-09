package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import haxe.Timer;
import org.aijai.godot.common.RGBA;
import org.aijai.godot.common.XY;
import org.aijai.godot.node.properties.Modifier;
import org.aijai.godot.GodotScene;
import org.aijai.godot.node.GodotNode;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		add(new FlxText(0, 0, 100, "Hello World!"));
		var g = new GodotScene("assets/TestScene.xml");
		//add(new GodotSprite(g));
		var de = new GodotNode();
		trace(de.processPauseMode);
		var c = new ConstantModifier<String>("fuu");
		var bn:Array<Float> = [0, 1];
		var sd:Array<Int> = [0, 5];
		var d = new LinearAnimatedModifier(bn, sd);
		trace(d.value(1, 0.5));
		
		var t = Timer.stamp();
		var a:XY = [];
		a.x = 1;
		a.y = 2;
		for (i in 1...10000)
		{
			assert(a.x == 1);
			assert(a.y == 2);
		}
		trace(Timer.stamp() - t);
		/*var b:RGBA = new ABCD<Float>();
		b.r = 1;
		b.g = 2;
		
		t = Timer.stamp();
		for (i in 1...1000000)
		{
			assert(b.r == 1);
			assert(b.g == 2);
		}
		trace(Timer.stamp() - t);*/
	}
	
	static function assert( cond : Bool, ?pos : haxe.PosInfos ) {
      if( !cond )
          haxe.Log.trace("Assert in "+pos.className+"::"+pos.methodName,pos);
    }

	override public function update():Void
	{
		super.update();
	}	
}