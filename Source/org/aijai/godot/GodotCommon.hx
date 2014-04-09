package org.aijai.godot;


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



@:enum abstract NodeTypes(String) from String to String
{
	var Sprite				= "Sprite";
	var Position2D			= "Position2D";
	var CollisionShape2D	= "CollisionShape2D";
	var Node				= "Node";
}