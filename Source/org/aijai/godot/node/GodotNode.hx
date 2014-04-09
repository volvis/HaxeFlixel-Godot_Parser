package org.aijai.godot.node;
import org.aijai.godot.node.properties.Behaviour;
import org.aijai.godot.GodotCommon.PauseMode;
import org.aijai.godot.GodotCommon.NodeTypes;
import org.aijai.godot.GodotCommon.BlendMode;
import org.aijai.godot.common.XY;


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
		if (_ints == null) return DefaultBehaviours.integer;
		return _ints.exists(NodeParam.processPauseMode) ? _ints.get(NodeParam.processPauseMode) : DefaultBehaviours.integer;
	}
	function set_processPauseMode(s:Behaviour<PauseMode>):Behaviour<PauseMode>
	{
		return s;
	}
	
	public var script(get, never):Behaviour<String>;
	function get_script()
	{
		return _strings.exists(NodeParam.script) ? _strings.get(NodeParam.script) : DefaultBehaviours.string;
	}
	
	/**
	 * CanvasItem properties
	 */
	public var blendMode(get, never):Behaviour<BlendMode>;
	function get_blendMode()
	{
		return _ints.exists(NodeParam.blendMode) ? _ints.get(NodeParam.blendMode) : DefaultBehaviours.integer;
	}
}

