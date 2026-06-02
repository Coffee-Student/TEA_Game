extends Node2D

# Este é o script da FASE. Ele sim gerencia o jogo inteiro!
var total_pecas = 3
var pecas_encaixadas = 0

func registrar_acerto():
	pecas_encaixadas += 1
	print("Peças encaixadas no total: ", pecas_encaixadas)
	
	if pecas_encaixadas >= total_pecas:
		_avancar_para_fase_2()

func _avancar_para_fase_2():
	# Espera o efeito do último Sonic terminar
	await get_tree().create_timer(1.5).timeout
	
	# Muda o jogo para a cena do Nível 2
	get_tree().change_scene_to_file("res://nivel2.TSCN")
