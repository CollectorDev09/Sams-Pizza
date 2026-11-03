extends Node

const save_location = "user://SaveData.tres"

var SaveFileData: SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	_load()

func _save():
	ResourceSaver.save(SaveFileData, save_location)

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)

func resetAccuracy():
	var total: float = 0
	
	for acc in SaveFileData.accArray:
		total += acc
	
	SaveFileData.accuracy = total / SaveFileData.accArray.size()
