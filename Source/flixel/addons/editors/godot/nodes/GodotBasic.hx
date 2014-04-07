package flixel.addons.editors.godot.nodes;
import flixel.addons.editors.godot.GodotCommon.NodeTypes;
import flixel.addons.editors.godot.properties.Behaviour;
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
		var hasUpdated = false;
		updatePaths = [];
		if (updateFlags & UpdateParams.IntType)
		{
			for (key in _ints.keys())
			{
				var behaviour = _ints.get(key);
				if (behaviour.update(Delta)) updatePaths.push(key);
			}
		}
		if (updateFlags & UpdateParams.FloatType)
		{
			for (behaviour in _floats)
			{
				hasUpdated |= behaviour.update(Delta);
			}
		}
		if (updateFlags & UpdateParams.StringType)
		{
			for (behaviour in _strings)
			{
				hasUpdated |= behaviour.update(Delta);
			}
		}
		if (updateFlags & UpdateParams.BoolType)
		{
			for (behaviour in _bools)
			{
				hasUpdated |= behaviour.update(Delta);
			}
		}
		if (updateFlags & UpdateParams.MapStringType)
		{
			for (behaviour in _mapStrings)
			{
				hasUpdated |= behaviour.update(Delta);
			}
		}
		if (updateFlags & UpdateParams.FloatArrayType)
		{
			for (behaviour in mFloatArrayType)
			{
				hasUpdated |= behaviour.update(Delta);
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
				updateFlags |= UpdateParams.ArrayFloatType;
			default:
				unknown = true;
		}
	}
	
}


@:abstract enum UpdateParams(Int) from Int to Int
{
	var BoolType = 1;
	var FloatType = 2;
	var IntType = 4;
	var StringType = 8;
	var MapStringType = 16;
	var FloatArrayType = 32;
}

typedef ParamMap<T> = Map<String, Behaviour<T>>;