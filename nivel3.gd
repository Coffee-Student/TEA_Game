extends Node2D

func _ready():
	# Mantém a mesma música tocando direto lá do nível 2!
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")
