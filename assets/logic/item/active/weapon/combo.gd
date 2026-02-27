class_name Combo
extends Resource

## Array of attacks to perform in sequence.
@export var attacks: Array[Attack]

var length: int:
	get:
		return attacks.size()
