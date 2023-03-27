extends Node2D

class_name Health

@export var gradual : TextureProgressBar
@export var instant : TextureProgressBar

@export var gradient : Gradient

var larger = true

var currentValue : float
var maxValue := 10
var gradualVal = .1

func _process(_delta: float) -> void:
	if larger:
		if gradual.value <= currentValue:
			gradual.value += gradualVal
		
		elif gradual.value != currentValue:
			gradual.value = currentValue	
	else:
		if gradual.value >= currentValue:
			gradual.value -= gradualVal
		
		elif gradual.value != currentValue:
			gradual.value = currentValue	

func change_value(value):
	
	instant.value = value
	larger =  value > currentValue  
	currentValue = value
	instant.tint_progress = gradient.sample(currentValue/maxValue)
	
	
	

func _ready() -> void:

	visible = false

func start(max_health:int, current_level, gradual_decline):
	visible = true
	maxValue = max_health
	gradualVal = gradual_decline
	gradual.max_value = maxValue
	instant.max_value = maxValue
	currentValue = current_level
	gradual.value = currentValue
	instant.value = currentValue
	
	instant.tint_progress = gradient.sample(currentValue)
	
