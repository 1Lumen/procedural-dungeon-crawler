class_name ArmorStats
extends PassiveItemStats

@export var type: Armor.Type
## Extra movespeed in % (additive).
@export_custom(PROPERTY_HINT_NONE, "suffix:+%") var bonus_move_speed: int
## Extra defense. Decides how much the incoming damage will be reduced. 
## Should use a function that moves toward 1 asymtotically, growing slower for big x (like sqrt(x)). 
@export var defense: int
## Extra max health.
@export var bonus_max_health: int
## How strong healing affects the character.
@export var healing_multiplier: float
