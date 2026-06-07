extends Node2D

# Ajustado para o nome real da sua Scene Tree!
@onready var painel_fade = $FadeOut/ColorRect

# Nível 1 tem exatamente 3 peças de encaixe
var total_pecas = 3
var pecas_encaixadas = 0

func registrar_acerto():
	pecas_encaixadas += 1
	print("MENSAGEM DA MAIN: Uma peça foi encaixada! Total agora: ", pecas_encaixadas)
	
	if pecas_encaixadas >= total_pecas:
		_avancar_para_fase_2()

func _avancar_para_fase_2():
	# Proteção caso o nó não seja encontrado por erro de digitação
	if painel_fade == null:
		print("Erro: O nó ColorRect dentro de FadeOut não foi encontrado.")
		mudar_cena()
		return
		
	var tween = create_tween()
	# Faz o seu retângulo preto aparecer em 1.5 segundos
	tween.tween_property(painel_fade, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.5)
	tween.tween_callback(mudar_cena)

func mudar_cena():
	print("Carregando o Nível 2...")
	# Certifique-se de que o seu arquivo na pasta se chama exatamente nivel2.tscn
	get_tree().change_scene_to_file("res://nivel2.tscn")
