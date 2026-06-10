extends Node2D

# Pega o painel preto de FadeOut da Fase 3
@onready var painel_fade = $FadeOut/ColorRect

# Defina aqui quantas peças/palavras precisam ser encaixadas na Fase 3 para vencer
var total_pecas = 3
var pecas_encaixadas = 0

func _ready():
	# Mantém a mesma música tocando direto lá do nível 2!
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")
	MeuSonicDoJogo.jogo_ativo = true

func registrar_acerto():
	pecas_encaixadas += 1
	print("MENSAGEM DO NÍVEL 3: Uma peça foi encaixada! Total agora: ", pecas_encaixadas)
	
	if pecas_encaixadas >= total_pecas:
		_voltar_para_tela_entrada()

func _voltar_para_tela_entrada():
	# Proteção caso o nó de Fade Out não seja encontrado na árvore da Fase 3
	if painel_fade == null:
		print("Erro: O nó ColorRect dentro de FadeOut não foi encontrado na Fase 3.")
		mudar_cena()
		return
		
	var tween = create_tween()
	# Faz o retângulo preto da tela aparecer em 1.5 segundos
	tween.tween_property(painel_fade, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.5)
	tween.tween_callback(mudar_cena)

func mudar_cena():
	print("Parabéns! Jogo concluído. Voltando para a tela de entrada...")
	get_tree().change_scene_to_file("res://tela_entrada.tscn")
