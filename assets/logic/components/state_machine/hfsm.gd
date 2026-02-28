class_name HFSM
extends State
## A Hierarchical Finite State Machine (HFSM) using its children as states.
##
## The HSM is a state itself and can be a state of a parent HFSM.

signal state_changed(old_state: State, new_state: State)

@export_group("HFSM")
@export var initial_state: State
## When [code]true[/code], always starts at the initial state when entering this HFSM.
@export var reset_state_on_enter := true
## When [code]true[/code], cycles to the next state in this HFSM if the last state did not include a new state to transition to.
@export var advance_to_next_state := true
## Allows the state to transition to itself, so to exit and enter again. 
@export var allow_transition_to_self := false
@export var debug_state_change := false

var current_state: State
var previous_state: State
var is_root := false
var is_leaf := true
var parent: HFSM


func _ready() -> void:
	# Checks if the HFSM is a leaf.
	for child in get_children():
		if child is State:
			is_leaf = false
	assert(not is_leaf and initial_state, "No initial state set on HFSM!")
	
	# The HFSM is the root HFSM.
	var parent_node = get_parent()
	if parent_node is HFSM:
		parent = parent_node as HFSM
	else:
		is_root = true
		await parent_node.ready
		_internal_init(character)


# Only called when root.
func _process(delta: float) -> void:
	_update(delta)


# Only called when root.
func _physics_process(delta: float) -> void:
	_physics_update(delta)


# Only called when root.
func _input(event: InputEvent) -> void:
	_internal_input(event)


## Initializes the HFSM with its initial state and initializes its child states.
## Only used internally, do not override.
func _internal_init(character: Character):
	super._internal_init(character)
	
	# Initialize child states and set initial state.
	if not is_leaf:
		_init_states()
	
	if is_root:
		set_state(initial_state)
	
	init()


## Sets the current state to the initial state when [member]reset_state_on_enter[/member] is [code]true[/code].
## Only used internally, do not override.
func _enter(...args):
	if not is_leaf and ((not is_root and current_state == null) or reset_state_on_enter):
		set_state(initial_state)
	
	enter.callv(args)


## Only used internally, do not override.
func _exit(...args):
	# FIXME: Handle correctly when parent HFSM transitions to another state, what happens with this HFSM's current state.
	if current_state:
		current_state._exit()
	
	exit()


## Updates the current state. Only used internally, do not override.
func _update(delta: float):
	if current_state:
		current_state._update(delta)
	
	update(delta)


## Updates the current state's physics. Only used internally, do not override.
func _physics_update(delta: float):
	var debug = name
	if current_state:
		current_state._physics_update(delta)
	
	physics_update(delta)


## Recieves input events on the current state. Only used internally, do not override.
func _internal_input(event: InputEvent):
	if current_state:
		current_state._internal_input(event)
	
	input(event)


#region Virtual Methods

## Initializes the state at the start of the game or when the HSFM is instantiated.
func init():
	pass


## Called when the state is entered.
func enter(...args):
	pass


## Called when the state is exited.
func exit():
	pass


## Called during _process update steps.
func update(delta: float):
	pass


## Called during _physics_process update steps.
func physics_update(delta: float):
	pass


## Called when recieving an input event.
func input(event: InputEvent):
	pass

#endregion


## Initializes all states.
func _init_states():
	for child in get_children():
		if child is not State:
			push_warning("Node %s is not a state" % child.name)
			continue
		var state = child as State
		
		# Disable engine processing, only allow custom processing by the HFSM.
		state.process_mode = Node.PROCESS_MODE_DISABLED
		state.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		state.set_process_input(false)
		
		# Initialize state.
		state._internal_init(character)
		state.transition.connect(set_state)


## Transitions the current state to the given new one.
func set_state(new_state: State, ...args):
	if is_leaf:
		push_error("Tried to set state on a leaf state!")
		return
	
	var old_state = current_state
	
	if not new_state:
		if advance_to_next_state:
			new_state = get_child(wrap(old_state.get_index() + 1, 0, get_child_count()))
		else:
			printerr("State %s is not a valid state in this state machine. \
					If you indendet to cycle to the next state, check on \"advance_to_next_state\" \
					on HFSM %s." % [new_state.name, name])
			return
	
	if new_state == old_state and not new_state.allow_transition_to_self:
		return
	
	if old_state:
		old_state._exit()
	current_state = new_state
	previous_state = old_state
	current_state._enter.callv(args)
	
	state_changed.emit(old_state, current_state)
	
	if debug_state_change:
		print("%s transitioned from %s state to %s state." % 
				[character.name.to_snake_case(), old_state.name.to_snake_case() if old_state else "null", new_state.name.to_snake_case()])


## Returns the root HFSM.
func get_root():
	var node = self
	var parent = node.get_parent()
	while parent is HFSM:
		node = parent
		parent = node.get_parent()
	return node as HFSM
