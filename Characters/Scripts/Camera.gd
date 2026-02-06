extends Camera2D

#criando classe para ser usado como node
class_name MyCamera #minha camera

#region Variables

#player
@export var Player : FruitsCharacter

#minha redução 
const REDUCAO : float = 0.5

#desvio desejado para o efeito
var desired_offset : Vector2

#desvio minimo
var min_offset = -50

#desvio maximo
var max_offset = 50

#SCREEN SHAKE

#chocalho maximo
var max_shake : float 

#variavel que fara a suavição para acabar com o screen shake
var shake_fade : float = 10.0

#força do chocalho
var shake_strength : float = 0.0

#endregion

#region Methods

#método que ira rodar acada instante
func _process(delta: float) -> void:
	
	#SE o player NÃO ESTIVER MORTO
	if !Game.Player_Dead:
		
		#definindo o desvio desejado como a posição do mouse menos minha posição com uma redução
		desired_offset = (get_global_mouse_position() - position) * REDUCAO
		
		#o x do meu desvio desejado fica restringido aos limites maximos e minimos
		desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
		
		#e o y o mesmo acontece
		desired_offset.y = clamp(desired_offset.y,min_offset / 2.0, max_offset / 2.0)
		
		#minha posição global é igual a posição do player mais o desvio desejado
		global_position = Player.global_position + desired_offset 

	else: #SE NÃO

		#minha posição global é igual a do player
		global_position = Player.global_position
	
	#fazendo o screen shake 
	#SE a força do chocalho for maior que 0
	if shake_strength > 0:

		#a força do chocalho cai até chegar em 0
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)

		#meu desvio faz eu tremer
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
			
################################################################################

#endregion

#region My Methods

#método que atualizara a força do meu screen shake
func trigger_shake(_max_value): # _max_value : valor maximo
	
	#meu chocalho maximo é igual a _max_value
	max_shake = _max_value
	
	#a força do chocalho é igual ao meu chocalho maximo
	shake_strength = max_shake

################################################################################

#endregion
