extends Node

class_name LastMove

const Piece = preload("res://Classes/Piece.gd")

var LastPiece;
var LastMoveStart;
var LastMoveEnd;
var EnPassantSquare;
var CapturedPiece;

func _init():
	LastPiece = Piece.new();
	CapturedPiece = Piece.new();
	LastMoveStart = null;
	LastMoveEnd = null;
	EnPassantSquare = null;
	
func SetLastMove(varPiece, varStart, varEnd, varCapture=null):
	LastPiece = varPiece
	LastMoveStart = varStart
	LastMoveEnd = varEnd
	if (varCapture != null):
		CapturedPiece = varCapture
	else:
		CapturedPiece = Piece.new()
	
	IsEnPassant();
		
func PrintLastMove():
	if (CapturedPiece.IsPieceNull()):
		print (LastPiece.GetColorType() + " moved from " + str(LastMoveStart) + " to " + str(LastMoveEnd))
	else:
		print(LastPiece.GetColorType() + " captured " + CapturedPiece.GetColorType() + " moving from " + str(LastMoveStart) + " to " + str(LastMoveEnd))

func IsEnPassant() -> bool:
	var returnBool = false;
	
	if (!LastPiece.IsPieceNull()):
		#check if white pawn moved up 2 squares
		if (LastPiece.IsPawn() && LastPiece.IsWhite()):
			if (LastMoveEnd.y - LastMoveStart.y == 2):
				returnBool = true;
				EnPassantSquare = Vector2(LastMoveEnd.x, LastMoveEnd.y - 1)
			else:
				EnPassantSquare = null
		elif (LastPiece.IsPawn() && !LastPiece.IsWhite()):
			if (LastMoveEnd.y - LastMoveStart.y == -2):
				returnBool = true;
				EnPassantSquare = Vector2(LastMoveEnd.x, LastMoveEnd.y + 1)
			else:
				EnPassantSquare = null;
		else:
			EnPassantSquare = null;
	
	return returnBool;
