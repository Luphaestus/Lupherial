extends Entity

class_name character

var animationTree : AnimationTree
var idleAnim
var walkAnim

var animationPlayer : AnimationPlayer
var hurtAnim

var lastDirection := Vector2(0, 1)

func _ready():
	super._ready()
	
	$CharacterBody2D.position = Vector2(
		DATA["general_propoties"]["posx"],
		DATA["general_propoties"]["posy"]	
	)

func _process(delta):
	super._process(delta)

	var direction = Vector2(movement.call())

	if direction != Vector2.ZERO: lastDirection = direction
	if animationTree:		
		if idleAnim:
			animationTree.set(idleAnim, lastDirection)
			if direction == Vector2.ZERO: animationTree.get("parameters/playback").travel("idle")
		if walkAnim: 
			animationTree.set(walkAnim, lastDirection)
			if direction != Vector2.ZERO: animationTree.get("parameters/playback").travel("walk")
	#$CharacterBody2D.velocity = direction
	$CharacterBody2D.move_and_collide(direction)
	var positionTemp = $CharacterBody2D.position

	DATA["general_propoties"]["posx"] = positionTemp.x
	DATA["general_propoties"]["posy"] = positionTemp.y
#empty function#
var movement = func () -> Vector2: return Vector2(0, 0)
var get_damage = func() -> float: return 0

func apply_damage(damage):
	DATA["character"]["health"] -= damage
	if DATA["character"]["health"] <= 0: queue_free()
	if animationPlayer and hurtAnim:
		animationPlayer.stop()
		animationPlayer.play(hurtAnim)
