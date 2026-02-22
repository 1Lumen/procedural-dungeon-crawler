extends Node
## Preloads all scenes that can be instantiated during the game. Holds a reference to each one.


class Models:
	static var weapons: Dictionary[String, PackedScene] = {
		"sword_basic": preload("uid://cms3ppuap0thj"),
		"sword_gem": preload("uid://cxswbxihvyn44"),
		"sword_gem_gold": preload("uid://c7s5y26i4nhl1"),
		"sword_skeleton": preload("uid://4fehn6q65iil"),
		"bow": preload("uid://daatqpx5jkqvq"),
	}
	static var armor: Dictionary[String, PackedScene] = {
		
	}
	static var shields: Dictionary[String, PackedScene] = {
		
	}
	static var ability_items: Dictionary[String, PackedScene] = {
		
	}
	static var characters: Dictionary[String, PackedScene] = {
		"barbarian": preload("uid://d3rdgaqmwdd2e"),
		"skeleton_warrior": preload("uid://boq8xlcfxvhm6"),
	}


class Scenes:
	static var weapons: Dictionary[String, PackedScene] = {
		"sword": load("uid://kpcum04qgocn"), # Cyclic dependency when using preload. Can't resolve class Weapon.
		"ranged_weapon": load("uid://c17kmpaemrxw"),
	}
	static var armor: Dictionary[String, PackedScene] = {
	}
