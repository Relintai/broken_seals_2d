extends Node

export (int) var _sprite_size
export (int) var _sprite_num
var _directions : int = 4

export (bool) var _show_atlas = false

export (bool) var save_texture = false

export (bool) var generate : bool = false setget set_generate, get_generate

export (String) var output_file_name : String = "res://testsave.png"

export (Array, String) var animations : Array

export (NodePath) var instant_preview_path
export (NodePath) var sprite_preview_path
export (NodePath) var viewport_path
export (NodePath) var atlas_preview_path

export (NodePath) var model_front_path
export (NodePath) var model_front_animation_player_path
export (NodePath) var model_front_animation_tree_player_path
export (NodePath) var model_side_path
export (NodePath) var model_side_animation_player_path
export (NodePath) var model_side_animation_tree_player_path


var _viewport
var _viewport_texture 
var _atlas
var _image_texture
var _atlas_texture

var _instant_preview
var _sprite_preview
var _atlas_preview

var _time = 0
var _frame = 0
var _index = 0
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

var _first = true

func _ready():
	_viewport = get_node(viewport_path)

	_instant_preview = get_node(instant_preview_path)
	_sprite_preview = get_node(sprite_preview_path)
	_atlas_preview = get_node(atlas_preview_path)
	
	var img = ImageTexture.new()
	img.flags = 0
	img.create(_sprite_size, _sprite_size, 5, 0)
	_sprite_preview.texture = img
	
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
	_texture.create(_sprite_size * _sprite_num, _sprite_size * _directions * animations.size(), false, frame.get_format())
	
	_running = true
	set_process(true)

func _process(delta):
	#todo remove, only to make development easier
	if !_viewport:
		_ready()
		
	if _first:
		_first = false
		
		setup_direction()
		
		_current_animation_player.play(animations[_current_animation_index])
		_current_animation_player.seek(0, true)
		
		return
		
	var frame = _viewport.get_texture().get_data()
	
	_sprite_preview.get_texture().set_data(frame)
	
	if not _running:
		return

	if _frame >= _sprite_num:
		_frame = 0
		_index += 1
		_direction += 1
		
		if _direction >= _directions:
			_direction = 0
			
			_current_animation_index += 1
			
		setup_direction()

		if (_index >= _directions * animations.size()):
			_running = false
			create_atlas()
			return

		_current_animation_player.play(animations[_current_animation_index])
		_current_animation_player.seek(0, true)
		return

	var ur = frame.get_used_rect()
	var xx : float = 0
	xx = (_sprite_size - ur.size.x) / 2

	_texture.blend_rect(frame, ur, Vector2((_frame * _sprite_size) + xx, (_index * _sprite_size)))
	
	_current_animation_player.seek(_frame * (_current_animation_player.current_animation_length / (_sprite_num - 1)), true)
	
	_frame += 1

#enum CharacterFacing 
#	FACING_FRONT = 0,
#	FACING_BACK = 1,
#	FACING_RIGHT = 2,
#	FACING_LEFT = 3,

func setup_direction():
	if _direction == 0:
		_current_animation_player = _model_side_animation_player
		_model_side.set_facing(2)
		_model_side.transform.x.x = -1
		
		_model_side.show()
		_model_front.hide()
	if _direction == 1:
		_current_animation_player = _model_side_animation_player
		_model_side.set_facing(3)
		_model_side.transform.x.x = 1
		
		_model_side.show()
		_model_front.hide()
	if _direction == 2:
		_current_animation_player = _model_front_animation_player
		_model_front.set_facing(0)
		
		_model_side.hide()
		_model_front.show()
	if _direction == 3:
		_current_animation_player = _model_front_animation_player
		_model_front.set_facing(1)
		
		_model_side.hide()
		_model_front.show()
		

func create_atlas():
	_image_texture = ImageTexture.new()
	_image_texture.create_from_image(_texture, 0)
	
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
