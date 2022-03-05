tool
extends Node2D


var _player_file_name : String
var _player : Entity


func _ready():
	pass # Replace with function body.

func load_character(file_name: String) -> void:
	_player_file_name = file_name
	
	#This is where things start to break due to preceision
	#var world_pos : Vector2 = Vector2(5000000, 5000000) # In world coords: (0, 4500000), chunk coords: (9765, 9765)
	
	var world_pos : Vector2 = Vector2(0, 0)
	var tm : Vector2 = mesh_transform_terrain.xform(world_pos)
	
	_player = ESS.entity_spawner.load_player(file_name, tm, 1) as Entity
	#TODO hack, do this properly
#	_player.set_physics_process(false)
	
	Server.sset_seed(_player.sseed)

	spawn(world_pos.x / (cell_size_x * chunk_size_x), world_pos.y / (cell_size_y * chunk_size_x))
	
	#if spawn_mobs:
	#	generate()

func save() -> void:
	if _player == null or _player_file_name == "":
		return
	
	ESS.entity_spawner.save_player(_player, _player_file_name)
