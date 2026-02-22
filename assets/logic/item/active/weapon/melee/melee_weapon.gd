class_name MeleeWeapon
extends Weapon

const TYPE = "melee"

@onready var hurtbox: Hurtbox = %Hurtbox


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_T:
			attack(null)


func attack(character: Character) -> void:
	var attack = get_stats().combo.attacks.get(combo_index)
	var damage = attack.damage
	var animation_name = attack.animation_name
	hurtbox.monitoring = false
	hurtbox.monitoring = true
	
	# TODO: Cache.
	var library_name := "character_%s_%s_animations" % [character.stats.model_type.to_lower(), TYPE]
	var animation = library_name + "/" + animation_name
	character.model.animation_player.play(animation)
