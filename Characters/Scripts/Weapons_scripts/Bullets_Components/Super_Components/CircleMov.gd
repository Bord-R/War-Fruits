extends Node

#criando classe para ser usado como node
class_name CircleMov

@export var Father : CharacterBody2D = null #meu pai

#método que rodara a cada frame
func _process(_delta: float) -> void:

    #SE eu tiver um pai, eu faço o pai rodar
    if Father: CircleMoviment(_delta)
    else: printerr("Not parent!!!")

################################################################################

#método que fara o movimento circular do meu pai
func CircleMoviment(_value : float):

    #SE o angulo for maior que uma volta completa
    if Father.Angle > TAU:

        #zero o angulo
        Father.Angle = 0

        return #retorna

    Father.Angle += (_value * Father.Vel) #o angulo é somado a _value multiplicado pela velocidade

    #calculando a posição em movimento /seno e cosseno do angulo mais o angulo a ser somado respectivamente, tudo multiplicado pelo raio/
    Father.Mov_Postion = Vector2(sin(Father.Angle + Father.Summed_Angle), cos(Father.Angle + Father.Summed_Angle)) * Father.Radius

    #calculo a posição do player
    if Father.Player: Father.Player_Postion = Father.Player.global_position

    #minha posição global é igual a posição em movimento mais a posição do player
    Father.global_position = Father.Player_Postion + Father.Mov_Postion

################################################################################
