extends Label

var startTime = -1 
var root 
# Called when the node enters the scene tree for the first time.
func set_time(time, root_s):
	root = root_s
	if int(time) == -1: 
		startTime = Time.get_unix_time_from_system()
	else:
		startTime =  Time.get_unix_time_from_system() - int(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if startTime != -1:
		text = str(Time.get_unix_time_from_system()-startTime)
		root.DATA["time"] = str(Time.get_unix_time_from_system()-startTime)
