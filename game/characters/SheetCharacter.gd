extends CharacterSkeleton2D

export(NodePath) var sprite_path : NodePath

var _sprite : Sprite
var _standing = true

func _ready():
	_sprite = get_node(sprite_path)

func get_sprite() -> Sprite:
	return _sprite

func move_dir(input_dir):
	if _standing:
		_standing = false
		_sprite.set_to_move()
		
	_sprite.set_facing(input_dir)
	
func stand():
	if _standing:
		return
		
	_standing = true
	
	_sprite.set_to_stand()
