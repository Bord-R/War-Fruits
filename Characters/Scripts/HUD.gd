extends CanvasLayer

#region Variables

#criando uma aba
@export_group("Nodes")

#meu player
@export var Player : FruitsCharacter

#HUD DA VIDA
@export var Life : Sprite2D

#HUD DOS PONTOS
@export var Points : Sprite2D

#pontuação
@export var Pontucao : Label

#tela de debug
@export var DEBUG_Code : Sprite2D

#lineedit debug
@export var Line_Code : LineEdit

#criando aba
@export_group("Skins")

@export_subgroup("Player Skins")

#skin normal
@export var Skin_Normal : Texture2D

#skin de maid
@export var Maid_Skin : Texture2D

#region Simbolic Constants

#vida maxima
const LIFE_MAX : int = 4

#3/4 de vida
const LIFE_THREE_FOUR : int = 3

#2/4 de vida
const LIFE_TWO_FOUR : int = 2

#1/4 de vida
const LIFE_ONE_FOUR : int = 1

#vida zerada
const LIFE_ZERO : int = 0

#corte horizontal original
const HFRAME_NORMAL : int = 4

#corte vertical original
const VFRAME_NORMAL : int = 6

#valor a ser acresentado
const ACRECIMO : float = 0.001

#rotação maxima
const MAX_ROT : float = 0.2

#rotação minima
const MIN_ROT : float = -0.2

#meus segundos
const SEGS : Dictionary = {"COMUM" : 0.15, "MEDIO": 0.5, "LONGO": 1.5}

#posição original de debugcode
const DEBUGORIGINAL_POS : Vector2 = Vector2(160, 400)

#posição quando debugcode estiver em cena
const DEBUGSCENE_POS : Vector2 = Vector2(160, 320)

#posição fora da tela do life
const LIFEFADE_POS : Vector2 = Vector2(-45, 40)

#posição fora da tela do points
const POINTFADE_POS : Vector2 = Vector2(144, -96)

#posição na tela do game over
const GAMEOVER_POS : Vector2 = Vector2(188, 45)

#distancia minima do mouse
const MIN_MOUSE_DIST : float = 100.0

#minha transparencia normal
const NORMAL_TRANSPARENT : Color = Color.WHITE

#minha transparenica modificada
const MOD_TRANSPARENT : Color = Color(1.0 ,1.0 ,1.0 , 0.25)

#endregion

#boleano que vereficara a rotação da HUD life
var Bool_life : bool = true

#boleano que vereficara se eu posso ficar com skin de maid
var Bool_maid : bool = false

#animação de rotação
var Tween_Rot : Tween = null

#tempo que life fica girando para um lado
var Seg_Life : float = 2.0

#animação de confirmação
var Tween_Submmit : Tween = null

#animação de aparecer
var Tween_aparicion : Tween = null

#tween de quando o player morrer
var  Tween_Dead : Tween = null

#distancia atual do mouse
var dist_mouse : float = 0.0

#variavel para facilitar os comandos
var IsHelped : bool = false

#endregion

#region Methods

#método que rodara qunado eu estiver pronto
func _ready() -> void: 

	#SE o line Code existir eu conecto o sinal ao método
	if Line_Code: VM.Conected_Signals(Line_Code.text_submitted, Enter_text)
	
	Animated_Life() #rodando método para animar o node life

################################################################################

#método que rodara a cada frame do game
func _process(_delta: float) -> void:
	
	#método que rodara a janela de debug
	DEBUG_Mode()

	#SE o player não estiver morto
	if !Game.Player_Dead:

		#método que rodara a vida do player
		Life_HUD()
		
		#método que rodara os pontos do player
		Points_HUD()

		return #retorna
	
	#Método que rodara quando o player morrer
	Dead_Player_Commands()

################################################################################

#endregion

#region My Methods

