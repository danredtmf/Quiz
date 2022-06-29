extends PanelContainer

var text_id: int = 0

func _ready():
	update_ui()

func _process(_delta):
	update_ui()

func update_ui():
	$VB/Name.text = tr('achv_%d_name') % text_id
	$VB/Description.text = tr('achv_%d_desc') % text_id
