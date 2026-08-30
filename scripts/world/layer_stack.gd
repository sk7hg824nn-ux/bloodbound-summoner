extends Node2D
class_name LayerStack

const NAMES := ["Background", "Distant", "Architecture", "Npcs", "Party", "Foreground"]
const Z := [-30, -18, -8, 1, 4, 12]
const MOTION := [0.12, 0.28, 0.55, 1.0, 1.0, 1.18]

static func attach(host: Node2D) -> LayerStack:
	var existing := host.get_node_or_null("LayerStack") as LayerStack
	if existing:
		return existing
	var stack := LayerStack.new()
	stack.name = "LayerStack"
	host.add_child(stack)
	host.move_child(stack, 0)
	for i in NAMES.size():
		var n := Node2D.new()
		n.name = NAMES[i]
		n.z_index = Z[i]
		stack.add_child(n)
	return stack

func band(name: String) -> Node2D:
	return get_node_or_null(name) as Node2D
