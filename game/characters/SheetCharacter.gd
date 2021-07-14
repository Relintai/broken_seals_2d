extends CharacterSkeleton2D

export(NodePath) var sprite_path : NodePath

var _sprite : Sprite

func _ready():
	_sprite = get_node(sprite_path)

func get_sprite() -> Sprite:
	return _sprite


