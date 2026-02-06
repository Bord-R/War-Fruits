extends Area2D

#criando uma classe para os efeitos
class_name Effects #efeitos

#region Variables

#minhas particulas
@export var Particles : GPUParticles2D

@export var Type_Effect : String = ""

#meu ospedero
@onready var Meu_Ospedero : EnemiesFruits = null

#meu dano
const DANO : int = 1

#intervalo de dano maximo
const MAX_TIME_DAMAGE : float = 2.5

#intervalo de dano
var Time_Damage : float = MAX_TIME_DAMAGE

#tempo de vida
var Time_life : float = 25.0

#boleano que fara eu "grudar no inimigo"
var Ospedero : bool = false

#estado morto do inimigo
var Ene_Dead : String = "estadomorto"

#quantidade de pontos que eu dou
var Acresim_Points : int = 75

#quantidade de pontos de super
var Acresim_Super : int = 1

#endregion

#region Methods

#método que rodara quando o jogo iniciar
func _ready() -> void:
	
	#conectando sinal a um método
	VM.Conected_Signals(area_entered,Area_detectada)

################################################################################

#método que rodara a cada frame do game
func _process(_delta: float) -> void:
	
	call(Type_Effect) #chamo o método
	
	#método que rodara meu ciclo de vida
	Life_Timer()

	#SE meu ospedero existir E o meu ospedero estiver no estado morto, eu...
	if (Meu_Ospedero != null and Meu_Ospedero.Maquina_estados.Estado_Atual ==
		 Meu_Ospedero.Maquina_estados.Meus_Estados["estadomorto"]):
		
		#meu tempo de vida acaba
		Time_life = 0

		Life_Timer() #chamo denovo para eu morrer
	
	#SE  meu ospedero EXISTIR
	elif Meu_Ospedero != null:
		
		#minha posição é igual a do inimigo 
		global_position = Meu_Ospedero.global_position - Vector2(0.0, 16.0)
	
	elif Game.Player_Dead: queue_free() #SE o player morreu eu me deleto

################################################################################

#endregion

#region My Methods

#método que dara dano no inimigo
func Poison_Damage():
	
	#SE meu ospedero NÃO for nulo
	if Meu_Ospedero != null:
		
		#SE meu intervalo for maior que zero, eu...
		if Time_Damage > 0:
			
			#diminuo o timer
			Time_Damage -= VM.MINOS_TIMER
		
		#SE NÃO
		else:
			
			#dando dano no inimigo
			Meu_Ospedero.Take_Damaged(
				DANO,
				Vector2.ZERO,
				0.0,
				Acresim_Super,
				Acresim_Points
			)
			
			#reiniciando o timer
			Time_Damage = MAX_TIME_DAMAGE

################################################################################

#método que rodara quando o sinal for ativado
func Area_detectada(_area : Area2D):
	
	#SE o pai da area que eu colidi for um inimigo, eu
	if _area.get_parent() is EnemiesFruits:
		
		#eu tenho um Ospedero
		Ospedero = true
		
		#adiquiro meu ospedero
		Meu_Ospedero = _area.get_parent()

################################################################################

#método que rodara meu tempo de vida
func Life_Timer():
	
	#SE o meu tempo de vida for maior ou igual que zero, eu...
	if Time_life > 0:
		
		#eu diminuo minha vida
		Time_life -= VM.MINOS_TIMER
	
	#SE NÃO, SE a minha vida for menor ou igual que zero, eu...
	elif Time_life <= 0:
		
		#minhas particulas param de aparecer
		Particles.one_shot = true
		
		await get_tree().create_timer(0.5).timeout
		
		#SE meu ospedero NÃO FOR nulo meu ospedero deixa de ter um efeito
		if Meu_Ospedero != null: Meu_Ospedero.Effect = false
		
		queue_free() #me deleto

################################################################################

#endregion
