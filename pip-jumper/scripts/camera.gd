extends Camera2D

var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = player.position

## [Utils] ------------------------------------

func get_target() -> void:
	#pass # Replace with function body.
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
	player = nodes[0]
