extends Node2D
@onready var itemLabel: Label = $MainHUD/Items
@onready var total_text: Label = $MainHUD/TotalText
@onready var scoreText: Label = $StatsHUD/ScoreText
@onready var requestText: Label = $MainHUD/RequestText
@onready var customersText: Label = $MainHUD/CustomersText
@onready var statsHUD: CanvasLayer = $StatsHUD
@onready var accuracyText: Label = get_node("StatsHUD/AccuracyText")
@onready var character: AnimatedSprite2D = $BG/Character
@onready var chatItem: AnimatedSprite2D = $BG/ChatItem

var total = 0.00
var points:int = 0

var items:Dictionary[String, float] = {
	"Cheese Pizza": 8.00, 
	"Pepperoni Pizza": 8.50,
	"Soda": 8.50
}

var itemArray = [""]
var requestArray = [""]

var keys = items.keys()
var values = items.values()

var random = RandomNumberGenerator.new()

var customerWants

var randomNum

var customers:int = random.randf_range(5, 20)
var totalOrders = 0
var correctOrders = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveLoad._load()
	points = SaveLoad.SaveFileData.points
	
	statsHUD.hide()
	newCustomer()
	updateText()

var lastAnim = ""
var lastOrder = ""

func newCustomer():
	var anims = ["Jonathan", "Macy", "Star"]
	
	while (character.animation.get_basename() == lastAnim):
		character.play(anims[random.randi() % anims.size()])
	
	lastAnim = character.animation.get_basename()
	print(lastAnim)
	Stats.orderAccuracy = Stats.getAccuracy(float(correctOrders), float(totalOrders))
	accuracyText.text = "Accuracy: %.2f%%" % Stats.orderAccuracy
	print(accuracyText.text)
	
	itemArray = [""]
	requestArray = [""]
	total = 0
	
	randomNum = random.randi() % 2
	
	customerWants = random.randi() % items.size()
	
	print(randomNum)
	print(keys[customerWants])
	
	lastOrder = keys[customerWants]
	
	requestArray.append(keys[customerWants])
	requestArray.pop_front()
	print("\n")
	
	updateText()

func updateText():
	if (randomNum == 1 and not keys[customerWants] == "Soda"):
		requestText.text = "Customer wants a %s and a Soda." % keys[customerWants]
		if (keys[customerWants] == "Cheese Pizza"):
			chatItem.play("CheeseSoda")
		elif (keys[customerWants] == "Pepperoni Pizza"):
			chatItem.play("PepperSoda")
		requestArray.append("Soda")
		# itemLabel.text = "%s\nSoda" % keys[customerWants]
	else:
		requestText.text = "Customer wants a %s" % keys[customerWants]
		if (keys[customerWants] == "Cheese Pizza"):
			chatItem.play("Cheese")
		elif (keys[customerWants] == "Pepperoni Pizza"):
			chatItem.play("Pepper")
		# itemLabel.text = keys[customerWants]

	total_text.text = "Total: $%.2f" % total
	scoreText.text = "Score: %d" % points
	
	customersText.text = "Customers Left: %d" % customers
	itemLabel.text = arrayItems(itemArray)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func arrayItems(array: Array) -> String:
	var string = ""
	for item in array:
		string += "%s\n" % item
	
	return string

func createTotal(array: Array) -> float:
	var price = 0
	var add = 0
	
	for i in array.size():
		if array[i] in keys:
			add = items.get(array[i])
			
		price += add
	
	return round_to_dec(price,2)

func round_to_dec(num,digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func addItem(name:String):
	if (itemArray.size() == 3): return
	
	itemArray.append(name)
	if itemArray[0] == "":
		itemArray.pop_front()
	total = createTotal(itemArray)
	updateText()
	
	itemLabel.text = arrayItems(itemArray)

func clearItems():
	itemArray = [""]
	itemLabel.text = arrayItems(itemArray)
	total = 0
	total_text.text = "Total: $%.2f" % total

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
		print("They are the same!!")
		correctOrders += 1
		points += 400 * requestArray.size()
	else:
		print("YOU WERE WRONG!!")
		points -= 400 * requestArray.size()
	
	totalOrders += 1
	
	Stats.orderAccuracy = Stats.getAccuracy(float(correctOrders), float(totalOrders))
	accuracyText.text = "Accuracy: %.2f%%" % Stats.orderAccuracy
	print(accuracyText.text)
	
	customers -= 1
	updateText()
	clearItems()
		
	if (customers > 0):
		newCustomer()
	else:
		print("Good Job! You're done!")
		SaveLoad.SaveFileData.points = points
		SaveLoad.SaveFileData.accArray.append(Stats.orderAccuracy)
		SaveLoad.resetAccuracy()
		SaveLoad.SaveFileData.totalOrders += totalOrders
		SaveLoad._save()
		statsHUD.show()
