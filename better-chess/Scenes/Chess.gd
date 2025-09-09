extends Sprite2D

#public variables
@export var _boardSize = Vector2(8,8);
@export var _cellWidth = 18

@export var _whiteKing = preload("res://Art/Default/white_king.png")
@export var _whiteQueen = preload("res://Art/Default/white_queen.png")
@export var _whiteRook = preload("res://Art/Default/white_rook.png")
@export var _whiteBishop = preload("res://Art/Default/white_bishop.png")
@export var _whiteKnight = preload("res://Art/Default/white_knight.png")
@export var _whitePawn = preload("res://Art/Default/white_pawn.png")

@export var _blackKing = preload("res://Art/Default/black_king.png")
@export var _blackQueen = preload("res://Art/Default/black_queen.png")
@export var _blackRook = preload("res://Art/Default/black_rook.png")
@export var _blackBishop = preload("res://Art/Default/black_bishop.png")
@export var _blackKnight = preload("res://Art/Default/black_knight.png")
@export var _blackPawn = preload("res://Art/Default/black_pawn.png")

@export var _blackTurn = preload("res://Art/Default/turn-black.png")
@export var _whiteTurn = preload("res://Art/Default/turn-white.png")

@export var _dot = preload("res://Art/Default/Piece_move.png")

#scene references
const TextureHolder = preload("res://Scenes/texture_holder.tscn")



#node references
@onready var myPieces = $Pieces
@onready var myDots = $Dots
@onready var myTurn = $Turn
@onready var WhitePromotionButtons = $"../CanvasLayer/White Pieces"
@onready var BlackPromotionButtons = $"../CanvasLayer/Black Pieces"

#class references
const Piece = preload("res://Classes/Piece.gd")
const LastMove = preload("res://Classes/LastMove.gd")

#global vars
var myBoard : Dictionary;
var myIsWhiteTurn : bool;
var myBoardState : String;
var myMoves : Array = [];
var mySelectedPieceVector : Vector2;
var myPromotionSquare;
var myWhiteKingMoved = false;
var myBlackKingMoved = false;
var myLeftWhiteRookMoved = false;
var myRightWhiteRookMoved = false;
var myLeftBlackRookMoved = false;
var myRightBlackRookMoved = false;
var myLastMove;

#global constants
const stateSelect = "Select"
const stateConfirm = "Confirm"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#for now, player always begins level 0
	PlayerVariables.StartPlayerAtLevel0()
	
	myPromotionSquare = null;
	myIsWhiteTurn = true;
	myLastMove = LastMove.new()
	
	SetBoardStateToSelect();
	
	SetNewBoard();
	#SetClassicBoard();
	#print(myBoard)
	DisplayBoard();
	
	#connect promotion button signals
	var whiteButtonGroup = get_tree().get_nodes_in_group("WhitePromotionPieces")
	var blackButtonGroup = get_tree().get_nodes_in_group("BlackPromotionPieces")
	for i in whiteButtonGroup:
		i.pressed.connect(self._on_promotion_button_pressed.bind(i))
	for i in blackButtonGroup:
		i.pressed.connect(self._on_promotion_button_pressed.bind(i))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _square_clicked(square_name) -> void:
	
	#print(square_name)
	
	var localMouseX = int(square_name.split('-')[0])
	var localMouseY = int(square_name.split('-')[1])
	
	var localMouseVector = Vector2(localMouseX, localMouseY);
	
	#print(localMouseVector)
	
	if (IsBoardStateSelect()):
		
		#white turn
		if (myIsWhiteTurn):
			
			if (myBoard.has(localMouseVector)):
				
				if (myBoard[localMouseVector].IsWhite()):
					#print("valid")
					mySelectedPieceVector = localMouseVector
					#print(mySelectedPieceVector)
					#var curPiece = myBoard[localMouseVector]
					#curPiece.PrintColorType()
					SetBoardStateToConfirm()
					ShowOptionsForSelectedPiece()
					
					
		#black turn
		else:
			#print(localMouseVector)
			if (myBoard.has(localMouseVector)):
				
				if (!myBoard[localMouseVector].IsWhite()):
					#print("valid")
					mySelectedPieceVector = localMouseVector
					#print(mySelectedPieceVector)
					#var curPiece = myBoard[localMouseVector]
					#curPiece.PrintColorType()
					SetBoardStateToConfirm()
					ShowOptionsForSelectedPiece()
						
	elif (IsBoardStateConfirm()):
		MoveSelectedPiece(localMouseVector)	

func _on_promotion_button_pressed(button):
	var buttonName = button.name
	#print(buttonName)
	var newPiece = Piece.new()
	var isValid = newPiece.SetPieceFromName(buttonName)
	if (isValid):
		myBoard[myPromotionSquare] = newPiece
	WhitePromotionButtons.visible = false;
	BlackPromotionButtons.visible = false;
	myPromotionSquare = null;
	DisplayBoard()
	
