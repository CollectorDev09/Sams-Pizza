extends CanvasLayer

@onready var accuracyText: Label = $AccuracyText
@onready var scoreText: Label = $ScoreText

func getAccuracy(correct:float,total:float) -> float:
	var accuracy = 100 * (correct/total)
	
	return accuracy

func complete(points: int, totalOrders: int, accuracy: float):
	show()
	SaveLoad.SaveFileData.points = points
	SaveLoad.SaveFileData.accArray.append(accuracy)
	SaveLoad.resetAccuracy()
	SaveLoad.SaveFileData.totalOrders += totalOrders
	SaveLoad._save()
	
	scoreText.text = "Points: %d" % points
	accuracyText.text = "Accuracy: %.2f" % accuracy
