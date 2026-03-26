@abstract
class_name StatusEffect
extends Resource

## Emitted when the status effect expires.
signal expired

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration: float

var elapsed_time: float


## Applies the status effect to the given [param character].
@abstract func apply(character: Character) # Maybe take in a status effectable component instead.


func update(delta: float):
	tick(delta)
	elapsed_time += delta
	if elapsed_time >= duration:
		_expire()


func _expire() -> void:
	expired.emit()
	expire()


## Updates the effect. Called once per frame.
@abstract func tick(delta: float)


## Called when the status effect expires.
@abstract func expire()
