extends ProgressBar


#region Variables

@export var Daddy : EnemiesFruits #meu pai

var Tween_Life : Tween #tween

@export var Init_Life : int :
	set(_new_value):
		if Daddy: _new_value = Daddy.Enemie_life
		max_value = _new_value
		value = max_value

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

################################################################################

#endregion
