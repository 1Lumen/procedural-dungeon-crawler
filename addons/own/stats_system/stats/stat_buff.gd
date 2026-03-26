class_name StatBuff
extends Resource

## How the buff value is calculated together with the stats.
## Add: Add value on top of stat scaled by power.
## Mulitply: multiply stat by value.
## Flat: Add fixed value on top of stat.
enum Type { ADD, MULTIPLY, FLAT }

@export var stat: Stat
@export var type := Type.ADD


## Returns the buffed stat value.
## The way the combined value is calculated depends on the buff type.
func apply(value: float, power: int) -> float:
	match type:
		Type.ADD:
			return value + (stat.value * stat.get_power_multiplier(power))
		Type.MULTIPLY:
			return value * stat.value
		Type.FLAT:
			return value + stat.value
		_:
			return value
