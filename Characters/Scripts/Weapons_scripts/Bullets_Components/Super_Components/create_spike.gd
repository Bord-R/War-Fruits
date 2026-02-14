extends Node2D

class_name CreateSpike #criando classe para ser usado como node

#region Variables

@onready var Player : FruitsCharacter = get_parent() #player

@onready var Spike : PackedScene #espinhos

#minha quantidade maxima de espinhos
var MAX_SPIKES : int = 4

#variação do raio do filho
var Mod_Radius : float = 1.5

#raio interpolado
var Inter_Radius : float = 1.0

#contador
var Count : int = 1

#endregion

#region Methods

#método que rodara quando eu for carregado
func _init(_qtd_spikes : int, _scene_spike : PackedScene, _m_radius : float, _inter_radius : float):
	
	MAX_SPIKES = _qtd_spikes #minha quantidade de espinhos é igual a qtd spikes

	Mod_Radius = _m_radius #valor usado para modificar o raio do espinho

	Inter_Radius = _inter_radius #interpolação maxima do meu raio

	Spike = _scene_spike #meu espinho é igual a _scene_spike

################################################################################

#método que rodara quando eu for iniciado
func _ready(): 

	#PARA _spikes chegar em MAX SPIKES
	for _spikes in range(MAX_SPIKES):

		#crio uma variavel local que instanciara spike
		var _create_spike = Spike.instantiate()

		#adiciono a nova instancia como filha do player
		Player.add_child(_create_spike)

		#a posição dele é igual é igual a do player
		_create_spike.global_position = Player.global_position

		#mudo o angulo a ser somado da instancia
		_create_spike.Summed_Angle = (_spikes*PI)/(float(MAX_SPIKES)/2)

		#conecto o sinal ao método
		VM.Conected_Signals(_create_spike.isdead, on_dead_child)

		#SE _spikes for par, mudo o valor do raio da instancia spike
		if _spikes % 2: _create_spike.Radius *= Mod_Radius

		#uso método da instancia para animar ela
		if Inter_Radius > 0: _create_spike.Interpolate_Radius(Inter_Radius, _create_spike.Radius)

################################################################################

#endregion

#region My Methods

#método que ira rodar quando um dos spikes for deleto
func on_dead_child():

	#SE o contador for igual a quantidade maxima de espinhos
	if Count == MAX_SPIKES:
		
		#posso criar novos espinhos novamente
		Game.Is_CreateSpike = true

		queue_free() #me deleto
		return #retorne

	Count += 1 # soma 1 no contador

################################################################################

#endregion
