extends Sprite2D
	
class_name MeuSonicDoJogo
	
static var jogo_ativo = false

var arrastando = false
var encaixado = false

var posicao_inicial = Vector2.ZERO

func _ready():
	posicao_inicial = global_position
	
func _input(event):
	if not jogo_ativo:
		return
	if encaixado:
		return
		
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				arrastando = true
		else:
			if get_groups().size() == 0:
				arrastando = false
				return
				
			var meu_grupo = get_groups()[0]
			var objetos_do_grupo = get_tree().get_nodes_in_group(meu_grupo)
			
			var acertou = false
			var silhueta_alvo: Node = null
			
			for objeto in objetos_do_grupo:
				if objeto != self:
					if global_position.distance_to(objeto.global_position) < 200:
						global_position = objeto.global_position
						encaixado = true
						acertou = true
						silhueta_alvo = objeto
						
			if acertou:
				_executar_efeito_vitoria()
				if is_instance_valid(silhueta_alvo):
					silhueta_alvo.queue_free()
			
			if arrastando and not acertou and not encaixado:
				_executar_efeito_erro()
			
			arrastando = false
				
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			global_position = event.position

func _executar_efeito_vitoria():
	var escala_original = scale
	var escala_maior = escala_original * 1.2
	var tween = create_tween()
	
	tween.tween_property(self, "skew", 0.2, 0.1)
	tween.tween_property(self, "skew", 0.0, 0.1)
	
	tween.tween_property(self, "modulate", Color(0.5, 2.0, 0.5, 1.0), 0.2)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)
	
	tween.tween_property(self, "scale", escala_maior, 0.10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", escala_original, 0.10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0.4, 0.2)
	
	# Busca dinâmica pelo nó de som na raiz da cena atual
	var som_hit = get_tree().current_scene.get_node_or_null("sfx_hit")
	if som_hit:
		som_hit.play()
		
	set_process_input(false)
	
	if get_tree().current_scene.has_method("registrar_acerto"):
		get_tree().current_scene.registrar_acerto()
	
func _executar_efeito_erro():
	var tween = create_tween()
	
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x + 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x, 0.05)
	
	tween.tween_property(self, "modulate", Color(1.5, 0.8, 0.8), 0.3)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.3)
	
	# Busca dinâmica pelo nó de som de erro
	var som_erro = get_tree().current_scene.get_node_or_null("sfx_wronghit")
	if som_erro:
		som_erro.play()
		
	tween.tween_property(self, "global_position", posicao_inicial, 0.3).set_trans(Tween.TRANS_SINE)
