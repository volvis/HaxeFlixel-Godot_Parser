package flixel.addons.editors.godot.nodes;
import flixel.addons.editors.godot.nodes.GodotNode.ParamMap;
import flixel.addons.editors.godot.properties.Behaviour;
import flixel.addons.editors.godot.GodotCommon.NodeParam;
import flixel.addons.editors.godot.GodotCommon.PauseMode;
import flixel.addons.editors.godot.GodotCommon.NodeTypes;
import flixel.addons.editors.godot.GodotCommon.BlendMode;
import flixel.addons.editors.godot.GodotCommon.XY;


/**
 * ...
 * @author Pekka Heikkinen
 */
//@:build(flixel.addons.editors.godot.GodotMacro.buildNodeParams())



class GodotNode extends GodotBasic
{

	
	/**
	 * Node properties
	 */
	public var processPauseMode(get, set):Behaviour<PauseMode>;
	function get_processPauseMode()
	{
		return mInts.exists(NodeParam.processPauseMode) ? mInts.get(NodeParam.processPauseMode) : DefaultBehaviours.integer;
	}
	function set_processPauseMode(s:Behaviour<PauseMode>):Behaviour<PauseMode>
	{
		return s;
	}
	
	public var script(get, never):Behaviour<String>;
	function get_script()
	{
		return mStrings.exists(NodeParam.script) ? mStrings.get(NodeParam.script) : DefaultBehaviours.string;
	}
	
	/**
	 * CanvasItem properties
	 */
	public var blendMode(get, never):Behaviour<BlendMode>;
	function get_blendMode()
	{
		return mInts.exists(NodeParam.blendMode) ? mInts.get(NodeParam.blendMode) : DefaultBehaviours.integer;
	}
}

