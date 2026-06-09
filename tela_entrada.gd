extends Node2D

@onready var painel_fade = $CanvasFade/ColorRect
@onready var musica_fundo = $MusicaFundo # Puxa o nó da música

func _ready():
	if painel_fade:
		painel_fade.modulate.a = 0.0
	
	# Esta linha diz ao nosso script global para tocar a música de abertura
	AudioGlobal.tocar_musica_fase("res://Sounds/SonicOpening.mp3")
	
func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			set_process_input(false)
			_iniciar_jogo()

func _iniciar_jogo():
	if painel_fade == null:
		mudar_para_nivel_1()
		return
		
	var tween = create_tween()
	# Faz o fade preto na tela
	tween.tween_property(painel_fade, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_SINE)
	
	# Faz a música global abaixar o volume suavemente junto com o fade preto
	if AudioGlobal.tocador_musica:
		tween.parallel().tween_property(AudioGlobal.tocador_musica, "volume_db", -40.0, 0.7)
	
	tween.tween_callback(mudar_para_nivel_1)

func mudar_para_nivel_1():
	# Para a música de abertura de vez antes de trocar para o jogo
	AudioGlobal.parar_musica()
	get_tree().change_scene_to_file("res://main.tscn")
