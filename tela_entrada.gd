extends Node2D

@onready var painel_fade: ColorRect = $CanvasFade/ColorRect
@onready var musica_fundo: AudioStreamPlayer2D = $BackgroundMusic

func _ready() -> void:
	if painel_fade:
		painel_fade.modulate.a = 0.0
	
	# Inicializa a trilha sonora do menu principal através do gerenciador global
	AudioGlobal.tocar_musica_fase("res://Sounds/SonicOpening.mp3")
	
func _input(event: InputEvent) -> void:
	# Detecta qualquer interação inicial do usuário para iniciar o jogo
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			set_process_input(false)
			_iniciar_jogo()

func _iniciar_jogo() -> void:
	# Validação de segurança para o nó de transição visual
	if painel_fade == null:
		mudar_para_nivel_1()
		return
		
	var tween: Tween = create_tween()
	
	# Executa o efeito de transição (Fade Out) na tela
	tween.tween_property(painel_fade, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_SINE)
	
	# Reduz linearmente o volume do áudio global em sincronia com o efeito visual
	if AudioGlobal.tocador_musica:
		tween.parallel().tween_property(AudioGlobal.tocador_musica, "volume_db", -40.0, 0.7)
	
	tween.tween_callback(mudar_para_nivel_1)

func mudar_para_nivel_1() -> void:
	# Finaliza a execução do áudio do menu e realiza a transição para o primeiro nível
	AudioGlobal.parar_musica()
	get_tree().change_scene_to_file("res://main.tscn")
