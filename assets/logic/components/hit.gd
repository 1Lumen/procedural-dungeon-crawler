class_name Hit
extends RefCounted

var attacker: StatsHolder
var target: StatsHolder
var hitbox: Hitbox


func _init(attacker: StatsHolder, target: StatsHolder, hitbox: Hitbox) -> void:
	self.attacker = attacker
	self.target = target
	self.hitbox = hitbox
