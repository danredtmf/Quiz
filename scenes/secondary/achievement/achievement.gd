extends PanelContainer

var text_name: String = ''
var text_description: String = ''

func _ready():
	update_ui()

func _process(_delta):
	update_ui()

func update_ui():
	$VB/Name.text = text_name
	$VB/Description.text = text_description
