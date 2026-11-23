extends TextureButton
@onready var pauseHUD: CanvasLayer = $"../../PauseHUD"
@onready var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func pressed() -> void:
	paused = !paused
	
	if (paused):
		pauseHUD.show()
	else:
		pauseHUD.hide()


func _on_resume_pressed() -> void:
	paused = false
	pauseHUD.hide()
