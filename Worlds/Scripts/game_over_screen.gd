extends Node2D

#region Variables

@export_group("Elements") #grupo elementos

#luz 
@export var Dramatic_Light : Sprite2D

#fundo
@export var BackGroud : ColorRect

#botão de menu
@export var Menu_bottom : MyButton

#texto
@export var Text : Label

@export_group("Characteristics Elements")

@export_subgroup("Positions Screen") #grupo posições na tela

#posição do botão menu
var Bottom_Menu_Position : Vector2 

#posição do texto
var Text_Position : Vector2

#region Simbolic Constants

#cor normal de Dramatic light
const DLCOLOR_NORMAL : Color = Color(1.0, 1.0, 0.54, 0.9)

#cor normal do backgroud
const BGCOLOR_NORMAL : Color = Color(0.07, 0.01, 0.16, 1.0)

#endregion

#tween que animara TUDO
var Tween_GameOver

#endregion

#region My Methods

#meu ciclo de vida
func Cicle_Life():

	#fico visivel
	visible = true

	#calculando posição do meu botão de menu
	Bottom_Menu_Position = Vector2(Menu_bottom.position.x, Menu_bottom.position.y/2)

	#calculando posição do meu texto
	Text_Position = Vector2(Text.position.x, Text.position.y/10)

	Tween_Objects(1.0, 1.25, 1.5) #meus objetos são animados

################################################################################

#método que animara os objetos
func Tween_Objects(_first : float = 0.0, _second : float = 0.0, _third : float = 0.0):

	#SE esse tween existir, eu deleto ele
	if Tween_GameOver: Tween_GameOver.kill()

	#crio um tween
	Tween_GameOver = create_tween()

	#agora esse tween é liberado da mémoria junto de mim
	Tween_GameOver.bind_node(self)

	Tween_GameOver.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC) #modifico o tipo de transição

	#meu backgroud fica visivel
	Tween_GameOver.parallel().tween_property(BackGroud, "color", BGCOLOR_NORMAL, _first)

	#os respectivos objetos ficam em suas posições
	Tween_GameOver.parallel().tween_property(Text, "position", Text_Position, _second).set_trans(Tween.TRANS_BACK)
	Tween_GameOver.parallel().tween_property(Menu_bottom, "position", Bottom_Menu_Position, _third).set_trans(Tween.TRANS_ELASTIC)
	
	#ESPERE até que o tween acabe
	await Tween_GameOver.finished

	Animated_Light() #rodo as animações de dramatic light

################################################################################

#método que fara o ciclo de animações de dramatic light
func Animated_Light():

	#minh luz dramatica aparece
	Dramatic_Light.get_child(0).play("start")

	#ESPERE ATÉ QUE a animação acabe
	await Dramatic_Light.get_child(0).animation_finished

	#minh luz dramatica roda a animação normal
	Dramatic_Light.get_child(0).play("fail")

################################################################################

#endregion 
