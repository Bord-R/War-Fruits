extends CharacterBody2D

class_name FruitsCharacter

#region Variables

#sinal de gameover 
signal gameover(_on_active : bool)

#region consts

#minha velocidade maxima original
const NORMAL_MAX_VEL : float = 200.0

#vida maxima
const VIDA_MAX : int = 4

#aceleração do meu player
const ACELERACAO : float = 0.80

#desaceleração do meu player
const DESACELERACAO : float = 0.25

#minha cor quando eu ficar invencivel
const COR_INVINCIBLE : Color = Color(1.0, 1.0, 1.0, 1.0)

#valor maximo do meu timer
const TIMER_MAX : float = 8.0

#velocidade de knock back
const KNOCK_VEL : int = 20

#meu shake ao levar dano
const SHAKE_HIT : int = 15

#segundos de espera
const SECS_TWEEN : float = 0.25

#cor de quando levar dano
const COLOR_DAMAGE : Color = Color.RED

#cor de quando eu atirar uma super
const COLOR_SUPER : Color = Color(0.137, 0.004, 0.137)

#minha ordenação inicial
const INI_ZINDEX : int = 2

#minha ordenação maxima
const MAX_ZINDEX : int = 5

#ordenação inicial da sombra
const SHADOW_INI_ZINDEX : int = 1

#ordenação maxima da sombra
const SHADOW_MAX_ZINDEX : int = 4

#bonus de velocidade do debug mode
const DEBUG_VEL : float = 500.0

#endregion

#se eu tenho uma arma
var Possui_arma : bool = false

#minha arma atual
@onready var Pistol_atual 

#meu animationplayer
@export var animate : AnimationPlayer

#minha textura
@export var texture : Sprite2D

#camera
@export var Screen_shake : MyCamera

#loader
@export var Loader : Area2D

#sombra
@export var Shadow : Sprite2D

#exportando o fundo falso
@export var BackGroud_Fake : ColorRect

#modo de jogo (label)
@export var GameMode : Label

#tela de game over
@export var Game_Over_Screen : Node2D

#vida do jogador
var Player_life : int = 0

#velocidade
var vel : float = 0

#direção
var direction : Vector2 = Vector2.ZERO

#velocidade maxima
var VEL_MAX : float = NORMAL_MAX_VEL

#minha animação atual
var anim_atual : String

#boleano que vereficara se eu tomei dano
var Dano_sofrido : bool = false

#valor de interpolação
var Interpolation : float = 0.0

#boleano que vera se eu posso mudar interpolation
var Is_AcresimIterpolation : bool = true

#tempo de invencibilidade
var Invincible_time : float = 0.0

#variavel responsavel pro criar um efeito de fade out para o node backgroud fake
var Tween_Backfade : Tween

#endregion

#region Methods

#função que vai rodar no inicio do game
func _ready() -> void:

	VM.Conected_Signals(gameover, GameOver_on) #conecto meu sinal ao meu método

	#meu loader começa a monitorar
	Loader.monitorable = true
	
	#definindo que eu não estou morto
	Game.Player_Dead = false
	
	#definindo a quantidade de bonus de super
	Game.Super_Bonus = 0
	
	#método que da um efeito de fade out no node backgroudfake
	BackGroud_Tween()

	#minha vida
	Player_life = VIDA_MAX

	#minha velocidade
	vel = VEL_MAX

################################################################################

#função que vai rodar a cada frame do meu game
func _physics_process(_delta: float) -> void:
	
	#SE eu não estiver morto
	if !Game.Player_Dead:
		
		#método para eu me mover
		movimentacao() 
		
		#método para usar minha arma
		Usando_Arma()
		
		#método para me mover comforme a variavel "velocity"
		move_and_slide()

		#método que me deixara invensivel
		Invincible_Time(0.75, 0.25, 0.05)

		#método que mostrara meu modo de jogo atual
		Game_Mode_label()

		return #retorna

	#mudo a camada de exebição da minha textura
	texture.z_index = MAX_ZINDEX

	#mudo a camada de exebição da minha sombra
	Shadow.z_index = SHADOW_MAX_ZINDEX

################################################################################

#endregion

#region My Methods

