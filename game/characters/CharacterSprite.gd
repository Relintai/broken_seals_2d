extends Sprite

enum Facing {
	FACING_RIGHT = 0,
	FACING_LEFT = 1,
	FACING_FRONT = 2,
	FACING_BACK = 3
}

enum Animations {
	ANIMATION_RUN = 0,
	ANIMATION_WALK = 1,
	ANIMATION_CAST = 2,
	ANIMATION_STAND = 3
}

export(bool) var enabled : bool = true

export(float) var timer : float = 0.13

export(int) var _animset = 0
export(int) var _animset_size = 16
export(int) var _animset_count = 16

var _min_frame = 0
var _max_frame = 16 * 16

var x = 0
var y = 0
var _timer : float  = 0
var _frame : int  = 0

var _facing : int = Facing.FACING_RIGHT
var _current_animation : int = Animations.ANIMATION_STAND

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_frame(_min_frame)
	update_animset()
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

func update_animset():
	_animset = _current_animation * 4 + (_facing)

func _process(delta):
	#set_animset(_animset)
	
	if not enabled:
		set_process(false)
		return
	
	_timer += delta
	
	if (_timer > timer):
		_timer -= timer
		_frame += 1
		
		if _frame > _animset_size - 1:
			_frame = 0
			
		set_frame(_frame + (_animset * _animset_size))
		
func set_to_move():
	if _current_animation != Animations.ANIMATION_RUN:
		_current_animation = Animations.ANIMATION_RUN
		_frame = 0
		
func set_facing(input_direction : Vector2) -> void:
	var front : bool = abs(input_direction.dot(Vector2(0, 1))) > 0.9
	
	if front:
		if input_direction.y > 0:
			_facing = Facing.FACING_FRONT
		else:
			_facing = Facing.FACING_BACK
	else:
		if input_direction.x > 0.01:
			_facing = Facing.FACING_RIGHT
		elif input_direction.x < -0.01:
			_facing = Facing.FACING_LEFT
			
	update_animset()
	
func set_to_stand():
	if _current_animation != Animations.ANIMATION_STAND:
		_current_animation = Animations.ANIMATION_STAND
		_frame = 0
		update_animset()

func set_to_cast():
	if _current_animation != Animations.ANIMATION_CAST:
		_current_animation = Animations.ANIMATION_CAST
		_frame = 0
		update_animset()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func a_process(delta):
	#x += int(delta * 300)
	y += int(delta * 200)
	
	if y > 700:
		y = -50
	
	set_position(Vector2(x, y))