#método que rodara a vida do player
func Life_HUD():

	#método que mudara minha transparencia quando o mouse chegar perto
	Transparent_In_Combat(Life)

	#SE a vida for menor ou igual que 0, eu reinicio o game
	if Player.Player_life <= 0.0:
		
		#o player morreu
		Game.Player_Dead = true
		
		#o jogo reinicia
		#get_tree().reload_current_scene()
	
	#region Frame
	
	#SE a vida do player for igual ao valor maximo, eu executo o código
	if Player.Player_life == LIFE_MAX:
		
		Life.frame = 0
	
	#SE NÃO, SE a vida do player for igual a 3/4, eu executo o código
	elif Player.Player_life == LIFE_THREE_FOUR:
		
		Life.frame = 1
	
	#SE NÃO, SE a vida do player for igual a 2/4, eu executo o código
	elif Player.Player_life == LIFE_TWO_FOUR:
		
		Life.frame = 2
	
	#SE NÃO, SE a vida do player for igual a 1/4, eu executo o código
	elif Player.Player_life == LIFE_ONE_FOUR:
		
		Life.frame = 3
	
	#SE NÃO, SE a vida do player for igual a 0, eu executo o código
	elif Player.Player_life == LIFE_ZERO:
		
		Life.frame = 4
	
	#endregion

################################################################################

#método que fara a animaçãõ de Life
func Animated_Life():

	#SE o tween_rot existir, eu deleto esse tween
	if Tween_Rot: Tween_Rot.kill()
	
	#crio o tween(interpolação)
	Tween_Rot = create_tween()
	
	#SÓ POR GARANTIA eu conecto esse tween a mim
	Tween_Rot.bind_node(self)
	
	#defino ele como uma animação que durara pra sempre até ser liberado da mémoria
	Tween_Rot.set_loops()
	
	#ele gira pra direita por seg life segundos
	Tween_Rot.tween_property(Life,"rotation",MAX_ROT, Seg_Life).set_ease(Tween.EASE_IN_OUT)
	
	#ele gira pra esquerda por seg life segundos
	Tween_Rot.tween_property(Life,"rotation",MIN_ROT, Seg_Life).set_ease(Tween.EASE_IN_OUT)

################################################################################

#método que rodara os pontos do player
func Points_HUD():
	
	#método que fara eu ficar transparente quando o mouse chegar perto de mim
	Transparent_In_Combat(Points)

	#modificando o texto da pontuacao para ele ser igual a coin bonus
	Pontucao.text = str(Game.Coin_Bonus)
	
	#SE os pontos de super forem menores do que os pontos maximos, a sprite da hud de pontos é igual a quantidade de pontos atual
	if Game.Super_Bonus <= Game.MAX_SUPER_BONUS: Points.frame = Game.Super_Bonus
	else: Game.Super_Bonus = Game.MAX_SUPER_BONUS #SE NÃO, os pontos são iguais aos seus pontos maximos
	
	#SE o player morreu
	if Game.Player_Dead:
		
		#eu renicio os pontos
		Game.Super_Bonus = 0
		Game.Coin_Bonus = 0

################################################################################

#método que fara tudo que é preciso quando o player morrer
func Dead_Player_Commands():
	
	#SE esse tween existir eu deleto ele
	if Tween_Dead: Tween_Dead.kill()

	#crio um tween
	Tween_Dead = create_tween()

	#fazendo life sair de cena
	Tween_Dead.parallel().tween_property(Life, "position", LIFEFADE_POS, SEGS["COMUM"])
	
	#fazendo points sair de cena
	Tween_Dead.parallel().tween_property(Points, "position", POINTFADE_POS, SEGS["COMUM"])

	#ESPERE ATÉ a animação acabar
	await Tween_Dead.finished

	#points fica invisivel
	Points.visible = false

	#life fica invisivel
	Life.visible = false

################################################################################

