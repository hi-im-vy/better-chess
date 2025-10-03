extends Node2D


#start game
func _on_button_pressed() -> void:
	#start player level 0
	PlayerVariables.StartPlayerAtLevel0()
	#send to board
	Global.goto_scene("res://Scenes/main.tscn")
