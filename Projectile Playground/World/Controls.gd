extends CanvasLayer

onready var fire_rate_slider = $"PanelContainer/MarginContainer/Rows/Fire Rate/HSlider"

func _on_FireRateSlider_value_changed(value):
	ControlManager.properties.fire_rate = value

func _on_RangeSlider_value_changed(value):
	ControlManager.properties.fire_range = value

func _on_ScaleSlider_value_changed(value):
	ControlManager.properties.scale = value

func _on_ColorPickerButton_color_changed(color):
	ControlManager.properties.color = color

func _on_RainbowCheckBox_toggled(button_pressed):
	ControlManager.properties.rainbow = button_pressed

func _on_ShotsSlider_value_changed(value):
	ControlManager.properties.shots = value

func _on_ShotAngleSlider_value_changed(value):
	ControlManager.properties.shot_angle = value
