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
}

@export var type: Type
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
@export_enum("Float", "Floor", "Round", "Ceil") var precision: int = 1


func _init(builder: Builder) -> void:
	type = builder._type
	precision = builder._precision
	value = builder._value


class Builder:
	var _type: Type
	var _precision: int
	var _value: float
	
	func type(type: Type) -> Builder:
		_type = type
		return self
	
	
	func precision(precision: int) -> Builder:
		_precision = precision
		return self
	
	
	func value(value: float) -> Builder:
		_value = value
		return self
	
	
	func build() -> Stat:
		return Stat.new(self)
