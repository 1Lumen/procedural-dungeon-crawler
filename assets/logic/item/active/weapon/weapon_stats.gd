class_name WeaponStats
extends ActiveItemStats

@export var type: Weapon.Type
@export var handed: Weapon.Handed
@export var weapon_class: Weapon.Class
@export var combo: Combo
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var range: float = 2.0


## Returns the stat matching the given [param]type[/param] scaled by the stats power level.
## If the weapon's damage is requested, returns the damage of the current attack in the combo.
func get_stat(type: Stat.Type) -> float:
	var stat = stats.get(type) as Stat
	if type == Stat.Type.DAMAGE:
		stat = combo.attacks[combo.index].damage
	if not stat:
		push_warning("No stat of type %s found on %s" % [str(type), resource_name])
		return 0
	return stat * stat.get_power_multiplier(power)
