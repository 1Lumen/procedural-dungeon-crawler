class_name Hurtbox
extends Area3D
## Gives an object the ability to attack and deal damage.
##
## Emits a signal on damaging an object with a reference of the target's stats.

signal attacked(hit: Hit)

@export var stats_holder: StatsHolder = get_node_or_null("../StatsHolder")
@export var tilemap: TileMapLayer


func _ready() -> void:
	assert(stats_holder, "The attack component needs the entity to have a stats holder component")
	
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func attack(target: Node3D):
	# Get target stats holder component.
	var target_stats_holder
	var hitbox
	if target is Hitbox:
		target_stats_holder = target.get_node_or_null("../StatsHolder") as StatsHolder
		hitbox = target as Hitbox
	else:
		target_stats_holder = target.get_node_or_null("StatsHolder") as StatsHolder
	
	if not target_stats_holder:
		return
	
	var hit_info = Hit.new(stats_holder, target_stats_holder, hitbox)
	if hitbox:
		hitbox.register_hit(hit_info)
	attacked.emit(hit_info)


## Returns all hitboxes in the attack area.
func get_targets() -> Array[Hitbox]:
	var hitboxes: Array[Hitbox] = []
	var areas = get_overlapping_areas()
	for area in areas:
		if area is Hitbox:
			hitboxes.append(area as Hitbox)
	return hitboxes


## Called when the hurtbox hits an area2d. Checks if it is a hitbox.
func _on_area_entered(area: Area3D):
	if area is Hitbox:
		attack(area)


## Called when the hurtbox hits a tilemap or physics body.
func _on_body_entered(body: Node3D):
	if body.is_in_group("hittable"):
		attack(body)
