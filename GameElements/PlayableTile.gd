extends Node2D

var textures = [
	preload('../Visuals/Texture1.png'),
	preload('../Visuals/Texture2.png'),
	preload('../Visuals/Texture3.png'),
	preload('../Visuals/Texture4.png')
	]

func _ready() -> void:
	var randomText = randi() % 4
	$Sprite.texture = textures[randomText]
	return
