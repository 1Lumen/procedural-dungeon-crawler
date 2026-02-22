class_name CharacterAnimationTree
extends AnimationTree

@onready var character: Character = get_parent()

var animation_player: AnimationPlayer
var character_model_type: String
var tree: AnimationNodeStateMachine
var idle_transition: AnimationNodeTransition
var attack_state_machine: AnimationNodeStateMachine
var alive_tree: AnimationNodeBlendTree


func _ready() -> void:
	tree_root = tree_root.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) # Make unique to character.
	
	tree = tree_root as AnimationNodeStateMachine
	alive_tree = tree.get_node("Alive")
	var action_tree = alive_tree.get_node("Action")
	attack_state_machine = action_tree.get_node("Attack")


func init(model: CharacterModel):
	anim_player = model.animation_player.get_path()
	animation_player = model.animation_player
	character_model_type = character.stats.model_type.to_lower()
	set_idle_animation(null)


func _process(delta: float) -> void:
	update_walk_animation()


# FIXME: Blend between walk animations.
func update_walk_animation() -> void:
	var velocity_2d = Vector2(character.velocity.x, character.velocity.z)
	var global_forward = Vector2(character.forward.x, character.forward.z).normalized()
	var forward_velocity := Vector2(velocity_2d.x * global_forward.x, velocity_2d.y * global_forward.y).length()
	#var global_right = Vector2(global_forward.y, -global_forward.x)
	#var local_velocity = Vector2(velocity_2d.dot(global_right), velocity_2d.dot(global_forward))
	var forward_strafe = Input.get_action_strength("strafe_back") - Input.get_action_strength("strafe_forward")
	var motion = Vector2(
		Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left"),
		max(forward_strafe, forward_velocity)
	)
	set("parameters/Alive/Action/Move/move_animation/blend_position", motion)


func respawn() -> void:
	set("parameters/conditions/respawn", true)


func die() -> void:
	set("parameters/conditions/respawn", false)
	set("parameters/conditions/dead", true)


# TODO: Dynamic hit directions.
func play_hit_animation(heavy: bool = false) -> void:
	set("parameters/Alive/hit_tree/hit_strength/transition_request", "hit_heavy" if heavy else "hit_light")
	set("parameters/Alive/hit/request", "Fire")


func start_attacking(primary: bool) -> void:
	# Reset combo.
	set("parameters/Alive/Action/Attack/Primary/attack_combo/transition_request", "attack_0")
	set("parameters/Alive/Action/Attack/Secondary/attack_combo/transition_request", "attack_0")
	
	## Choose weapon.
	set("parameters/Alive/Action/Attack/conditions/primary", primary)
	set("parameters/Alive/Action/Attack/conditions/secondary", not primary)
	
	## Transition to attack state.
	set("parameters/Alive/Action/conditions/normal", false)
	set("parameters/Alive/Action/conditions/attacking", true)


func stop_attacking() -> void:
	set("parameters/Alive/Action/conditions/attacking", false)
	set("parameters/Alive/Action/conditions/normal", true)


func equip_weapon(weapon_stats: WeaponStats) -> void:
	set_idle_animation(weapon_stats)


func set_primary_weapon(weapon_stats: WeaponStats) -> void:
	set_weapon("primary", 0, weapon_stats)


func set_secondary_weapon(weapon_stats: WeaponStats) -> void:
	set_weapon("secondary", 1, weapon_stats)


func set_weapon(weapon_slot: String, weapon_index: int, weapon_stats: WeaponStats) -> void:
	build_attack_sequence_tree(weapon_slot, weapon_index, weapon_stats.combo)


## Clears and recreates the attack sequence animation blend tree for [param combo].
func build_attack_sequence_tree(weapon_slot: String, weapon_index: int, combo: Combo) -> void:
	remove_weapon_tree(weapon_slot, weapon_index)
	create_weapon_tree(weapon_slot, weapon_index, combo)


