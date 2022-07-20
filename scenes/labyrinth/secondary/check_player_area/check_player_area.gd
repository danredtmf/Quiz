extends Area

signal entered
signal exited

export(bool) var removed := false

func _ready():
	$Mesh.queue_free()

func check_removed():
	if removed:
		queue_free()

func _on_CheckPlayerArea_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("entered")
		check_removed()

func _on_CheckPlayerArea_body_exited(body):
	if body.is_in_group("Player"):
		emit_signal("exited")
		check_removed()
