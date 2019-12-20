extends Entity

# Copyright Péter Magyar relintai@gmail.com
# MIT License, functionality from this class needs to be protable to the entity spell system

# Copyright (c) 2019 Péter Magyar

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#export (String) var map_path : String
export(float) var max_visible_distance : float = 120 setget set_max_visible_distance
var max_visible_distance_squared : float = max_visible_distance * max_visible_distance

const ray_length = 1000
const ACCEL : float = 100.0
const DEACCEL : float = 100.0
const GRAVITY : float = -24.8
const JUMP_SPEED : float = 3.8
const MAX_SLOPE_ANGLE : float = 40.0

#var process_gravity : bool = true

var _on : bool = true

var y_rot : float = 0.0

var vel : Vector3 = Vector3()
var dir : Vector3 = Vector3()
var target_movement_direction : Vector2 = Vector2()

var animation_tree : AnimationTree
var anim_node_state_machine : AnimationNodeStateMachinePlayback = null
var animation_run : bool = false

var moving : bool = false
var sleep : bool = false
var dead : bool = false
var death_timer : float = 0

func _ready() -> void:
	animation_tree = get_character_skeleton().get_animation_tree()
	
	if animation_tree != null:
		anim_node_state_machine = animation_tree["parameters/playback"]

	animation_tree["parameters/run-loop/blend_position"] = Vector2(0, -1)

	ai_state = EntityEnums.AI_STATE_PATROL

	set_process(true)
	set_physics_process(true)
	
	
func _process(delta : float) -> void:
	if dead:
		death_timer += delta
		
		if death_timer > 60:
			queue_free()
		
		return
	
	var camera : Camera = get_tree().get_root().get_camera() as Camera
	
	if camera == null:
		return
	
	var cam_pos : Vector2 = camera.global_transform.xform(Vector3())
	var dstv : Vector2 = cam_pos - position
	dstv.y = 0
	var dst : float = dstv.length_squared()

	if dst > max_visible_distance_squared:
		if visible:
			hide()
		return
	else:
		if not visible:
			show()
		
	#TODO check later if this gives a performance boost
#	var cam_facing : Vector3 = -camera.global_transform.basis.z
#	var d : float = cam_facing.dot(dstv)
#
#	if d > 0:
#		if visible:
#			hide()
#		return
#	else:
#		if not visible:
#			show()
	

func _physics_process(delta : float) -> void:
	if not _on:
		return
	
	if sentity_data == null:
		return
		
	if dead:
		return

	process_movement(delta)

func process_movement(delta : float) -> void:
#	if starget != null:
#		look_at(starget.translation, Vector3(0, 1, 0))
#
	var state : int = getc_state()
	
	if state & EntityEnums.ENTITY_STATE_TYPE_FLAG_ROOT != 0 or state & EntityEnums.ENTITY_STATE_TYPE_FLAG_STUN != 0:
		moving = false
		return
	
	if target_movement_direction.length_squared() > 0.1:
		if anim_node_state_machine != null and not animation_run:
			anim_node_state_machine.travel("run-loop")
			animation_run = true
		
		target_movement_direction = target_movement_direction.normalized()
		moving = true
	else:
		if anim_node_state_machine != null and animation_run:
			anim_node_state_machine.travel("idle-loop")
			animation_run = false
			
		moving = false
	
	if target_movement_direction.x > 0.1 or target_movement_direction.y > 0.1 or target_movement_direction.x < -0.1 or target_movement_direction.y < -0.1:
		y_rot = Vector2(0, 1).angle_to(target_movement_direction)
		
		var forward : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), deg2rad(y_rot)) 
		var right : Vector3 = forward.cross(Vector3(0, 1, 0)) * -target_movement_direction.x
		forward *= target_movement_direction.y #only potentially make it zero after getting the right vector
	
		dir = forward
		dir += right
		
		if dir.length_squared() > 0.1:
			dir = dir.normalized()
			
		moving = true
	else:
		dir = Vector3()
		moving = false
		
	if not moving and sleep:
		return
		
	if moving and sleep:
		sleep = false

	vel.y += delta * GRAVITY

	var hvel : Vector3 = vel
	hvel.y = 0

	var target : Vector3 = dir
	target *= get_speed().ccurrent

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta) as Vector3
	vel.x = hvel.x
	vel.z = hvel.z
	
	var facing : Vector3 = vel
	facing.y = 0
	