#criando um método para me mover
func movimentacao():
	
	#minha direção é igual a um vetor com dois valores (Vector2)
	direction = Vector2(
		
		#vai checar se eu apertei um botão com um valor negativo ou positivo
		#que sera definido pela função "get_axis()"
		Input.get_axis("ui_left","ui_right"),
		Input.get_axis("ui_up","ui_down")
		) 
	
	if sign(velocity.x) < 0.0: texture.flip_h = true #SE velocity for maior que 0, viro pra direita
	else: texture.flip_h = false #SE NÃO, viro pra esquerda

	#SE eu não estou sofrendo dano, eu executo o código
	if !Dano_sofrido:
		
		#SE minha direção NÃO FOR igual ao Vector2 zerado
		if direction != Vector2.ZERO:
			
			#minha movimentação vai ser acelerada
			velocity = lerp(velocity, direction.normalized() * vel, ACELERACAO)
			
			#minha animação é tocada 
			animação("walk")
			
			return #retorna
		
		#minha movimentação vai ser desacelerada
		velocity = lerp(velocity, direction.normalized() * vel, DESACELERACAO)
		
		#minha animação é tocada 
		animação("idle")

################################################################################

#criando método para animar o player
func animação(_nova_anim : String):
	
	#SE minha animação atual não for igual a minha nova animação, eu executo o código
	if anim_atual != _nova_anim:
		
		#minha animação atual é igual a nova animação
		anim_atual = _nova_anim

	#toco a animação atual
	animate.play(anim_atual)

################################################################################

#método que dara o tempo de invensibilidade
func Invincible_Time(_max_value : float, _min_value : float, _value  : float):
	
	#SE time for menor que 0
	if Invincible_time > 0.0:

		Invincible_time -= _value #diminuo o timer

	else: Interpolation = 0.0 #SE NÃO, eu zero o timer

	if Is_AcresimIterpolation: #SE posso aumentar interpolation

		Interpolation += _value #aumento interpolation

		if Interpolation >= _max_value: Is_AcresimIterpolation = false #SE interpolation for maior ou igual a max value, deixo de poder aumentar

	elif not Is_AcresimIterpolation: #SE NÃO, SE eu NÃO posso modificar interpolation

		Interpolation -= _value #diminuo interpolation

		if Interpolation <= _min_value: Is_AcresimIterpolation = true #SE interpolation for menor ou igual a min value, volto a poder aumentar interpolation

	#mudando a cor do meu shader
	texture.material.set("shader_parameter/flash_cor", COR_INVINCIBLE)
	
	#mudando a intensidade do meu shader
	texture.material.set("shader_parameter/float_flash", Interpolation)

################################################################################

#criando método para quando eu possuir uma arma
func Usando_Arma():
	
	#SE eu possuo uma arma, eu executo o código
	if Possui_arma and Pistol_atual.Bool_pai:
		
		#SE eu apertar o botão esquerdo do mouse, eu executo o código
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			
			#usando a função Atirando() da minha arma atual
			Pistol_atual.Atirando() #atirando com minha arma atual
		
		#SE NÃO, SE eu apertar a tecla Q, eu executo o código
		elif Input.is_key_label_pressed(KEY_Q):
			
			#dando uma direção para minha arma qunado ela for dropada
			#a direção sera a posição global do mouse subtraida pela posição da minha arma atual
			Pistol_atual.Drop_direction = (get_global_mouse_position() - Pistol_atual.global_position).normalized()
			
			#usando a função Drop_pistol da minha arma atual
			Pistol_atual.Drop_arma() #jogando minha arma atual

		#SE NÃO, SE eu apertar o botão direito do mouse E a variavel Super Bonus for igual ao valor maximo dela
		elif Input.is_key_label_pressed(KEY_SPACE) and Game.Super_Bonus == Game.MAX_SUPER_BONUS:

			#usando a função Super da minha arma atual
			Pistol_atual.Super() #atirando a super da minha arma atual

################################################################################

