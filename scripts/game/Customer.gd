class_name Customer extends Node

var rng = RandomNumberGenerator.new()

var customerMenu = []
var order: Array[BaseItem] = []
var orderID: String = ""
var lastOrder: String
var randomOrderNumber: int

var customerNames = ["Jonathan", "Macy", "Star"]
var customerName: String = ""

var previousName: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initCustomer(menu: Array[BaseItem]):
	if (customerName == ""):
		print("Name is Null")
	else:
		print("Adding to Previous Names Array")
		previousName = customerName
	
	if not orderID == "":
		lastOrder = orderID
	
	customerMenu = menu
	customerName = customerNames[rng.randf_range(0, customerNames.size())]
	
	while customerName == previousName:
		customerName = customerNames[rng.randf_range(0, customerNames.size())]
	
	while orderID == lastOrder:
		newOrder()
	
	print("ID: %s" % orderID)

func newOrder():
	@warning_ignore("narrowing_conversion")
	randomOrderNumber = rng.randf_range(0, 100)
	
	orderID = ""
	
	if randomOrderNumber % 4 == 3:
		orderID = str(int(rng.randf_range(0, 1)))
		order.append(customerMenu[int(orderID)])
		orderID += "2"
		order.append(customerMenu[2])
	else:
		orderID = str(randomOrderNumber % 4)
		order.append(customerMenu[int(orderID)])
