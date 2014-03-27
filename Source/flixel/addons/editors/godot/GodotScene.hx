package flixel.addons.editors.godot;

import flixel.addons.display.FlxNestedSprite;
import openfl.Assets;
import haxe.xml.Fast;
import haxe.io.Path;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotScene extends FlxNestedSprite
{
	/*
	 * This will replace "res://" in external resource paths
	*/
	public static var assetPath:String = "assets";
	
	public function new(Data: Dynamic, X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
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
			throw "Unknown format";
		}
		
		if (source.hasNode.resource_file == false)
		{
			throw "Not Godot format";
		}
		
		var resources = new Map<String, Map<String, Dynamic>>();
		for ( resource in source.node.resource_file.nodes.resource )
		{
			resources.set(resource.att.path, getResource(resource));
		}
		
		var external_resources = new Map<String, String>();
		for ( ext_resource in source.node.resource_file.nodes.ext_resource )
		{
			external_resources.set(ext_resource.att.path, Path.join([assetPath, ext_resource.att.path.substring(6)]));
		}
		
		var rawSource = getDictionary(source.node.resource_file.node.main_resource.node.dictionary);
		
		var nodes = new Array < Map < String, Dynamic >> ();
		
		// Build a structured array of nodes from rawSource
		var _a:Array<Int> = rawSource.get("nodes");
		while (_a.length > 0)
		{
			var node = new Map<String, Dynamic>();
			node.set("parent", _a.shift());
			node.set("owner", _a.shift());
			node.set("type", rawSource.get("names")[_a.shift()]);
			node.set("name", rawSource.get("names")[_a.shift()]);
			node.set("instance", _a.shift());
			var properties:UInt =  _a.shift();
			while (properties > 0)
			{
				node.set(rawSource.get("names")[_a.shift()], rawSource.get("variants")[_a.shift()]);
				properties = properties - 1;
			}
			var groups:UInt = _a.shift();
			var groupArr = new Array<Int>();
			while (groups > 0)
			{
				groupArr.push(_a.shift());
				groups = groups - 1;
			}
			node.set("groups", groupArr);
			nodes.push(node);
		}
		
		1;
	}
	
	private function getResource(Element:Fast)
	{
		var resource = new Map<String, Dynamic>();
		if (Element.has.type)
		{
			resource.set("type", Element.att.type);
		}
		if (Element.has.type)
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
			case "vector2_array":
				var _p = Element.innerHTML.split(",");
				var _a = new Array<Dynamic>(); // TODO: Typed!
				while (_p.length > 0)
				{
					_a.push( { x:Std.parseFloat(_p.shift()), y:Std.parseFloat(_p.shift()) } );
				}
				return _a;
			case "real_array":
				var _p = Element.innerHTML.split(",");
				var _a = new Array<Float>();
				while (_p.length > 0)
				{
					_a.push( Std.parseFloat(_p.shift()) );
				}
				return _a;
			case "node_path":
				return getStringArray(Element);
			case "resource":
				return getResource(Element);
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