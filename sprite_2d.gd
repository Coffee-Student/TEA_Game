extends Sprite2D

var arrastando = false

func _input(event):
	# Evento toque/clique
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		# Touch Down
		if event.pressed:
			# Verifica toque "touch down"
			if get_rect().has_point(to_local(event.position)):
				arrastando = true
		else:
			# Soltou o toque "touch up"
			arrastando = false
			
	# Arrastando para se mover
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if arrastando:
			# Movimentação
			global_position = event.position
