class_name EnemyAI
extends Node

signal target_position_changed(position: Vector3)

const FRAMES_BETWEEN_UPDATES := 5

var target: Character


func _process(delta: float) -> void:
	if Engine.get_process_frames() % FRAMES_BETWEEN_UPDATES == 0:
		update_target_position()


func update_target_position() -> void:
	if target:
		target_position_changed.emit(target.global_position)


func _on_target_changed(target: Character) -> void:
	self.target = target
	update_target_position()
