extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var _sprite_size
export (int) var _sprite_num
export (int) var _directions

export (bool) var _show_atlas = false

export (bool) var save_texture = false

export (NodePath) var _atlas_show_sprite_path
export (NodePath) var _sprite_path
export (NodePath) var _animation_player_path
export (NodePath) var _player_path
export (NodePath) var _animation_tree_player_path

var _viewport
var _viewport_texture 
var _sprite
var _animation_player
var _time = 0
var _animation_tree_player
var _frame = 0
var _rotcount = 0
var _rotation = 0
var _atlas
var _image_texture
var _running = false
var _atlas_sprite_show_node
var _atlas_texture
var _player

var _texture

# Called when the node enters the scene tree for the first time.
func _ready():
	_viewport = get_node(".")
	#_viewport.set
	_sprite = get_node(_sprite_path)
	_atlas_sprite_show_node = get_node(_atlas_show_sprite_path)
	_animation_player = get_node(_animation_player_path)
	_player = get_node(_player_path)
	_animation_tree_player = get_node(_animation_tree_player_path)
	_viewport_texture = _viewport.get_texture()
	
	_texture = Image.new()
	var frame = _viewport.get_texture().get_data()
	_texture.create(_sprite_size * _sprite_num, _sprite_size * _directions, false, frame.get_format())
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	_running = true
	
	#_generated_image = Image.new()
	#_generated_image.
	#_sprite.set_texture(_viewport_texture)
	
	
	#_frame_data.clear()
	
	#_generated_image.create_from_data(64, 64, false, Image.FORMAT_RGBA4444, texture.get_data().get_data())
	#texture = _viewport.get_texture()
	#_sprite.set_texture(texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if not _running and Input.is_key_pressed(KEY_K):
	#	_running = true
	
	if not _running:
		return
		
	#_viewport.update_worlds()
		
	var frame = _viewport.get_texture().get_data()
	
	
	#if _frame == 0 and _rotcount == 0:
	
	_texture.blend_rect(frame, frame.get_used_rect(), Vector2((_frame * _sprite_size), (_rotcount * _sprite_size)))
	
	#_time += 0.3
	#_animation_player.seek (_time , true )
	_frame += 1
	
	if _frame > _sprite_num - 1:
		_frame = 0
		
		_rotcount += 1

		if (_rotcount > _sprite_num - 1):
			_running = false
			create_atlas()
			return
		
		#var m3 = Basis()
		#m3 = m3.rotated( Vector3(0,1,0), 0.19625 )
		_player.rotate_y((PI*2)/float(_directions))
		
		_animation_player.play("default")
		#_rotation = _rotcount * 22.5
		#_player.tra
		

		#return

	#0.83
	_animation_player.seek(_frame * (_animation_player.current_animation_length / (_sprite_num - 1)), true)
	#_animation_tree_player.advance(0.05)


func create_atlas():
	_image_texture = ImageTexture.new()
	_image_texture.create_from_image(_texture, 0)
	
	_image_texture.get_data().save_png("res://testsave.png")
	
	if save_texture:
		_sprite.set_texture(_image_texture)
	
	if _show_atlas:
		_atlas_sprite_show_node.set_texture(_image_texture)
	
	pass
