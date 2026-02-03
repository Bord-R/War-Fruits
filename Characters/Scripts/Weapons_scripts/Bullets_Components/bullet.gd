extends Area2D

#criando uma classe para ser usado como node
class_name Bala 

#region Variables

#danos
const DANOZERO = 0.0
const DANOBAIXO = 1.5
const DANOMEDIO = 2.5
const DANONORMAL = 3.5
const DANOALTO = 5.0

@export_group("Caracteristicas")

#minha textura
@export var texture : Sprite2D

#minha animação
@export var Anim : AnimationPlayer

#particula
@export var Particle : PackedScene

#escala da particula
@export var Scale_particle : Vector2 = Vector2(1.0, 1.0)

#boleano que vereficara se eu vou usar o método Color damage
@export var Bool_color : bool = false

#quantidade de pontos 
@export var Points_Acresim : int = 25

#quantidade de pontos de super
@export var Super_Acresim : int = 1

#Screen shake (efeito de camera)
@export var Screen_shake : MyCamera

#minha velocidade
@export var Vel : float 

#meu dano
@export var Damage : int

#meu empurrão
@export var Knockback : float

#boleano que vereficara se eu posso reduzir os pontos de super
@export var IsReduction_Super : bool = false

@onready var MyPlayer : FruitsCharacter #player

#minha particula instanciada
var Create_particle

#endregion

#region Methods

#método que rodara no inicio do jogo
func _ready() -> void:

	#definindo minha ordenação
	texture.z_index = 5

	#SE eu posso reduzir os pontos de super, eu reduzo eles
	if IsReduction_Super: Game.Decresim_Super()

	#definindo a mascara de colisão
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)

################################################################################

#método que ira rodar durante no game
func _process(_delta: float) -> void:
	
	#SE bool color for verdeiro, eu...
	if Bool_color == true:
		
		#método que muda minha cor com base na dano
		color_damage()

################################################################################

#endregion

#region My Methods

#método que ira mudar minha cor com base no meu dano
func color_damage():
	
	#SE meu for maior que 0 e menor que 1.2, eu executo o código
	if Damage > DANOZERO and Damage < DANOBAIXO: #dano baixo
		
		#sprite verde
		texture.frame = 2
	
	#SE NÃO, SE meu for maior que 1.2 e menor que 2.5, eu executo o código
	elif Damage > DANOBAIXO and Damage < DANOMEDIO: #dano médio baixo
		
		#sprite amarelo
		texture.frame = 3
	
	#SE NÃO, SE meu for maior que 2.5 e menor que 3.5, eu executo o código
	elif Damage > DANOMEDIO and Damage < DANONORMAL: #dano médio baixo
		
		#sprite azul
		texture.frame = 1
	
	#SE NÃO, SE meu for maior que 3.5 e menor que 5, eu executo o código
	elif Damage > DANONORMAL and Damage <= DANOALTO: #dano médio baixo
		
		#sprite vermelho
		texture.frame = 0

################################################################################

#método para criar um efeito ao eu morrer
func Effect_explodion():
	
	#criando instancia
	Create_particle = Particle.instantiate()
	
	#adicionando ela a scenetree
	get_tree().root.call_deferred("add_child", Create_particle)
	
	#definindo a posição dela
	Create_particle.global_position = global_position
	
	#definindo a escala da instancia
	Create_particle.scale = Scale_particle
	
	#definindo a rotação da instancia
	Create_particle.rotation = randf_range(-360, 360)
	
	#SE a minha particula for uma bala, o shake dela vai ser igual ao meu
	if Create_particle is Bala: Create_particle.Screen_shake = Screen_shake
	
	#me deleto
	queue_free()

################################################################################

#endregion
