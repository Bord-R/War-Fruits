extends ProgressBar


#region Variables

@export var Daddy : EnemiesFruits #meu pai

var Tween_Life : Tween #tween

@export var Init_Life : int : #definindo essa variavel como uma do tipo setter (definida)
	set(_new_value): #toda vez que seu valor for alterado
		max_value = _new_value #faço o valor maximo ser igual a new value
		value = max_value #meu valor é igual ao valor maximo

#endregion

#region Methods

func _ready():

	#SE eu tenho um pai, conecto o sinal ao método
	VM.Conected_Signals(Daddy.Damaged, Update_Life)

################################################################################

#endregion

#region My Methods

#método que atualizara a minha quantidade de vida
func Update_Life():

	#SE esse tween existe eu deleto ele
	if Tween_Life: Tween_Life.kill()

	#instancio ele e conecto a mim
	Tween_Life = create_tween().bind_node(self)

	#interpolo a vida do player
	Tween_Life.tween_property(self, "value", Daddy.Enemie_life, .25)

	if Daddy.Enemie_life <= 0:
				
		#SE esse tween existe eu deleto ele
		if Tween_Life: Tween_Life.kill()

		#instancio ele e conecto a mim
		Tween_Life = create_tween().bind_node(self)

		#fico transparente
		Tween_Life.tween_property(self, "modulate", Color.TRANSPARENT, .25)
		
		await Tween_Life.finished #ESPERE até que a animação acabe

		queue_free() #me deleto

################################################################################

#endregion
