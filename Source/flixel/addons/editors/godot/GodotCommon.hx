package flixel.addons.editors.godot;


/**
 * ...
 * @author Pekka Heikkinen
 */
typedef Vector =
#if HAXEFLIXEL
flixel.util.FlxPoint;
#else
flash.geom.Point;
#end

typedef AF = Array<Float>;

abstract XY(AF) from AF to AF
{
	inline function new(a:AF)
	{
		this = a;
	}
	
	public var x(get, set):Float;
	function get_x():Float { return this[0]; }
	function set_x(Value:Float):Float { this[0] = Value; return Value; }
	
	public var y(get, set):Float;
	function get_y():Float { return this[1]; }
	function set_y(Value:Float):Float { this[1] = Value; return Value; }
}

abstract RGBA(AF) from AF to AF
{
	inline function new(a:AF)
	{
		this = a;
	}
	
	public var a(get, set):Float;
	function get_a():Float { return this[0]; }
	function set_a(Value:Float):Float { this[0] = Value; return Value; }
	
	public var b(get, set):Float;
	function get_b():Float { return this[1]; }
	function set_b(Value:Float):Float { this[1] = Value; return Value; }
	
	public var g(get, set):Float;
	function get_g():Float { return this[2]; }
	function set_g(Value:Float):Float { this[2] = Value; return Value; }
	
	public var r(get, set):Float;
	function get_r():Float { return this[3]; }
	function set_r(Value:Float):Float { this[3] = Value; return Value; }
}

@:enum abstract KeyType(Int)
{
    var BooleanKeys = 0;
    var StringKeys = 1;
    var IntKeys = 2;
	var FloatKeys = 3;
	var VectorKeys = 4;
}

@:enum abstract PauseMode(Int) from Int to Int
{
	var Inherit = 0;
	var Stop = 1;
	var Process = 2;
}

@:enum abstract BlendMode(Int) from Int to Int
{
	var Mix = 0;
	var Add = 1;
	var Sub = 2;
	var Mul = 3;
}

@:enum abstract InterpolationType(Int) from Int to Int
{
	var Nearest = 0;
	var Linear = 1;
	var Cubic = 2;
}

@:enum abstract NodeParam(String) from String to String
{
	var type = "type";
	var name = "name";
	var position = "transform/pos";
	var scale = "transform/scale";
	var rotation = "transform/rot";
	var script = "script/script";
	var processPauseMode = "process/pause_mode";
	
	var centered = "centered";
	var flipH = "flip_h";
	var flipV = "flip_v";
	
	var blendMode = "visibility/blend_mode";
	var onTop = "visibility/on_top";
	var opacity = "visibility/opacity";
	var selfOpacity = "visibility/self_opacity";
	var visible = "visibility/visible";
}

@:enum abstract NodeTypes(String) from String to String
{
	var Sprite				= "Sprite";
	var Position2D			= "Position2D";
	var CollisionShape2D	= "CollisionShape2D";
	var Node				= "Node";
}