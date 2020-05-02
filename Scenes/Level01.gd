extends Node2D

var PlayableTileScene := preload('../GameElements/PlayableTile.tscn')

func _ready() -> void:
	generate_tile_on_tile_map()
	
func generate_tile_on_tile_map() -> void:
	var cellSize = $TileMap.cell_size
	var usedCell = $TileMap.get_used_cells()
	for uc in usedCell:
		var newT = PlayableTileScene.instance()		
		newT.position = Vector2(uc.x * cellSize.x + cellSize.x/2, uc.y * cellSize.y + cellSize.y/2)
		add_child(newT)
	return

func _input(event):
	if event is InputEventMouseButton:
		var isOnTile = checkClickIsOnTile(event.position)

func checkClickIsOnTile(pos: Vector2) -> bool :
	var et = $TileMap.world_to_map(pos)
	print($TileMap.get_cellv($TileMap.world_to_map(pos)))
	return true
