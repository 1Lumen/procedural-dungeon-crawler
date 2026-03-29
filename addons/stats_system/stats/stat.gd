class_name Stat
extends Resource

enum Type {
	WALK_SPEED,
	RUN_SPEED,
	TURN_SPEED,
	WALK_ACCELERATION,
	WALK_DECELERATION,
	RUN_ACCELERATION,
	RUN_DECELERATION,
	ATTACK_SPEED,
	STRENGTH,
	MAX_HEALTH,
	DEFENSE,
	REGENERATION,
	HEALING_MULTIPLIER,
	SPEED,
	RANGE,
	DAMAGE,
	# ...
	# Add more stat types here.
}

enum Scaling {
	ROOT,
	LOGARITHMIC,
	LINEAR,
	NONE,
	CUSTOM,
}

## The value of the stat.
@export var value: float:
	set(x):
		match precision:
			1:
				value = floor(x)
			2:
				value = round(x)
			3:
				value = ceil(x)
			_:
				value = x
## The precision of the value. Determines if the value has decimals or is rounded.
@export_enum("Float", "Floor", "Round", "Ceil") var precision: int = 1
## The power scaling function applied. Set to custom to provide a custom function.
@export var scaling: Scaling:
	set(value):
		scaling = value
		notify_property_list_changed()
## The custompower scaling function. Only used when [member]scaling[/member] is set to CUSTOM.
@export var custom_scaling_function: String

var custom_function = Expression.new()


#func _init(builder: Builder) -> void:
	#precision = builder._precision
	#value = builder._value


# BALANCE: Find right scaling functions.
## Returns the value all base stats are multiplied with for the stat holders power level.
## Power level 1 should return a multiplier of 1.0.
func get_power_multiplier(power: int) -> float:
	match scaling:
		Scaling.ROOT:
			return sqrt(power)
		Scaling.LOGARITHMIC:
			return log(power)
		Scaling.LINEAR:
			return power * 0.1
		Scaling.NONE:
			return 1.0
		_:
			return _get_custom_function_multiplier(power)


func _get_custom_function_multiplier(power: int) -> float:
	var error = custom_function.parse(custom_scaling_function)
	if error != OK:
		print(custom_function.get_error_text())
		return 0
	var result = custom_function.execute()
	if custom_function.has_execute_failed():
		return 0
	return result


#class Builder:
	#var _precision: int
	#var _value: float
	#
	#
	#func precision(precision: int) -> Builder:
		#_precision = precision
		#return self
	#
	#
	#func value(value: float) -> Builder:
		#_value = value
		#return self
	#
	#
	#func build() -> Stat:
		#return Stat.new(self)