## Creates a node tree with every attack of [param combo] and animation speed nodes.
func create_weapon_tree(weapon_slot: String, weapon_index: int, combo: Combo) -> void:
	# Create state and tree.
	var weapon_tree = AnimationNodeBlendTree.new()
	attack_state_machine.add_node(weapon_slot.to_pascal_case(), weapon_tree)
	var transition = AnimationNodeStateMachineTransition.new()
	transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
	transition.advance_condition = weapon_slot.to_lower()
	attack_state_machine.add_transition("Start", weapon_slot.to_pascal_case(), transition)
	
	# Add other nodes.
	var transition_node = AnimationNodeTransition.new()
	weapon_tree.add_node("attack_combo", transition_node)
	transition_node.xfade_time = 0.1
	var attack_speed_node = AnimationNodeTimeScale.new()
	weapon_tree.add_node("attack_speed", attack_speed_node)
	# Connect them to output.
	weapon_tree.connect_node("attack_speed", 0, "attack_combo")
	weapon_tree.connect_node("output", 0, "attack_speed")
	
	# Add attack nodes.
	var i := 0
	for attack in combo.attacks:
		var animation_node = add_attack_animation("attack_%s" % i, attack.animation_name, weapon_tree)
		var speed_node := AnimationNodeTimeScale.new()
		weapon_tree.add_node("attack_speed_%s" % i, speed_node)
		# Add transition input.
		transition_node.add_input("attack_%s" % i)
		transition_node.set_input_reset(i, true)
		transition_node.set_input_as_auto_advance(i, true)
		# Connect inputs.
		weapon_tree.connect_node("attack_speed_%s" % i, 0, "attack_%s" % i)
		weapon_tree.connect_node("attack_combo", i, "attack_speed_%s" % i)
		i += 1


## Clears the previous attack animation node tree.
func remove_weapon_tree(weapon_slot: String, weapon_index: int) -> void:
	attack_state_machine.remove_transition("Start", weapon_slot.to_pascal_case())
	attack_state_machine.remove_node(weapon_slot.to_pascal_case())


## Adds an animation node to the attack animation blend tree with 
func add_attack_animation(node_name: StringName, animation_name: String, weapon_tree: AnimationNodeBlendTree) -> AnimationNodeAnimation:
	var animation_node := AnimationNodeAnimation.new()
	var weapon_type := animation_name.split("_")[0].to_lower()
	var library_name := "character_%s_%s_animations" % [character_model_type, weapon_type]
	var library = animation_player.get_animation_library(library_name)
	assert(library, "Animation library %s not found for %s weapon" % [library_name, node_name.to_lower()])
	var animation = library.get_animation(animation_name)
	assert(animation, "Animation %s not found in library %s" % [animation_name, library_name])
	animation_node.animation = library_name + "/" + animation.resource_name
	weapon_tree.add_node(node_name, animation_node)
	return animation_node


func set_idle_animation(weapon_stats: WeaponStats):
	if not weapon_stats:
		set("parameters/Alive/Action/Move/move_animation/0/Transition/transition_request", "idle")
	elif weapon_stats.type == Weapon.Type.RANGED:
		set("parameters/Alive/Action/Move/move_animation/0/Transition/transition_request", "idle_bow")
	elif weapon_stats.handed == Weapon.Handed.TWO_HANDED:
		set("parameters/Alive/Action/Move/move_animation/0/Transition/transition_request", "idle_2h_melee")
	elif weapon_stats == null:
		set("parameters/Alive/Action/Move/move_animation/0/Transition/transition_request", "idle_unarmed")
	else:
		set("parameters/Alive/Action/Move/move_animation/0/Transition/transition_request", "idle")


## TEST: Used for debugging the generated weapon node trees.
func save_tree() -> void:
	ResourceSaver.save(tree_root, "res://test/animation_trees/character_animation_tree_saved.tres")
