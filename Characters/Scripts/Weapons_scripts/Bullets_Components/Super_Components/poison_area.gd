extends Area2D

#region Variables

#dano inicial
@export_range(0.5, 5.0, 0.1) var Init_Damage : float = 0.0

@export var Poits_Acresim : float = 0.0 # pontos a acresentar

@export var Super_Acresim : float = 0.0 #pontos de super a acresentar

#tempo maximo de vida
const MAX_TIME_LIFE : float = 30.0

#tempo de vida
var life_time : float = MAX_TIME_LIFE

#estado morto
var Stt_Dead : String = "estadomorto"

#endregion

func _ready():
	VM.Conected_Signals(area_entered, Enemie_Collided)

func Enemie_Collided(_area):
	if _area.get_parent() is EnemiesFruits:

		var _Enemy_Col = _area.get_parent()

		if _Enemy_Col.Maquina_estados.Estado_Atual is EstadoMorto: return

		_Enemy_Col.Enemie_life -= Init_Damage

		_Enemy_Col.Maquina_estados.Troca_Estado("estadohit")

		if Stt_Dead in _Enemy_Col.Maquina_estados.Meus_Estados:
			
			_Enemy_Col.Maquina_estados.Meus_Estados[Stt_Dead].Quantity_Super = Poits_Acresim

			_Enemy_Col.Maquina_estados.Meus_Estados[Stt_Dead].Quantity_Points = Super_Acresim

################################################################################
