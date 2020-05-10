extends Node2D

var PlayableTileScene := preload('../GameElements/PlayableTile.tscn')

var myLevelGrid = []
var selectShapeTile = null
var cellSize = null
var my_seed = "Godot Rocks"

func _ready() -> void:
	seed(my_seed.hash())

func generate_tile_on_tile_map() -> void:
	var nbrTileWidth = 5
	cellSize = $LevelDesign.cell_size
	var screenSize = get_viewport().size
	var nbrTileOnScreenX = floor(screenSize.x / cellSize.x)
	var nbrTileOnScreenY = floor(screenSize.y / cellSize.y)

#	Génération du tableau myLevelGrid pour faire les shapes à la TileMap
	for x in range(nbrTileOnScreenX):
		myLevelGrid.append([])
		for y in range(nbrTileOnScreenY):
			myLevelGrid[x].append([])
			myLevelGrid[x][y] = null
	for v in $LevelDesign.get_used_cells():
		myLevelGrid[v.x][v.y] = PlayableTileScene.instance()
		myLevelGrid[v.x][v.y].position = setShapePositionFromTileIndex(v)
		add_child(myLevelGrid[v.x][v.y])
		
	checkIfWinningCombinaison()
	

func _input(event):
	if event is InputEventMouseButton:
		var posMouseOnTile = $LevelDesign.world_to_map(event.position)
#		Dans le cas où je clique et relache sur des tuiles de jeu
		if(myLevelGrid[posMouseOnTile.x][posMouseOnTile.y] != null && event.button_index == 1):
#			Je clique sur une tuile et je sélectionne une forme
			if(event.pressed): 
				if(myLevelGrid[posMouseOnTile.x][posMouseOnTile.y] != null):
					selectShapeTile = {
						'shape': myLevelGrid[posMouseOnTile.x][posMouseOnTile.y],
						'posOnArray': posMouseOnTile,
						}
					
#			Je relache mon clique et je switch les cases
			if(!event.pressed):
				var shapeWhereReleased = myLevelGrid[posMouseOnTile.x][posMouseOnTile.y]
				print(selectShapeTile['posOnArray'], posMouseOnTile)
				var switchOkay = checkIfReleaseShapePossible(selectShapeTile['posOnArray'], posMouseOnTile)
				if(switchOkay):
					myLevelGrid[posMouseOnTile.x][posMouseOnTile.y] = selectShapeTile['shape']
					myLevelGrid[posMouseOnTile.x][posMouseOnTile.y].position = setShapePositionFromTileIndex(posMouseOnTile)
					myLevelGrid[selectShapeTile.posOnArray.x][selectShapeTile.posOnArray.y] = shapeWhereReleased
					myLevelGrid[selectShapeTile.posOnArray.x][selectShapeTile.posOnArray.y].position = setShapePositionFromTileIndex(selectShapeTile.posOnArray)
#					Je teste si il y a des combinaisons gagnantes
					checkIfWinningCombinaison()
				else :
					selectShapeTile['shape'].position = setShapePositionFromTileIndex(selectShapeTile['posOnArray'])
				selectShapeTile = null
#		Si je clique ou relache en dehors du terrain
		if(!event.pressed):
			if(selectShapeTile != null):
				selectShapeTile['shape'].position = setShapePositionFromTileIndex(selectShapeTile['posOnArray'])
				selectShapeTile = null
			
	if event is InputEventMouseMotion:
		if(selectShapeTile != null):
			selectShapeTile['shape'].position = event.position
			
func checkIfWinningCombinaison():
	var startValueX = {'shape':null, 'position':null}
	var endValueX = {'shape':null, 'position':null}
	var winCon = []
#	Check horizontal combinaison
	for x in range(myLevelGrid.size()):
		for y in range(myLevelGrid[x].size()):
			if myLevelGrid[x][y] != null:
				if myLevelGrid[x][y].shape != startValueX.shape:
					print(startValueX, ' ', endValueX)
					if(startValueX.shape != null && endValueX.shape != null && endValueX.position.x - startValueX.position.x >= 3 ):
						winCon.push({
							'startValue': startValueX,
							'endValue': endValueX,
						})
					startValueX = {
						'shape': myLevelGrid[x][y].shape,
						'position' : Vector2(x, y)
						}
					endValueX = {
						'shape':null, 'position':null
					}
						
				elif myLevelGrid[x][y].shape == startValueX.shape:
					endValueX = {
						'shape': myLevelGrid[x][y].shape,
						'position' : Vector2(x, y)
					}
	print("wincon", winCon)
	
func checkIfReleaseShapePossible(posOrigin:Vector2, posRelease: Vector2) -> bool:
#	Test d'un déplacement horizontal
	if((posRelease.y == posOrigin.y + 1 && posRelease.x == posOrigin.x) || (posRelease.y == posOrigin.y - 1 && posRelease.x == posOrigin.x)):
		return true
	if((posRelease.x == posOrigin.x + 1 && posRelease.y == posOrigin.y)|| (posRelease.x == posOrigin.x - 1 && posRelease.y == posOrigin.y)):
		return true
	return false
	
func setShapePositionFromTileIndex(tileIndex: Vector2) -> Vector2:
	var tileIndexUpdated = Vector2(tileIndex.x*cellSize.x+cellSize.x/2, tileIndex.y*cellSize.y+cellSize.y/2)
	return tileIndexUpdated

