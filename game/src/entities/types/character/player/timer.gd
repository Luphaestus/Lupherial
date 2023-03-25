extends Label

var startTime 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startTime = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(Time.get_unix_time_from_system()-startTime)
