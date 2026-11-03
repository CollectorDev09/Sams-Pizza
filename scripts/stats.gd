extends CanvasLayer

@onready var orderAccuracy:float = 0
@onready var accuracyText: Label = $AccuracyText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func getAccuracy(correct:float,total:float) -> float:
	var accuracy = 100 * (correct/total)
	
	return accuracy
