extends Node

#current level of the game
var CurrentLevel

#how much gold the player has on them currently
var CurrentGold

#current player army
var CurrentArmy

#current player passives
var CurrentPassives

#current player items
var CurrentInventory

#needed classes
const Piece = preload("res://Classes/Piece.gd")

func StartPlayerAtLevel0():
	CurrentLevel = 0
	CurrentGold = 0
	
	#build starting army
	CurrentArmy = {}
	
	#make a queen
	var queenStart = Vector2(3,0)
	var queenPiece = Piece.new()
	queenPiece.MakeWhiteQueen()
	queenPiece.StartingLocation = queenStart;
	CurrentArmy[queenPiece] = queenStart;
	
	#make a king
	var kingStart = Vector2(4,0)
	var kingPiece = Piece.new()
	kingPiece.MakeWhiteKing()
	kingPiece.StartingLocation = kingStart
	CurrentArmy[kingPiece] = kingStart
	
	#wipe passives and inventory
	CurrentPassives = {}
	CurrentInventory = {}
	
