extends Node

#region Variables

#exportando o menu
@export var Menu : CanvasLayer

#exportando o primeiro mundo
@export var P_World : Node2D

#exportando o menu de opções
@export var Options : CanvasLayer

@export var Start : MyButton #Botão de Start

@export var Option : MyButton #Botão de Opções

@export var Quit : MyButton #Botão de Sair

@export var Return_menu : Button #Botão de Retornar ao menu

#minha quantidade maxima de super
const MAX_SUPER_BONUS : int = 8

#minha quantidade maxima de pontos moedas
const MAX_COIN_BONUS : int = 100_000_000

#tempo dos tween 
const SEG_TWEEN : float = 0.5

#minha quantidade de bonus de super
var Super_Bonus : int = 0

var Previous_Coins : int = 0

#minha quantidade de pontos moedas
var Coin_Bonus : int = 0

#vereficando se o player morreu
var Player_Dead : bool = false

#variavel que sera usada pelo método Acresim, para ser somado por um até um certo intervalo
var Intervalo : int = 0

#variavel responsavel por criar um tween no método Acresim Points
var Coin_Tween

#variavel responsavel por criar uma interpolação no método Decresim super
var Super_Tween

#boleano que vareficara se eu posso usar o debug mode
var DEBUG_Active : bool = false

#boleano que ativara a super velocidade
var Vel_Active : bool = false

#boleano que ativara a invensibilidade
var Invincible_Active : bool = false

#boleano que vera se eu posso criar espinhos
var Is_CreateSpike : bool = true

#meu modo de jogo atual
var Current_Mode : String = ""

#endregion

#region Methods

#método que rodara no inicio do game
func _ready() -> void:

	if not Start: return #SE Start NÃO EXISTIR retorna

	#conectando os sinais aos seus respectivos métodos
	VM.Conected_Signals(Start.button_up, on_start_button_up)
	VM.Conected_Signals(Option.button_up, on_opitions_button_up)
	VM.Conected_Signals(Quit.button_up, on_quit_button_up)
	VM.Conected_Signals(Return_menu.button_up, on_return_button_up)


################################################################################

#método que ira notificar se o botão "Start" foi pressionado
func on_start_button_up() -> void:
	
	#deixando o primeiro mundo visivel
	P_World.visible = true
	
	#mudando a visibilidade do node HUD de P_World
	P_World.get_node("HUD").visible = true
	
	#mudando o tipo de processamento do primeiro o mundo
	P_World.process_mode = Node.PROCESS_MODE_INHERIT
	
	#meu menu não é processado
	Menu.process_mode = Node.PROCESS_MODE_DISABLED
	
	#ele deixa de ser visivel
	Menu.visible = false

################################################################################

#método que ira notificar se o botão "Opitions" foi pressionado
func on_opitions_button_up():
	
	#as opções ficam visiveis
	Options.visible = true
	
	#meu menu é dasabilitado
	Menu.process_mode = Node.PROCESS_MODE_DISABLED

################################################################################

#método que ira notificar se o botão "Quit" foi pressionado
func on_quit_button_up() -> void:
	
	#o jogo acaba (:
	get_tree().quit()

################################################################################

###EM DESENVOLVIMENTO
func on_return_button_up() -> void:
	
	Options.visible = false
	Menu.process_mode = Node.PROCESS_MODE_INHERIT

################################################################################

#endregion

#region My Methods

#método que dara um efeito quando minha pontuação aumentar
func Acresim_Points(_Pontuacao : int):
	
	if Coin_Bonus != MAX_COIN_BONUS:

		#meus pontos previstos são atualizados
		Previous_Coins += _Pontuacao 
		
		#SE Coin tween existir ou coin bonus for igual a max coin bonus, eu deleto esse tween
		if Coin_Tween: Coin_Tween.kill()
		
		#criando uma interpolação(tween)
		Coin_Tween = create_tween()
		
		#SÓ POR GARANTIA conecte o tween
		#a mim para quando eu for liberado da mémoria ele tambem va junto
		Coin_Tween.bind_node(self)
		
		#SE os pontos previstos forem menores que max coin bonus
		if Previous_Coins < MAX_COIN_BONUS:
			#interpolo a minha propriedade Coin bunus para ela ser igual a Previous Coins
			Coin_Tween.tween_property(self,"Coin_Bonus",Previous_Coins, SEG_TWEEN)
		
		#SE NÃO, minha potuação é igual a minha potuação maxima
		#SE NÃO
		else:
			#interpolo a minha propriedade Coin bunus para ela ser igual a max Coins
			Coin_Tween.tween_property(self,"Coin_Bonus", MAX_COIN_BONUS, SEG_TWEEN)

################################################################################

#método que ira executar uma animação que fara meus pontos de super deserem
func Decresim_Super():
	
	#SE Super tween existir
	if Super_Tween:

		#eu deleto esse tweens
		Super_Tween.kill()
	
	#crio um tween
	Super_Tween = create_tween()

	#conecto ele a mim para ser liberado da memória junto de mim
	Super_Tween.bind_node(self)

	#interpolo minha propriedade super bonus até chegar a 0
	Super_Tween.tween_property(self, "Super_Bonus",0, SEG_TWEEN)

################################################################################

#método global para criar o efeito de freeze frame (quadro congelado)
func Freeze_Frame(_ScaleTime : float = 0.1, _Duration : float = 0.035):
	
	#mudando a escala de tempo do jogo
	Engine.time_scale = _ScaleTime

	#ESPERE ATÉ QUE o timer criado pare
	await get_tree().create_timer(_Duration, true, false, true).timeout

	#escala de tempo volta ao normal
	Engine.time_scale = 1.0

################################################################################

#endregion