func DisplayBoard() -> void:
	
	#print(myPieces.get_child_count())
	var pieceChildren = myPieces.get_children()
	for child in pieceChildren:
		myPieces.remove_child(child)
		child.queue_free()

	#print(myPieces.get_child_count())
	#print (_boardSize)
	
	for i in _boardSize.y:
		for j in _boardSize.x:
			
			var newVector = Vector2(j, i)
			
			var newTextureHolder = TextureHolder.instantiate();
			
			myPieces.add_child(newTextureHolder);
			
			newTextureHolder.position = GetGlobalPositionFromBoardVector(newVector)
			
			#set signal
			#var textureArea2D = newTextureHolder.get_node("Area2D")
			#textureArea2D.input_event.connect(_on_area_2d_input_event)
			
			#newTextureHolder._square_clicked.connect()
			#print(str(int(i)))
			#print(str(int(j)))
			var newName = str(int(j)) + '-' + str(int(i))
			newTextureHolder.name = newName
			#print(newTextureHolder.name)
			
			newTextureHolder.clickable = true; 
			
			if (myBoard.has(newVector)):
				newTextureHolder.texture = GetTextureForPiece(myBoard[newVector])
			
			#print(newVector)
			#print(newTextureHolder.global_position)
			#print(newTextureHolder.texture)
			
	#show turn
	if (myIsWhiteTurn):
		myTurn.texture = _whiteTurn
	else:
		myTurn.texture = _blackTurn
		
			
			
			
			
			
func MoveSelectedPiece(moveVector : Vector2) -> void:
	#print("in MoveSelectedPiece with moveVector " + str(moveVector))
	var findMove = myMoves.find(moveVector);
	#print(findMove)
	if (findMove > -1):
		
		
		var selectedPieceCode = myBoard[mySelectedPieceVector]
		
		if (selectedPieceCode.IsPawn()):
			
			#check for promoting pawn
			if (selectedPieceCode.IsWhite() && (moveVector.y == (_boardSize.y-1))):
				PromoteHere(moveVector, selectedPieceCode.IsWhite())
			elif (!selectedPieceCode.IsWhite() && (moveVector.y == 0)):
				PromoteHere(moveVector, selectedPieceCode.IsWhite())
				
			#check for doing en passant attack
			if (myLastMove.IsEnPassant()):
				if (moveVector == myLastMove.EnPassantSquare):
					#capture piece from last move
					CapturePiece(selectedPieceCode, myLastMove.LastPiece, myLastMove.EnPassantSquare)
					#remove it
					myBoard.erase(myLastMove.LastMoveEnd)
			
		elif (selectedPieceCode.IsKing()):
			if (selectedPieceCode.IsWhite()):
				#check if castling
				if (!myWhiteKingMoved):
					if (moveVector.x - mySelectedPieceVector.x == -2):
						#castling left
						myLeftWhiteRookMoved = true
						myRightWhiteRookMoved = true
						#move rook
						var rookVector = Vector2(0,0)
						myBoard.erase(rookVector)
						var rookDestination = Vector2(moveVector.x + 1, moveVector.y)
						var rookPiece = Piece.new()
						rookPiece.MakeWhiteRook()
						myBoard[rookDestination] = rookPiece
					elif (moveVector.x - mySelectedPieceVector.x == 2):
						#castling right
						myLeftWhiteRookMoved = true
						myRightWhiteRookMoved = true
						#move rook
						var rookVector = Vector2(_boardSize.x - 1, 0)
						myBoard.erase(rookVector)
						var rookDestination = Vector2(moveVector.x - 1, moveVector.y)
						var rookPiece = Piece.new()
						rookPiece.MakeWhiteRook()
						myBoard[rookDestination] = rookPiece
				myWhiteKingMoved = true
			else:
				#check if castling
				if (!myBlackKingMoved):
					if (moveVector.x - mySelectedPieceVector.x == -2):
						#castling left
						myLeftBlackRookMoved = true
						myRightBlackRookMoved = true
						#move rook
						var rookVector = Vector2(0,_boardSize.y-1)
						myBoard.erase(rookVector)
						var rookDestination = Vector2(moveVector.x + 1, moveVector.y)
						var rookPiece = Piece.new()
						rookPiece.MakeBlackRook()
						myBoard[rookDestination] = rookPiece
					elif (moveVector.x - mySelectedPieceVector.x == 2):
						#castling right
						myLeftBlackRookMoved = true
						myRightBlackRookMoved = true
						#move rook
						var rookVector = Vector2(_boardSize.x - 1, _boardSize.y-1)
						myBoard.erase(rookVector)
						var rookDestination = Vector2(moveVector.x - 1, moveVector.y)
						var rookPiece = Piece.new()
						rookPiece.MakeBlackRook()
						myBoard[rookDestination] = rookPiece
				myBlackKingMoved = true
		elif (selectedPieceCode.IsRook()):
			if (selectedPieceCode.IsWhite()):
				if (mySelectedPieceVector.x == 0 && mySelectedPieceVector.y == 0):
					#moving left white rook
					myLeftWhiteRookMoved = true
				elif (mySelectedPieceVector.x == _boardSize.x - 1 && mySelectedPieceVector.y == 0):
					#moving white rook
					myRightWhiteRookMoved = true;
			else:
				if (mySelectedPieceVector.x == 0 && mySelectedPieceVector.y == _boardSize.y - 1):
					#moving left black rook
					myLeftBlackRookMoved = true
				elif (mySelectedPieceVector.x == _boardSize.x - 1 && mySelectedPieceVector.y == _boardSize.y - 1):
					#moving black rook
					myRightBlackRookMoved = true;
			
		
		if (myBoard.has(moveVector)):
			#capturing a piece
			CapturePiece(myBoard[mySelectedPieceVector], myBoard[moveVector], moveVector)
			myLastMove.SetLastMove(myBoard[mySelectedPieceVector], mySelectedPieceVector, moveVector, myBoard[moveVector])
		else:
			myLastMove.SetLastMove(myBoard[mySelectedPieceVector], mySelectedPieceVector, moveVector)
		myBoard[moveVector] = myBoard[mySelectedPieceVector]
		myBoard.erase(mySelectedPieceVector)

		myIsWhiteTurn = !myIsWhiteTurn
		
		CheckForCheckmateAndStalemate(myBoard, myIsWhiteTurn)
		
		
		
		#var allAttacks = GetAllThreatsForColor(myBoard, myIsWhiteTurn)
		#print(allAttacks)
		
		#check if in check
		#IsInCheck(myBoard, myIsWhiteTurn)
		
		DisplayBoard()
		
		#myLastMove.PrintLastMove();
	mySelectedPieceVector = Vector2(-1,-1)
	myMoves = []
	HideDots()
	SetBoardStateToSelect()
	
