extends Control

# TODO:
	# Talent states
	# Manager (this class)
		# load talent definitions
		# instantiate talent node scenes
		# position nodes
		# draw connections
		# handle talent selection
		# can the talent be unlocked?
		# update the ui

	# Implementation
	# 3. interaction (clicking node displays its information in the info panel)
	# 4. talent data (move definitions into resources)
	# 5. prerequisites (unlocking rules)
	# 6. visual states (update node and appearance based on player progress)
	# 7. navigation (panning and zooming)

@onready var container: Control = $Talents
@onready var cons: Connections = $Talents/Connections
@onready var points_label: Label = $PointsLabel/Value

@export var node_scene: PackedScene
@export var talent_resources: Array[Talent] = []

var points: int = 3

class TalentData:
	var resource: Talent
	var node: TalentNode
	var taken: bool

	func _init(res: Talent, n: TalentNode, t: bool) -> void:
		resource = res
		node = n
		taken = t


var talent_map: Dictionary[String, TalentData] = {}

func _ready() -> void:
	for resource in talent_resources:
		var node = node_scene.instantiate() as TalentNode
		container.add_child(node)
		node.set_resource(resource)
		node.selected.connect(_on_talent_selected.bind(resource.id))
		talent_map[resource.id] = TalentData.new(resource, node, false)

	create_connections()
	update_node_states()


func create_connections() -> void:
	for id in talent_map:
		var data = talent_map[id]
		var input = data.node.input
		for out_id in data.resource.prerequisites:
			var output = talent_map[out_id].node.output
			cons.add(TalentConnection.new(output, input))

func update_node_states() -> void:
	for id in talent_map:
		var data = talent_map[id]

		if data.taken:
			data.node.set_taken()
			return

		var prereqs = data.resource.prerequisites
		if prereqs.size() == 0 or all_taken(prereqs):
			data.node.set_available()
			return
			
		data.node.set_locked()

func all_taken(ids: Array[String]) -> bool:
	for id in ids:
		if !talent_map[id].taken:
			return false
	return true

func _on_talent_selected(id: String) -> void:
	if points <= 0:
		return

	points -= 1
	talent_map[id].taken = true
	update_node_states()
