extends Node2D

#node references
@onready var ScoreCounter = $"CanvasLayer/ScoreTitle/ScoreCounter"
@onready var TurnCounter = $"CanvasLayer/TurnTitle/TurnCounter"
@onready var GoldCounter = $"CanvasLayer/GoldCounter"

func _ready() -> void:
	ScoreCounter.text = str(PlayerVariables.LastRoundResult.Score) + "/" + str(PlayerVariables.LastRoundResult.ScoreGoal)
	TurnCounter.text = str(PlayerVariables.LastRoundResult.TurnCount) + "/" + str(PlayerVariables.LastRoundResult.TurnMax)
	CalculateAndDisplayGoldGain()
	
func CalculateAndDisplayGoldGain():
	var resultString = ""
	var totalGold = 0
	
	#base gold
	totalGold = totalGold + PlayerVariables.BaseGoldGain
	resultString += "Base Gold Gain: " + str(PlayerVariables.BaseGoldGain) + "\n"
	
	#gold from early round end
	var turnDiff = PlayerVariables.LastRoundResult.TurnMax - PlayerVariables.LastRoundResult.TurnCount
	var turnGoldGain = turnDiff
	if (turnGoldGain > PlayerVariables.MaxGoldGainFromTurns):
		turnGoldGain = PlayerVariables.MaxGoldGainFromTurns
	totalGold += + turnGoldGain
	resultString += "Gold Gained From Early Win (Max " + str(PlayerVariables.MaxGoldGainFromTurns) + "): " + str(turnGoldGain) + "\n"
	
	#check if hit max gold
	if (totalGold > PlayerVariables.MaxGoldGainPerRound):
		totalGold = PlayerVariables.MaxGoldGainPerRound
	
	#add to player current gold
	PlayerVariables.CurrentGold += totalGold
	
	#display total	
	resultString += "TOTAL GOLD (Max " + str(PlayerVariables.MaxGoldGainPerRound) + "): " + str(totalGold)
	
	GoldCounter.text = resultString	
