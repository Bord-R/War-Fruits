extends Estado

#criando uma classe para ser usado como node
class_name EstadoDash #estado de Dash

#region Variables

#minha animação
@export var Anim : AnimationPlayer

#minha area2d
@export var Area2d : Area2D

#minha sprite
@export var Sprite2d : Sprite2D

@export var Frame_Ghost : int

#velocidade maxima do dash
@export_range(2.0, 10.0, 0.5) var Dash_Vel_Max : float = 3.0

#velocidade minima para comparação
const MIN_VEL : float = 0.2

#direção do dash
var Dash_direction : Vector2

#velocidade do dash
var Dash_vel : float = Dash_Vel_Max

#tempo para criar um Effect dash
var Seg : float = 0.125

#meu timer
var Dash_Timer : Timer = Timer.new()

#função em forma de variavel que criara o efeito no dash
var Parou_Timer : Callable = func (): Create_Effect()

#endregion

#region My Methods

#método que rodara quando eu iniciar
func Entrada():
	
	#mudando minha animação para Pre atk
	Pai_estados.Anim_nome = "Preatk"
	
	#garantindo que o delay_vel volte a ter seu valor original
	Dash_vel = Dash_Vel_Max
	
	#fazendo o dash direction ter seu valor original
	Dash_direction = Vector2.ZERO
	
	#Conecto o sinal ao método
	VM.Conected_Signals(Anim.animation_finished, Animacao_finalizada)
	
	#SE o dash timer NÃO ESTIVER na Scenetree, eu adciono ele a Scenetree
	if !Dash_Timer.is_inside_tree(): get_tree().current_scene.add_child(Dash_Timer)
	
	#meu tempo de espera
	Dash_Timer.wait_time = Seg
	
	#meu timer inicia
	Dash_Timer.start()
	
	#Conecto o sinal ao método
	VM.Conected_Signals(Dash_Timer.timeout, Parou_Timer)

################################################################################

#método que rodara a fisica
func Atualizacao_Fisica(_delta : float):
	
	#trocando o lado que o character olha
	Character.Flip_Direcao()
	
	#definindo uma movimentação para o character realizar
	Character.velocity = Dash_direction * Dash_vel
	
	#SE o Dash_vel for maior que VALOR_MINIMO E dash direction for igual a um vetor zerado,
	#eu executo o código
	if Dash_vel > MIN_VEL and Dash_direction != Vector2.ZERO:
		
		#diminuindo o dash vel
		Dash_vel -= VM.MINOS_TIMER
	
	#SE NÃO, SE o dash vel for menor que VALOR_MINIMO, eu executo o código
	elif Dash_vel < MIN_VEL:
		
		#trocando o estado para o estado de splash
		Pai_estados.Troca_Estado(State[0])
	
	#movendo o character
	Character.move_and_slide()

################################################################################

#método que vereficara se a animação acabou
func Animacao_finalizada(_Anim : StringName):
	
	#SE a animação for igual a Preatk, eu executo o código
	if _Anim == "Preatk":
		
		#definindo a direcão do meu player
		var _Player_direction = Character.player.global_position
		
		#definindo a direção do dash
		Dash_direction = _Player_direction - Character.global_position
		
		#definindo animação 
		Pai_estados.Anim_nome = "Dash"

################################################################################

func Saida():
	Dash_Timer.stop()

################################################################################

#método que criara o efeito
func Create_Effect():
	
	var _light = PointLight2D.new() #criando efeito de bilho

	#criando instancia
	var _Create_Effect = DashEffect.new(Sprite2d.global_position, Character.scale, Sprite2d.texture, _light, Color.RED, 2.0)
	
	#mudando o corte de cada frame
	_Create_Effect.hframes = Sprite2d.hframes
	_Create_Effect.vframes = Sprite2d.vframes

	_light.texture = load("res://Characters/Sprites/Effects/Sprite-BlurEffect.png") #coloco uma textura no ponto de luz
	
	#mudando a direção do efeito
	_Create_Effect.flip_h = Character.Image_texture.flip_h
	
	#mundando para o 1º frame
	_Create_Effect.frame = Frame_Ghost
	
	#adcionando a instancia como filha da cena atual
	get_tree().current_scene.add_child(_Create_Effect)

	#adiciono como filho da instancia
	_Create_Effect.add_child(_light)

################################################################################

#endregion
