package org.aijai.godot.node;
import org.aijai.godot.GodotCommon.NodeTypes;
import org.aijai.godot.node.properties.Behaviour;
/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotBasic
{

	public var name:String;
	public var type:NodeTypes;
	
	var _bools:ParamMap<Bool>;
	var _floats:ParamMap<Float>;
	var _strings:ParamMap<String>;
	var _ints:ParamMap<Int>;
	var _mapStrings:ParamMap < Map < String, String >> ;
	var _floatArrays:ParamMap<Array<Float>>;
	
	var updateFlags:Int = 0;
	
	var updatePaths:Array<String>;
	
	public function update(Delta:Float):Bool
	{
		updatePaths = [];
		if (updateFlags & UpdateParams.IntType > 0)
		{
			for (key in _ints.keys())
			{
				var behaviour = _ints.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.FloatType > 0)
		{
			for (key in _floats.keys())
			{
				var behaviour = _floats.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.StringType > 0)
		{
			for (key in _strings.keys())
			{
				var behaviour = _strings.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.BoolType > 0)
		{
			for (key in _bools.keys())
			{
				var behaviour = _bools.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.MapStringType > 0)
		{
			for (key in _mapStrings.keys())
			{
				var behaviour = _mapStrings.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.FloatArrayType > 0)
		{
			for (key in _floatArrays.keys())
			{
				var behaviour = _floatArrays.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		return (updatePaths.length > 0);
	}
	
	public function insert(Name:String, Value:Dynamic)
	{
		var unknown:Bool = false;
		switch(Value)
		{
			case Std.is(_, Int) => true:
				if (_ints == null) _ints = new ParamMap<Int>();
				_ints.set(Name, new Behaviour<Int>(Value));
				updateFlags |= UpdateParams.IntType;
			case Std.is(_, Float) => true:
				if (_floats == null) _floats = new ParamMap<Float>();
				_floats.set(Name, new Behaviour<Float>(Value));
				updateFlags |= UpdateParams.FloatType;
			case Std.is(_, String) => true:
				if (_strings == null) _strings = new ParamMap<String>();
				_strings.set(Name, new Behaviour<String>(Value));
				updateFlags |= UpdateParams.StringType;
			case Std.is(_, Bool) => true:
				if (_bools == null) _bools = new ParamMap<Bool>();
				_bools.set(Name, new Behaviour<Bool>(Value));
				updateFlags |= UpdateParams.BoolType;
			case (Std.is(_, Array) && Std.is(_[0], Float)) => true:
				if (_floatArrays == null) _floatArrays = new ParamMap<Array<Float>>();
				_floatArrays.set(Name, new Behaviour<Array<Float>>(Value));
				updateFlags |= UpdateParams.FloatArrayType;
			default:
				unknown = true;
		}
	}
	
}


@:enum abstract UpdateParams(Int) from Int to Int
{
	var BoolType = 1;
	var FloatType = 2;
	var IntType = 4;
	var StringType = 8;
	var MapStringType = 16;
	var FloatArrayType = 32;
}

typedef ParamMap<T> = Map<String, Behaviour<T>>;