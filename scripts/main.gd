class_name Main extends Node2D

@onready var character: AnimatedSprite2D = $BG/Customer
@onready var chatItem: AnimatedSprite2D = $BG/ChatItem

var total = 0.00
var points:int = 0

# Items that will be on the menu
var cheesePizza = CheesePizza.new()
var pepperoniPizza = PepperoniPizza.new()
var soda = Soda.new()

var menu = [cheesePizza, pepperoniPizza, soda]

var itemArray = [""]
var requestArray = [""]

var random = RandomNumberGenerator.new()

var currentCustomer: Customer = Customer.new()
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
	currentCustomer.initCustomer(menu)
	print(cheesePizza.name)
	SaveLoad._load()
	points = SaveLoad.SaveFileData.points
	
	newCustomer()
	updateText()

var lastAnim = ""
var lastOrder = ""

func newCustomer():
	itemArray = [""]
	requestArray = [""]
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


func arrayItems(array: Array) -> String:
	var string = ""
	for item in array:
		string += "%s\n" % item
	
	return string

func createTotal(array: Array) -> float:
	print(array)
	var price = 0
	var add = 0
	
	for i in array.size():
		if array[i] in menu:
			add = menu[i].price
			
		price += add
	
	return round_to_dec(price,2)

func round_to_dec(num,digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func addItem(itemName:String):
	if (itemArray.size() == 3): return
	
	itemArray.append(itemName)
	if itemArray[0] == "":
		itemArray.pop_front()
	total = createTotal(itemArray)
	updateText()
	
	# itemLabel.text = arrayItems(itemArray)

func clearItems():
	itemArray = [""]
	# itemLabel.text = arrayItems(itemArray)
	total = 0
	hudManager.updateOrderText(total)

func addSoda() -> void:
	addItem("Soda")

func addPepperoni() -> void:
	addItem("Pepperoni Pizza")

func addCheese() -> void:
	addItem("Cheese Pizza")

func removeItem() -> void:
	itemArray.pop_back()
	print(itemArray)
	total = createTotal(itemArray)
	updateText()


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