#método que roda quando a animação acabar
func _on_animation_player_animation_finished(anim_name: StringName) -> void:

	#SE NÃO, SE minha animação for igual a hit, eu executo o código
	if anim_name == "hit":

		if not Game.Player_Dead: #SE o player NÃO morreu
			Dano_sofrido = false #deixo de sofrer dano
			return #retorna

		animação("glitch") #minha animação de bug

		gameover.emit(true) #emito o sinal game over

	#SE NÃO, SE minha animação for igual a glitch, eu executo o código
	elif anim_name == "glitch":

		#a animação tocada é "aguard"
		animação("aguard")

	#SE NÃO, SE a minha animação for igual a aguard
	elif anim_name == "aguard":
		
		#a animação tocada é "zombie"
		animação("zombie")

################################################################################

#método que rodar caso eu interaja com alguma area2d
func _on_player_area_entered(_area : Area2D):
	
	#SE o pai da area for um enemiefruits E meu tempo invencivel for menor ou igual a zero E invisible active for falso,
	# eu executo o código
	if _area.get_parent() is EnemiesFruits and Invincible_time <= 0.0 and !Game.Invincible_Active:

		Update_backGroud(COLOR_DAMAGE) #atualizando tween

		#congelo a tela por alguns segundos
		Game.Freeze_Frame(0, 0.3)

		#sofro dano
		Dano_sofrido = true
		
		#a animação tocada é "hit"
		animação("hit")
		
		#minha  direção é igual a minha posição global subtraida
		#pela posição global do parente da area
		direction = global_position - _area.get_parent().global_position
		
		#adicionando a movimento
		velocity = direction * KNOCK_VEL
		
		#movendo
		move_and_slide()
		
		#efeito de screen shake
		Screen_shake.trigger_shake(SHAKE_HIT)
		
		#perco vida
		Player_life -= 1
		
		#meu tempo invencivel fica com o tempo maximo
		Invincible_time = TIMER_MAX

################################################################################

#método que ira rodar um efeito de fade out
func BackGroud_Tween():
	
	#SE esse tween existir, eu deleto ele
	if Tween_Backfade: Tween_Backfade.kill()

	#crio um tween
	Tween_Backfade = create_tween()

	#conectando ele a mim mesmo para ele ser liberado junto de mim da memória
	Tween_Backfade.bind_node(self)

	#faço o backgroud fake ficar transparente
	Tween_Backfade.tween_property(BackGroud_Fake,"modulate", Color.TRANSPARENT,0.2)

	#ESPERE ATÉ QUE esse tween acabe
	await Tween_Backfade.finished

	#o backgroud fake é descarregado
	BackGroud_Fake.visible = false

	#mudo a ordenação da minha textura
	texture.z_index = INI_ZINDEX

	#mudo a ordenação da minha sombra
	Shadow.z_index = SHADOW_INI_ZINDEX

################################################################################

#método que atulizara o backgroud tween
func Update_backGroud(_color : Color):

	#backgroud fake é carregado
	BackGroud_Fake.visible = true

	if !Game.Player_Dead: #SE o player não morreu

		#mudo a modulação dele
		BackGroud_Fake.modulate = _color

		#a cor dele é igual a modulação
		BackGroud_Fake.color = BackGroud_Fake.modulate

		#chamo esse método para a animação rodar
		BackGroud_Tween()

	else: #SE NÃO

		#congelo o jogo por meio segundo
		Game.Freeze_Frame(0.01, 0.25)

		#mudo a cor do backgroud
		BackGroud_Fake.modulate = Color.TRANSPARENT

	#mudo a ordenação da minha textura
	texture.z_index = MAX_ZINDEX

	#mudo a ordenação da minha sombra
	Shadow.z_index = SHADOW_MAX_ZINDEX

################################################################################

#método que mostra meu modo de jogo atual
func Game_Mode_label():

	#SE o DEbug mode estiver ativado OU eu estou morto
	if Game.DEBUG_Active and !Game.Player_Dead:

		#o texto do GameMode é igual ao modo atual
		GameMode.text = Game.Current_Mode

		#retorna
		return

	#meu texto é vazio
	GameMode.text = ""

################################################################################

#método que ativara o game over
func GameOver_on(_active : bool):

	#SE active for verdadeiro 
	if _active:

		#inicio o ciclo de vida da tela de game over
		Game_Over_Screen.Cicle_Life()

################################################################################

#endregion
