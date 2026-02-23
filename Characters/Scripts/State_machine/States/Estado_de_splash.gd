extends Estado

#criando uma classe para eu ser usado como node
class_name EstadoSplash #estado de splash

#region Variables

#minha possa
@export var Possa : PackedScene = preload("res://Characters/cines/Possa.tscn")

#animation player
@export var Anim : AnimationPlayer

#quantidade maxima de possas que eu posso gerar
@export var QUANTITY_POSS : int = 5

#tamanho das minhas possas
@export var SCALE_POSS : Array[float] = [1, 1.4]

#valor aleatório
var _randow_value : float = 0

#endregion

#region Method

#método que ira rodar  no inicio do game
func Entrada():
	
	Pai_estados.Anim_nome = "Splash"
	
	#conecto o sinal ao método
	VM.Conected_Signals(Anim.animation_finished, Animacao_finalizada)

################################################################################

#endregion 

#region My Method

#método conectado com o sinal de quando a animação acabar
func Animacao_finalizada(_Anim : StringName):
	
	#SE a animação for igual a "Splash"
	if _Anim == "Splash":
		
		#PARA a variavel local "_possa" chegar ao alcance de "QUANTITY_POSS", eu...
		for _possa in range(QUANTITY_POSS):
			
			#criando uma nova instancia
			var _Create_poss = Possa.instantiate()
			
			#adicionando ela a cena atual
			get_tree().current_scene.add_child(_Create_poss)
			
			#definindo a posição da nova instancia
			_Create_poss.position = Vector2(
				
				Character.position.x + randf_range(-50, 50),
				
				Character.position.y + randf_range(-20, 20))
			
			_randow_value = randf_range(SCALE_POSS[0], SCALE_POSS[1]) #dou valor aleatório

			#gerando um tamanho aleatorio da possa
			_Create_poss.scale = Vector2(_randow_value, _randow_value)

			#return #retona caso o loop seja verdadeiro
		
		Pai_estados.Troca_Estado(State[0]) #trocando para o estado de guarda

################################################################################

#endregion
