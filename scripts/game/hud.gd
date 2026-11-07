extends CanvasLayer

@onready var itemLabel: Label = $Items
@onready var keyPress: AudioStreamPlayer = $"../KeyPressSFX"
@onready var keyRelease: AudioStreamPlayer = $"../KeyReleaseSFX"

func updateItemsText(textArray: Array[BaseItem]) -> void:
	itemLabel.text = ""
	
	for item in textArray:
		itemLabel.text += "%s\n" % item.itemName

func press() -> void:
	keyPress.play()

func release() -> void:
	keyRelease.play()
