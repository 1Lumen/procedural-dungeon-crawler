extends Area3D

enum Mode { NAVIGATE, ATTACK }

## The follow speed of the cursor.
@export var speed := 50.0
@export var ground_offset := 0.0
@export var ground_y := 0.0
@export_flags_3d_physics var ground_layer: int

@onready var walk: MeshInstance3D = %Walk
@onready var attack: MeshInstance3D = %Attack

var camera: Camera3D
var viewport: Viewport
## Position of the mouse in global world space at ground level.
var target_position: Vector3
var mode := Mode.NAVIGATE:
	set(value):
		mode = value
		walk.visible = mode == Mode.NAVIGATE
		attack.visible = mode == Mode.ATTACK
var enemies: Array[Character]


func _ready() -> void:
	viewport = get_viewport()
	camera = viewport.get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_position = get_cursor_position_3d()
	if not target_position:
		return
	target_position.y = ground_y + ground_offset


func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, target_position, delta * speed)
	
	mode = Mode.ATTACK if not enemies.is_empty() else Mode.NAVIGATE


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_click"):
		return
	
	if mode == Mode.NAVIGATE:
		SignalBus.clicked_on_map.emit(target_position)
	else:
		var closest = enemies.get(0)
		var closest_distance = closest.global_position.distance_squared_to(target_position)
		for enemy in enemies:
			var distance = enemy.global_position.distance_squared_to(target_position)
			if distance < closest_distance:
				closest = enemy
				closest_distance = distance
		SignalBus.clicked_on_enemy.emit(closest)


## Returns the position the cursor intersects with in 3d space.
func get_cursor_position_3d() -> Vector3:
	var mouse_pos := viewport.get_mouse_position()
	var origin := camera.project_ray_origin(mouse_pos)
	var direction := camera.project_ray_normal(mouse_pos)
	var ray_length := camera.far
	var end := origin + direction * ray_length
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end, ground_layer)
	var result := space_state.intersect_ray(query)
	return result.get("position", end)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		enemies.append(body)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		enemies.erase(body)
