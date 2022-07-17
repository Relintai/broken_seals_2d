extends Node

# Copyright (c) 2022 Péter Magyar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

export(bool) var generate_on_ready : bool = true
export(bool) var show_loading_screen : bool = true

var _player_file_name : String
var _player : Entity

# World generation

# Gets called in ready
func generate_world():
	# just spawn in the terrain world
	# make it register itself, and then call generation_finished
	pass

func generation_finished():
	# Spawn the player
	# Entity should be placed under Entities
	# Entity spawner will need to have a layer id for spawning stuff
	# Entity creates it's body and asks for the proper parent node using 
	# get_layer()
	
	if show_loading_screen and not Engine.editor_hint:
		get_node("..").hide_loading_screen()

# Layers

func get_layer_spawn_point() -> Transform2D:
	return Transform2D()
	
func get_default_layer_id() -> int:
	return 0
	
func get_layer(id : int) -> Node:
	return null

func register_layer(layer : Node, default_spawn_point : Transform2D, is_default : bool = false) -> int:
	return 0 #index / id

func unregister_layer(layer : Node) -> void:
	pass

func unregister_layer_id(id : bool) -> void:
	pass
	
func clear_layers() -> void:
	pass
	
#Character

func load_character(file_name: String) -> void:
	_player_file_name = file_name
	
	#This is where things start to break due to preceision
	#var world_pos : Vector2 = Vector2(5000000, 5000000) # In world coords: (0, 4500000), chunk coords: (9765, 9765)
	
#	var world_pos : Vector2 = Vector2(0, 0)
#	var tm : Vector2 = mesh_transform_terrain.xform(world_pos)
	
#	_player = ESS.entity_spawner.load_player(file_name, tm, 1) as Entity
#	Server.sset_seed(_player.sseed)
#	spawn(world_pos.x / (cell_size_x * chunk_size_x), world_pos.y / (cell_size_y * chunk_size_x))

func save() -> void:
	if _player == null or _player_file_name == "":
		return
	
	ESS.entity_spawner.save_player(_player, _player_file_name)
	
func _ready():
	if generate_on_ready:
		generate_world()

