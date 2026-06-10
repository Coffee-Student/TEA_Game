extends ColorRect

@onready var sonic_demo: Sprite2D = $SonicDemo
@onready var alvo_demo: Sprite2D = $AlvoDemo

var posicao_inicial: Vector2
var posicao_final: Vector2

func _ready() -> void:
	# Armazena as coordenadas de origem e destino para a simulação
	posicao_inicial = sonic_demo.position
	posicao_final = alvo_demo.position
	
	_executar_loop_tutorial()

func _executar_loop_tutorial() -> void:
	# Inicializa o Tween configurado para repetição contínua (infinitos loops)
	var tween: Tween = create_tween().set_loops()
	
	# Etapa 1: Deslocamento linear da peça de demonstração até o ponto focal
	tween.tween_property(sonic_demo, "position", posicao_final, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Etapa 2: Ocultação instantânea do indicador de silhueta ao simular o encaixe
	tween.tween_property(alvo_demo, "modulate:a", 0.0, 0.1)
	
	# Etapa 3: Intervalo de retenção para fixação cognitiva do acerto
	tween.tween_interval(0.6)
	
	# Etapa 4: Transição de atenuação (Fade Out) da peça demonstrativa
	tween.tween_property(sonic_demo, "modulate:a", 0.0, 0.2)
	
	# Etapa 5: Chamada de retorno para restauração dos estados originais dos nós
	tween.tween_callback(_resetar_posicoes_demo)
	
	# Etapa 6: Transição de ressurgimento (Fade In) da peça na coordenada inicial
	tween.tween_property(sonic_demo, "modulate:a", 1.0, 0.2)
	
	# Etapa 7: Intervalo de transição padrão antes da reinicialização do ciclo visual
	tween.tween_interval(0.3)

func _resetar_posicoes_demo() -> void:
	# Restaura os atributos espaciais e de opacidade dos elementos visuais
	sonic_demo.position = posicao_inicial
	alvo_demo.modulate.a = 1.0

func _input(event: InputEvent) -> void:
	# Interrompe a exibição do tutorial e inicia a gameplay ao primeiro toque do usuário
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			set_process_input(false)
			
			var tween_fechar: Tween = create_tween()
			tween_fechar.tween_property(self, "modulate:a", 0.0, 0.4)
			tween_fechar.tween_callback(_finalizar_tutorial)

func _finalizar_tutorial() -> void:
	# Habilita o estado de jogo ativo globalmente e libera a memória do overlay
	MeuSonicDoJogo.jogo_ativo = true
	queue_free()
