package flixel.addons.editors.godot;

import openfl.Assets;
import haxe.xml.Fast;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotScene
{

	public function new(Data: Dynamic) 
	{
		var source:Fast = null;
		
		#if (LOAD_CONFIG_REAL_TIME && !neko)
		// Load the asset located in the assets foldier, not the copies within bin folder
		if (Std.is(Data, String)) 
		{
			source = new Fast(Xml.parse(File.getContent("../../../../" + Data)));
		}
		#else
		if (Std.is(Data, String)) 
		{
			source = new Fast(Xml.parse(Assets.getText(Data)));
		}
		#end
		else if (Std.is(Data, Xml)) 
		{
			source = new Fast(Data);
		}
		else 
		{
			throw "Unknown TMX map format";
		}
		
		if (source.hasNode.resource_file == false)
		{
			throw "Not Godot format";
		}
		
		/*for (elem in )
		{
			trace(elem.name );
		}*/
		var dict = getDictionary(source.node.resource_file.node.main_resource.node.dictionary);
		1;
	}
	
	
	
	private function getDictionary(Element:Fast)
	{
		var oddEven = true;
		var name:String = null;
		var dict = new Map<String, Dynamic>();
		for (element in Element.elements)
		{
			if (oddEven)
			{
				name = getString(element);
			}
			else
			{
				dict.set(name, parseElement(element));
			}
			
			oddEven = !oddEven;
		}
		1;
		return dict;
	}
	
	private function parseElement(Element:Fast):Dynamic
	{
		switch(Element.name)
		{
			case "string_array":
				return getStringArray(Element);
			case "int":
				return Std.parseInt(Element.innerHTML);
			case "string":
				return getString(Element);
			case "array":
				return getArray(Element);
			case "real":
				return Std.parseFloat(Element.innerHTML);
			case "bool":
				return (StringTools.trim(Element.innerHTML) == "True" ? true : false);
			case "int_array":
				return getIntArray(Element);
			case "vector2":
				var _p = Element.innerHTML.split(",");
				return { x:Std.parseFloat(_p[0]), y:Std.parseFloat(_p[1]) };
			case "dictionary":
				return getDictionary(Element);
		}
		return null;
	}
	
	private function getArray(Element:Fast)
	{
		var _a = new Array<Dynamic>();
		for (Item in Element.elements)
		{
			_a.push(parseElement(Item));
		}
		return _a;
	}
	
	private function getIntArray(Element:Fast)
	{
		var _a = new Array<Int>();
		for (Item in Element.innerHTML.split(","))
		{
			_a.push(Std.parseInt(Item));
		}
		return _a;
	}
	
	
	private function getStringArray(Element:Fast)
	{
		var _a = new Array<String>();
		for (Item in Element.elements)
		{
			_a.push(getString(Item));
		}
		return _a;
	}
	
	private inline function getString(Element:Fast)
	{
		return Element.innerHTML.substring(Element.innerHTML.indexOf("\"")+1, Element.innerHTML.lastIndexOf("\""));
	}
	
}