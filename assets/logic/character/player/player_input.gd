class_name PlayerInput
extends Node
## Recieves player input and instructs actions based on it.

signal attack_primary_pressed
signal attack_secondary_pressed
signal attack_primary_released
signal attack_secondary_released

@onready var character: Character = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_primary"):
		attack_primary_pressed.emit()
	elif event.is_action_released("attack_primary"):
		attack_primary_released.emit()
	elif event.is_action_pressed("attack_secondary"):
		attack_secondary_pressed.emit()
	elif event.is_action_released("attack_secondary"):
		attack_secondary_released.emit()
