tool
extends Spatial

var label_font = preload('res://resourses/fonts/roboto_16.tres').duplicate()

export(String) var id_text := "Checking..."
export(float) var text_size := 16
export(float) var text_scale := 0.01
export(float) var min_x_size := 100

export(bool) var shaded := true

func _ready() -> void:
	$Viewport/Label.theme.default_font = label_font

func _process(_delta: float) -> void:
	var text = tr(id_text)
	
	$Viewport/Label.text = text
	label_font.size = text_size
	$Viewport/Label.rect_min_size.x = min_x_size
	
	$Viewport.size = $Viewport/Label.rect_size
	
	$Sprite3D.shaded = shaded
	$Sprite3D.pixel_size = text_scale
