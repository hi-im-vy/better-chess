extends Node

class_name Piece

#piece and color codes
const _blackCode = "Black";
const _whiteCode = "White";
const _colorCodes = [_blackCode, _whiteCode]

const _kingCode = "King"
const _queenCode = "Queen"
const _rookCode = "Rook"
const _bishopCode = "Bishop"
const _knightCode = "Knight"
const _pawnCode = "Pawn"
const _typeCodes = [_kingCode, _queenCode, _rookCode, _bishopCode, _knightCode, _pawnCode]

var color;
var type;
var StartingLocation = null;

func _init():
	color = null;
	type = null;
	
func SetPieceFromName(pieceName : String) -> bool:
	var returnBool = false
	
	var splitName = pieceName.split(" ")
	if (splitName.size() == 2):
		var colorName = splitName[0]
		if (_colorCodes.has(colorName)):
			var typeName = splitName[1]
			if (_typeCodes.has(typeName)):
				color = colorName;
				type = typeName;
				returnBool = true;
		
	
	return returnBool

#basic color functions	
func MakeBlack():
	color = _blackCode;
	
func MakeWhite():
	color = _whiteCode;
	
func IsWhite():
	if (color == null):
		print("WARNING: color is null")
		return false;
	elif (color == _whiteCode):
		return true;
	else:
		return false;

#basic type functions
func MakeKing():
	type = _kingCode;
	
func MakeQueen():
	type = _queenCode;
	
func MakeBishop():
	type = _bishopCode;
	
func MakeRook():
	type = _rookCode;
	
func MakeKnight():
	type = _knightCode;
	
func MakePawn():
	type = _pawnCode;
	
func IsKing():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _kingCode):
		return true;
	else:
		return false;
		
func IsQueen():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _queenCode):
		return true;
	else:
		return false;
		
func IsRook():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _rookCode):
		return true;
	else:
		return false;
		
func IsBishop():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _bishopCode):
		return true;
	else:
		return false;
		
func IsKnight():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _knightCode):
		return true;
	else:
		return false;
		
func IsPawn():
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == _pawnCode):
		return true;
	else:
		return false;

func IsPieceType(typeCode):
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (type == typeCode):
		return true;
	else:
		return false;

#combination functions
func MakeWhiteKing():
	MakeWhite();
	MakeKing();

func MakeBlackKing():
	MakeBlack();
	MakeKing();
	
func MakeWhiteQueen():
	MakeWhite();
	MakeQueen();

func MakeBlackQueen():
	MakeBlack();
	MakeQueen();
	
func MakeWhiteRook():
	MakeWhite();
	MakeRook();

func MakeBlackRook():
	MakeBlack();
	MakeRook();
	
func MakeWhiteBishop():
	MakeWhite();
	MakeBishop();

func MakeBlackBishop():
	MakeBlack();
	MakeBishop();
	
func MakeWhiteKnight():
	MakeWhite();
	MakeKnight();

func MakeBlackKnight():
	MakeBlack();
	MakeKnight();
	
func MakeWhitePawn():
	MakeWhite();
	MakePawn();

func MakeBlackPawn():
	MakeBlack();
	MakePawn();
		
func IsPieceColorType(colorCode, typeCode):
	if (type == null):
		print("WARNING: type is null")
		return false;
	elif (color == null):
		print("WARNING: color is null")
		return false;
	elif ((color == colorCode) && (type == typeCode)):
		return true;
	else:
		return false;
		
func IsPieceNull():
	if (type == null || color == null):
		return true;
	else:
		return false;

#make random non-king black piece
func MakeRandomBlackPiece():
	MakeBlack();
	var possiblePieces = [_pawnCode, _knightCode, _bishopCode, _rookCode, _queenCode]
	var randomSelect = possiblePieces.pick_random();
	if (randomSelect == _pawnCode):
		MakePawn()
	elif (randomSelect== _knightCode):
		MakeKnight()
	elif (randomSelect == _bishopCode):
		MakeBishop()
	elif (randomSelect == _rookCode):
		MakeRook()
	elif (randomSelect == _queenCode):
		MakeQueen()
	else:
		print("WARNING: unable to decide what piece this is in MakeRandomBlackPiece")

#other functions		
func PrintColorType():
	print(color + " " + type)

func GetColorType() -> String:
	return color + " " + type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
