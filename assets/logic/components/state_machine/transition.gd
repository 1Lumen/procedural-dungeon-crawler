@tool
class_name Transition
extends Node

@export var new_state: State:
	set(value):
		new_state = value
		update_configuration_warnings()

@onready var state: State = get_parent()
@onready var state_machine: HFSM = state.get_parent()


func _ready() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	if not new_state:
		return ["Needs a new state to transition to"]
	if not state_machine:
		return ["Parent state needs to be child of a HFSM"]
	return []


func transition() -> void:
	state_machine.set_state(new_state)
