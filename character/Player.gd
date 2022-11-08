extends KinematicBody2D

export (float) var ACCELERATION = 512.0
export (float) var MAX_MOVE_SPEED = 90.0
export (float) var GRAVITY = 200.0
export (float) var JUMP_FORCE = 128.0
export (float) var FRICTION = 0.25

var motion := Vector2.ZERO


func get_input():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector
	

func apply_movement(input_vector: Vector2, delta: float):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_MOVE_SPEED, MAX_MOVE_SPEED)

	
func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			motion.y = -JUMP_FORCE
			
	else:
		if Input.is_action_just_released("ui_accept") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE / 2
			

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func apply_friction(input_vector):
	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION)


func _physics_process(delta):
	var input_vector = get_input()
	apply_movement(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	
	motion = move_and_slide(motion, Vector2.UP, true)
