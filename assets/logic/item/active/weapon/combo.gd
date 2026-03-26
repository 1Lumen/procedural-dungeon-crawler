class_name Combo
extends Resource

## Array of attacks to perform in sequence.
@export var attacks: Array[Attack]

var length: int:
	get:
		return attacks.size()
var index: int:
	set(value):
		index = clamp(value, 0, length - 1)
