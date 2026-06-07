extends ColorRect

@onready var sonic_demo = $SonicDemo
@onready var alvo_demo = $AlvoDemo

var posicao_inicial: Vector2
var posicao_final: Vector2

func _ready():
	posicao_inicial = sonic_demo.position
	posicao_final = alvo_demo.position
	
	_executar_loop_tutorial()

func _executar_loop_tutorial():
	# Criamos o tween que vai rodar em loop eterno
	var tween = create_tween().set_loops()
	
	# PASSO 1: O Sonic colorido desliza até o alvo
	tween.tween_property(sonic_demo, "position", posicao_final, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# PASSO 2: No momento do encaixe, o alvo P&B some instantaneamente
	tween.tween_property(alvo_demo, "modulate:a", 0.0, 0.1)
	
	# PASSO 3: Pausa de 0.6 segundos com o Sonic colorido parado no lugar certo
	tween.tween_interval(0.6)
	
	# PASSO 4: O Sonic colorido some suavemente para fazer a transição de volta
	tween.tween_property(sonic_demo, "modulate:a", 0.0, 0.2)
	
	# PASSO 5: Chamamos uma função separada para resetar as posições com segurança
	tween.tween_callback(_resetar_posicoes_demo)
	
	# PASSO 6: O Sonic colorido reaparece na posição inicial
	tween.tween_property(sonic_demo, "modulate:a", 1.0, 0.2)
	
	# PASSO 7: Uma mini pausa antes de começar o próximo ciclo do "vídeo"
	tween.tween_interval(0.3)

# Função auxiliar que o Tween chama no PASSO 5 para evitar erros de indentação
func _resetar_posicoes_demo():
	sonic_demo.position = posicao_inicial
	alvo_demo.modulate.a = 1.0

# Se o jogador tocar na tela, fecha o tutorial e ativa o jogo real
func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			
			set_process_input(false)
			
			var tween_fechar = create_tween()
			tween_fechar.tween_property(self, "modulate:a", 0.0, 0.4)
			tween_fechar.tween_callback(_finalizar_tutorial)

# Função chamada quando a animação de fechar o tutorial termina
func _finalizar_tutorial():
	# Ativa o jogo real
	MeuSonicDoJogo.jogo_ativo = true
	# Deleta o tutorial da árvore de nós completamente
	queue_free()
