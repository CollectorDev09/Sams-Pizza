class_name Main extends Node2D

@onready var character: AnimatedSprite2D = $BG/Customer
@onready var chatItem: AnimatedSprite2D = $BG/ChatItem
@onready var totalText: Label = get_node("MainHUD/TotalText")

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

var currentCustomer: Customer
var customerWants

var randomNum

@onready var hudManager = preload("res://scripts/game/HudManager.gd").new()

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
	currentCustomer.initCustomer(menu)
	
	cheesePizza.setPrice(8)
	pepperoniPizza.setPrice(8.50)
	soda.setPrice(2.50)
	
	cheesePizza.setName("Cheese Pizza")
	pepperoniPizza.setName("Pepperoni Pizza")
	soda.setName("Soda")
	
	newCustomer()
	updateText()

var lastAnim = ""
var lastOrder = ""

func newCustomer():
	itemArray.clear()
	requestArray.clear()
	total = 0
	
	randomNum = random.randi() % 2
	
	customerWants = random.randi() % menu.size()
	
	print("\n")
	
	#updateText()

func updateText():
	hudManager.initHUD()
	#if (randomNum == 1 and not keys[customerWants] == "Soda"):
		#requestText.text = "Customer wants a %s and a Soda." % keys[customerWants]
		#if (keys[customerWants] == "Cheese Pizza"):
			#chatItem.play("CheeseSoda")
		#elif (keys[customerWants] == "Pepperoni Pizza"):
			#chatItem.play("PepperSoda")
		#requestArray.append("Soda")
		 #itemLabel.text = "%s\nSoda" % keys[customerWants]
	#else:
		#requestText.text = "Customer wants a %s" % keys[customerWants]
		#if (keys[customerWants] == "Cheese Pizza"):
			#chatItem.play("Cheese")
		#elif (keys[customerWants] == "Pepperoni Pizza"):
			#chatItem.play("Pepper")
		## itemLabel.text = keys[customerWants]
#
	#total_text.text = "Total: $%.2f" % total
	#scoreText.text = "Score: %d" % points
	#
	#customersText.text = "Customers Left: %d" % customers
	#itemLabel.text = arrayItems(itemArray)

func round_to_dec(num,digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func addItem(itemName:String):
	if (itemArray.size() == 3): return
	
	print(itemName)
	
	var daItem: BaseItem
	daItem = get(itemName)
	
	itemArray.append(daItem)
	
	total += daItem.itemPrice
	
	totalText.text = "Total: $%.2f" % total
	
	# itemLabel.text = arrayItems(itemArray)

func clearItems():
	itemArray.clear()
	# itemLabel.text = arrayItems(itemArray)
	total = 0
	totalText.text = "Total: $%.2f" % total

func removeItem() -> void:
	if itemArray.size() == 0:
		print("Too Small")
		return
	
	total -= itemArray.back().itemPrice
	
	itemArray.pop_back()
	
	totalText.text = "Total: $%.2f" % total


func finish() -> void:
	print(requestArray)
	print(itemArray)
	
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
	updateText()
	clearItems()
		
	if (totalCustomers > 0):
		newCustomer()
	else:
		SaveLoad.SaveFileData.points = points
		SaveLoad.SaveFileData.accArray.append(Stats.orderAccuracy)
		SaveLoad.resetAccuracy()
		SaveLoad.SaveFileData.totalOrders += totalOrders
		SaveLoad._save()
		hudManager.endScreen()
