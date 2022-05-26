class_name BasePopup
extends WindowDialog

var _logger: Logger

var screen: Control

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _init(p_name: String, p_screen) -> void:
	_logger = Logger.new(p_name)

	# Node configuration
	window_title = p_name
	resizable = true
	anchor_bottom = 1.0
	anchor_right = 1.0
	
	# Add all children
	var panel_container := PanelContainer.new()
	
	var stylebox := StyleBoxFlat.new()
	stylebox.content_margin_top = 10
	stylebox.content_margin_bottom = 10
	stylebox.content_margin_left = 10
	stylebox.content_margin_right = 10
	stylebox.bg_color = Color("333a4f")
	
	panel_container.set_indexed("custom_styles/panel", stylebox)
	panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_container.anchor_bottom = 1.0
	panel_container.anchor_right = 1.0
	
	add_child(panel_container)
	
	screen = p_screen.instance() if p_screen is PackedScene else p_screen.new()
	screen.name = p_name
	screen.set("logger", _logger)

	panel_container.add_child(screen)
	
	# Hook up close button
	get_close_button().connect("pressed", self, "_on_close")

func _ready() -> void:
	show()
	
	var rect := Rect2()
	var window_size := get_viewport_rect().size
	rect.size = (window_size * 0.75).floor()
	rect.size.x *= 0.5
	rect.position = ((window_size - rect.size) / 2.0).floor()
	
	rect_global_position = rect.position
	rect_size = rect.size

	_logger.info("%s popup setup" % window_title)

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

func _on_close() -> void:
	queue_free()

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#
