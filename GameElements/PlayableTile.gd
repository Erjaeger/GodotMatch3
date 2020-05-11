extends Node2D

var textures = [
	preload('../Visuals/Texture1.png'),
	preload('../Visuals/Texture2.png'),
	preload('../Visuals/Texture3.png'),
	preload('../Visuals/Texture4.png')
	]
	
var shape = null

func _ready() -> void:
	shape = randi() % 4
	$Sprite.texture = textures[shape]
	return
	
func selected() -> void:
	$ColorRect.color = Color(252, 186, 3, 1)
