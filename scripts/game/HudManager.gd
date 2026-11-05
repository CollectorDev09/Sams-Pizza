class_name HUD extends Node

@onready var itemLabel: Label = $MainHUD/Items
@onready var total_text: Label = $MainHUD/TotalText
@onready var scoreText: Label = $StatsHUD/ScoreText
@onready var requestText: Label = $MainHUD/RequestText
@onready var customersText: Label = $MainHUD/CustomersText
@onready var statsHUD: CanvasLayer = get_node("StatsHUD")
@onready var accuracyText: Label = get_node("StatsHUD/AccuracyText")

func initHUD():
	pass

func updateText():
	print("Updating text")

func updateOrderText(total: float):
	# total_text.text = "Total: $%.2f" % total
	pass

func hideHUD():
	statsHUD.hide()

func endScreen():
	accuracyText.text = "Accuracy: %.2f%%" % Stats.orderAccuracy
	statsHUD.show()
