tool
extends Viewport

export(bool) var enabled : bool = false setget set_enabled, get_enabled

var terrain : Node2D
var _enabled : bool

func _ready():
	terrain = $World
	
	set_enabled(enabled)

func get_enabled() -> bool:
	return _enabled

func set_enabled(val) -> void:
	_enabled = val
	
	if _enabled:
		render_target_clear_mode = Viewport.CLEAR_MODE_ALWAYS
		render_target_update_mode = Viewport.UPDATE_ALWAYS
	else:
		render_target_clear_mode = Viewport.CLEAR_MODE_NEVER
		render_target_update_mode = Viewport.UPDATE_DISABLED
