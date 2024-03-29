tool
extends Terrain2DWorldIsometric

# Copyright (c) 2019 Péter Magyar
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

export(int) var spawn_range : int = 2
export(bool) var spawn_mobs : bool = true
export(bool) var show_loading_screen : bool = true
export(bool) var generate_on_ready : bool = false
export(bool) var generate setget set_generate, get_generate
export(bool) var clear setget set_clear, get_clear

var initial_generation : bool = false

var _player_file_name : String
var _player : Entity

func _enter_tree():
	if !Engine.editor_hint && generate_on_ready:
		spawn(0, 0)
		
	RenderingServer.canvas_item_set_sort_children_by_y(get_canvas_item(), true)

func spawn(x : int, y : int):
	chunks_clear()
	
	for xx in range(x - spawn_range, x + spawn_range):
		for yy in range(y - spawn_range, y + spawn_range):
			chunk_create(xx, yy)

func set_clear(val):
	if (val):
		chunks_clear()
	
func get_clear():
	return false


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
	
	if spawn_mobs:
		generate()

func _create_chunk(x, y, chunk):
	if !chunk:
		chunk = Terrain2DChunkIsometric.new()

	if chunk.job_get_count() == 0:
		var tj : Terrain2DTerrain2DJob = Terrain2DTerrain2DJob.new()
		var lj : Terrain2DLightJob = Terrain2DLightJob.new()
		var pj : Terrain2DProp2DJob = Terrain2DProp2DJob.new()
		
		var mesher : Terrain2DMesherIsometric = Terrain2DMesherIsometric.new()
		mesher.base_light_value = 0.5
		mesher.ao_strength = 0.25
		mesher.texture_scale = 1

		tj.set_mesher(mesher)
		
		var liquid_mesher : Terrain2DMesherIsometric = Terrain2DMesherIsometric.new()
		liquid_mesher.base_light_value = 0.5
		liquid_mesher.ao_strength = 0.25
		liquid_mesher.set_channel_index_type(Terrain2DChunkDefault.DEFAULT_CHANNEL_LIQUID_TYPE)
		liquid_mesher.texture_scale = 1
		tj.set_liquid_mesher(liquid_mesher)

		pj.set_prop_mesher(Terrain2DMesherIsometric.new())

		chunk.job_add(lj)
		chunk.job_add(tj)
		chunk.job_add(pj)

	return ._create_chunk(x, y, chunk)

func generate() -> void:
	if Engine.is_editor_hint():
		return
	
#	for x in range(-2, 2):
#		for y in range(-2, 2):
#			ESS.entity_spawner.spawn_mob(1, 50, Vector2(x * 200, y * 200))
	
	for i in range(10):
		var x : float = rand_range(1, 4)
		var y : float = rand_range(1, 4)
		ESS.entity_spawner.spawn_mob(1, 50, Vector2(x * 200, y * 200))

func save() -> void:
	if _player == null or _player_file_name == "":
		return
	
	ESS.entity_spawner.save_player(_player, _player_file_name)
	
func _generation_finished():
	if show_loading_screen and not Engine.editor_hint:
		var p : Node = get_node("..")
		
		if p && p.has_method("hide_loading_screen"):
			get_node("..").hide_loading_screen()
		
#	if _player:
#		_player.set_physics_process(true)

func set_generate(val):
	if (val):
		#library.refresh_rects()
		#level_generator.setup(self, current_seed, false, library)
		spawn(0, 0)
		
func get_generate():
	return false


