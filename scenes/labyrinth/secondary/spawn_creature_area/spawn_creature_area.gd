extends Area

enum Creatures { Ghost }

export(NodePath) var spawn_point: NodePath
export(Creatures) var creature: int
export(NodePath) var showing_creature: NodePath
export(bool) var destroyed: bool

func _ready():
	$Mesh.queue_free()

func _check_conditions():
	if not showing_creature.is_empty():
		var c = get_node(showing_creature)
		c.call_deferred("set_visible", true)
	
	if destroyed:
		queue_free()

func _on_SpawnCreatureArea_body_entered(body):
	if body.is_in_group("Player"):
		_check_conditions()
