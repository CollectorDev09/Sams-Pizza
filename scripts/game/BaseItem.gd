class_name BaseItem extends Node

@export
var itemPrice: float

@export
var itemName: String

func setName(daName: String):
	itemName = daName

func setPrice(price: float):
	itemPrice = price

func getName() -> String:
	return itemName
	
func getPrice() -> float:
	return itemPrice
