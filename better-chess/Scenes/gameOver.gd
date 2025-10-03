extends Node2D

#node reference
@onready var Reason = $"CanvasLayer/Reason"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#set lose reason
	if (PlayerVariables.LastRoundResult.IsLoseReasonStalemate()):
		Reason.text = "You lost by stalemate (you weren't in check, but you had no legal moves left.)"
	elif (PlayerVariables.LastRoundResult.IsLoseReasonCheckmate()):
		Reason.text = "You lost by checkmate (you were in check and had no legal way to get out of it.)"
	elif (PlayerVariables.LastRoundResult.IsLoseReasonTurnLimit()):
		Reason.text = "You lost by turn limit (you must get " + str(PlayerVariables.LastRoundResult.ScoreGoal) + " points in " + str(PlayerVariables.LastRoundResult.TurnMax) + " turns.)"
	else:
		Reason.text = "How did you get here?? eh just try again"

#try again - set player to level 0 and move to main
func _on_try_again_pressed() -> void:
	#start player level 0
	PlayerVariables.StartPlayerAtLevel0()
	#send to board
	Global.goto_scene("res://Scenes/main.tscn")
