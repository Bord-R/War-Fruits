extends CharacterBody2D

#region Variables

signal isdead() #sinal que ativara quando eu morrer

@onready var Player : FruitsCharacter = null #meu player

@onready var Camera : MyCamera = null #camera

#minha area2d
@export var HitBox : Area2D

#meu animation player
@export var Anim : AnimationPlayer

#quantidade de pontos
@export var Points : int

#quantidade de pontos de super
@export var Points_Super : int

#chaqualho
const SHAKE : float = 4.0

#dano que darei no inimigo
const DAMAGE : int = 5

#empurrão que darei no inimigo
const KNOCKBACK : float = 2.0

#valor maximo de break
const BREAK_MAX : int = 0

#angulo
var Angle : float = 0.0

#velocidade
var Vel : float = 1.25

#raio do circulo
var Radius : float = 60.0

#angulo somado
var Summed_Angle : float = 0.0

#posição em movimento
var Mov_Postion : Vector2 = Vector2.ZERO

#posição do player
var Player_Postion : Vector2 = Vector2.ZERO

#o quão quebrado estou
var Break : int = 1

#tween que interpolara meu raio
var Radius_Tween : Tween

#endregion

#método que rodara quando eu estiver carregado
func _ready():

	#SE meu node pai for da classe fruitscharacter
	if get_parent() is FruitsCharacter:Player = get_parent() #meu player é igual a esse pai

	else: queue_free() #SE NÃO, eu me deleto

	Camera = Player.Screen_shake #camera igual a camera do player

	#conecto o sinal ao método
	VM.Conected_Signals(HitBox.area_entered, HitBox_On)

################################################################################

#método que rodara a cada frame
func _physics_process(_delta: float) -> void:

	if Game.Player_Dead: #SE o player estiver morto
		Anim.play("destroy") #toco destroy
		Game.Is_CreateSpike = true #posso criar novos espinhos
		return #retorna

################################################################################

#método que ira rodar quando o sinal area_entered for emitido
func HitBox_On(_area : Area2D):

	#SE o pai de _area for um enemiefruits
	if _area.get_parent() is EnemiesFruits:

		 #crio variaveis locais para facilitar as chamadas
		var _enemy : EnemiesFruits = _area.get_parent() #inimigo

		#SE o estado atual do inimigo for hit, retorna
		if _enemy.Maquina_estados.Estado_Atual is EstadoHit: return

		Camera.trigger_shake(SHAKE) #tremo a tela

		#faço ele tomar dano
		_enemy.Take_Damaged(
			DAMAGE,
			global_position,
			KNOCKBACK,
			Points_Super,
			Points
		)

		if Break > BREAK_MAX: #SE Break for maior que 0

			Anim.play("hit") #rodo hit
			Break -= 1 #diminuo break
		   
		#SE NÃO, SE Break for igual ou menor que BREAK MAX
		elif Break == BREAK_MAX:

			Anim.play("destroy") #toco destroy

			await Anim.animation_finished

			Acresim_LifePlayer(1) #aumentando a vida do player

			queue_free() #me deleto

			isdead.emit() #emito o sinal que falara para meu pai que eu morri

################################################################################

#método que interpolara meu raio
func Interpolate_Radius(_time, _max_radius): # / _tempo / _raio_maximo/

	if Radius_Tween: Radius_Tween.kill() #SE esse tweem existe, eu deleto ele

	Radius_Tween = create_tween().bind_node(self) #crio tween e conecto ele a mim 

	#definindo o tipo de transição
	Radius_Tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	Radius_Tween.set_loops(-1) #animação rodara em loop

	#raio contrai
	Radius_Tween.tween_property(self,"Radius", _max_radius/1.8, _time)

	#raio expande
	Radius_Tween.tween_property(self,"Radius", _max_radius, _time)

################################################################################

#método que almentara a vida do player
func Acresim_LifePlayer(_add_life : int): # /_add_life/	vida adicionada /
	
	#SE a vida do player não for igual a a vida maxima dele E a vida dele não for igual 0
	if Player.Player_life != Player.VIDA_MAX and Player.Player_life != 0: 

		Player.Player_life += _add_life #adiciono mais vida a ele

################################################################################
