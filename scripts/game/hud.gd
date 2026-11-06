extends CanvasLayer

@onready var itemLabel: Label = $Items

func updateItemsText(textArray: Array[BaseItem]) -> void:
	itemLabel.text = ""
	
	for item in textArray:
		itemLabel.text += "%s\n" % item.itemName
