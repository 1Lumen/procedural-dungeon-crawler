@abstract
class_name OnHitEffect
extends Resource

@export var target_status_effect: StatusEffect
@export var self_status_effect: StatusEffect


## Triggers the on hit effect. Takes in a reference to the character and the hit target.
@abstract func trigger(character: Character, target: Character)
