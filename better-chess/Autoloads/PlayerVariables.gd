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

#base values for pieces
const QueenBaseValue = 9
const RookBaseValue = 5
const KnightBaseValue = 3
const BishopBaseValue = 3
const PawnBaseValue = 1


func GetCurrentPieceValue(thisPiece : Piece) -> int:
	var returnInt = 0
	
	if (thisPiece.IsQueen()):
		returnInt = GetCurrentQueenValue()
	elif (thisPiece.IsBishop()):
		returnInt = GetCurrentBishopValue()
	elif (thisPiece.IsRook()):
		returnInt = GetCurrentRookValue()
	elif (thisPiece.IsKnight()):
		returnInt = GetCurrentKnightValue()
	elif (thisPiece.IsPawn()):
		returnInt = GetCurrentPawnValue()

	return returnInt
	
func GetCurrentQueenValue() -> int:
	return QueenBaseValue

func GetCurrentRookValue() -> int:
	return RookBaseValue

func GetCurrentBishopValue() -> int:
	return BishopBaseValue

func GetCurrentKnightValue() -> int:
	return KnightBaseValue

func GetCurrentPawnValue() -> int:
	return PawnBaseValue
	
func GetCurrentGoalValueBasedOnPlayerLevel() -> int:
	var returnInt = 0;
	
	returnInt = (CurrentLevel * 10) + 10;
	
	return returnInt;

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
	
