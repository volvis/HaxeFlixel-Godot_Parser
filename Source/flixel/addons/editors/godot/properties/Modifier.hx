package flixel.addons.editors.godot.properties;
import flixel.addons.editors.godot.properties.Modifier.AnimatedModifier;
import flixel.addons.editors.godot.properties.Modifier.ConstantModifier;
import flixel.addons.editors.godot.GodotCommon.Vector;

/**
 * ...
 * @author Pekka Heikkinen
 */
@:generic
class Modifier<T>
{

	public function new() 
	{
		name = ControllerType.PassThrough;
		active = true;
	}
	
	public var name:ControllerType;
	public var active:Bool;
	
	public function value(Value:T, Time:Float, Start:Float = 0):T
	{
		return Value;
	}
	
}

@:generic
class ConstantModifier<T> extends Modifier<T>
{
	var constantValue:T;
	
	public function new(ConstantValue:T)
	{
		super();
		constantValue = ConstantValue;
		name = ControllerType.Constant;
		
	}
	
	override public function value(Value:T, Time:Float, Start:Float = 0):T 
	{
		return constantValue;
	}
}

@:generic
class AnimatedModifier<T> extends Modifier<T>
{
	
	public function new(Times:Array<Float>, Values:Array<T>)
	{
		super();
		name = ControllerType.Animated;
		times = Times;
		values = Values;
	}
	
	var times:Array<Float>;
	var values:Array<T>;
	
	override public function value(Value:T, Time:Float, Start:Float = 0):T 
	{
		Time -= Start;
		var index = times.length - 1;
		while (times[index] > Time)
		{
			index--;
		}
		return values[index];
	}
	
	function closestTimeIndex(Time:Float):Int
	{
		var index = times.length - 1;
		while (times[index] > Time)
		{
			index--;
		}
		return index;
	}
}

class LinearAnimatedModifier extends AnimatedModifier<Float>
{
	override public function value(Value:Float, Time:Float, Start:Float = 0):Float 
	{
		Time -= Start;
		var index = closestTimeIndex(Time);
		if (Time == times[index])
		{
			return values[index];
		}
		return Ease.easeLinear(Time, values[index], values[index + 1] - values[index], times[index + 1] - times[index])+Value;
	}
}

class CubicAnimatedModifier  extends AnimatedModifier<Float>
{
	
	override public function value(Value:Float, Time:Float, Start:Float = 0):Float 
	{
		Time -= Start;
		var index = closestTimeIndex(Time);
		if (Time == times[index])
		{
			return values[index];
		}
		return Ease.easeCubic(Time, values[index], values[index + 1] - values[index], times[index + 1] - times[index])+Value;
	}
}

class LinearCoordinateModifier extends AnimatedModifier<Vector>
{
	override public function value(Value:Vector, Time:Float, Start:Float = 0):Vector 
	{
		Time -= Start;
		var index = closestTimeIndex(Time);
		if (Time == times[index])
		{
			return values[index];
		}
		Value.x = Ease.easeLinear(Time, values[index].x, values[index + 1].x - values[index].x, times[index + 1] - times[index]) + Value.x;
		Value.y = Ease.easeLinear(Time, values[index].y, values[index + 1].y - values[index].y, times[index + 1] - times[index]) + Value.y;
		return Value;
	}
}

class CubicCoordinateModifier extends AnimatedModifier<Vector>
{
	override public function value(Value:Vector, Time:Float, Start:Float = 0):Vector 
	{
		Time -= Start;
		var index = closestTimeIndex(Time);
		if (Time == times[index])
		{
			return values[index];
		}
		Value.x = Ease.easeCubic(Time, values[index].x, values[index + 1].x - values[index].x, times[index + 1] - times[index]) + Value.x;
		Value.y = Ease.easeCubic(Time, values[index].y, values[index + 1].y - values[index].y, times[index + 1] - times[index]) + Value.y;
		return Value;
	}
}

class LinkModifier extends Modifier<Vector>
{
	var linkParent:Modifier<Vector>;
	
	public function new(LinkParent:Modifier<Vector>)
	{
		super();
		linkParent = LinkParent;
		name = ControllerType.Link;
	}
	
	override public function value(Value:Vector, Time:Float, Start:Float = 0):Vector 
	{
		var linkCoordinate:Vector = linkParent.value(Value, Time, Start);
		Value.x += linkCoordinate.x;
		Value.y += linkCoordinate.y;
		return Value;
	}
}

private class Ease
{
	inline public static function easeLinear(CurrentTime:Float, StartValue:Float, ChangeInValue:Float, Duration:Float):Float
	{
		return ChangeInValue * CurrentTime / Duration + StartValue;
	}
	
	inline public static function easeCubic(CurrentTime:Float, StartValue:Float, ChangeInValue:Float, Duration:Float):Float
	{
		CurrentTime /= Duration / 2;
		if (CurrentTime < 1)
		{
			return ChangeInValue / 2 * CurrentTime * CurrentTime * CurrentTime + StartValue;
		}
		else
		{
			CurrentTime -= 2;
			return ChangeInValue / 2 * (CurrentTime * CurrentTime * CurrentTime + 2) + StartValue;
		}
	}
}

@:enum abstract ControllerType(String) from String to String
{
	var PassThrough = "PASSTHROUGH";
	var Constant = "CONSTANT";
	var Animated = "ANIMATED";
	var Link = "LINK";
}