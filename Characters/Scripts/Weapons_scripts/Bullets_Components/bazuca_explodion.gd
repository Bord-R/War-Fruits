extends Bala

#region Variables

#força do shake
@export var Shake_Force : float :
	#definindo como uma variavel do tipo setter
	set(_value): #pege o valor atribuido
		Shake_Force = _value #e adicione ele a shake force


#endregion

#region Methods

#método que rodara quando eu estiver carregado
func _process(_delta : float) -> void:

	#fazendo a tela tremer
	Screen_shake.trigger_shake(Shake_Force)

################################################################################

#métood que rodara quando a minha animação acabar
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	
	#SE o nome da animação for igual a Start, eu me deleto
	if _anim_name == "start": queue_free()

################################################################################

#endregion