extends AudioStreamPlayer2D

class_name SoundEffect #criando a classe SoundEffect como nó

#variáveis para definir os limites de randomização do volume e pitch do som
@export var Max_Db : float = 0.0 #limite máximo para o volume do som
@export var Min_Db : float = 0.0 #limite mínimo para o volume do som
@export var Max_Pitch : float = 0.0 #limite máximo para o
@export var Min_Pitch : float = 0.0 #limite mínimo para o pitch do som

#função para randomizar o volume e pitch do som, dentro dos limites definidos
func Randomize_Sound():

    #gerando um valor aleatório para o volume e pitch do som, dentro dos limites definidos
    var _volume : float = randf_range(Min_Db, Max_Db) #gerando um valor aleatório para o volume do som, dentro dos limites definidos
    var _pitch : float = randf_range(Min_Pitch, Max_Pitch) #gerando um valor aleatório para o pitch do som, dentro dos limites definidos

    #aplicando os valores gerados ao som
    volume_db = _volume
    #aplicando o valor gerado para o pitch do som
    pitch_scale = _pitch
