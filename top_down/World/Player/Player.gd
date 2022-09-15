extends KinematicBody2D

export var MAXSPEED := 250
export var ACCELERATION := 1000
var VELOCITY := Vector2.ZERO 

func _physics_process(delta: float):
	var axis = Get_input_axis()
	if axis == Vector2.ZERO:
		Apply_friction(ACCELERATION * delta)
	else:
		Apply_movement(axis*ACCELERATION*delta, MAXSPEED)
	VELOCITY = move_and_slide(VELOCITY)
	
func Get_input_axis():
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	axis.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return axis.normalized()
	
func Apply_friction(amount):
	if VELOCITY.length() > amount:
		VELOCITY -= VELOCITY.normalized() * amount
	else:
		VELOCITY = Vector2.ZERO

func Apply_movement(acceleration, max_speed):
	VELOCITY += acceleration
	VELOCITY = VELOCITY.clamped(max_speed)
