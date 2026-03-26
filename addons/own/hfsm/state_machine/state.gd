@abstract
class_name State
extends Node
## Base class for all states used in a HFSM.
##
## This class is not supposed to be inherited from, rather from its child class HFSM.
## Every HFSM is a state that can also be its own state machine with states.

# TODO: Improve state transitions. Make HFSM more modular by assigning transitions in inspector.
## Emitted when the state wants to transition to another. Additional arguments may be bound to pass to the new state's enter function.
signal transition(state_name: String)

## A reference to the character controlled by the state machine.
@export var character: Character


## Initializes the state at the start of the game or when the HSFM is instantiated.
func _internal_init(character: Character):
	self.character = character


## Called when the state is entered.
func _enter(...args):
	pass


## Called when the state is exited.
func _exit():
	pass


## Called during _process update steps. This is used so that only the current state of a HFSM is updated.
func _update(delta: float):
	pass


## Called during _physics_process update steps. This is used so that only the current state of a HFSM is updated.
func _physics_update(delta: float):
	pass


## Called when recieving an input event.
func _internal_input(event: InputEvent):
	pass
