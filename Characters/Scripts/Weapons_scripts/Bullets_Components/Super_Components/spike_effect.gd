extends CharacterBody2D

#region Variables

signal isdead() #sinal que ativara quando eu morrer

@onready var Player : FruitsCharacter = null #meu player

@onready var Camera : MyCamera = null #camera

#minha sprite
@export var MyTexture : Sprite2D

#minha area2d
@export var HitBox : Area2D

#meu animation player
@export var Anim : AnimationPlayer

#quantidade de pontos
@export var Points : int

#quantidade de pontos de super
@export var Points_Super : int

#chaqualho
const SHAKE : float = 2.5

#dano que darei no inimigo
const DAMAGE : int = 1

#empurrão que darei no inimigo
const KNOCKBACK : float = 1.5

#angulo
var Angle : float = 0.0

#velocidade
var Vel : float = 2.0

#raio do circulo
var Radius : float = 40.0

#angulo somado
var Summed_Angle : float = 0.0

#posição em movimento
var Mov_Postion : Vector2 = Vector2.ZERO

#posição do player
var Player_Postion : Vector2 = Vector2.ZERO

#vida
var Life : int = 1

#tween que interpolara meu raio
var Radius_Tween : Tween

#endregion

#region Methods

#método que rodara quando eu estiver carregado
func _ready():

    #SE meu node pai for da classe fruitscharacter
    if get_parent() is FruitsCharacter:Player = get_parent() #meu player é igual a esse pai

    else: queue_free() #SE NÃO, eu me deleto

    Camera = Player.Screen_shake #camera igual a camera do player

    #conecto o sinal ao método
    VM.Conected_Signals(HitBox.area_entered, HitBox_On)

################################################################################

#método que rodara a cada frame
func _physics_process(_delta: float) -> void:

    if Game.Player_Dead: #SE o player estiver morto
        Anim.play("destroy") #toco destroy
        Game.Is_CreateSpike = true #posso criar novos espinhos
        return #retorna

    #giro circular
    SpinMoviment()

################################################################################

#endregion

#region My Methods

#método que fara eu fazer o movimento circular
func SpinMoviment():

    #defino o intervalo que meu grau de rotação vai poder ter
    rotation_degrees = wrap(rotation_degrees, 0, 360)

    #SE meu grau de rotação for maior que 270 E menor que 90
    if rotation_degrees < 270 and rotation_degrees > 90:

        MyTexture.flip_v = true #meu flip vertical é ativado

    else: MyTexture.flip_v = false #SE NÃO, ele é desativado

    look_at(Player_Postion) #giro na direção do player

################################################################################

#método que ira rodar quando o sinal area_entered for emitido
func HitBox_On(_area : Area2D):

    #SE o pai de _area for um enemiefruits
    if _area.get_parent() is EnemiesFruits:

         #crio variaveis locais para facilitar as chamadas
        var _enemy : EnemiesFruits = _area.get_parent() #inimigo

        #SE o estado atual do inimigo for hit, retorna
        if _enemy.Maquina_estados.Estado_Atual is EstadoHit: return

        Camera.trigger_shake(SHAKE) #tremo a tela

        #faço ele tomar dano
        _enemy.Take_Damaged(
            DAMAGE,
            global_position,
            KNOCKBACK,
            Points_Super,
            Points
        )

        if Life > 0: #SE a vida for maior que 0
            Anim.play("hit") #rodo hit
            Life -= 1 #perco um de vida

        #SE NÃO, SE a vida for igual ou menor que 0
        elif Life <= 0:

            Anim.play("destroy") #toco destroy

            isdead.emit() #emito o sinal que falara para meu pai que eu morri

################################################################################

#método que interpolara meu raio
func Interpolate_Radius(_time, _max_radius): # / _tempo / _raio_maximo/

    if Radius_Tween: Radius_Tween.kill() #SE esse tweem existe, eu deleto ele

    Radius_Tween = create_tween().bind_node(self) #crio tween e conecto ele a mim 

    #definindo o tipo de transição
    Radius_Tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

    Radius_Tween.set_loops(-1) #animação rodara em loop

    #raio contrai
    Radius_Tween.tween_property(self,"Radius", _max_radius/1.8, _time)

    #raio expande
    Radius_Tween.tween_property(self,"Radius", _max_radius, _time)

################################################################################

#endregion
