extends Area

enum Creatures { Ghost }

export(Vector3) var spawn_point
export(Creatures) var spawn

func _ready():
	$Mesh.queue_free()
