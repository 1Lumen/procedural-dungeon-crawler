class_name PlayerInput
extends Node
## Recieves player input and instructs actions based on it.

signal attack_primary_pressed
signal attack_secondary_pressed
signal attack_primary_released
signal attack_secondary_released

@onready var character: Character = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if InputMode.input_device == InputMode.Mode.CONTROLLER:
		handle_controller_input(event)
	else:
		handle_mouse_input(event)


func handle_controller_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_primary"):
		attack_primary_pressed.emit()
	elif event.is_action_released("attack_primary"):
		attack_primary_released.emit()
	elif event.is_action_pressed("attack_secondary"):
		attack_secondary_pressed.emit()
	elif event.is_action_released("attack_secondary"):
		attack_secondary_released.emit()


func handle_mouse_input(event: InputEvent) -> void:
	if event.is_action_released("attack_primary"):
		attack_primary_released.emit()
	elif event.is_action_released("attack_secondary"):
		attack_secondary_released.emit()
	
	if not Input.is_action_pressed("attack_mode"):
		return
	
	if event.is_action_pressed("attack_primary"):
		attack_primary_pressed.emit()
	elif event.is_action_pressed("attack_secondary"):
		attack_secondary_pressed.emit()