#método que fara meus filhos ficarem semi transparentes quando o player estiver em combate
func Transparent_In_Combat(_node : Sprite2D):
	
	#crio um tween local que mudara minha transparencia
	var _tween_alpha : Tween = null

	#SE eu Não apertar o botão esquerdo e direito do mouse ou o player não ter arma
	if  !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !Input.is_key_label_pressed(KEY_SPACE) or !Player.Possui_arma:
		
		if _tween_alpha: _tween_alpha.kill() #SE esse tween existe, eu deleto ele

		_tween_alpha = create_tween().bind_node(_node) #crio tween e conecto ele a mim

		_tween_alpha.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR) #defino o tipo de transição

		#a transparencia de _node fica normal
		_tween_alpha.parallel().tween_property(_node, "modulate", NORMAL_TRANSPARENT, SEGS["COMUM"])

		return #retorna caso seja verdadeiro

	if _tween_alpha: _tween_alpha.kill() #SE esse tween existe, eu deleto ele

	_tween_alpha = create_tween().bind_node(_node) #crio tween e conecto ele a mim

	_tween_alpha.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR) #defino o tipo de transição

	#a transparencia é modificada
	_tween_alpha.parallel().tween_property(_node, "modulate", MOD_TRANSPARENT, SEGS["COMUM"])
	
################################################################################

#método que adiministrara o debug mode
func DEBUG_Mode():

	#SE eu apertar DEbug MODE 
	if Input.is_action_just_pressed("DEBUG_MODE"):
		#eu troco o valor de debug active
		Game.DEBUG_Active = !Game.DEBUG_Active

		Game.Current_Mode = "" #fico com o texto vazio

	#SE debug active for verdadeiro
	if Game.DEBUG_Active and !Game.Player_Dead:

		#animação de entrar em cena
		Tween_fade_in(DEBUG_Code, DEBUGSCENE_POS)

		#posso editar o line code
		Line_Code.edit()

		#retorna
		return

	#deixo de poder editar o line code
	Line_Code.unedit()

	#animação de sair da cena
	Tween_fade_out(DEBUG_Code, DEBUGORIGINAL_POS)

################################################################################

#método aparecer na cena
func Tween_fade_in(_object : Sprite2D, _position_scene : Vector2):

	#o objeto fica visivel
	_object.visible = true

	#SE Tween aparicion existir, eu deleto esse tween
	if Tween_aparicion: Tween_aparicion.kill()

	#crio o tween
	Tween_aparicion = create_tween()
	
	#conecto ele a mim para ele ser liberado da memória junto de mim
	Tween_aparicion.bind_node(self)

	#transciono para aparecer em cena
	Tween_aparicion.tween_property(_object, "position", _position_scene, SEGS["COMUM"]).set_ease(Tween.EASE_IN_OUT)

################################################################################

#método sair da cena
func Tween_fade_out(_object : Node2D, _position_origin : Vector2):

	#SE Tween aparicion existir, eu deleto esse tween
	if Tween_aparicion: Tween_aparicion.kill()

	#crio um tweem
	Tween_aparicion = create_tween()
	
	#conecto ele a mim para ele ser liberado da memória junto de mim
	Tween_aparicion.bind_node(self)

	#transciono para sair da cena
	Tween_aparicion.tween_property(_object, "position", _position_origin, SEGS["COMUM"]).set_ease(Tween.EASE_OUT_IN)

	#ESPERE ATÉ QUE tween aparicion acabe
	await Tween_aparicion.finished

	#o objeto vida invisivel
	_object.visible = false

################################################################################

