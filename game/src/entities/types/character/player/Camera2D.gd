extends Camera2D

var center = Vector2()
var damping = 12.0

func _physics_process(delta):
	apply_camera(delta)

func apply_camera(delta):
	var mpos = get_global_mouse_position()
	var ppos = global_position
	center = Vector2((ppos.x + mpos.x) / 2, (ppos.y + mpos.y) / 2)
	position = lerp(position, center, delta * damping)
