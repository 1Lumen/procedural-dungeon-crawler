class_name Attack
extends Resource

## The animation the attack plays.
@export var animation_name: String
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var animation_duration: float
@export var hold: bool = false
## The damage the attack deals.
@export var damage: int
## The on hit effect triggered when hitting something.
@export var on_hit_effect: OnHitEffect
