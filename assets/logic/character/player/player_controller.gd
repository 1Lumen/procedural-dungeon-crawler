class_name PlayerController
extends Node

signal target_position_changed(position: Vector3)

const FRAMES_BETWEEN_UPDATES := 5

@onready var character_navigator: CharacterNavigator = %CharacterNavigator
@onready var character: Character = get_parent()

var target: Character
var move_input: Vector2


func _ready() -> void:
	SignalBus.clicked_on_map.connect(set_move_target)
	# TODO: Support ranged weapons as secondary weapon.
	SignalBus.clicked_on_enemy.connect(_on_target_changed)
	InputMode.input_mode_changed.connect(_on_input_switched)


func _process(delta: float) -> void:
	if InputMode.input_device == InputMode.Mode.CONTROLLER:
		handle_controller_input(delta)
	else:
		handle_mouse_input(delta)


func _physics_process(delta: float) -> void:
	if InputMode.input_device == InputMode.Mode.CONTROLLER:
		handle_controller_movement(delta)


func handle_controller_input(delta: float):
	move_input = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))


func handle_mouse_input(delta: float):
	if Engine.get_process_frames() % FRAMES_BETWEEN_UPDATES == 0:
		update_target_position()


func handle_controller_movement(delta: float) -> void:
	move_input = move_input.normalized()
	if move_input:
		character.velocity.x = move_toward(character.velocity.x, move_input.x * character.stats.run_speed, character.stats.run_acceleration * delta)
		character.velocity.z = move_toward(character.velocity.z, move_input.y * character.stats.run_speed, character.stats.run_acceleration * delta)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, character.stats.run_deceleration * delta)
		character.velocity.z = move_toward(character.velocity.z, 0, character.stats.run_deceleration * delta)


func set_move_target(position: Vector3) -> void:
	target_position_changed.emit(position)


func update_target_position() -> void:
	if target:
		set_move_target(target.global_position)


func _on_target_changed(target: Character) -> void:
	self.target = target
	update_target_position()


func _on_input_switched(mode: InputMode.Mode):
	move_input = Vector2.ZERO
	if mode == InputMode.Mode.CONTROLLER:
		character_navigator.stop()
