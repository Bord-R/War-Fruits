extends Area2D

#region Variables

#minha Sprite2d
@export var Texture2d : Sprite2D

const COLOR = Color(1.0, 0.521, 0.0,1.0) #minha cor

#valor a ser subtraido
const PMINOS_TIMER : float = 0.05 #5%

#tempo maximo de vida que eu tenho
const LIFE_TIMER_MAX : float = 100.0

#decreximo
const DECRESIMO : float = 0.2

#variavel que ira mudar minha transparencia
var alpha : float = 0.0

#variavel que definira meu tempo de vida
var timer_life : float = LIFE_TIMER_MAX

var decresim_vel : float = 0 #velocidade reduzida do player

#endregion

#region Methods

#método que ira rodar a cada frame do game
func _process(_delta: float) -> void:
	
	#SE o player morreu eu me deleto
	if Game.Player_Dead: queue_free()
	
	#meu tempo de vida é diminuido
	timer_life -= PMINOS_TIMER 
	
	#SE o meu tempo de vida for maior que 0, eu executo o código
	if timer_life > 0.0:
		
		#SE alpha menor que 0, eu executo o código
		if alpha < 1.0:
			
			#meu alpha aumenta
			alpha += PMINOS_TIMER
	
	#SE NÃO
	else:
		
		#SE meu alpha for maior que 0, eu executo o código
		if alpha > 0.0:
			
			#alpha é diminuido
			alpha -= PMINOS_TIMER
		
		#SE NÃO, SE alpha for menor ou igual a 0, eu...
		elif alpha <= 0.0:
			
			#me deleto
			queue_free()
	
	#a cor da minha textura fica transparente 
	Texture2d.modulate = Color(COLOR.r, COLOR.g, COLOR.b, alpha)

################################################################################

#método que vereficara se eu colidi com algum corpo
func _on_body_entered(_body: Node2D) -> void:
	
	#SE o corpo for um tilemaplayer, eu...
	if (_body is TileMapLayer):
		
		#me deleto
		queue_free()
	
	#SE o nome do corpo que eu colidi for igual "Player_body", eu executo o código
	if (_body.name == "Player_body"):

		decresim_vel =_body.VEL_MAX * DECRESIMO #dando um valor a decresim vel
	
		#a variavel vel max do player é reduzida
		_body.vel = decresim_vel

################################################################################

#método que vereficara se eu deixei de colidir com algum corpo
func _on_body_exited(_body: Node2D) -> void:
	
	#SE o nome do corpo que eu colidi for igual "Player_body", eu executo o código
	if (_body.name == "Player_body"):
		
		#a variavel vel do corpo é igual a constante VEL_MAX do corpo
		_body.vel = _body.VEL_MAX

################################################################################

#endregion
