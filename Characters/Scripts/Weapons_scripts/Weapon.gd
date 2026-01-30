extends CharacterBody2D

#classe base para criar futuras armas
class_name Armas

#region Variables

#region Weapons Status

@export_group("Weapons Status")

#tipo de bala da arma
@export var Bullet : PackedScene = null

#tipo de super da arma
@export var Super_Bullet : PackedScene = null

#meu buff para a super
@export_range(1.0, 2.0, 0.05) var Buff_Super : float = 1.0

#meu intervalo de curvatura
@export var Variant_Curve : Dictionary[String, float] = {"Min_Curve": 0.0, "Max_Curve": 0.0}

#curvatura da bala
var Curve_bullet : float = 0.0

#meu intervalo de dano
@export var Variant_Damage : Dictionary[String, int] = {"Min_Damage": 0, "Max_Damage": 0}

#buff para o dano da super
@export_range(0, 100, 1) var Buff_Damage : int = 25

#dano da bala
var Damage_bullet : int = 0

#delay maximo da arma
@export_range(0.0, 5.0, 0.05) var MAX_DELAY_WEAPON : float = 0.0

#delay da arma
var Delay_weapon : float = 0.0

#empurrão da bala
@export_range(0.0, 10.0, 0.05) var Knock_bullet : float = 0.0

#quantidade de balas que eu posso atirar
@export var Quantity_bullets : int = 1

#quantidade de supers que  eu posso atirar
@export var Quantity_Super : int = 1

#meu screenshake ao atirar
@export_range(0.0, 5.0, 0.05) var Shake_pistol : float = 0.0

#velocidade da bala
@export_range(0.5, 10.0, 0.05) var Vel_bullet : float = 0.0

#minha animação brilhando
@export var Glow_anim : StringName = ""

#minha animação ao ser usado
@export var Use_anim : StringName = ""

#endregion

#criando uma categoria de variaveis que podem ser alteradas no inspetor
@export_category("Nodes")

#animação
@export var Anim : AnimatedSprite2D

#colisão
@export var Collision : CollisionShape2D

#meu ray
@export var Ray : RayCast2D

#minha area2d
@export var Area : Area2D

#ponto onde surgira a bala
@export var Marker : Marker2D

#meu pai atual kkkkKKK
@onready var Pai_atual : FruitsCharacter

#camera da minha scenetree atual
@onready var Camera : MyCamera = owner.get_node("MyCamera")


#region Simbolics Constants

#valor zero
const ZERADO : float = 0.0

#suavização de lerp
const SUAVIZACAO : float = 0.1

#valor minimo para a velocidade de quando eu for dropado
const MIN_DROP_VEL : float = 0.2

#minos timer para super
const MINOS_SUPER : float = 0.05

#escala horizontal modificada
const XMOD_SCALE : float = 0.7

#escala vertical modificada
const YMOD_SCALE : float = 1.3

#tempo do tween do método effect pistol
const SEG_TWEEN : float = 0.1

#endregion

#minha velocidade maxima ao ser dropado
const MAX_DROP_VEL : float = 10.0

#minha velocidade ao ser dropada
var Drop_vel : float = MAX_DROP_VEL

#minha direção ao ser dropada
var Drop_direction : Vector2 

#boleano que vereficara se eu tenho um pai
var Bool_pai : bool = false #não tenho um pai, igual vc aí kkkkk

#boleano que vereficara uma condição para uma função
var Bool_scale : bool = false

#minha escala original 
var Normal_scale : Vector2 = scale

#minha escala atual
var Atual_scale : Vector2

#minha animação atual
var Atual_anim : String = ""

#escala modificada para a animação
var MODAnim_Scale : Vector2 = Vector2(XMOD_SCALE, YMOD_SCALE)

#animação de atirar
var Tween_pistol_fire

#endregion

#region Methods

#método que ira rodar no inicio do game
func _ready() -> void:
	
	#não sou carregado
	visible = false
	
	#desativando a minha colisão
	Collision.disabled = true
	
	#meu z index é igual a 6
	z_index = 6
	
	#conectando um sinal via código
	VM.Conected_Signals(Area.area_entered, Area_ativada)
	VM.Conected_Signals(Area.area_exited, Area_desativada)

################################################################################

#método que ira rodar a fisica a cada instante do game
func _physics_process(_delta: float) -> void:
	
	#SE o player estiver morto
	if !Game.Player_Dead:

		#chamado método para qunado eu for usada
		Usando_arma()
		
		#chamando método para dar um efeito 
		Effect_pistol()
		
		#SE minhas animações Não são inesistentes
		if Glow_anim != "" and Use_anim != "":
		
			#SE eu NÃO tiver um pai
			if !Bool_pai:
				
				Animated(Glow_anim) #animação brilhando
			
			else: #SE NÃO
				
				Animated(Use_anim) #animação de sendo usado

	#SE NÃO
	else: 
		#eu me deleto
		queue_free()

