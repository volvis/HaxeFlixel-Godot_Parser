package flixel.addons.editors.godot;
import haxe.macro.Expr;
import haxe.xml.Fast;
import StringTools;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotAnimation
{
	
	public var tracks:Array<GodotAnimationTrackData>;
	public var name:String;
	public var length:Float;
	public var loop:Bool;
	public var step:Float;
	
	public function new(Element:Fast) 
	{
		tracks = new Array<GodotAnimationTrackData>();
		for (element in Element.elements)
		{
			switch (element.att.name)
			{
				case "resource/name":
					this.name = GodotXML.getString(element);
				case "length":
					this.length = Std.parseFloat(element.innerHTML);
				case "loop":
					this.loop = (StringTools.trim(element.innerHTML) == "True" ? true : false);
				case "step":
					this.step = this.length = Std.parseFloat(Element.innerHTML);
				case StringTools.startsWith(_, "tracks") => true:
					var path:Array<String> = element.att.name.split("/");
					var index:Int = Std.parseInt(path[1]);
					var variant:String = path[2];
					if (tracks[index] == null)
					{
						tracks[index] = new GodotAnimationTrackData();
					}
					var track:GodotAnimationTrackData = tracks[index];
					switch(variant)
					{
						case "type":
							track.type = GodotXML.getString(element);
						case "path":
							track.path = GodotXML.getString(element);
						case "interp":
							track.interp = Std.parseInt(element.innerHTML);
						case "keys":
							var _d = GodotXML.getDictionary(element);
							track.cont = _d.get("cont");
							track.transitions = _d.get("transitions");
							track.times = _d.get("times");
							var _v = _d.get("values");
							switch(element.node.array.elements.next().name)
							{
								case "bool":
									track.keyType = KeyType.BooleanKeys;
									track.booleanKeys = _v;
								case "int":
									track.keyType = KeyType.IntKeys;
									track.intKeys = _v;
								case "vector2":
									track.keyType = KeyType.VectorKeys;
									track.vectorKeys = _v;
								case "string":
									track.keyType = KeyType.StringKeys;
									track.stringKeys = _v;
								case "float":
									track.keyType = KeyType.FloatKeys;
									track.floatKeys = _v;
							}
					}
				default:
					// None
			}
		}
		1;
	}
}

class GodotTypedTrack
{
	private var track:GodotAnimationTrackWrapper;
	public function new(TrackWrapper:GodotAnimationTrackWrapper)
	{
		track = TrackWrapper;
		keyType = track.keyType;
	}
	
	public var keyType(default, null):KeyType;
	
	public var time(get, set):Float;
	function set_time(newTime:Float)
	{
		track.time = newTime;
		return track.time;
	}
	function get_time():Float
	{
		return track.time;
	}
}

class GodotStringTrack extends GodotTypedTrack
{
	public function new(TrackWrapper:GodotAnimationTrackWrapper)
	{
		super(TrackWrapper);
	}
	
	public var value(get, never):String;
	function get_value():String
	{
		return track.stringValue;
	}
}

class GodotBoolTrack extends GodotTypedTrack
{
	public function new(TrackWrapper:GodotAnimationTrackWrapper)
	{
		super(TrackWrapper);
	}
	
	public var value(get, never):Bool;
	function get_value():Bool
	{
		return track.boolValue;
	}
}

class GodotFloatTrack extends GodotTypedTrack
{
	public function new(TrackWrapper:GodotAnimationTrackWrapper)
	{
		super(TrackWrapper);
	}
	
	public var value(get, never):Float;
	function get_value():Float
	{
		return track.floatValue;
	}
}

private class GodotAnimationTrackWrapper
{
	private var track:GodotAnimationTrackData;
	private var length:Float;
	private var loop:Bool;
	public function new(Track:GodotAnimationTrackData, Length:Float, Loop:Bool)
	{
		track = Track;
		length = Length;
		loop = Loop;
	}
	
	public var boolValue:Bool;
	public var intValue:Int;
	public var floatValue:Float;
	public var stringValue:String;
	public var vectorValue:Vector;
	
	public var time(default, set):Float;
	function set_time(newTime:Float)
	{
		if (loop == true)
		{
			newTime %= length;
		}
		var keyIndex = track.times.length;
		while (track.times[keyIndex] > newTime)
		{
			keyIndex--;
		}
		switch (track.keyType)
		{
			case KeyType.StringKeys:
				stringValue = track.stringKeys[keyIndex];
			case KeyType.BooleanKeys:
				boolValue = track.booleanKeys[keyIndex];
			case KeyType.FloatKeys:
				if (keyIndex == track.times.length)
				{
					floatValue = track.floatKeys[keyIndex];
				}
				else
				{
					floatValue = calculateEase("floatKeys");
				}
			case KeyType.IntKeys:
				if (keyIndex == track.times.length)
				{
					intValue = track.intKeys[keyIndex];
				}
				else
				{
					intValue = Std.int(calculateEase("intKeys"));
				}
			default:
				//Do none
		}
		return newTime;
	}
	
	macro public static function calculateEase(keyType:String):Expr
	{
		return macro ease(newTime-track.times[keyIndex], track.$keyType[keyIndex], track.$keyType[keyIndex + 1], track.times[keyIndex]-track.times[keyIndex + 1]);
	}
	
	public var keyType(get, never):KeyType;
	function get_keyType()
	{
		return track.keyType;
	}
	
	function ease(CurrentTime:Float, StartValue:Float, EndValue:Float, Duration:Float):Float
	{
		switch (track.interp)
		{
			case InterpolationType.Nearest:
				return easeNearest(CurrentTime, StartValue, EndValue-StartValue, Duration);
			case InterpolationType.Linear:
				return easeLinear(CurrentTime, StartValue, EndValue-StartValue, Duration);
			case InterpolationType.Cubic:
				return easeCubic(CurrentTime, StartValue, EndValue-StartValue, Duration);
		}
	}
	
	
	inline function easeLinear(CurrentTime:Float, StartValue:Float, ChangeInValue:Float, Duration:Float):Float
	{
		return ChangeInValue * CurrentTime / Duration + StartValue;
	}
	
	inline function easeCubic(CurrentTime:Float, StartValue:Float, ChangeInValue:Float, Duration:Float):Float
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
	
	inline function easeNearest(CurrentTime:Float, StartValue:Float, ChangeInValue:Float, Duration:Float):Float
	{
		if (CurrentTime == Duration)
		{
			return StartValue + ChangeInValue;
		}
		else
		{
			return StartValue;
		}
	}
}

private class GodotAnimationTrackData
{
	public function new() {}
	public var type:String;
	public var path:String;
	public var interp:InterpolationType;
	
	public var cont:Bool;
	public var transitions:Array<Float>;
	public var times:Array<Float>;
	
	public var keyType:KeyType;
	
	public var booleanKeys:Array<Bool>;
	public var intKeys:Array<Int>;
	public var stringKeys:Array<String>;
	public var floatKeys:Array<Float>;
	public var vectorKeys:Array<Vector>;
}

typedef Vector =
{
	x:Float,
	y:Float,
}

@:enum abstract KeyType(Int)
{
    var BooleanKeys = 0;
    var StringKeys = 1;
    var IntKeys = 2;
	var FloatKeys = 3;
	var VectorKeys = 4;
}

@:enum abstract InterpolationType(Int) from Int to Int
{
	var Nearest = 0;
	var Linear = 1;
	var Cubic = 2;
}