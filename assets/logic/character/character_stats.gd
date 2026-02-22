class_name CharacterStats
extends Stats
## Holds all stats of basic characters.

@export_category("Base Character")
@export_group("Visuals")
@export var name: String
@export var model_name: String
@export_enum("Medium", "Large") var model_type: String
@export_group("Base Movement")
@export var walk_speed: float
@export var run_speed: float
@export var turn_speed: float
@export_subgroup("Acceleration")
@export var walk_acceleration: float
@export var walk_deceleration: float
@export var run_acceleration: float
@export var run_deceleration: float
@export_category("Stats")
@export_group("Combat")
@export_subgroup("Offense")
@export var attack_speed: int = 100
## All damage is multiplied by this in %.
@export var strength: int = 100
@export_subgroup("Defense")
@export var max_health: int = 100
## Decides how much the incoming damage will be reduced. 
## Should use a function that moves toward 1 asymtotically, growing slower for big x (like sqrt(x)). 
@export var defense: int
## Health regenerated passively per second.
@export_custom(PROPERTY_HINT_NONE, "suffix:/s") var regeneration: int 
## How strong healing affects the character.
@export_custom(PROPERTY_HINT_NONE, "suffix:x") var healing_multiplier: float = 1.0
@export_group("Movement")
## Move speed that is multiplied with base character run speed.
@export var speed: int = 100
@export_group("Gear")
@export var primary_starting_weapon: WeaponStats
@export var secondary_starting_weapon: WeaponStats
@export var starting_armor: ArmorStats
