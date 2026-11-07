class_name Main extends Node2D

@onready var customerSprite: AnimatedSprite2D = $BG/Customer
@onready var chatItem: AnimatedSprite2D = $BG/ChatItem
@onready var totalText: Label = get_node("MainHUD/TotalText")
@onready var HUD: CanvasLayer = $MainHUD
@onready var customersLeft: Label = $MainHUD/CustomersText

var total = 0.00
var points:int = 0

# Items that will be on the menu
var cheesePizza = BaseItem.new()
var pepperoniPizza = BaseItem.new()
var soda = BaseItem.new()

var menu: Array[BaseItem] = [cheesePizza, pepperoniPizza, soda]

var itemArray: Array[BaseItem]
var requestArray = [""]

var random = RandomNumberGenerator.new()
var randomNum

var currentCustomer: Customer

@warning_ignore("narrowing_conversion")
var totalCustomers:int = random.randf_range(5, 20)
var totalOrders = 0
var correctOrders = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Stats.orderAccuracy = Stats.getAccuracy(float(correctOrders), float(totalOrders))
	print(cheesePizza.name)
	SaveLoad._load()
	points = SaveLoad.SaveFileData.points
	
	currentCustomer = Customer.new()
	customersLeft.text = "Customers Left: %d" % totalCustomers
	
	cheesePizza.setPrice(8)
	pepperoniPizza.setPrice(8.50)
	soda.setPrice(2.50)
	
	cheesePizza.setName("Cheese Pizza")
	pepperoniPizza.setName("Pepperoni Pizza")
	soda.setName("Soda")
	
	newCustomer()

func newCustomer():
	itemArray.clear()
	requestArray.clear()
	total = 0
	
	currentCustomer.initCustomer(menu)
	customerSprite.play(currentCustomer.customerName)
	chatItem.play(currentCustomer.orderID)
	
	randomNum = random.randi() % 2
	
	print("\n")

func round_to_dec(num,digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func addItem(itemName:String):
	if (itemArray.size() == 3): return
	
	var daItem: BaseItem
	daItem = get(itemName)
	itemArray.append(daItem)
	
	total += daItem.itemPrice
	totalText.text = "Total: $%.2f" % total
	
	HUD.updateItemsText(itemArray)

func clearItems():
	itemArray.clear()
	total = 0
	totalText.text = "Total: $%.2f" % total
	
	HUD.updateItemsText(itemArray)

func removeItem() -> void:
	if itemArray.size() == 0:
		print("Too Small")
		return
	
	total -= itemArray.back().itemPrice
	totalText.text = "Total: $%.2f" % total
	itemArray.pop_back()
	
	HUD.updateItemsText(itemArray)

func finish() -> void:
	if (itemArray.size() == 0):
		print("WHY ARE THERE NO ITEMS. TRY AGAIN")
		return
	
	var arraysAreSame:bool = true
	
	for item in requestArray:
		if !itemArray.has(item) and arraysAreSame:
			arraysAreSame = false
	
	if (arraysAreSame):
		correctOrders += 1
		points += 400 * requestArray.size()
	else:
		points -= 400 * requestArray.size()
	
	totalOrders += 1
	Stats.orderAccuracy = Stats.getAccuracy(float(correctOrders), float(totalOrders))
	totalCustomers -= 1
	customersLeft.text = "Customers Left: %d" % totalCustomers
	clearItems()
		
	if (totalCustomers > 0):
		newCustomer()
	else:
		SaveLoad.SaveFileData.points = points
		SaveLoad.SaveFileData.accArray.append(Stats.orderAccuracy)
		SaveLoad.resetAccuracy()
		SaveLoad.SaveFileData.totalOrders += totalOrders
		SaveLoad._save()
