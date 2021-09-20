extends Node

export (int) var _sprite_size
export (int) var _sprite_num
var _directions : int = 4

export (bool) var _show_atlas = false

export (bool) var save_texture = false

export (bool) var generate : bool = false setget set_generate, get_generate

export (String) var output_file_name : String = "res://testsave.png"

export (Array, String) var animations : Array
export (Array, NodePath) var z_index_paths : Array

export (NodePath) var wp2_sprite3d_path

export (NodePath) var instant_preview_path
export (NodePath) var sprite_preview_path
export (NodePath) var viewport_path
export (NodePath) var viewport2_path
export (NodePath) var atlas_preview_path

export (NodePath) var model_front_path
export (NodePath) var model_front_animation_player_path
export (NodePath) var model_front_animation_tree_player_path
export (NodePath) var model_side_path
export (NodePath) var model_side_animation_player_path
export (NodePath) var model_side_animation_tree_player_path

export(int) var cast_animation_index : int = 0
export(PackedScene) var cast_animation_scene : PackedScene = null
export (Array, NodePath) var cast_animation_paths : Array
var cast_animations : Array

var _wp2_sprite3d

var _viewport
var _viewport_texture
var _viewport2
var _viewport2_texture 
var _atlas
var _image_texture
var _atlas_texture

var _instant_preview
var _sprite_preview
var _atlas_preview

var _time = 0
var _frame = 0
var _index = 0
var _frame_atlas = 0
var _index_atlas = 0
var _direction = 0
var _current_animation_index = 0
var _current_animation_player = null

var _running = false

var _model_front
var _model_front_animation_player
var _model_front_animation_tree_player
var _model_side
var _model_side_animation_player
var _model_side_animation_tree_player

var _texture
var _texture2

var _first = true
var _first_frame = true

func _ready():
	_viewport = get_node(viewport_path)
	_viewport2 = get_node(viewport2_path)
	_wp2_sprite3d = get_node(wp2_sprite3d_path)

	_instant_preview = get_node(instant_preview_path)
	_sprite_preview = get_node(sprite_preview_path)
	_atlas_preview = get_node(atlas_preview_path)
	
	var img = ImageTexture.new()
	img.flags = 0
	img.create(_sprite_size, _sprite_size, 5, 0)
	_sprite_preview.texture = img
	
	var img2 = ImageTexture.new()
	img2.flags = 0
	img2.create(64, 64, 5, 0)
	_wp2_sprite3d.texture = img2
	
	_model_front = get_node(model_front_path)
	_model_front_animation_player = get_node(model_front_animation_player_path)
	_model_front_animation_tree_player = get_node(model_front_animation_tree_player_path)
	
	if _model_side_animation_tree_player:
		_model_front_animation_tree_player.active = false
	
	_model_side = get_node(model_side_path)
	_model_side_animation_player = get_node(model_side_animation_player_path)
	_model_side_animation_tree_player = get_node(model_side_animation_tree_player_path)
	
	if _model_side_animation_tree_player:
		_model_side_animation_tree_player.active = false
	
	_model_front.hide()
	_model_side.show()

	_viewport_texture = _viewport.get_texture()
	
	_texture = Image.new()
	var frame = _viewport.get_texture().get_data()
	_texture.create(64, 64, false, frame.get_format())
	
	_texture2 = Image.new()
	var frame2 = _viewport2.get_texture().get_data()
	_texture2.create(_sprite_size * _sprite_num, _sprite_size * _directions * animations.size(), false, frame2.get_format())
	
	
	_running = true
	set_process(true)

func _process(delta):
	if not _running:
		return

	#todo remove, only to make development easier
	if !_viewport || !_viewport2:
		_ready()
		
	if _first:
		_first = false
		
		setup_direction()
		setup_animation()
		
		return
		
	var frame = _viewport.get_texture().get_data()
	
	_wp2_sprite3d.get_texture().set_data(frame)
	
	if _first_frame:
		_first_frame = false
		#we need to let the second step render the first image from the prev step
		return
		
	var frame2 = _viewport2.get_texture().get_data()
		
	var ur = frame2.get_used_rect()
	var xx : float = 0
	xx = (_sprite_size - ur.size.x) / 2
	_texture2.blend_rect(frame2, ur, Vector2((_frame_atlas * _sprite_size) + xx, (_index_atlas * _sprite_size)))
	_current_animation_player.seek(_frame_atlas * (_current_animation_player.current_animation_length / (_sprite_num)), true)
	
	if (_index >= _directions * animations.size()):
		_running = false
		create_atlas()
		return
		
	_frame_atlas = _frame
	_index_atlas = _index

	_sprite_preview.get_texture().set_data(frame2)
	
	if _frame >= _sprite_num:
		_frame = 0
		_index += 1
		_direction += 1
		
		if _direction >= _directions:
			_direction = 0
			
			_current_animation_index += 1
			
		setup_direction()

		if (_index >= _directions * animations.size()):
#			_running = false
#			create_atlas()
			return
		
		setup_animation()

		return

	_frame += 1

func setup_animation():
	_current_animation_player.play(animations[_current_animation_index])
	_current_animation_player.seek(0, true)
	
	if !cast_animation_scene:
		return
	
	if _current_animation_index == cast_animation_index:
		for cap in cast_animation_paths:
			var n = get_node(cap)
			
			if !n:
				continue
				
			var pa = cast_animation_scene.instance()
			
			cast_animations.push_back(pa)
			
			n.add_child(pa)
	else:
		for n in cast_animations:
			n.queue_free()
			
		cast_animations.clear()

#enum CharacterFacing 
#	FACING_FRONT = 0,
#	FACING_BACK = 1,
#	FACING_RIGHT = 2,
#	FACING_LEFT = 3,

func setup_direction():
	for a in cast_animations:
			if a.has_method("get_z_index"):
				a.z_index = 0
	
	if _direction == 0:
		_current_animation_player = _model_side_animation_player
		_model_side.set_facing(2)
		_model_side.transform.x.x = -1

		_model_side.show()
		_model_front.hide()
		
		for np in z_index_paths:
			get_node(np).z_index = 0
	if _direction == 1:
		_current_animation_player = _model_side_animation_player
		_model_side.set_facing(3)
		_model_side.transform.x.x = 1

		_model_side.show()
		_model_front.hide()
		
		for np in z_index_paths:
			get_node(np).z_index = 0
	if _direction == 2:
		_current_animation_player = _model_front_animation_player
		_model_front.set_facing(0)
		
		_model_side.hide()
		_model_front.show()
		
		for np in z_index_paths:
			get_node(np).z_index = 0
	if _direction == 3:
		_current_animation_player = _model_front_animation_player
		_model_front.set_facing(1)
		
		_model_side.hide()
		_model_front.show()
		
		for np in z_index_paths:
			get_node(np).z_index = -1
			
		for a in cast_animations:
			if a.has_method("get_z_index"):
				a.z_index = -1
		

func create_atlas():
	_image_texture = ImageTexture.new()
	_image_texture.create_from_image(_texture2, 0)
	
	_image_texture.get_data().save_png(output_file_name)
	
	if save_texture:
		_sprite_preview.set_texture(_image_texture)
	
	if _show_atlas:
		_atlas_preview.set_texture(_image_texture)
	

func set_generate(v : bool) -> void:
	if !v:
		return
		
	#for easier development
	_ready()
	_running = true
	#set_process(true)

func get_generate() -> bool:
	return false
