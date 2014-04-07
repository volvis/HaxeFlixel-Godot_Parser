package flixel.addoflixel.addons.editors.godot;

import flixel.addons.editors.godot.GodotCommon.NodeTypes;
import flixel.addons.editors.godot.GodotCommon.NodeParam;
import flixel.addons.editors.godot.GodotCommon.Vector;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.FlxObject;
import openfl.Assets;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotSprite extends FlxSprite
{
	var points:Map<String, FlxPoint>;
	var rects:Map<String, FlxObject>;
	var sprites:Map<String, Int>;
	var spriteArray:Array<FlxSprite>;
	
	public function new(Blueprint:GodotScene, X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		points = new Map<String, FlxPoint>();
		rects = new Map<String, FlxObject>();
		sprites = new Map<String, Int>();
		spriteArray = [];
		for (node in Blueprint.nodes)
		{
			var godotNode = new GodotNode(node);
			switch(godotNode.type)
			{
				case NodeTypes.Position2D:
					points.set(godotNode.name, FlxPoint.get(godotNode.position.x, godotNode.position.y));
				case NodeTypes.CollisionShape2D:
					1;
					points.set(godotNode.name, FlxPoint.get(godotNode.position.x, godotNode.position.y));
					var _o = new FlxObject(0, 0, godotNode.scale.x, godotNode.scale.y);
				case NodeTypes.Sprite:
					var _s:FlxSprite = new FlxSprite(0, 0);
					_s.loadGraphic(Assets.getBitmapData( Blueprint.external_resources.get(godotNode.texturepath) ) );
					
					_s.x = godotNode.position.x;
					_s.y = godotNode.position.y;
					
					if (godotNode.centered)
					{
						_s.x -= _s.width * 0.5;
						_s.y -= _s.height * 0.5;
					}
					
					spriteArray.push(_s);
					trace( Blueprint.external_resources.get(node.get("texture").get("path")) );
					1;
				default:
					1;
			}
		}
		
		1;
	}
	
	public function globalPoint(Name:String):FlxPoint
	{
		var _p = points.get(Name);
		return FlxPoint.weak(_p.x + x, _p.y + y);
	}
	
	/*override public function update():Void
	{
		super.update();
	}
	*/
	override public function draw():Void
	{
		for (sprite in spriteArray)
		{
			sprite.x += x;
			sprite.y += y;
			sprite.draw();
			sprite.x -= x;
			sprite.y -= y;
		}
	}
	
	override public function destroy():Void
	{
		for (point in points)
		{
			point.put();
		}
		
		for (rect in rects)
		{
			rect.destroy();
		}
		
		super.destroy();
	}
	
}


abstract GodotNode(Map<String, Dynamic>)
{
	public inline function new(m:Map<String, Dynamic>)
	{
		this = m;
	}
	
	public var type(get, never):NodeTypes;
	inline function get_type():NodeTypes
	{
		return this.get(NodeParam.type);
	}
	
	public var position(get, never):Vector;
	inline function get_position():Vector
	{
		return this.get(NodeParam.position);
	}
	
	public var name(get, never):String;
	inline function get_name():String
	{
		return this.get(NodeParam.name);
	}
	
	public var scale(get, never):Vector;
	inline function get_scale():Vector
	{
		return this.get(NodeParam.scale);
	}
	
	public var texturepath(get, never):String;
	inline function get_texturepath():String
	{
		return this.get("texture").get("path");
	}
	
	public var centered(get, never):Bool;
	inline function get_centered():Bool
	{
		return this.get("centered");
	}
}