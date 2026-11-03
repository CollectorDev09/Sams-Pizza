extends Node2D
@onready var scoreLabel: Label = $ScoreLabel
@onready var accuracyLabel: Label = $AccuracyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveLoad._load()
	scoreLabel.text = "Points: %d" % SaveLoad.SaveFileData.points
	accuracyLabel.text = "Accuracy: %.2f%%" % SaveLoad.SaveFileData.accuracy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _goBack() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
