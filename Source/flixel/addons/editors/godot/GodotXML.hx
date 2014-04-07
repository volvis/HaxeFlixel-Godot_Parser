package flixel.addons.editors.godot;

import haxe.xml.Fast;
import flixel.addons.editors.godot.GodotCommon;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotXML
{

	public static function getResource(Element:Fast)
	{
		var resource = new Map<String, Dynamic>();
		if (Element.has.type)
		{
			resource.set("type", Element.att.type);
		}
		if (Element.has.path)
		{
			resource.set("path", Element.att.path);
		}
		if (Element.has.resource_type)
		{
			resource.set("resource_type", Element.att.resource_type);
		}
		for (element in Element.elements)
		{
			resource.set(element.att.name, parseElement(element));
		}
		return resource;
	}
	
	public static function getDictionary(Element:Fast)
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
		return dict;
	}
	
	public static  function parseElement(Element:Fast):Dynamic
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
			case (_ == "vector2" || _ == "real_array" || _ == "color") => true:
				var _p = Element.innerHTML.split(",");
				return [while (_p.length > 0) Std.parseFloat(_p.shift())];
				//return { x:Std.parseFloat(_p[0]), y:Std.parseFloat(_p[1]) };
			case "dictionary":
				return getDictionary(Element);
			case "vector2_array":
				var _p = Element.innerHTML.split(",");
				return [while (_p.length > 0) [Std.parseFloat(_p.shift()), Std.parseFloat(_p.shift()) ] ];
			/*case "real_array":
				var _p = Element.innerHTML.split(",");
				return [while (_p.length > 0) Std.parseFloat(_p.shift())];
			case "color":
				var _p = Element.innerHTML.split(",");
				return { a: Std.parseFloat(_p.shift()), b: Std.parseFloat(_p.shift()), g: Std.parseFloat(_p.shift()), r: Std.parseFloat(_p.shift()) };*/
			case "node_path":
				return getString(Element);
			case "resource":
				return getResource(Element);
		}
		return null;
	}
	
	public static  function getArray(Element:Fast):Array<Dynamic>
	{
		return [for (Item in Element.elements) parseElement(Item)];
	}
	
	public static  function getIntArray(Element:Fast):Array<Int>
	{
		return [for (Item in Element.innerHTML.split(",")) Std.parseInt(Item)];
	}
	
	
	public static  function getStringArray(Element:Fast):Array<String>
	{
		return [for (Item in Element.elements) getString(Item)];
	}
	
	public static  inline function getString(Element:Fast)
	{
		return Element.innerHTML.substring(Element.innerHTML.indexOf("\"")+1, Element.innerHTML.lastIndexOf("\""));
	}
	
}