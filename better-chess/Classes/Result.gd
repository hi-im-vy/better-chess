extends Node

class_name Result

#public variables
var Score
var ScoreGoal
var TurnCount
var TurnMax
var LoseReason

#constant code
const StalemateCode = "Stalemate"
const CheckmateCode = "Checkmate"
const TurnLimitCode = "Turn Limit"

func _init():
	Score = 0
	ScoreGoal = 0
	TurnCount = 0
	TurnMax = 0
	ResetLoseReason()
	
func SetLoseReasonToStalemate():
	LoseReason = StalemateCode
	
func SetLoseReasonToCheckmate():
	LoseReason = CheckmateCode
	
func SetLoseReasonToTurnLimit():
	LoseReason = TurnLimitCode
	
func ResetLoseReason():
	LoseReason = ""
	
func IsLoseReasonStalemate() -> bool:
	var returnBool = false
	
	if (LoseReason == StalemateCode):
		returnBool = true
		
	return returnBool
	
func IsLoseReasonCheckmate() -> bool:
	var returnBool = false
	
	if (LoseReason == CheckmateCode):
		returnBool = true
		
	return returnBool
	
func IsLoseReasonTurnLimit() -> bool:
	var returnBool = false
	
	if (LoseReason == TurnLimitCode):
		returnBool = true
		
	return returnBool
	
func IsLoseReasonBlank() -> bool:
	var returnBool = false
	
	if (LoseReason == ""):
		returnBool = true
		
	return returnBool
	
	

	
