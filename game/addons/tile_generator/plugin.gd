tool
extends EditorPlugin

var SimpleTile = preload("res://addons/tile_generator/smple_tile.gd")
var ShearTile = preload("res://addons/tile_generator/shear_tile.gd")

func _enter_tree():
	add_custom_type("SimpleTile", "Resource", SimpleTile, null)
	add_custom_type("ShearTile", "Resource", ShearTile, null)

func _exit_tree():
	remove_custom_type("SimpleTile")
	remove_custom_type("ShearTile")
