package org.aijai.godot.common;

/**
 * ...
 * @author Pekka Heikkinen
 */
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