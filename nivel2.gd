extends Node2D

# Pega o painel preto de FadeOut da Fase 2
@onready var painel_fade = $FadeOut/ColorRect

# Defina aqui quantas peças/palavras precisam ser encaixadas na Fase 2 para vencer
var total_pecas = 5
var pecas_encaixadas = 0

func _ready():
	# Diz ao sistema global para manter a mesma música tocando
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")

func registrar_acerto():
	pecas_encaixadas += 1
	print("MENSAGEM DO NÍVEL 2: Uma peça foi encaixada! Total agora: ", pecas_encaixadas)
	
	if pecas_encaixadas >= total_pecas:
		_avancar_para_fase_3()

func _avancar_para_fase_3():
	# Proteção caso o nó de Fade Out não seja encontrado na árvore da Fase 2
	if painel_fade == null:
		print("Erro: O nó ColorRect dentro de FadeOut não foi encontrado na Fase 2.")
		mudar_cena()
		return
		
	var tween = create_tween()
	# Faz o retângulo preto da tela aparecer em 1.5 segundos
	tween.tween_property(painel_fade, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.5)
	tween.tween_callback(mudar_cena)

func mudar_cena():
	print("Carregando o Nível 3...")
	# Certifique-se de que o seu arquivo na pasta se chama exatamente nivel3.tscn
	get_tree().change_scene_to_file("res://nivel_3.tscn")
