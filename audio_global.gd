extends Node

var tocador_musica: AudioStreamPlayer
var caminho_da_musica_atual: String = ""

func _ready() -> void:
	# Inicialização do nó de áudio global persistente
	tocador_musica = AudioStreamPlayer.new()
	add_child(tocador_musica)
	tocador_musica.process_mode = Node.PROCESS_MODE_ALWAYS

func tocar_musica_fase(caminho_da_musica: String) -> void:
	# Evita reiniciar a música caso ela já esteja em reprodução
	if caminho_da_musica_atual == caminho_da_musica:
		if tocador_musica.playing:
			return
			
	# Carrega e inicia a nova trilha sonora
	var nova_musica: AudioStream = load(caminho_da_musica)
	if nova_musica:
		tocador_musica.stream = nova_musica
		tocador_musica.play()
		caminho_da_musica_atual = caminho_da_musica

func parar_musica() -> void:
	# Interrompe a reprodução atual e limpa o registro da trilha
	if tocador_musica:
		tocador_musica.stop()
	caminho_da_musica_atual = ""