func PromoteHere(thisVector : Vector2, isWhite : bool):
	myPromotionSquare = thisVector
	WhitePromotionButtons.visible = isWhite;
	BlackPromotionButtons.visible = !isWhite;
			
			
		

func CapturePiece(capturingPiece : Piece, capturedPiece : Piece, captureVector : Vector2) -> void:
	print("Capturing " + capturedPiece.GetColorType() + " with " + capturingPiece.GetColorType() + " at " + str(captureVector))
	

#changes a board vector (like (0,1)) into a global position based on cell width
func GetGlobalPositionFromBoardVector(boardVector : Vector2) -> Vector2:
	var returnVector = Vector2((boardVector.x * _cellWidth) + (_cellWidth / 2), (((_boardSize.y * _cellWidth) - (boardVector.y * _cellWidth)) - (_cellWidth / 2)))
	return returnVector
	
#get texture matching given piece
func GetTextureForPiece(thisPiece : Piece):
	if (thisPiece == null):
		return null;
	elif (thisPiece.IsPieceNull()):
		print("WARNING: piece is null when getting texture for piece")
		return null;
	#white checks
	elif (thisPiece.IsPieceColorType(Piece._whiteCode, Piece._kingCode)):
		return _whiteKing;
	elif(thisPiece.IsPieceColorType(Piece._whiteCode, Piece._queenCode)):
		return _whiteQueen;
	elif(thisPiece.IsPieceColorType(Piece._whiteCode, Piece._rookCode)):
		return _whiteRook;
	elif(thisPiece.IsPieceColorType(Piece._whiteCode, Piece._bishopCode)):
		return _whiteBishop;
	elif(thisPiece.IsPieceColorType(Piece._whiteCode, Piece._knightCode)):
		return _whiteKnight;
	elif(thisPiece.IsPieceColorType(Piece._whiteCode, Piece._pawnCode)):
		return _whitePawn;
	#black checks
	elif (thisPiece.IsPieceColorType(Piece._blackCode, Piece._kingCode)):
		return _blackKing;
	elif(thisPiece.IsPieceColorType(Piece._blackCode, Piece._queenCode)):
		return _blackQueen;
	elif(thisPiece.IsPieceColorType(Piece._blackCode, Piece._rookCode)):
		return _blackRook;
	elif(thisPiece.IsPieceColorType(Piece._blackCode, Piece._bishopCode)):
		return _blackBishop;
	elif(thisPiece.IsPieceColorType(Piece._blackCode, Piece._knightCode)):
		return _blackKnight;
	elif(thisPiece.IsPieceColorType(Piece._blackCode, Piece._pawnCode)):
		return _blackPawn;
	else:
		print("WARNING: could not determine texture to match piece")
		return null;
		
