extends Node

#criando classe para ser usado como node
class_name CreateEffect #criando efeito

#region Variables

#meu efeito 
@export var Effect : PackedScene

#boleano que vera eu posso criar um efeito apenas por script
@export var IsScriptEffect : bool = false

#hitbox da bala
@export var HitBox : Area2D

@export_group("IsScriptEffect = true") #grupo de se isscripteffect igual a verdadeiro

@export var Quantity_Spikes : int = 4

@export var Mod_Radius_Spikes : float = 1.0

#endregion

#region Methods

#método que rodara no inicio do game
func _ready() -> void:
	
	#SE Meu node Pai for uma bala, e for uma super
	if get_parent() is Bala and get_parent().IsReduction_Super:
		AreaCreate() #crio uma area
		return #retorna

	#conectando sinal a um método 
	VM.Conected_Signals(HitBox.area_entered, Inimigo_Detectado)


################################################################################

#endregion

#region My Methods

#método que rodara quando eu interagir com alguma arma
func Inimigo_Detectado(_area : Area2D):
	
	#criando uma referencia ao inimigo
	var _Enemy = _area.get_parent()
	
	#SE o inimigo for da classe Enemie fruits, eu...
	if _Enemy is EnemiesFruits and _Enemy.Effect == false:
		
		#instancio o efeito
		var _Create_effect = Effect.instantiate()
		
		#adiciono ele a scenetree
		get_tree().root.call_deferred("add_child", _Create_effect)
		
		#definindo sua posição
		_Create_effect.position = _Enemy.global_position + Vector2(0.0, -16.0)
		
		#o inimigo ganha o efeito
		_Enemy.Effect = true

################################################################################

#método que criara uma area em volta do player
func AreaCreate():
	
	#SE o efeito criado não for nulo
	if Effect and !IsScriptEffect:

		#instancio o efeito
		var _New_Effect = Effect.instantiate()

		get_parent().MyPlayer.add_child(_New_Effect) #adiciono como filho do player

		_New_Effect.global_position = get_parent().MyPlayer.global_position #a posição do efeito é igual a do player

	#SE NÃO, SE eu tenho um efeito, podendo fazer via class.new E poder criar uma nova area
	elif Effect and IsScriptEffect and Game.Is_CreateSpike:

		var _new_Effect_Script = CreateSpike.new(Quantity_Spikes, Effect, Mod_Radius_Spikes) #instancio um createspike com seu dados ja configurados

		get_parent().MyPlayer.add_child(_new_Effect_Script) #adiciono como filho do player

		Game.Is_CreateSpike = false #não posso criar espinhos

################################################################################

#endregion
