class_name Health
extends Node
## Adds health to an object.
##
## This component requires the object to have both a stats and a hitbox component.
## It handles taking damage and dying.

signal damaged(remaining_health: int)
signal died

@export var can_take_damage := true

var stats: Stats


func _ready() -> void:
	await get_tree().process_frame
	stats = get_node_or_null("../StatsHolder").stats
	
	stats.health = stats.max_health
	
	died.connect(_on_death)


func damage(amount: int):
	if not can_take_damage:
		return
	
	stats.health -= amount
	damaged.emit(stats.health)
	
	if stats.health <= 0:
		died.emit()


func _on_death():
	get_parent().queue_free()


func _on_hitbox_hit(hit: Hit) -> void:
	damage(hit.attacker.stats.attack.damage)
