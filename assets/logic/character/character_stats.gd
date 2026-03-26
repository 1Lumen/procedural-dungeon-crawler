class_name CharacterStats
extends Stats
## Holds all stats of basic characters.

@export_category("Base Character")
@export_group("Visuals")
@export var name: String
@export var model_name: String
@export_enum("Medium", "Large") var model_type: String
@export_group("Gear")
@export var primary_starting_weapon: WeaponStats
@export var secondary_starting_weapon: WeaponStats
@export var starting_armor: ArmorStats