################################################################################

#endregion

#region My Methods

#função associada ao sinal area_entered
func Area_ativada(_area : Area2D): #parametro para se referir a area que eu colidi
	
	#SE o nome da area for igual a "Carregador", eu sou carregado
	if _area.name == "Carregador": visible = true
	
	#SE o nome da area em que eu colidi for igual a "Player", eu
	if _area.name == "Player":
		
		#meu pai atual vai ser o parente da area a qual eu colidi
		Pai_atual = _area.get_parent()
		
		#SE o pai NÃO POSSUI UMA ARMA, eu
		if !Pai_atual.Possui_arma:
			
			#eu ganho um pai
			Bool_pai = true
			
			#meu pai passa a possuir uma arma
			Pai_atual.Possui_arma = true
			
			#meu pai tem sua arma atual sendo eu mesmo
			Pai_atual.Pistol_atual = self

################################################################################

#função associada ao sinal area_exited
func Area_desativada(_area : Area2D): #parametro para se refereir a area que eu deixei de colidir
	
	#SE o nome da area for igual a carregador, eu deixo de ser carregado
	if _area.name == "Carregador": visible = false 

################################################################################

#método para quando eu ser usado
func Usando_arma():
	
	#SE eu tenho um pai eu...
	if Bool_pai:
		
		#irei gira de acordo com a posição do mouse
		look_at(get_global_mouse_position())
		
		#mudo minha posição global para a posição global do meu pai
		global_position = Pai_atual.global_position
		
		#meu grau de rotação tem como parametros: ele mesmo, 0(valor minimo) e 360(valor maximo)
		rotation_degrees = wrap(rotation_degrees,0,360)
		
		#SE meu grau de rotação for menor que 270º e maior que 90º, eu...
		if rotation_degrees < 270 and rotation_degrees > 90: #quando a arma fica apontada para a esquerda
			
			#minha animação inverte a imagem verticalmente
			Anim.flip_v = true
			
			return #retorna caso a condicional acima seja verdadeira
		
		#minha animação desinverte a imagem verticalmente
		Anim.flip_v = false #quando a arma fica apontada para a direita
	
	#SE NÃO, eu...
	else:
		
		#minha velocidade ao ser dropada é diminuida até chegar em 0 com uma suavização d 0.1
		Drop_vel = lerp(Drop_vel, ZERADO, SUAVIZACAO)
		
		#criando uma variavel local que me movera até que eu colida com alguma caixa de colisão
		var _Colide = move_and_collide(Drop_direction * Drop_vel)
		
		#SE minha velocidade for menor que o valor minimo, eu...
		if Drop_vel < MIN_DROP_VEL:
			
			#minha colisão é desabilitada
			Collision.disabled = true
		
		#SE eu colidi, eu...
		if  _Colide:
			
			#minha direção é "refletida"
			Drop_direction = Drop_direction.bounce(_Colide.get_normal())

################################################################################

#método para atirar
func Atirando():
	
	#meu dano é atualizado
	Damage_bullet = randi_range(Variant_Damage["Min_Damage"], Variant_Damage["Max_Damage"])
	
	#minha curvatura é atualizada
	Curve_bullet = randf_range(Variant_Curve["Min_Curve"], Variant_Curve["Max_Curve"])
	
	#meu delay é diminuido
	Delay_weapon -= VM.MINOS_TIMER
	
	#SE meu delay for menor ou igual a zero, eu...
	if Delay_weapon <= 0.0:
		
		#usando um método da camera da minha scenetree para gerar um screen shake
		Camera.trigger_shake(Shake_pistol)
		
		#PARA variavel local _Bala chegar ao alcance da quantidade de balas, eu...
		for _Bala in range(Quantity_bullets): #criando um for loop
			
			#criando uma variavel local que sera responsavel por instanciar a minha bala
			var _Bullet_create = Bullet.instantiate()
			
			#adicionando essa nova instancia como filha da minha Scenetree
			get_tree().root.add_child(_Bullet_create)
			
			#a posição de surgimento da minha bala vai ser igual ao ponto de partida(marker)
			_Bullet_create.global_position = Marker.global_position
			
			#definindo o valor de uma variavel da bala como um nó da minha scenetree
			_Bullet_create.Screen_shake = Camera
			
			#definindo a rotação da minha bala
			_Bullet_create.global_rotation = global_rotation + (Curve_bullet * _Bala)
			
			#definindo a velocidade do meu projetil
			_Bullet_create.Vel = Vel_bullet
			
			#definindo o dano da bala
			_Bullet_create.Damage = Damage_bullet 
			
			#definindo o "empurrão" do projetil
			_Bullet_create.Knockback = Knock_bullet
		
		#meu delay volta ao seu valor maximo
		Delay_weapon = MAX_DELAY_WEAPON
		
		#chamando método para ele dar um efeito legal
		Effect_pistol()
		
		#eu posso modificar minha escala
		Bool_scale = true #isso ira ativar um if do método Effect_pistol()

