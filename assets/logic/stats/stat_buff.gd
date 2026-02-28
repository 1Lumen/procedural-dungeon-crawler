class_name StatBuff
extends Resource

## Mulitply: multiply stat by value; Add: Add value on top of stat.
enum TYPE { ADD, MULTIPLY }

@export var stat: Stat.Type
@export var type = TYPE.ADD
@export var value: float