#método que rodara quando o código for subtimido
func Enter_text(_text : String):

	#dando o efeito ao terminar de digitar
	Submmit_Text_Tween()

	#cadeia de códigos

	if _text == "PEAR_GOAT01" or (IsHelped and _text == "1"):
		Game.Super_Bonus = Game.MAX_SUPER_BONUS #código de super

		Game.Current_Mode = "SUPER_MAX" #meu modo de jogo

	elif _text == "BIG_LMAO02" or (IsHelped and _text == "2"):

		Game.Vel_Active = !Game.Vel_Active #código de supervelocidade

		#SE vel active for verdadeiro
		if Game.Vel_Active:

			#o vel é mudado pra ser igual a DEbug vel
			Player.vel = Player.DEBUG_VEL

		else: #SE NÃO

			#o vel volta a ter seu valor original
			Player.vel = Player.VEL_MAX

		Mod_Text(Game.Vel_Active, "I_SHOW_SPEED_MODE")

	elif _text == "LITTLE_APPLE03" or (IsHelped and _text == "3"):

		Game.Invincible_Active = !Game.Invincible_Active #código de super

		Mod_Text(Game.Invincible_Active, "INVINCIBLE_MODE")

	elif _text == "ROTTEN_AVOCADO04" or (IsHelped and _text == "4"):
		
		Bool_maid = !Bool_maid #código de skin maid uwu

		#troco a skin atual do player5
		Swap_Skin(Bool_maid, Maid_Skin, 4, 5, "MAID_MODE_UWU")

	elif _text == "FAT_PINEAPPLE05" or (IsHelped and _text == "5"):

		Game.Acresim_Points(Game.MAX_COIN_BONUS) #código de pontos

		Game.Current_Mode = "COIN_MAX" #meu modo de jogo

	elif _text == "I_LOVE...06" or (IsHelped and _text == "6"):

		Player.Dano_sofrido = true #o player sofre dano

		Game.Current_Mode = "" #modo de jogo nulo

		Player.animação("hit") #player executa animação

		Player.Player_life = 0 #código de matar o player

	elif _text == "HELP_ME07" or (IsHelped and _text == "7"):
		
		IsHelped = !IsHelped #mudo o valor de IsHelped

		Game.Current_Mode = "NOOB_MODE" #modo noob

	else: #SE NÃO

		Game.Current_Mode = "INVALID_CODE" # código invalido

################################################################################

#método que atualizara o texto atual
func Mod_Text(_active : bool, _text : String):
	
	#SE estiver ativo
	if _active:
		#eu mudo o texto
		Game.Current_Mode = _text

		#retorna
		return
	
	#meu mudo para um texto vazio
	Game.Current_Mode = ""

################################################################################

#método que trocara a skin do player
func Swap_Skin(_condicion : bool, _texture : Texture2D, _hframe : int, _vframe : int, _mode : String):

	#SE a condicion for verdadeira
	if _condicion:

		#eu troco a textura do player
		Player.texture.texture = _texture

		#mudo o hframe pra ajustar o corte horizontal
		Player.texture.hframes = _hframe

		#mudo o vframe pra ajustar o corte vertical
		Player.texture.vframes = _vframe

		#exibo o nome do modo que estou agora
		Game.Current_Mode = _mode

		#retorna
		return

	#volto com as comfigurações originais
	Player.texture.texture = Skin_Normal
	Player.texture.hframes = HFRAME_NORMAL
	Player.texture.vframes = VFRAME_NORMAL

	#deixo de exibir meu modo de jogo
	Game.Current_Mode = ""

################################################################################

#método que ira fazer o efeito de confirmação do código
func Submmit_Text_Tween():

	#SE line code Existir
	if Line_Code:

		#SE esse tween existir, eu deleto ele
		if Tween_Submmit: Tween_Submmit.kill()
		
		#crio um tween
		Tween_Submmit = create_tween()

		#conecto ele a mim para ele ser liberado da memória junto de mim
		Tween_Submmit.bind_node(self)

		#animação de vermelho para transparente em meio segundo
		Tween_Submmit.tween_method( Mod_text_submmit, Color.RED, Color.TRANSPARENT, 0.5)

		#deixo de poder editar o line code
		Line_Code.unedit()

		#ESPERE ATÉ QUE esse tween acabe
		await Tween_Submmit.finished

		#removo o texto atual
		Line_Code.text = ""

		#chamo o método para deixar o texto branco
		Mod_text_submmit(Color.WHITE)

		#volto a poder editar o line code
		Line_Code.edit()

################################################################################

#método que modificara a cor do texto do line code
func Mod_text_submmit(_color : Color):
	#trocando a cor do texto cor _color
	Line_Code.add_theme_color_override("font_color", _color)

#################################################################################

#endregion
