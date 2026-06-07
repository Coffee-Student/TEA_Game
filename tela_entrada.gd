extends Node2D

# Puxa a referência exata do ColorRect que acabamos de criar
@onready var painel_fade = $CanvasFade/ColorRect

func _ready():
	# Garante que o painel começa invisível por segurança
	if painel_fade:
		painel_fade.modulate.a = 0.0

func _input(event):
	# Detecta se a criança tocou na tela ou clicou com o mouse
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			# Desativa temporariamente novos cliques para evitar bugs de transição dupla
			set_process_input(false)
			_iniciar_jogo()

func _iniciar_jogo():
	if painel_fade == null:
		mudar_para_nivel_1()
		return
		
	var tween = create_tween()
	# Faz o quadrado preto aparecer suavemente em 0.7 segundos
	tween.tween_property(painel_fade, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_SINE)
	# Assim que o fade terminar, chama a função para trocar de cena
	tween.tween_callback(mudar_para_nivel_1)

func mudar_para_nivel_1():
	print("Saindo do menu... Indo para o Nível 1!")
	# Transiciona para a sua cena principal
	get_tree().change_scene_to_file("res://main.tscn")
