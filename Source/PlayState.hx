package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.editors.godot.properties.Modifier;
import flixel.addons.editors.godot.GodotScene;
import flixel.addons.editors.godot.nodes.GodotNode;

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
	}

	override public function update():Void
	{
		super.update();
	}	
}