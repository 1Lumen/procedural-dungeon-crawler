class_name MeleeWeapon
extends Weapon

const TYPE = "melee"

@onready var hurtbox: Hurtbox = %Hurtbox


func use(character: Character) -> void:
	attack_started.emit()
	print(combo_index)
	var attack = get_stats().combo.attacks.get(combo_index)
	var damage = attack.damage
	var animation_name = attack.animation_name
	refresh_hit()
	
	# TODO: Cache.
	var library_name := "character_%s_%s_animations" % [character.stats.model_type.to_lower(), TYPE]
	var animation = library_name + "/" + animation_name
	character.model.animation_player.play(animation)
	await character.model.animation_player.animation_finished
	combo_index += 1
	attack_finished.emit()
	combo_timer.start()


## Turns on an off the hurtbox to reset all collsions so that hitboxes can enter again.
func refresh_hit() -> void:
	hurtbox.monitoring = false
	hurtbox.monitoring = true
