class_name KnockbackReciever
extends Node

signal knocked_back

@export var can_recieve_knockback := true

var character_body: CharacterBody2D
var knockback_resistance: float


func _ready() -> void:
	character_body = get_parent() as CharacterBody2D
	assert(character_body, "Knockback reciever needs a CharacterBody2D as a parent")
	var stats_holder = get_node("../StatsHolder") as StatsHolder
	if stats_holder:
		knockback_resistance = stats_holder.stats.knockback_resistance
	else:
		printerr("No stats holder knockback reciever can access")


func apply_knockback(hit: Hit):
	if not character_body or not hit or not can_recieve_knockback:
		return
	
	var knockback_velocity = hit.attacker.stats.attack.knockback_velocity
	if not knockback_velocity:
		return
	var direction = hit.attacker.get_parent().global_position.direction_to(character_body.global_position)
	var knockback_direction = Vector2.RIGHT.rotated(deg_to_rad(-45))
	knockback_direction.x = sign(direction.x)
	
	character_body.velocity = knockback_direction * knockback_velocity * knockback_resistance
	knocked_back.emit()
