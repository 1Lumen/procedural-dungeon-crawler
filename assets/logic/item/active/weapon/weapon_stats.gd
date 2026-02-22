class_name WeaponStats
extends ActiveItemStats

@export var type: Weapon.Type
@export var handed: Weapon.Handed
@export var weapon_class: Weapon.Class
@export var combo: Combo
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var range: float = 2.0
