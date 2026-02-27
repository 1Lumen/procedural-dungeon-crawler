class_name Health
extends Node
## Adds health to an object.
##
## This component requires the object to have both a stats and a hitbox component.
## It handles taking damage and dying.

signal damaged(remaining_health: int)
signal health_depleted

@export var can_take_damage := true

var stats: Stats

# TODO: Set stats when stat holder signal is emitted.
# TODO: Fix taking damage.


func damage(amount: int):
	if not can_take_damage:
		return
	
	stats.health -= amount
	damaged.emit(stats.health)
	
	if stats.health <= 0:
		health_depleted.emit()


func _on_hitbox_hit(hit: Hit) -> void:
	#damage(hit.attacker.stats.attack.damage)
	pass
