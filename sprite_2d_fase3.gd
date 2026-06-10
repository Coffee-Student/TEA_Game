# Isso faz o script herdar TODAS as funções e mecânicas de arrastar do seu script antigo!
extends "res://sprite_2d.gd" 

# Aqui nós vamos ajustar apenas a posição final do encaixe sem quebrar o resto do jogo
func _ready():
	# Mantém o comportamento de inicialização do script original
	super._ready()
