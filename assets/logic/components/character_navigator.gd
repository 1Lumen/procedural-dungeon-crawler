class_name CharacterNavigator
extends NavigationAgent3D

signal navigation_stopped
signal navigation_resumed
signal target_position_changed(target_position: Vector3)

@onready var character: Character = get_parent()

var navigating := false
var speed: float
var acceleration: float
var deceleration: float
var rotation_speed: float

var target_direction: Vector3


func _physics_process(delta: float) -> void:
	if navigating:
		navigate(delta)
	turn_towards_navigation_direction(delta)
	
	character.move_and_slide()


## Sets the target position to pathfind to to [param global_position].
func set_navigation_position(global_position: Vector3) -> void:
	var relative_position = global_position
	target_position = relative_position
	target_position_changed.emit(global_position)
	navigating = true


## Sets the speed stats of the character.
func set_stats(stats: Stats) -> void:
	if not stats:
		return
	speed = stats.get_stat(Stat.Type.RUN_SPEED) * stats.get_stat(Stat.Type.SPEED) * 0.01
	acceleration = stats.get_stat(Stat.Type.RUN_ACCELERATION)
	deceleration = stats.get_stat(Stat.Type.RUN_DECELERATION)
	rotation_speed = stats.get_stat(Stat.Type.TURN_SPEED)


func stop() -> void:
	navigating = false


func resume() -> void:
	navigating = true


func navigate(delta: float):
	var navigating = not is_navigation_finished() and is_target_reachable()
	var path_position = get_next_path_position()
	var direction = character.position.direction_to(path_position)
	if navigating and path_position:
		character.velocity.x = move_toward(character.velocity.x, direction.x * speed, delta * acceleration)
		character.velocity.z = move_toward(character.velocity.z, direction.z * speed, delta * acceleration)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, delta * deceleration)
		character.velocity.z = move_toward(character.velocity.z, 0, delta * deceleration)


# FIXME: Does not interpolate the rotation.
func turn_towards_navigation_direction(delta: float):
	var new_target_direction = character.global_position + character.velocity
	var look_at_position = lerp(target_direction, new_target_direction, delta * rotation_speed)
	if look_at_position != character.global_position:
		character.look_at(look_at_position, Vector3.UP, true)
	target_direction = new_target_direction
