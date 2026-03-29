class_name Stats
extends Resource
## Base class for all stats.

## The power level of the item or character. Many stats scale with it.
@export var power: int = 1
@export var stats: Dictionary[Stat.Type, Stat]


## Returns the stat matching the given [param]type[/param] scaled by the stats' power level.
func get_stat(type: Stat.Type) -> float:
	var stat = stats.get(type) as Stat
	if not stat:
		push_warning("No stat of type %s found on %s" % [str(type), resource_name])
		return 0
	return stat.value * stat.get_power_multiplier(power)
