class_name DetectionRange
extends Area3D

const FRAMES_BETWEEN_CHECKS := 5

signal target_changed(target: Character)

@onready var character: Character = get_parent()

var target: Character
var potential_targets: Array[Character]


func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % FRAMES_BETWEEN_CHECKS == 0:
		update_target()


func update_target() -> void:
	potential_targets.sort_custom(sort_by_closest)
	var closest = null if potential_targets.is_empty() else potential_targets.front()
	if target != closest:
		target = closest
		target_changed.emit(target)


func sort_by_closest(a: Node3D, b: Node3D) -> bool:
	var a_distance = character.global_position.distance_squared_to(a.global_position)
	var b_distance = character.global_position.distance_squared_to(b.global_position)
	return a_distance <= b_distance


func _on_detection_range_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		potential_targets.append(body as Character)
		update_target()


func _on_detection_range_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		potential_targets.erase(body as Character)
		update_target()
