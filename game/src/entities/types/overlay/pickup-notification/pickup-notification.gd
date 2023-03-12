extends Entity

@export var notification_scene : String

var current_notifications = []
var slideAnimQueue = []
var RemoveSlideAnimQueue = []

func slideInAnim():
	var finalPos = 8
	for scene in slideAnimQueue:
		if scene.offset.x <=finalPos:
			scene.offset.x += 5
		else:
			scene.offset.x = finalPos
			slideAnimQueue.erase(scene)
func slideOutAnim():
	for scene in RemoveSlideAnimQueue:
		if scene.offset.x+scene.size.x >=0:
			scene.offset.x -= 5
		else:
			remove_child(RemoveSlideAnimQueue[RemoveSlideAnimQueue.find(scene)])
			RemoveSlideAnimQueue.erase(scene)

var slideDownAnimFinished = -1
func slideDownAnim():
	
	if slideDownAnimFinished != 1:
		slideDownAnimFinished += 1
		if not slideDownAnimFinished:
			for scene in range(len(current_notifications)):
				if current_notifications[scene][0].offset.y <= (current_notifications[scene][0].size.y+5)*(len(current_notifications)-1-current_notifications.find(current_notifications[scene])):
					current_notifications[scene][0].offset.y += 3
					slideDownAnimFinished = -1
				else:
					current_notifications[scene][0].offset.y = (current_notifications[scene][0].size.y+5)*(len(current_notifications)-1-current_notifications.find(current_notifications[scene]))
					current_notifications[scene][0].offset.y += 5


func new_notif(text):
	var is_duplicate = false

	for dupe in current_notifications:
		if text == dupe[0].label.text.substr(0, dupe[0].label.text.rfind(" x ")): is_duplicate = dupe

	if is_duplicate:
		is_duplicate[0].label.text = text + " x " + str(int(is_duplicate[0].label.text.substr(is_duplicate[0].label.text.rfind(" x ")+3, -1))+1)
		is_duplicate[1].start()
	else:
		text += " x 1"

		slideDownAnimFinished = -1
		var scene = load(notification_scene).instantiate()
		scene.label.text = text

		add_child(scene)
		scene.offset.x = -scene.size.x-2
		
		slideAnimQueue.append(scene)
		
		var timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", remove_notif)
		timer.set_wait_time(3)
		timer.start()
		current_notifications.append([scene, timer])
		
func remove_notif():
	current_notifications[0][1].stop()
	remove_child(current_notifications[0][1])
	RemoveSlideAnimQueue.append(current_notifications[0][0])

	current_notifications.remove_at(0)
	
func _ready() -> void:
	super._ready()
	add_to_group("notification")

func _process(delta: float) -> void:
	super._process(delta)
	slideInAnim()
	slideOutAnim()
	slideDownAnim()
