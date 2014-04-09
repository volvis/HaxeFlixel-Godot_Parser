package org.aijai.godot.node;
import org.aijai.godot.node.properties.Behaviour;
import org.aijai.godot.GodotCommon;

/**
 * @author Pekka Heikkinen
 */

interface IGodotNode 
{
	var processPauseMode(get, set):Behaviour<PauseMode>; 
}