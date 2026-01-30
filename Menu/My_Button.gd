extends TextureButton

#criando classe para ser usado como node
class_name MyButton #kkkkkkkkkkkk

#region Variables

#valor 
const VALUE : float = 0.15

#minha escala original 
var Origin_Scale : Vector2 = Vector2(1.0, 1.0)

#minha escala modificada
var Modif_Scale : Vector2 = Vector2(1.1, 1.1)

#tween que mudara minha escala
var Scale_Tween : Tween = null

#tempo do tween
var Time_Tween : float = 1.0

#endregion

#region Methods

#método que rodara no inicio do game
func _ready() -> void:
	
	#chamando a função Entered mouse quando o sinal for ativado
	mouse_entered.connect(Entered_Mouse)
	
	#chamando a função Exited Mouse quando o sinal for ativado
	mouse_exited.connect(Exited_Mouse) 

################################################################################

#endregion

#region My Methods

#método que rodara quando o mouse encostar em mim
func Entered_Mouse():
	
	Reset_Tweens() #reseto o tween
	Scale_Tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC) #mudo o tipo de transição
	Scale_Tween.tween_property(self, "scale", Modif_Scale, Time_Tween) #me estico

################################################################################

#método que rodara quando o mouse sair de mim
func Exited_Mouse():
	
	Reset_Tweens() #reseto o tween
	Scale_Tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC) #mudo o tipo de transição
	Scale_Tween.tween_property(self, "scale", Origin_Scale, Time_Tween) #volto ao normal

################################################################################

#método que resetara tweens
func Reset_Tweens():  
	
	#SE o tween existir eu deleto ele
	if Scale_Tween: Scale_Tween.kill()

	#crio um novo tween e adiciono ele a mimm
	Scale_Tween = create_tween().bind_node(self)

################################################################################

#endregion 