func ShowOptionsForSelectedPiece() -> void:
	myMoves = GetMovesForSelectedPiece()
	if (myMoves == []):
		SetBoardStateToSelect()
	else:
		ShowDotsForMoves()
	
func GetMovesForSelectedPiece() -> Array:
	
	var returnArray = [];
	
	var selectedPiece = myBoard[mySelectedPieceVector]
	
	if (selectedPiece.IsRook()):
		returnArray = GetRookMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsBishop()):
		returnArray = GetBishopMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsQueen()):
		returnArray = GetQueenMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsKnight()):
		returnArray = GetKnightMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsPawn()):
		returnArray = GetPawnMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsKing()):
		returnArray = GetKingMoves(mySelectedPieceVector, selectedPiece.IsWhite())
	
	
	return returnArray;
	
func GetMovesForGivenPiece(varVector) -> Array:
	
	var returnArray = [];
	
	var selectedPiece = myBoard[varVector]
	
	if (selectedPiece.IsRook()):
		returnArray = GetRookMoves(varVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsBishop()):
		returnArray = GetBishopMoves(varVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsQueen()):
		returnArray = GetQueenMoves(varVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsKnight()):
		returnArray = GetKnightMoves(varVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsPawn()):
		returnArray = GetPawnMoves(varVector, selectedPiece.IsWhite())
	elif (selectedPiece.IsKing()):
		returnArray = GetKingMoves(varVector, selectedPiece.IsWhite())
	
	
	return returnArray;
	
func ShowDotsForMoves() -> void:
	for i in myMoves:
		var newHolder = TextureHolder.instantiate();
		myDots.add_child(newHolder)
		newHolder.texture = _dot;
		newHolder.position = GetGlobalPositionFromBoardVector(Vector2(i.x,i.y))
		newHolder.name = str(int(i.x)) + '-' + str(int(i.y)) 
		
func HideDots():
	for child in myDots.get_children():
		child.queue_free()
		
func IsValidSpace(myVector : Vector2) -> bool:
	if (myVector.x < 0 || myVector.x > (_boardSize.x-1) || myVector.y < 0 || myVector.y > (_boardSize.y-1)):
		return false;
	return true;

#check for checkmate and stalemate given a board and a turn	
func CheckForCheckmateAndStalemate(varBoard, isWhite) -> void:
	var possibleMoves = []
	for i in varBoard.keys():
		var curPiece = varBoard[i]
		if (curPiece.IsWhite() == isWhite):
			var checkMoves = GetMovesForGivenPiece(i)
			possibleMoves.append_array(checkMoves)
	if (possibleMoves == []):
		#print("No moves left!")
		if (IsInCheck(varBoard, isWhite)):
			print("Checkmate!")
			if (isWhite):
				print("Black wins!")
			else:
				print("White wins!")
		else:
			print("Stalemate!")
	
func IsInCheck(varBoard, isWhite) -> bool:
	var returnBool = false;
	
	var allThreats = GetAllThreatsForColor(varBoard, !isWhite);
	var kingPos = FindKing(varBoard, isWhite);
	
	if (allThreats.has(kingPos)):
		returnBool = true;
		#if (isWhite):
			#print("White King in check!")
		#else:
			#print("Black King in check!")
	
	return returnBool;
	
func FindKing(varBoard, isWhite) -> Vector2:
	
	var returnVector = Vector2(-1,-1)
	
	for i in varBoard.keys():
		var curPiece = varBoard[i]
		if (curPiece.IsKing()):
			if (curPiece.IsWhite() == isWhite):
				returnVector = i;
				break;

	if (returnVector.x == -1 || returnVector.y == -1):
		if (isWhite):
			print("WARNING: Can't find white king in FindKing")

	return returnVector

#get array of all attacking squares for a color	
func GetAllThreatsForColor(varBoard, isWhite) -> Array:
	var returnArray = [];
	
	for i in varBoard.keys():
		var curPiece = varBoard[i]
		if (curPiece.IsWhite() == isWhite):
			if (curPiece.IsRook()):
				var rookMoves = GetRookMoves(i, curPiece.IsWhite(), false, false, varBoard)
				for j in rookMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			elif (curPiece.IsBishop()):
				var bishopMoves = GetBishopMoves(i, curPiece.IsWhite(), false, false, varBoard)
				for j in bishopMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			elif (curPiece.IsQueen()):
				var queenMoves = GetQueenMoves(i, curPiece.IsWhite(), false, false, varBoard)
				for j in queenMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			elif (curPiece.IsKing()):
				var kingMoves = GetKingMoves(i, curPiece.IsWhite(), false, true, false, varBoard)
				for j in kingMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			elif (curPiece.IsKnight()):
				var knightMoves = GetKnightMoves(i, curPiece.IsWhite(), false, false, varBoard)
				for j in knightMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			elif (curPiece.IsPawn()):
				var pawnMoves = GetPawnMoves(i, curPiece.IsWhite(), false, true, false, varBoard)
				for j in pawnMoves:
					if (!returnArray.has(j)):
						returnArray.append(j)
			else:
				print("WARNING: unable to find piece in GetAllThreatsForColor")
	
	return returnArray;
		
func GetRookMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions =[Vector2(0,1), Vector2(1,0), Vector2(0,-1), Vector2(-1,0)]
		
	for dir in directions:
		
		var curVector = myVector
		
		for i in range(0,_boardSize.x):
			
			#move in direction
			curVector = curVector + dir
			
			#check if space exists
			if (IsValidSpace(curVector)):
				#check if space is empty or not
				if (useBoard.has(curVector)):
					var curPiece = useBoard[curVector]
					
					#if checking for white, check if piece is white and add it only if adding covers
					if (isWhitePiece):
						if (curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is black, so add it
						else:
							returnArray.append(curVector)
					#if checking for black, check if piece is black and add it only if adding covers
					else:
						if (!curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is white, so add it
						else:
							returnArray.append(curVector)
					break;
				#if not empty, add it and continue	
				else:
					returnArray.append(curVector)
			else:
				break;
			
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakeRook();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)
	
	return returnArray
	
func GetBishopMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions =[Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1)]
		
	for dir in directions:
		
		var curVector = myVector
		
		for i in range(0,_boardSize.x):
			
			#move in direction
			curVector = curVector + dir
			
			#check if space exists
			if (IsValidSpace(curVector)):
				#check if space is empty or not
				if (useBoard.has(curVector)):
					var curPiece = useBoard[curVector]
					
					#if checking for white, check if piece is white and add it only if adding covers
					if (isWhitePiece):
						if (curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is black, so add it
						else:
							returnArray.append(curVector)
					#if checking for black, check if piece is black and add it only if adding covers
					else:
						if (!curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is white, so add it
						else:
							returnArray.append(curVector)
					break;
				#if not empty, add it and continue	
				else:
					returnArray.append(curVector)
			else:
				break;
			
			
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakeBishop();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)
	
	return returnArray
	
func GetQueenMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions =[Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1), Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1)]
		
	for dir in directions:
		
		var curVector = myVector
		
		for i in range(0,_boardSize.x):
			
			#move in direction
			curVector = curVector + dir
			
			#check if space exists
			if (IsValidSpace(curVector)):
				#check if space is empty or not
				if (useBoard.has(curVector)):
					var curPiece = useBoard[curVector]
					
					#if checking for white, check if piece is white and add it only if adding covers
					if (isWhitePiece):
						if (curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is black, so add it
						else:
							returnArray.append(curVector)
					#if checking for black, check if piece is black and add it only if adding covers
					else:
						if (!curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is white, so add it
						else:
							returnArray.append(curVector)
					break;
				#if not empty, add it and continue	
				else:
					returnArray.append(curVector)
			else:
				break;
			
			
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakeQueen();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)
	
	return returnArray
	
func GetKingMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, onlyAttacks : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions =[Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1), Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1)]
		
	for dir in directions:
		
		var curVector = myVector
			
		#move in direction
		curVector = curVector + dir
		
		#check if space exists
		if (IsValidSpace(curVector)):
			#check if space is empty or not
			if (useBoard.has(curVector)):
				var curPiece = useBoard[curVector]
				
				#if checking for white, check if piece is white and add it only if adding covers
				if (isWhitePiece):
					if (curPiece.IsWhite()):
						if (includeCover):
							returnArray.append(curVector)
					#otherwise piece is black, so add it
					else:
						returnArray.append(curVector)
				#if checking for black, check if piece is black and add it only if adding covers
				else:
					if (!curPiece.IsWhite()):
						if (includeCover):
							returnArray.append(curVector)
					#otherwise piece is white, so add it
					else:
						returnArray.append(curVector)
			#if not empty, add it and continue	
			else:
				returnArray.append(curVector)
	
	#castling time - if looking for more than just attacks
	if (!onlyAttacks):
		#check if in check - can't castle if so
		if (!IsInCheck(myBoard, isWhitePiece)):
		#add castling moves
			if (isWhitePiece):
				#check white
				if (!myWhiteKingMoved):
					#check left
					if (!myLeftWhiteRookMoved):
						var castleVector = Vector2(-2,0)
						var curVector = myVector + castleVector
						
						var canCastle = false;
						
						var checkVector = myVector
						for i in _boardSize.x:
							checkVector = checkVector + Vector2(-1,0)
							if (IsValidSpace(checkVector)):
								#if piece is at location, make sure it's the leftmost white rook
								if (useBoard.has(checkVector)):
									var curPiece = useBoard[checkVector]
									if (curPiece.IsPieceColorType(Piece._whiteCode, Piece._rookCode)):
										if (checkVector.x == 0 && checkVector.y == 0):
											canCastle = true;
											break;
										else:
											break;
									else:
										break;
								else:
									if (abs(checkVector.x - myVector.x) < 3):
										#check if moving to empty square would put king in check - if so, can't castle, and stop trying
										var checkBoard = useBoard.duplicate(true);
										var movedPiece = Piece.new()
										movedPiece.MakeKing();
										if (isWhitePiece):
											movedPiece.MakeWhite()
										else:
											movedPiece.MakeBlack()
										checkBoard[checkVector] = movedPiece
										checkBoard.erase(myVector)
										if (IsInCheck(checkBoard, isWhitePiece)):
											canCastle = false;
											break;
										
							else:
								break;
								
						if (canCastle && !onlyAttacks):
							returnArray.append(curVector)
					
					#check right
					if (!myRightWhiteRookMoved):
						var castleVector = Vector2(2,0)
						var curVector = myVector + castleVector
						
						var canCastle = false;
						
						var checkVector = myVector
						for i in _boardSize.x:
							checkVector = checkVector + Vector2(1,0)
							if (IsValidSpace(checkVector)):
								#if piece is at location, make sure it's the rightmost white rook
								if (useBoard.has(checkVector)):
									var curPiece = useBoard[checkVector]
									if (curPiece.IsPieceColorType(Piece._whiteCode, Piece._rookCode)):
										if (checkVector.x == _boardSize.x-1 && checkVector.y == 0):
											canCastle = true;
											break;
										else:
											break;
									else:
										break;
								else:
									if (abs(checkVector.x - myVector.x) < 3):
										#check if moving to empty square would put king in check - if so, can't castle, and stop trying
										var checkBoard = useBoard.duplicate(true);
										var movedPiece = Piece.new()
										movedPiece.MakeKing();
										if (isWhitePiece):
											movedPiece.MakeWhite()
										else:
											movedPiece.MakeBlack()
										checkBoard[checkVector] = movedPiece
										checkBoard.erase(myVector)
										if (IsInCheck(checkBoard, isWhitePiece)):
											canCastle = false;
											break;
										
							else:
								break;
								
						if (canCastle && !onlyAttacks):
							returnArray.append(curVector)
							
					
					
			else:
				#check black
				if (!myBlackKingMoved):
					#check left
					if (!myLeftBlackRookMoved):
						var castleVector = Vector2(-2,0)
						var curVector = myVector + castleVector
						
						var canCastle = false;
						
						var checkVector = myVector
						for i in _boardSize.x:
							checkVector = checkVector + Vector2(-1,0)
							if (IsValidSpace(checkVector)):
								#if piece is at location, make sure it's the leftmost black rook
								if (useBoard.has(checkVector)):
									var curPiece = useBoard[checkVector]
									if (curPiece.IsPieceColorType(Piece._blackCode, Piece._rookCode)):
										if (checkVector.x == 0 && checkVector.y == _boardSize.y - 1):
											canCastle = true;
											break;
										else:
											break;
									else:
										break;
								else:
									if (abs(checkVector.x - myVector.x) < 3):
										#check if moving to empty square would put king in check - if so, can't castle, and stop trying
										var checkBoard = useBoard.duplicate(true);
										var movedPiece = Piece.new()
										movedPiece.MakeKing();
										if (isWhitePiece):
											movedPiece.MakeWhite()
										else:
											movedPiece.MakeBlack()
										checkBoard[checkVector] = movedPiece
										checkBoard.erase(myVector)
										if (IsInCheck(checkBoard, isWhitePiece)):
											canCastle = false;
											break;
										
							else:
								break;
								
						if (canCastle && !onlyAttacks):
							returnArray.append(curVector)
					
					#check right
					if (!myRightBlackRookMoved):
						var castleVector = Vector2(2,0)
						var curVector = myVector + castleVector
						
						var canCastle = false;
						
						var checkVector = myVector
						for i in _boardSize.x:
							checkVector = checkVector + Vector2(1,0)
							if (IsValidSpace(checkVector)):
								#if piece is at location, make sure it's the rightmost black rook
								if (useBoard.has(checkVector)):
									var curPiece = useBoard[checkVector]
									if (curPiece.IsPieceColorType(Piece._blackCode, Piece._rookCode)):
										if (checkVector.x == _boardSize.x-1 && checkVector.y == _boardSize.y-1):
											canCastle = true;
											break;
										else:
											break;
									else:
										break;
								else:
									if (abs(checkVector.x - myVector.x) < 3):
										#check if moving to empty square would put king in check - if so, can't castle, and stop trying
										var checkBoard = useBoard.duplicate(true);
										var movedPiece = Piece.new()
										movedPiece.MakeKing();
										if (isWhitePiece):
											movedPiece.MakeWhite()
										else:
											movedPiece.MakeBlack()
										checkBoard[checkVector] = movedPiece
										checkBoard.erase(myVector)
										if (IsInCheck(checkBoard, isWhitePiece)):
											canCastle = false;
											break;
										
							else:
								break;
								
						if (canCastle && !onlyAttacks):
							returnArray.append(curVector)
									
	
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakeKing();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)
	
	return returnArray
	
func GetKnightMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions =[Vector2(1,2), Vector2(1,-2), Vector2(2,1), Vector2(2,-1), Vector2(-1,-2), Vector2(-1,2), Vector2(-2,-1), Vector2(-2,1)]
		
	for dir in directions:
		
		var curVector = myVector
			
		#move in direction
		curVector = curVector + dir
		
		#check if space exists
		if (IsValidSpace(curVector)):
			#check if space is empty or not
			if (useBoard.has(curVector)):
				var curPiece = useBoard[curVector]
				
				#if checking for white, check if piece is white and add it only if adding covers
				if (isWhitePiece):
					if (curPiece.IsWhite()):
						if (includeCover):
							returnArray.append(curVector)
					#otherwise piece is black, so add it
					else:
						returnArray.append(curVector)
				#if checking for black, check if piece is black and add it only if adding covers
				else:
					if (!curPiece.IsWhite()):
						if (includeCover):
							returnArray.append(curVector)
					#otherwise piece is white, so add it
					else:
						returnArray.append(curVector)
			#if not empty, add it and continue	
			else:
				returnArray.append(curVector)
	
			
			
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakeKnight();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)	
	
	return returnArray
	
func GetPawnMoves(myVector : Vector2, isWhitePiece : bool, includeCover : bool = false, onlyAttacks : bool = false, runCheck : bool = true, useBoard = null) -> Array:
	var returnArray = []
	
	if (useBoard == null):
		useBoard = myBoard.duplicate(true)
	
	var directions = []
	
	if (isWhitePiece):
		directions.append(Vector2(0,1))
		directions.append(Vector2(1,1))
		directions.append(Vector2(-1,1))
		#also add double-move forward if on row 1
		if (myVector.y == 1):
			directions.append(Vector2(0,2))
	else:
		directions.append(Vector2(0,-1))
		directions.append(Vector2(1,-1))
		directions.append(Vector2(-1,-1))
		if (myVector.y == _boardSize.y-2):
			directions.append(Vector2(0,-2))
		
	for dir in directions:
		
		var curVector = myVector
			
		#move in direction
		curVector = curVector + dir
		
		#check if space exists
		if (IsValidSpace(curVector)):
			#check if space is empty or not - if not empty, only allow move to enemy piece/cover on diagonal
			if (useBoard.has(curVector)):
				
				if (dir.x != 0):				
					var curPiece = useBoard[curVector]
				
					#if checking for white, check if piece is white and add it only if adding covers
					if (isWhitePiece):
						if (curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is black, so add it
						else:
							returnArray.append(curVector)
					#if checking for black, check if piece is black and add it only if adding covers
					else:
						if (!curPiece.IsWhite()):
							if (includeCover):
								returnArray.append(curVector)
						#otherwise piece is white, so add it
						else:
							returnArray.append(curVector)
			#if empty, check if going in forward direction and add if so	
			else:
				if (dir.x == 0):
					#for double-moves, make sure no pieces are between the jump
					if (isWhitePiece):
						if (dir.y > 1):
							var checkDir = Vector2(0,1)
							var checkPos = myVector + checkDir
							if (!useBoard.has(checkPos) && !onlyAttacks):
								returnArray.append(curVector)						
						else:
							if (!onlyAttacks):
								returnArray.append(curVector)
					else:
						if (dir.y < -1):
							var checkDir = Vector2(0,-1)
							var checkPos = myVector + checkDir
							if (!useBoard.has(checkPos) && !onlyAttacks):
								returnArray.append(curVector)						
						else:
							if (!onlyAttacks):
								returnArray.append(curVector)
				else:
					#moving diagnally to an empty square - only allow of going to an en passant square
					if (myLastMove.IsEnPassant()):
						if (curVector == myLastMove.EnPassantSquare):
							returnArray.append(curVector)
						elif (onlyAttacks):
							returnArray.append(curVector)
					elif (onlyAttacks):
						returnArray.append(curVector)
							
	
			
			
	#make sure moves won't put in check
	if (runCheck):
		var removeArray = []
		for i in returnArray:
			var checkBoard = useBoard.duplicate(true);
			var movedPiece = Piece.new()
			movedPiece.MakePawn();
			if (isWhitePiece):
				movedPiece.MakeWhite()
			else:
				movedPiece.MakeBlack()
			checkBoard[i] = movedPiece
			checkBoard.erase(myVector)
			if (IsInCheck(checkBoard, isWhitePiece)):
				removeArray.append(i)
		for i in removeArray:
			if (returnArray.has(i)):
				returnArray.erase(i)
	
	return returnArray

		
func SetBoardStateToSelect() -> void:
	myBoardState = stateSelect;
	
func IsBoardStateSelect() -> bool:
	if (myBoardState == stateSelect):
		return true;
	else:
		return false;
		
func SetBoardStateToConfirm() -> void:
	myBoardState = stateConfirm;

func IsBoardStateConfirm() -> bool:
	if (myBoardState == stateConfirm):
		return true;
	else:
		return false;

#set a new board with player's army and two starting black pieces randomly placed	
func SetNewBoard() -> void:
	myBoard.clear()
	
	SetWhiteStart()
	SetBlackStart(2)
		
func SetWhiteStart() -> void:
	for i in PlayerVariables.CurrentArmy:
		myBoard[i.StartingLocation] = i

func SetBlackStart(numPieces : int) -> void:
	for i in range(0,numPieces):
		var newPiece = Piece.new();
		newPiece.MakeRandomBlackPiece();
		var checkPos = GetRandomEnemySpawnOnce()
		if (checkPos.x < 0 || checkPos.y < 0):
			newPiece.MakeBlackPawn()
			checkPos = GetRandomEnemySpawnMany()
		myBoard[checkPos] = newPiece

		

#one roll of the die for enemy spawn location - except if it ends up on white
func GetRandomEnemySpawnOnce() -> Vector2:
	var returnVector = Vector2(-1,-1);
	
	var boardArray = MakeBoardArray()
	
	#check if board is full
	if (boardArray.size() > myBoard.size()):
		for i in range(0,myBoard.size()):
			var randomSpace = boardArray.pick_random()
			
			if (myBoard.has(randomSpace)):
				#check if black - if not, roll again
				var curPiece = myBoard[randomSpace]
				if (!curPiece.IsWhite()):
					break;
			else:
				#space is empty, return it
				returnVector = randomSpace
				break;
				
	return returnVector
				
#gets back a new empty space no matter what - unless none remain
func GetRandomEnemySpawnMany() -> Vector2:
	var returnVector = Vector2(-1,-1);
	
	var boardArray = MakeBoardArray()
	
	#check if board is full
	if (boardArray.size() > myBoard.size()):
		for i in range(0,myBoard.size()):
			var randomSpace = boardArray.pick_random()
			
			if (!myBoard.has(randomSpace)):
				#space is empty, return it
				returnVector = randomSpace
				break;
				
	if (returnVector.x == -1 && returnVector.y == -1):
		print("WARNING: board is full or GetRandomEnemySpawnMany failed")
	
	return returnVector;
	
func MakeBoardArray() -> Array:
	var returnArray = []
	
	for i in range(0, _boardSize.x):
		for j in range (0, _boardSize.y):
			var newVector = Vector2(i, j)
			returnArray.append(newVector)
	
	return returnArray
	

func SetClassicBoard() -> void:
	#start by clearing board
	myBoard.clear();
	
	var newPiece = Piece.new();
	var newVector;
	
	#add pieces to board
	
	#white row 0
	newPiece.MakeWhiteRook();
	newVector = Vector2(0,0)
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteKnight();
	newVector = Vector2(1,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteBishop();
	newVector = Vector2(2,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteQueen();
	newVector = Vector2(3,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteKing();
	newVector = Vector2(4,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteBishop();
	newVector = Vector2(5,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteKnight();
	newVector = Vector2(6,0);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhiteRook();
	newVector = Vector2(7,0);
	myBoard[newVector] = newPiece;
	
	#white row 1
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(0,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(1,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(2,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(3,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(4,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(5,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(6,1);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeWhitePawn();
	newVector = Vector2(7,1);
	myBoard[newVector] = newPiece;
	
	#black row 7
	newPiece = Piece.new();
	newPiece.MakeBlackRook();
	newVector = Vector2(0,7)
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackKnight();
	newVector = Vector2(1,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackBishop();
	newVector = Vector2(2,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackQueen();
	newVector = Vector2(3,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackKing();
	newVector = Vector2(4,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackBishop();
	newVector = Vector2(5,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackKnight();
	newVector = Vector2(6,7);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackRook();
	newVector = Vector2(7,7);
	myBoard[newVector] = newPiece;
	
	#black row 6
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(0,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(1,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(2,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(3,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(4,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(5,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(6,6);
	myBoard[newVector] = newPiece;
	
	newPiece = Piece.new();
	newPiece.MakeBlackPawn();
	newVector = Vector2(7,6);
	myBoard[newVector] = newPiece;
	
	
	
	
