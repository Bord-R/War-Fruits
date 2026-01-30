extends Area2D

#region Variables

#dano inicial
@export var Init_Damage : int = 0

@export var Poits_Acresim : float = 0.0 # pontos a acresentar

@export var Super_Acresim : int = 0 #pontos de super a acresentar

@export var Anim : AnimationPlayer #minha animação

@export var Particles : GPUParticles2D #minhas particulas 2d

#tempo de vida
const TIME_LIFE : float = 30.0

var My_Timer : Timer = Timer.new() #meu timer

#estado morto
var Stt_Dead : String = "estadomorto"

#endregion

#region Methods

func _ready(): #método que começara quando eu estiver pronto

	#SE meu timer NÃO estiver na scenetree eu adiciono ele como filho da scenetree atual
	if !My_Timer.is_inside_tree(): get_tree().current_scene.add_child(My_Timer)

	My_Timer.wait_time = TIME_LIFE #espere pelo tempo do meu tempo de vida

	My_Timer. start() #inicio o timer

	#conectando os sinais ao seus métodos
	VM.Conected_Signals(My_Timer.timeout, Final_Stage)
	VM.Conected_Signals(Anim.animation_finished, Animation_Cicle)
	VM.Conected_Signals(area_entered, Enemie_Collided)

################################################################################

func _process(_delta):
	
	if Game.Player_Dead: Swap_Anim("end")

################################################################################

#endregion

#region My Methods

#colidindo com inimigo
func Enemie_Collided(_area): # /area/

	#SE o pai da area for dessa classe
	if _area.get_parent() is EnemiesFruits:

		#crio uma variavel local pra faciltar as chamadas
		var _Enemy_Col = _area.get_parent()

		#SE o inimigo que eu colidi estiver no estado morto retorna
		if _Enemy_Col.Maquina_estados.Estado_Atual is EstadoMorto: return

		#diminuo a vida dele
		_Enemy_Col.Enemie_life -= Init_Damage

		#troco o estado dele para o estado hit
		_Enemy_Col.Maquina_estados.Troca_Estado("estadohit")

		#SE o estado morto for um dos estados dele 
		if Stt_Dead in _Enemy_Col.Maquina_estados.Meus_Estados:
			
			#mudo a pontuação ao mata-lo
			_Enemy_Col.Maquina_estados.Meus_Estados[Stt_Dead].Quantity_Points = Poits_Acresim
			_Enemy_Col.Maquina_estados.Meus_Estados[Stt_Dead].Quantity_Super = Super_Acresim

################################################################################

#método que rodara quando uma animação acabar
func Animation_Cicle(_name_anim : StringName): #ciclo de animações

	if _name_anim == "start": #SE o nome da animação for start

		Particles.emitting = true #as particulas são emitidas

		Swap_Anim("in_game") #toca a animação "in game" (en jogo)

	#SE NÃO, SE a animação for end
	elif _name_anim == "end": queue_free() #eu me deleto

################################################################################

#método que trocara minha animação
func Swap_Anim(_anim : StringName): # / animação /

	if Anim.current_animation != _anim: #SE a animação atual não for igual a _anim
		Anim.current_animation = _anim #faço  com que ela seja igual a anim

	#SE a animação atual for dirferente de nulo eu toco a animação
	if Anim.current_animation != "": Anim.play(Anim.current_animation)

################################################################################

#método que fara eu morrer
func Final_Stage():

	Particles.emitting= false #paro de emitir as particulas

	get_tree().current_scene.remove_child(My_Timer) #removo o timer da scene tree pra não acumular coisa desnecessaria na memória
	
	Swap_Anim("end") #toco "end" (fim)

################################################################################

#endregion
