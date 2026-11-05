extends CanvasLayer

@onready var orderAccuracy:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func getAccuracy(correct:float,total:float) -> float:
	var accuracy = 100 * (correct/total)
	
	return accuracy
