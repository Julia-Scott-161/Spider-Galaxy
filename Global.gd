extends Node

var node_creation_parent:Node3D = null
var main_menu:Node3D = null

func instance_node(node: PackedScene, location: Vector3, parent: Node3D) -> Node3D:
		var node_instance:Node3D = node.instantiate()
		parent.add_child(node_instance)
		node_instance.global_position = location
		return node_instance
