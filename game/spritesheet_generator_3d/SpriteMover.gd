extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _sprite

export (bool) var enabled = true
export(int) var _animset = 0
export(int) var _animset_size = 16
export(int) var _animset_count = 16
var _min_frame = 0
var _max_frame = 16 * 16

var x = 0
var y = 0
var timer = 0
var _frame = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	_sprite = get_node(".")
	_sprite.set_frame(_min_frame)
	#_sprite.set_position(Vector2(x, y))

func set_movement_vector(vector):
	var a = Vector2(vector.x, vector.z)
	a = a.normalized()
	
	var base = Vector2(0, -1)
	
	var angle = a.angle_to(base) + PI
	
	var slice = (2*PI) / _animset_count 
	
	var num_slice = int(angle / slice)

	set_animset(num_slice)
	
func set_animset(animest_id):
	if (animest_id >= _animset_count):
		_animset = _animset_count - 1
		
	if (animest_id < 0):
		_animset = 0
		
	_animset = animest_id
	
	
	#_min_frame = _animset * _animset_size
	#_max_frame = _animset * _animset_size + _animset_size

func _process(delta):
	#set_animset(_animset)
	
	if not enabled:
		set_process(false)
		return
	
	timer += delta
	
	if (timer > 0.05):
		timer -= 0.05
		_frame += 1
		
		if _frame > _animset_size - 1:
			_frame = 0
			
		_sprite.set_frame(_frame + (_animset * _animset_size))
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func a_process(delta):
	#x += int(delta * 300)
	y += int(delta * 200)
	
	if y > 700:
		y = -50
	
	_sprite.set_position(Vector2(x, y))
