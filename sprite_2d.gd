extends Sprite2D

var arrastando = false
var encaixado = false

func _input(event):
	if encaixado:
		return #Objeto destravado
	# Evento toque/clique
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed: # Touch Down
			if get_rect().has_point(to_local(event.position)):
				arrastando = true
		else:
			arrastando = false # Touch up
			var meu_grupo = get_groups()[0]
			# Procura na cena todos os objetos que estão no mesmo grupo
			var objetos_do_grupo = get_tree().get_nodes_in_group(meu_grupo)
		
			for objeto in objetos_do_grupo:
				if objeto != self:
					if global_position.distance_to(objeto.global_position) < 200:
						global_position = objeto.global_position
						encaixado = true
						
						_executar_efeito_vitoria()
						
		# Evento mover mouse/toque
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			# Movimentação
			global_position = event.position

func _executar_efeito_vitoria():
	# 1. Guardamos o tamanho atual que você definiu na interface
	var escala_original = scale
		# 2. Calculamos um tamanho 20% maior baseado na escala atual
	var escala_maior = escala_original * 1.2
	
	var tween = create_tween()
		
	tween.tween_property(self, "skew", 0.2, 0.1)
	tween.tween_property(self, "skew", 0.0, 0.1)
	tween.tween_property(self, "modulate", Color(2.422, 3.809, 6.052, 1.0), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.5)
	
	
