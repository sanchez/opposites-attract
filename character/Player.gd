extends KinematicBody2D

const NegativeIcon := preload("res://components/magnet/negative.png")
const PositiveIcon := preload("res://components/magnet/positive.png")

export (float) var ACCELERATION = 128.0
export (float) var MAX_MOVE_SPEED = 180.0
export (float) var GRAVITY = 200.0
export (float) var JUMP_FORCE = 384.0

var motion := Vector2.ZERO
var last_checkpoint := Vector2.ZERO
onready var MaggedNode := $Magged

onready var RayLeft := $RayLeft
onready var RayRight := $RayRight
onready var RayMid := $RayMid
onready var ChargeIcon := $ChargeIcon


func set_charge():
	ChargeIcon.texture = null
	MaggedNode.CHARGE = Charge.CHARGE_TYPE.NO_CHARGE
	
	if Input.is_action_pressed("charge_negative") and Input.is_action_pressed("charge_positive"):
		return
	
	if Input.is_action_pressed("charge_negative"):
		ChargeIcon.texture = NegativeIcon
		MaggedNode.CHARGE = Charge.CHARGE_TYPE.NEGATIVE_CHARGE
		
	if Input.is_action_pressed("charge_positive"):
		ChargeIcon.texture = PositiveIcon
		MaggedNode.CHARGE = Charge.CHARGE_TYPE.POSITIVE_CHARGE


func get_input_force():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector *= ACCELERATION
	
#	if abs(motion.x) > MAX_MOVE_SPEED:
#		if sign(motion.x) == sign(input_vector.x):
#			return Vector2.ZERO
	
	return input_vector


func on_floor():
	if is_on_floor():
		return true
		
	if RayLeft.is_colliding() or RayRight.is_colliding() or RayMid.is_colliding():
		return true
		
	return false


var previous_jump_force = Vector2.ZERO
func get_jump_force():
	if not on_floor():
		previous_jump_force *= 0.99
		
	else:
		previous_jump_force = Vector2.ZERO
		if Input.is_action_just_pressed("ui_accept"):
			previous_jump_force += Vector2.UP * JUMP_FORCE
	
	return previous_jump_force


func get_gravity_force():
	if not on_floor():
		return Vector2.DOWN * GRAVITY
	return Vector2.ZERO


func get_friction_force(force: Vector2):
	if on_floor():
		if force.length_squared() < 1.5:
			return Vector2(-motion.x, 0)
		var x = motion.x
		x *= -0.1
		return Vector2(x, 0)
	return Vector2.ZERO


func get_mag_forces():
	var force_total = Vector2.ZERO
	var current_charge = MaggedNode.CHARGE
	
	for x in MaggedNode.get_overlapping_areas():
		if x is Charge:
			var dir = global_position - x.global_position
			var dist = dir.length_squared()
			var power = clamp(40_000_000 / dist, 0, 50_000) * x.STRENGTH
			var charge_type = x.CHARGE
			var charge_power = power * charge_type * current_charge
			var force = (dir / dist) * charge_power
			force_total += force
			
	return force_total


func get_total_force():
	var forces = get_input_force()
	forces += get_friction_force(forces)
	forces += get_jump_force()
	forces += get_gravity_force()
	forces += get_mag_forces()
	
	return forces


func _physics_process(delta):
	if global_position.y > 200:
		global_position = last_checkpoint
		motion = Vector2.ZERO
		
	set_charge()
	
	var force_total = get_total_force()
	
	motion = force_total
	motion = move_and_slide(motion, Vector2.UP, true, 4, 0.785398, true)


func _on_MagCollider_area_entered(area):
	last_checkpoint = area.global_position
	area.queue_free()
