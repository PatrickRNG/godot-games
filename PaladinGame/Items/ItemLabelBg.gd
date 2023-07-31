extends PanelContainer

@onready var label_node: RichTextLabel = $ItemNameLabel

func _ready():
	# Update the size of the ColorRect based on the Label's text
	update_rect_size()

func update_rect_size():
	# Get the size of the Label's text
	var label_size = label_node.custom_minimum_size
	var new_label_x = (size.x - label_size.x) / 2
	print(label_size)
	
	# Set the size of the ColorRect to match the Label's text size
	custom_minimum_size.x = new_label_x
