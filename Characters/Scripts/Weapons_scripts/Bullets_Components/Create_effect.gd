extends Node

#criando classe para ser usado como node
class_name CreateEffect #criando efeito

#region Variables

#hitbox da bala
@export var HitBox : Area2D

#efeito
@export var Effect : PackedScene

#meu efeito 
@export var Area : PackedScene

#meu espinho
@export var Spike : PackedScene

@export_group("Spikes Atributes") #grupo de atrbutos dos espinhos

@export var Quantity_Spikes : int = 4

@export var Mod_Radius_Spikes : float = 1.0

@export var Interpolate_Radius_Spike : float = 0.0

#endregion

#region Methods

#método que rodara no inicio do game
func _ready() -> void:
	
	#SE Meu node Pai for uma bala, e for uma super
	if get_parent() is Bala and get_parent().IsReduction_Super:
		CreateEffect() #crio uma area
		return #retorna

	#conectando sinal a um método 
	VM.Conected_Signals(HitBox.area_entered, Inimigo_Detectado)


################################################################################

#endregion

#region My Methods

#método que rodara quando eu interagir com algum inimigo
func Inimigo_Detectado(_area : Area2D):
	
	#criando uma referencia ao inimigo
	var _Enemy = _area.get_parent()
	
	#SE o inimigo for da classe Enemie fruits E ele não tiver um efeito
	if _Enemy is EnemiesFruits and _Enemy.Effect == false:
		
		#instancio o efeito
		var _Create_effect = Effect.instantiate()
		
		#adiciono ele a scenetree
		get_tree().root.call_deferred("add_child", _Create_effect)
		
		#definindo sua posição
		_Create_effect.position = _Enemy.global_position
		
		#o inimigo ganha o efeito
		_Enemy.Effect = true

################################################################################

#método que criara um efeito em volta do player
func CreateEffect():
	
	#SE a area criada não for nula E eu posso criar uma area
	if Area and Game.Is_CreateArea:

		#instancio a nova area
		var _New_Effect = Area.instantiate()

		get_parent().MyPlayer.add_child(_New_Effect) #adiciono como filho do player

		_New_Effect.global_position = get_parent().MyPlayer.global_position #a posição da area é igual a do player

		Game.Is_CreateArea = false

	#SE eu tenho um espinho E eu posso criar um novo espinho
	if Spike and Game.Is_CreateSpike:

		var _new_Effect_Script = CreateSpike.new(Quantity_Spikes, Spike, Mod_Radius_Spikes, Interpolate_Radius_Spike) #instancio um createspike com seu dados ja configurados

		get_parent().MyPlayer.add_child(_new_Effect_Script) #adiciono como filho do player

		Game.Is_CreateSpike = false #não posso criar espinhos

################################################################################

#endregion
