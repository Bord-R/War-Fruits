extends ProgressBar

#region Variables

@export var Daddy : EnemiesFruits = null #meu pai

@export var Points : int = 100 #pontos

@export var Super_Points : int = 2 #pontos de super

@export var Init_Life : int  #vida inicial

var valid75 : bool = true ##
var valid50 : bool = true #---VALIDAÇÕES---#
var valid25 : bool = true ##

var Tween_Life : Tween = null #tween

#endregion

#region Methods

func _ready():
	
	max_value = Init_Life #o valor maximo vai ser igual a vida inicial

	value = max_value #valor igual a valor maximo

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

	if Daddy.Enemie_life <= 0: #SE a vida do pai for menor ou igual a 0
				
		#SE esse tween existe eu deleto ele
		if Tween_Life: Tween_Life.kill()

		#instancio ele e conecto a mim
		Tween_Life = create_tween().bind_node(self)

		#fico transparente
		Tween_Life.tween_property(self, "modulate", Color.TRANSPARENT, .25)
		
		await Tween_Life.finished #ESPERE até que a animação acabe

		queue_free() #me deleto
	
	#region Bonus Validations

	if valid75 and (value <= max_value * 75.0/100): #SE value for menor ou igual a 75% de max value e estiver valido fazer isso
		BonusHit() #adionando 
		valid75 = false #desfazendo validação
		
	elif value <= max_value * 50.0/100 and valid50: #SE value for menor ou igual a 75% de max value e estiver valido fazer isso
		BonusHit() #adionando pontos
		valid50 = false #desfazendo validação
		
	elif value <= max_value * 25.0/100 and valid25: #SE value for menor ou igual a 75% de max value e estiver valido fazer isso
		BonusHit() #adionando pontos
		valid25 = false #desfazendo validação

	#endregion

################################################################################

#método que dara um bonus de pontuação e super
func BonusHit():

	Game.Acresim_Points(Points) #adicionando pontos 

	Game.Super_Bonus += Super_Points #adicionando pontos de super

################################################################################

#endregion
