package flixel.addons.editors.godot;
import flixel.addons.editors.godot.GodotAnimation.GodotAnimationTrack;
import flixel.addons.editors.godot.GodotAnimation.KeyType;
import flixel.addons.editors.godot.GodotAnimation.Vector;
import haxe.xml.Fast;
import StringTools;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotAnimation
{
	
	public var tracks:Array<GodotAnimationTrack>;
	public var name:String;
	public var length:Float;
	public var loop:Bool;
	public var step:Float;
	
	public function new(Element:Fast) 
	{
		tracks = new Array<GodotAnimationTrack>();
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
						tracks[index] = new GodotAnimationTrack();
					}
					var track:GodotAnimationTrack = tracks[index];
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

class GodotAnimationTrackWrapper
{
	private var track:GodotAnimationTrack;
	private var length:Float;
	private var loop:Bool;
	public function new(Track:GodotAnimationTrack, Length:Float, Loop:Bool)
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
		return newTime;
	}
	
	public var keyType(get, never):KeyType;
	function get_keyType()
	{
		return track.keyType;
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

class GodotAnimationTrack
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