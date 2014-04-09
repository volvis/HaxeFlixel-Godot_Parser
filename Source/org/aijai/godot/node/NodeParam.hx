package org.aijai.godot.node;

/**
 * @author Pekka Heikkinen
 */

@:enum abstract NodeParam(String) from String to String
{
	var type = "type";
	var name = "name";
	
	// Node
	var process = "process/*";
	var processPauseMode = "process/pause_mode";
	var script = "script/script";
	
	// CanvasItem
	var visibility = "visibility/*";
	var visible = "visibility/visible";
	var opacity = "visibility/opacity";
	var selfOpacity = "visibility/self_opacity";
	var behindParent = "visibility/behind_parent";
	var onTop = "visibility/on_top";
	var blendMode = "visibility/blend_mode";
	
	// Node2D
	var transformation = "transform/*";
	var position = "transform/pos";
	var scale = "transform/scale";
	var rotation = "transform/rot";
	
	// Sprite
	var texture = "texture";
	var centered = "centered";
	var offset = "offset";
	var flipH = "flip_h";
	var flipV = "flip_v";
	var vframes = "vframes";
	var hframes = "hframes";
	var frame = "frame";
	var modulate = "modulate";
	var region = "region";
	var regionRect = "region_rect";
	
}