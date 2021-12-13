tool
extends EditorPlugin

var SimpleTile = preload("res://addons/tile_generator/smple_tile.gd")

func _enter_tree():
	add_custom_type("SimpleTile", "Resource", SimpleTile, null)

func _exit_tree():
	remove_custom_type("SimpleTile")
