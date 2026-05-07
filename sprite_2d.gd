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
			# 1. Localiza o nó do Alvo na cena
			var alvo = get_parent().get_node("Alvo")
			# 2. Se a distância até o alvo for menor que 100 pixels...
			if global_position.distance_to(alvo.global_position) < 100:
			# 3. O robô "pula" para a posição exata do alvo
				global_position = alvo.global_position
				encaixado = true # Objeto travado
			
		# Evento mover mouse/toque
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			# Movimentação
			global_position = event.position
