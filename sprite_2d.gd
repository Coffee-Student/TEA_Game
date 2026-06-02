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
		return #Objeto destravado
		
	# Evento toque/clique
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed: # Touch Down
			if get_rect().has_point(to_local(event.position)):
				arrastando = true
		else: # Touch up
			var meu_grupo = get_groups()[0]
			# Procura na cena todos os objetos que estão no mesmo grupo
			var objetos_do_grupo = get_tree().get_nodes_in_group(meu_grupo)
			
			var acertou = false
			
			for objeto in objetos_do_grupo:
				if objeto != self:
					if global_position.distance_to(objeto.global_position) < 200:
						global_position = objeto.global_position
						encaixado = true
						acertou = true
						
						_executar_efeito_vitoria()
			
			# Agora sim! 'arrastando' ainda é true aqui se o jogador estava movendo este objeto
			if arrastando and not acertou and not encaixado:
				_executar_efeito_erro()
			
			# Só desligamos o arrasto aqui no final de tudo!
			arrastando = false
				
	# Evento mover mouse/toque
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			# Movimentação
			global_position = event.position
				
		# Evento mover mouse/toque
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			# Movimentação
			global_position = event.position

func _executar_efeito_vitoria():
	# 1. Guardamos o tamanho original exato antes de qualquer mudança
	var escala_original = scale
	var escala_maior = escala_original * 1.2
	
	var tween = create_tween()
	
	# Efeito molejo
	tween.tween_property(self, "skew", 0.2, 0.1)
	tween.tween_property(self, "skew", 0.0, 0.1)
	
	# Piscada verde de acerto
	tween.tween_property(self, "modulate", Color(0.5, 2.0, 0.5, 1.0), 0.2)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)
	
	# Efeito mola seguro (usando as variáveis guardadas)
	tween.tween_property(self, "scale", escala_maior, 0.10).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", escala_original, 0.10).set_trans(Tween.TRANS_CUBIC)
	
	# Transforma o Sonic em uma silhueta dourada/amarela brilhante constante e semi-transparente
	tween.tween_property(self, "modulate", Color(2.5, 1.997, 0.202, 0.259), 0.2)
	
	# Som e tranca física de clique
	get_node("/root/Main/sfx_hit").play()
	set_process_input(false)
	
	# CONFIRME SE ESTAS LINHAS ESTÃO AQUI:
	if get_tree().current_scene.has_method("registrar_acerto"):
		get_tree().current_scene.registrar_acerto()
	
func _executar_efeito_erro():
	var tween = create_tween()
	
	# 1. Efeito "Tremoço/Não": move um pouco para a esquerda e direita rapidamente
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x + 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x - 15, 0.05)
	tween.tween_property(self, "global_position:x", global_position.x, 0.05)
	
	# 2. Pisca em um tom vermelho sutil indicando erro
	tween.tween_property(self, "modulate", Color(1.5, 0.8, 0.8), 0.3)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.3)
	
	get_node("/root/Main/sfx_wronghit").play()
	# 3. Faz o Sonic voltar suavemente para o lugar de onde saiu
	tween.tween_property(self, "global_position", posicao_inicial, 0.3).set_trans(Tween.TRANS_SINE)
