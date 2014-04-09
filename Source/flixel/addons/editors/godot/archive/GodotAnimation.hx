package flixel.addons.editors.godot.archive;
import flixel.addons.editors.godot.archive.GodotAnimation.GodotBoolTrack;
import flixel.FlxObject;
import haxe.macro.Expr;
import haxe.xml.Fast;
import StringTools;
import org.aijai.godot.GodotCommon;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotAnimation
{
	
	
	public var name:String;
	var length:Float;
	var loop:Bool;
	var step:Float;
	//var tracks:Array<GodotAnimationTrackData>;
	
	public function new(Element:Fast) 
	{
		var tracks = new Array<GodotAnimationTrackData>();
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
		
		/*var GTT = new Array<GodotTypedTrack>();
		for (track in tracks)
		{
			switch (track.keyType)
			{
				case KeyType.BooleanKeys:
					new GodotBoolTrack(new GodotAnimationTrackWrapper(track, length, loop));
			}
		}*/
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
	
	public var path(get, never):String;
	function get_path():String
	{
		return track.track.path;
	}
	
	public function reset():Void
	{
		track.time = 0;
	}
	
	public function delta(Value:Float)
	{
		track.time += Value;
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
	public var track:GodotAnimationTrackData;
	public var length:Float;
	public var loop:Bool;
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
		if (newTime > length)
		{
			newTime = length;
		}
		var keyIndex = track.times.length;
		while (track.times[keyIndex] > newTime)
		{
			keyIndex--;
		}
		// Update track values
		switch (track.keyType)
		{
			case KeyType.StringKeys:
				stringValue = track.stringKeys[keyIndex];
			case KeyType.BooleanKeys:
				boolValue = track.booleanKeys[keyIndex];
			case KeyType.FloatKeys:
				if (keyIndex == track.times.length || newTime == track.times[keyIndex])
				{
					floatValue = track.floatKeys[keyIndex];
				}
				else
				{
					floatValue = ease(newTime-track.times[keyIndex], track.floatKeys[keyIndex], track.floatKeys[keyIndex + 1], track.times[keyIndex]-track.times[keyIndex + 1]);
				}
			case KeyType.IntKeys:
				if (keyIndex == track.times.length || newTime == track.times[keyIndex])
				{
					intValue = track.intKeys[keyIndex];
				}
				else
				{
					intValue = Std.int(ease(newTime-track.times[keyIndex], track.intKeys[keyIndex], track.intKeys[keyIndex + 1], track.times[keyIndex]-track.times[keyIndex + 1]));
				}
			case KeyType.VectorKeys:
				if (keyIndex == track.times.length || newTime == track.times[keyIndex])
				{
					vectorValue = track.vectorKeys[keyIndex];
				}
				else
				{
					vectorValue.x = ease(newTime-track.times[keyIndex], track.vectorKeys[keyIndex].x, track.vectorKeys[keyIndex + 1].x, track.times[keyIndex] - track.times[keyIndex + 1]);
					vectorValue.y = ease(newTime-track.times[keyIndex], track.vectorKeys[keyIndex].y, track.vectorKeys[keyIndex + 1].y, track.times[keyIndex] - track.times[keyIndex + 1]);
				}
		}
		return newTime;
	}
	
	/*macro public static function calculateEase(keyType:String, param:String = null):Expr
	{
		if (param == null)
		{
			return macro ease(newTime-track.times[keyIndex], track.$keyType[keyIndex], track.$keyType[keyIndex + 1], track.times[keyIndex]-track.times[keyIndex + 1]);
		}
		else
		{
			return macro ease(newTime-track.times[keyIndex], track.$keyType[keyIndex].$param, track.$keyType[keyIndex + 1].$param, track.times[keyIndex]-track.times[keyIndex + 1]);
		}
	}*/
	
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

/*interface AnimationController
{
	function update(Delta:Float):Void;
	function reset():Void;
}

class VisibilityController implements AnimationController
{
	var track:GodotBoolTrack;
	var target:FlxObject;
	
	public function new(Track:GodotBoolTrack, Target:FlxObject) {
		track = Track;
		target = Target;
	}
	
	public function update(Delta:Float):Void
	{
		track.delta(Delta);
		target.visible = track.value;
	}
	
	public function reset():Void
	{
		track.reset();
		update(0);
	}
}*/