#	vel = move_and_slide(vel, Vector3(0,1,0), false, 4, deg2rad(MAX_SLOPE_ANGLE))
	sset_position(position, rotation)
	
	if vel.length_squared() < 0.12:
		sleep = true


func sstart_attack(entity : Entity) -> void:
	ai_state = EntityEnums.AI_STATE_ATTACK
	
	starget = entity
	
func _onc_mouse_enter() -> void:
	if centity_interaction_type == EntityEnums.ENITIY_INTERACTION_TYPE_LOOT:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
		
func _onc_mouse_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _son_death():
	if dead:
		return
	
	if starget == null:
		queue_free()
		return
		
	#warning-ignore:unused_variable
	for i in range(sget_aura_count()):
		sremove_aura(sget_aura(0))
	
	dead = true
	
	var ldiff : float = slevel - starget.slevel + 10.0
	
	if ldiff < 0:
		ldiff = 0
		
	if ldiff > 15:
		ldiff = 15
		
	ldiff /= 10.0
	
	starget.adds_xp(int(5.0 * slevel * ldiff))
		
	starget = null
	
	sentity_interaction_type = EntityEnums.ENITIY_INTERACTION_TYPE_LOOT
	ai_state = EntityEnums.AI_STATE_OFF
	
	anim_node_state_machine.travel("dead")
	
#	set_process(false)
	set_physics_process(false)
	
remote func rset_position(position : Vector2, rotation : float) -> void:
	if get_tree().is_network_server():
		rpc("rset_position", position, rotation)

func _son_damage_dealt(data):
	if ai_state != EntityEnums.AI_STATE_ATTACK and data.dealer != self:
		sstart_attack(data.dealer)

func _con_damage_dealt(info : SpellDamageInfo) -> void:
#	if info.dealer == 
	WorldNumbers.damage(position, 1.6, info.damage, info.crit)

func _con_heal_dealt(info : SpellHealInfo) -> void:
	WorldNumbers.heal(position, 1.6, info.heal, info.crit)

func _moved() -> void:
	if sis_casting():
		sfail_cast()
		
func set_max_visible_distance(var value : float) -> void:
	max_visible_distance_squared = value * value
	
	max_visible_distance = value

func _setup():
	sentity_name = sentity_data.text_name
	
func _son_xp_gained(value : int) -> void:
	if not Entities.get_xp_data().can_level_up(gets_level()):
		return
	
	var xpr : int = Entities.get_xp_data().get_xp(gets_level());
	
	if xpr <= sxp:
		slevelup(1)
		sxp = 0

func _son_level_up(value: int) -> void:
	if sentity_data == null:
		return
		
	var ecd : EntityClassData = sentity_data.entity_class_data
	
	if ecd == null:
		return
	
	sfree_spell_points += ecd.spell_points_per_level * value
	sfree_talent_points += value

	for i in range(Stat.MAIN_STAT_ID_COUNT):
		var st : int = sentity_data.entity_class_data.get_stat_data().get_level_stat_data().get_stat_diff(i, slevel - value, slevel)

		var statid : int = i + Stat.MAIN_STAT_ID_START
		
		var stat : Stat = get_stat_int(statid)
		
		var sm : StatModifier = stat.get_modifier(0)
		sm.base_mod += st
		
	
	var arr : Array = Array()
	
	for i in range(ecd.get_num_spells()):
		arr.append(ecd.get_spell(i))
		
	randomize()
	arr.shuffle()
	
	for v in range(value):
		for i in range(arr.size()):
			var spell : Spell = arr[i]
			
			if not hass_spell(spell):
				var spnum :int = gets_spell_count()
				
				crequest_spell_learn(spell.id)
				
				if spnum != gets_spell_count():
					break
				
			if sfree_spell_points == 0:
				break
			
			
		if sfree_spell_points == 0:
			break
	

func sset_position(pposition : Vector2, protation : float) -> void:
	if multiplayer.network_peer and multiplayer.is_network_server():
#		cset_position(position, rotation)
		vrpc("cset_position", pposition, protation)
		
remote func cset_position(pposition : Vector2, protation : float) -> void:
	position = pposition
	rotation = protation

