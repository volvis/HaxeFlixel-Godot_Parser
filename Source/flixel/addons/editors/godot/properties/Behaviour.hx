package flixel.addons.editors.godot.properties;

/**
 * ...
 * @author Pekka Heikkinen
 */
class Behaviour<T>
{
	var defaultValue:T;
	var cachedValue:T;
	
	public function new(DefaultValue:T) 
	{
		modifiers = [];
		listeners = [];
		defaultValue = DefaultValue;
		cachedValue = DefaultValue;
	}
	
	var modifiers:Array<Modifier<T>>;
	
	/**
	 * Updates behaviour value
	 * @param	Delta
	 * @return	True if update causes the value to change
	 */
	public function update(Delta:Float):Bool;
	{
		if (modifers.length == 0)
		{
			return false;
		}
		else
		{
			var Value:T = defaultValue;
			for (modifier in modifiers)
			{
				if (modifier.active)
				{					
					Value = modifier.value(Value, Delta);
				}
			}
			if (Value !== cachedValue)
			{
				cachedValue = Value;
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	
	public function value():T
	{
		return cachedValue;
	}
	
	public function add(Comp:Modifier<T>)
	{
		modifiers.push(Comp);
	}
}

class DefaultBehaviours
{
	public static var integer(get, null):Behaviour<Int>;
	static function get_integer():Behaviour<Int>
	{
		if (integer == null) integer = new Behaviour<Int>(0);
		return integer;
	}
	
	public static var string(get, null):Behaviour<String>;
	static function get_string():Behaviour<String>
	{
		if (string == null) string = new Behaviour<String>("");
		return string;
	}
	
	public static var arrayFloats(get, null):Behaviour<Array<Float>>;
	static function get_arrayFloats():Behaviour<Array<Float>>
	{
		if (arrayFloats == null) arrayFloats = new Behaviour<Array<Float>>([0,0,0,0]);
		return arrayFloats;
	}
}