package flixel.addons.editors.godot;

import openfl.Assets;
import haxe.xml.Fast;
import haxe.io.Path;

/**
 * ...
 * @author Pekka Heikkinen
 */
class GodotScene
{
	/*
	 * This will replace "res://" in external resource paths
	*/
	public static var assetPath:String = "assets";
	
	public var resources:Map < String, Map < String, Dynamic >> ;
	public var external_resources:Map < String, String >;
	public var nodes:Array < Map < String, Dynamic >>;
	
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
			throw "Unknown format";
		}
		
		if (source.hasNode.resource_file == false)
		{
			throw "Not Godot format";
		}
		
		resources = new Map<String, Map<String, Dynamic>>();
		for ( resource in source.node.resource_file.nodes.resource )
		{
			if (resource.att.type == "Animation")
			{
				new GodotAnimation(resource);
			}
			//resources.set(resource.att.path, getResource(resource));
		}
		
		external_resources = new Map<String, String>();
		for ( ext_resource in source.node.resource_file.nodes.ext_resource )
		{
			external_resources.set(ext_resource.att.path, Path.join([assetPath, ext_resource.att.path.substring(6)]));
		}
		
		var rawSource = GodotXML.getDictionary(source.node.resource_file.node.main_resource.node.dictionary);
		
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
	

	
}