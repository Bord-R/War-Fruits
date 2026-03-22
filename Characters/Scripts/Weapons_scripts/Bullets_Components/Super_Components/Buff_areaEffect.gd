extends Area2D

#region Variables

#meu node de animação
@export var Anim : AnimationPlayer

const PUSH_ENEMY : float = 1.5 # empurrão no inimigo

const LIFE_TIME : float = 15.0 # meu tempo de vida

const BUFF_VEL : float = 500.0 #meu buff de velocidade pro player

var Timer_life : Timer = Timer.new() #crio um timer

var Current_Animation : String = "" #minha animação atual

var Tween_Buff : Tween #tween que bufara o player 

#inimigo 
var Enemy : EnemiesFruits = null

#meu pai
var Father : FruitsCharacter = null

#endregion

#region Methods

#método que rodara quando eu estiver carregado
func _ready():

	#SE o timer não estiver na scenetree, eu adiciono ele como filho da scenetree
	if !Timer_life.is_inside_tree(): get_tree().current_scene.add_child(Timer_life)

	Timer_life.wait_time = LIFE_TIME #faço ele rodar meu tempo de vida

	Timer_life.start() #faço ele iniciar

	#conecto os sinais aos métodos
	VM.Conected_Signals(Anim.animation_finished, Animacao_Finalizada)
	VM.Conected_Signals(Timer_life.timeout, Timer_Out)
	VM.Conected_Signals(area_entered, Hitbox_on)

################################################################################

#método que rodara a cada frame
func _process(_delta : float):
	
	if !Game.Player_Dead: #SE o player ta vivo

		RotateMe(1.2, _delta) #giro

		return #retorna

	#eu paro
	Timer_Out()

################################################################################

#endregion

#region My Methods

#método que rodara quando uma animação for finalizada
func Animacao_Finalizada(_anim_name : StringName):

	#SE a animação for "start"
	if _anim_name == "start":	

		#toco "normal"
		Anim_Swap("normal")

################################################################################

#SE o timer acabar
func Timer_Out():

	if Timer_life: Timer_life.queue_free() #removo o timer, SE ele existir
	
	Game.Is_CreateArea = true #posso criar uma area novamente

	Anim_Swap("end") #toco "end"

################################################################################

#método que mudara minha animação
func Anim_Swap( _new_anim):

	#SE a nova animação for diferente da animação atual
	if _new_anim != Current_Animation:

		Current_Animation = _new_anim #faço ela ser igual a nova animação

	Anim.play(Current_Animation) #toco a animação atual
   
################################################################################

#método que rodara quando eu colidir com o inimigo
func Hitbox_on(_area : Area2D):

	#SE o pai da area for um enemies fruits
	if _area.get_parent() is EnemiesFruits: 

		Enemy = _area.get_parent() #para facilitar as chamadas

		#faço ele ser empurrado sem perder a vida
		Enemy.Take_Damaged(
			0,
			global_position,
			PUSH_ENEMY,
			Enemy.Maquina_estados.Meus_Estados["estadomorto"].Quantity_Super,
			Enemy.Maquina_estados.Meus_Estados["estadomorto"].Quantity_Points
		)

################################################################################

#método que bufara o player depois de uma volta
func Buff_VelPlayer():

	#SE meu pai for um fruits character
	if get_parent() is FruitsCharacter:

		Father = get_parent() #para facilitar as chamadas

		#buffo a velocidade do player
		Father.vel = BUFF_VEL

		#SE esse tween existe, eu deleto ele
		if Tween_Buff: Tween_Buff.kill()

		#instancio esse tweem e atribuo ele a mim
		Tween_Buff = create_tween().bind_node(self)

		#interpolo a velocidade maxima do player até chegar ao seu valor original
		Tween_Buff.tween_property(Father, "vel", Father.VEL_MAX, 1)

################################################################################

#método que fara eu girar
func RotateMe(_speed, _delta):
  
	if rotation < TAU: #SE a rotação for menor que uma volta inteira

		rotation += _delta * _speed #aumento a rotação

	else: rotation = 0 #SE NÃO, a rotação é zerada

################################################################################

#endregion
