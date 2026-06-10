extends Sprite2D
	
class_name MeuSonicDoJogo
	
static var jogo_ativo: bool = false

var arrastando: bool = false
var encaixado: bool = false

var posicao_inicial: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Armazena a coordenada inicial para o retorno em caso de erro
	posicao_inicial = global_position
	
func _input(event: InputEvent) -> void:
	if not jogo_ativo or encaixado:
		return
		
	# Gerenciamento de cliques do mouse e toques na tela (Touchscreen)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				arrastando = true
		else:
			if get_groups().size() == 0:
				arrastando = false
				return
				
			var meu_grupo: StringName = get_groups()[0]
			var objetos_do_grupo: Array[Node] = get_tree().get_nodes_in_group(meu_grupo)
			
			var acertou: bool = false
			var silhueta_alvo: Node = null
			
			# Varre o grupo para identificar proximidade com o ponto de encaixe
			for objeto in objetos_do_grupo:
				if objeto != self:
					if global_position.distance_to(objeto.global_position) < 200:
						global_position = objeto.global_position
						encaixado = true
						acertou = true
						silhueta_alvo = objeto
						break
						
			if acertou:
				_executar_efeito_vitoria()
				if is_instance_valid(silhueta_alvo):
					silhueta_alvo.queue_free()
			elif arrastando and not encaixado:
				_executar_efeito_erro()
			
			arrastando = false
				
	# Gerenciamento de movimento do arraste (Mouse ou Drag)
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			global_position = event.position

func _executar_efeito_vitoria() -> void:
	var escala_original: Vector2 = scale
	var escala_maior: Vector2 = escala_original * 1.2
	var tween: Tween = create_tween()
	
	# Animação de distorção e feedback de cor positiva
	tween.tween_property(self, "skew", 0.2, 0.1)
	tween.tween_property(self, "skew", 0.0, 0.1)
	tween.tween_property(self, "modulate", Color(0.5, 2.0, 0.5, 1.0), 0.2)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.2)
	
	# Efeito de pulso escalar e opacidade
	tween.tween_property(self, "scale", escala_maior, 0.10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", escala_original, 0.10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0.4, 0.2)
	
	# Execução do efeito sonoro de acerto
	var som_hit: AudioStreamPlayer = get_tree().current_scene.get_node_or_null("sfx_hit") as AudioStreamPlayer
	if som_hit:
		som_hit.play()
		
	set_process_input(false)
	
	# Comunicação de sucesso com o nó gerenciador da fase ativa
	if get_tree().current_scene.has_method("registrar_acerto"):
		get_tree().current_scene.registrar_acerto()
	
func _executar_efeito_erro() -> void:
	var tween: Tween = create_tween()
	
	# Efeito visual de vibração horizontal (Shake)
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x + 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x, 0.05)
	
	# Feedback cromático negativo
	tween.tween_property(self, "modulate", Color(1.5, 0.8, 0.8), 0.3)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.3)
	
	# Execução do efeito sonoro de erro
	var som_erro: AudioStreamPlayer = get_tree().current_scene.get_node_or_null("sfx_wronghit") as AudioStreamPlayer
	if som_erro:
		som_erro.play()
		
	# Retorno suavizado da peça para a posição de origem
	tween.tween_property(self, "global_position", posicao_inicial, 0.3).set_trans(Tween.TRANS_SINE)
