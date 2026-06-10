extends Node2D

@onready var painel_fade: ColorRect = $FadeOut/ColorRect

var total_pecas: int = 3
var pecas_encaixadas: int = 0

func _ready() -> void:
	# Mantém a reprodução da música tema global e define o estado do jogo como ativo
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")
	MeuSonicDoJogo.jogo_ativo = true

func registrar_acerto() -> void:
	pecas_encaixadas += 1
	
	# Verifica se a condição de conclusão do jogo foi atingida
	if pecas_encaixadas >= total_pecas:
		_voltar_para_tela_entrada()

func _voltar_para_tela_entrada() -> void:
	# Validação de segurança para existência do nó de transição
	if painel_fade == null:
		push_error("Erro: O nó ColorRect dentro de FadeOut não foi localizado no Nível 3.")
		mudar_cena()
		return
		
	# Executa a animação de transição (Fade Out) utilizando Tween
	var tween: Tween = create_tween()
	tween.tween_property(painel_fade, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.5)
	tween.tween_callback(mudar_cena)

func mudar_cena() -> void:
	# Retorna o fluxo do jogo para o menu principal após a conclusão
	get_tree().change_scene_to_file("res://tela_entrada.tscn")
