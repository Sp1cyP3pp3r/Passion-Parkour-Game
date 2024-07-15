extends Stats
class_name PlayerStats

@export var speed : float
@export var acceleration : float
@export var additional_speed : float
@export var gravity : float
@export var jump_power : float

@export var max_hp : float
var current_hp : float
@export var damage_resistance : float
@export var healing_resistance : float

enum PROPERTY_LIST {debug,speed,acceleration,additional_speed,gravity,jump_power,max_hp,current_hp,damage_resistance,healing_resistance}
# Probably need to find a better way to transliterate property list, idk
# 'debug' value is not to be used
