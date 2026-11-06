class_name Customer extends Node

var rng = RandomNumberGenerator.new()

var customerMenu = []
var order: Array[BaseItem]
var orderID: String

var customerNames = ["Jonathan", "Macy", "Star"]
var customerName: String

var previousNames: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initCustomer(menu: Array[BaseItem]):
	if (customerName == null):
		print("Name is Null")
	else:
		print("Adding to Previous Names Array")
		previousNames.append(customerName)
		
		print("Previous Names: %s" % str(previousNames))
	
	customerMenu = menu
	customerName = customerNames[rng.randf_range(0, customerNames.size())]

func newOrder():
	order = customerMenu[rng.randf_range(0, customerMenu.size())]
