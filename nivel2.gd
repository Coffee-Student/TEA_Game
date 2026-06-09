extends Node2D

func _ready():
	# Diz ao sistema global para manter a mesma música tocando
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")