################################################################################

#método para atirar a super
func Super():

	#SE eu NÂO tenho uma Super
	if !Super_Bullet:
		return #retorna

	Delay_weapon -= MINOS_SUPER #diminuo o timer
 
	#DEFININDO O DANO E A IMPRESSIÇÂO
	Damage_bullet = Variant_Damage["Max_Damage"]
	Curve_bullet = Variant_Curve["Min_Curve"]

	#SE o delay da arma for menor ou igual que 0
	if Delay_weapon <= 0.0:

		#atualizando o efeito do meu pai
		Pai_atual.Update_backGroud(Pai_atual.COLOR_SUPER)

		#usando método da camera da minha cena para gerar um screen shake
		Camera.trigger_shake(Shake_pistol * Buff_Super)

		#PARA _super (var local) chegar ao alcance dw Quantity
		for _Super in range(Quantity_Super):
				
			#instanciando a super e armazenando ela em uma variavel
			var _Create_Super = Super_Bullet.instantiate()

			_Create_Super.MyPlayer = Pai_atual

			#adicionando a instancia a scenetree
			get_tree().root.add_child(_Create_Super)

			#minha super pode decresser os pontos de super
			_Create_Super.IsReduction_Super = true

			#mudando a posição de origem da super
			_Create_Super.global_position = Marker.global_position

			#definindo o valor de uma variavel da bala como um nó da minha scenetree
			_Create_Super.Screen_shake = Camera

			#definindo a rotação da minha super
			_Create_Super.global_rotation = global_rotation + Curve_bullet * _Super
			
			#definindo a velocidade da minha super
			_Create_Super.Vel = Vel_bullet * Buff_Super
					
			#definindo o dano da minha super
			_Create_Super.Damage = Damage_bullet * Buff_Damage
					
			#definindo o "empurrão" da super
			_Create_Super.Knockback = Knock_bullet * Buff_Super


		#meu delay volta ter seu valor original
		Delay_weapon = MAX_DELAY_WEAPON

		#chamando método para ele dar um efeito legal
		Effect_pistol()

		#posso modificar minha escala
		Bool_scale = true #isso ativara um if do método effect pistol

################################################################################

#método para quando eu for dropada(jogada)
func Drop_arma():
	
	#SE eu tenho um pai e meu raycast não esta colidindo com nada, eu...
	if Bool_pai and !Ray.is_colliding():
		
		#reseto o valor da minha velocidade de drop
		Drop_vel = MAX_DROP_VEL
		
		#minha colisão é abilitada
		Collision.disabled = false
		
		#deixo de ser a arma atual do meu pai
		Pai_atual.Pistol_atual = null
		
		#meu pai deixa de possuir uma arma
		Pai_atual.Possui_arma = false
		
		#meu pai atual deixa de ser meu pai
		Pai_atual = null
		
		#eu perco meu pai
		Bool_pai = false

################################################################################

#método para criar um efeito legalzinho (:<
func Effect_pistol():
	
	#a escala da minha animação é igual a escala atual
	Anim.scale = Atual_scale
	
	#SE eu posso modificar minha escala
	if Bool_scale:

		#minha escala atual é modificada
		Atual_scale = MODAnim_Scale

		#deixo de poder de modificar minha escala
		Bool_scale = false

	#SE eu NÃO posso modificar minha escala
	if !Bool_scale:

		#SE essa variavel tiver um valor
		if Tween_pistol_fire:

			#eu deleto esse tween
			Tween_pistol_fire.kill()

		#criando um tween (interpolação)
		Tween_pistol_fire = create_tween()
		
		#conectando ele a mim mesmo para quando eu for liberado da memória ele va junto
		Tween_pistol_fire.bind_node(self)

		#interpolando a minha propriedade Atual scale para ter como valor final Normal scale em Seg tween de segundos
		Tween_pistol_fire.tween_property(self, "Atual_scale", Normal_scale, SEG_TWEEN)

################################################################################

#criando um método para minha animação
func Animated(_New_anim : String):
	
	#SE minha animação atual não for igual a minha nova animação, eu executo o codígo
	if Atual_anim != _New_anim:
		
		#minha animação atual é igual a minha nova animação
		Atual_anim = _New_anim
	
	#tocando a animação atual
	Anim.play(Atual_anim)

################################################################################

#endregion
