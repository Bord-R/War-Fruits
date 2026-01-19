extends Area2D

#region Variables

#dano inicial
@export_range(0.5, 5.0, 0.1) var Init_Damage : float = 0.0

@export var Poits_Acresim : float = 0.0 # pontos a acresentar

@export var Super_Acresim : int = 0 #pontos de super a acresentar

#tempo maximo de vida
const MAX_TIME_LIFE : float = 30.0

#tempo de vida
var life_time : float = MAX_TIME_LIFE

#estado morto
var Stt_Dead : String = "estadomorto"

#endregion

#region Methods

func _ready(): #método que começara quando eu estiver pronto

	#conectando o sinal ao seu método
	VM.Conected_Signals(area_entered, Enemie_Collided)

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

#endregion