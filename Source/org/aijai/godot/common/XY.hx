package org.aijai.godot.common;

/**
 * ...
 * @author Pekka Heikkinen
 */
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