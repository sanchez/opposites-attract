extends KinematicBody2D

export (float) var ACCELERATION = 512.0
export (float) var MAX_MOVE_SPEED = 180.0
export (float) var GRAVITY = 200.0
export (float) var JUMP_FORCE = 4096.0

var motion := Vector2.ZERO
var last_checkpoint := Vector2.ZERO


func get_input_force():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector *= ACCELERATION
	
	if abs(motion.x) > MAX_MOVE_SPEED:
		if sign(motion.x) == sign(input_vector.x):
			return Vector2.ZERO
	
	return input_vector


var previous_jump_force = Vector2.ZERO
func get_jump_force():
	if previous_jump_force.length_squared() > 0.1:
		previous_jump_force /= 2
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			previous_jump_force += Vector2.UP * JUMP_FORCE
	
	return previous_jump_force


func get_gravity_force():
	if not is_on_floor():
		return Vector2.DOWN * GRAVITY
	return Vector2.ZERO


func get_friction_force(force: Vector2):
	if is_on_floor():
		if force.length_squared() < 0.1:
			return Vector2(-motion.x, 0)
		var x = motion.x
		x *= -0.1
		return Vector2(x, 0)
	return Vector2.ZERO


func get_total_force():
	var forces = get_input_force()
	forces += get_friction_force(forces)
	forces += get_jump_force()
	forces += get_gravity_force()
	
	return forces


func _physics_process(delta):
	if global_position.y > 200:
		global_position = last_checkpoint
	
	var force_total = get_total_force()
	
	motion += force_total * delta
	motion = move_and_slide(motion, Vector2.UP, true)


func _on_MagCollider_area_entered(area):
	last_checkpoint = area.global_position
