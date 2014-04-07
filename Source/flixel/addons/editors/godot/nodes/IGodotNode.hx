package flixel.addons.editors.godot.nodes;
import flixel.addons.editors.godot.properties.Behaviour;
import flixel.addons.editors.godot.GodotCommon;

/**
 * @author Pekka Heikkinen
 */

interface IGodotNode 
{
	var processPauseMode(get, set):Behaviour<PauseMode>; 
}