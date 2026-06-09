extends Node

var tocador_musica : AudioStreamPlayer
var caminho_da_musica_atual : String = ""

func _ready():
	# Criamos o tocador de som que fica "vivo" o jogo inteiro
	tocador_musica = AudioStreamPlayer.new()
	add_child(tocador_musica)
	# Garante que ele não pare por causa de pauses no jogo
	tocador_musica.process_mode = Node.PROCESS_MODE_ALWAYS

func tocar_musica_fase(caminho_da_musica: String):
	# Se a música que pediram para tocar JÁ FOR a que está tocando agora, não faz nada!
	if caminho_da_musica_atual == caminho_da_musica:
		if tocador_musica.playing:
			return # Deixa a música continuar tocando sem cortes
			
	# Se for uma música diferente, aí sim ele troca e toca
	var nova_musica = load(caminho_da_musica)
	if nova_musica:
		tocador_musica.stream = nova_musica
		tocador_musica.play()
		caminho_da_musica_atual = caminho_da_musica

func parar_musica():
	if tocador_musica:
		tocador_musica.stop()
	caminho_da_musica_atual = ""
