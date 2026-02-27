class_name Buff
extends Resource

## Mulitply: multiply stat by value; Add: Add value on top of stat.
enum TYPE { ADD, MULTIPLY }

@export var type = TYPE.ADD
@export var stat: String
