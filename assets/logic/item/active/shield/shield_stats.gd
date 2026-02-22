class_name ShieldStats
extends ActiveItemStats

@export_custom(PROPERTY_HINT_NONE, "suffix:%") var blocked_percent: int = 100
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var blocked_cooldown: float
## Combo of attack/blocks with animations, on hit effects and damage.
@export var combo: Combo
