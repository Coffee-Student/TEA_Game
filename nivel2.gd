extends Node2D

@onready var painel_fade: ColorRect = $FadeOut/ColorRect

var total_pecas: int = 5
var pecas_encaixadas: int = 0

func _ready() -> void:
	# Mantém a reprodução da música tema global ativa para este nível
	AudioGlobal.tocar_musica_fase("res://Sounds/BackgroundMusic.mp3")

func registrar_acerto() -> void:
	pecas_encaixadas += 1
	
	# Verifica se a condição de vitória do nível 2 foi atingida
	if pecas_encaixadas >= total_pecas:
		_avancar_para_fase_3()

func _avancar_para_fase_3() -> void:
	# Validação de segurança para existência do nó de transição
	if painel_fade == null:
		push_error("Erro: O nó ColorRect dentro de FadeOut não foi localizado no Nível 2.")
		mudar_cena()
		return
		
	# Executa a animação de transição (Fade Out) utilizando Tween
	var tween: Tween = create_tween()
	tween.tween_property(painel_fade, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(0.5)
	tween.tween_callback(mudar_cena)

func mudar_cena() -> void:
	# Transiciona o fluxo do jogo para o próximo nível
	get_tree().change_scene_to_file("res://nivel_3.tscn")
