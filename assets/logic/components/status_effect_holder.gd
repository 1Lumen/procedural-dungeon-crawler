class_name StatusEffectHolder
extends Node

@onready var character: Character = get_parent()

## List of active status effects to update.
var status_effects: Array[StatusEffect]


func _process(delta: float) -> void:
	for effect in status_effects:
		effect.update(delta)


## TODO: Decide what to do with multiple instances of the same effect. Do they stack or just refresh?
func apply(status_effect: StatusEffect) -> void:
	status_effects.append(status_effect)
	status_effect.expired.connect(remove.bind(status_effect))
	status_effect.apply(character)


func remove(status_effect: StatusEffect) -> void:
	status_effects.erase(status_effect)
