@abstract
class_name Stats
extends Resource
## Base class for all stats. Only used to filter resources.

## The power level of the item or character. Many stats scale with it.
@export var power: int = 1


# TODO: Find right scaling function.
## Returns the value all base stats are multiplied with for the stat holders power level.
## Power level 1 returns a multiplier of 1.0.
func get_power_multiplier() -> float:
	return sqrt(power)
