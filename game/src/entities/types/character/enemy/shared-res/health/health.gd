extends Node2D

class_name Health

@export var gradual : TextureProgressBar
@export var instant : TextureProgressBar

@export var colourGradient : GradientTexture1D
var gradient : Gradient
var numberOfpoints


var currentValue : float
var maxValue = 10


func _process(_delta: float) -> void:
	if gradual.value >= currentValue:
		gradual.value -= .05
	elif gradual.value != currentValue:
		gradual.value = currentValue	

func change_value(value):
	if currentValue > value:
		instant.value = value
		
	print(round(numberOfpoints * (currentValue / maxValue)))
	print(numberOfpoints)
	print()
	instant.tint_progress = gradient.sample(currentValue)
	currentValue = value
	
	

func _ready() -> void:

	visible = false

func start(max_health:int, current_level):
	visible = true
	var maxValue = max_health
	gradual.max_value = maxValue
	instant.max_value = maxValue
	currentValue = current_level
	gradual.value = currentValue
	instant.value = currentValue
	
	colourGradient.width = max_health
	gradient = colourGradient.gradient
	numberOfpoints = gradient.get_point_count()
	instant.tint_progress = gradient.sample(currentValue)
