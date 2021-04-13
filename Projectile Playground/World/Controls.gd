extends CanvasLayer

onready var fire_rate_slider = $"PanelContainer/MarginContainer/Rows/Fire Rate/HSlider"
onready var pixel_canva = $PanelContainer/MarginContainer/Rows/PixelEditor/PixelCanva

func _ready():
	pixel_canva.can_draw = false
	pixel_canva.visible = false

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

func update_custom_projectile(value):
	ControlManager.properties.custom_projectile = value

func _on_CustomProjectileCheckBox_toggled(button_pressed):
	ControlManager.properties.use_custom_projectile = button_pressed
	pixel_canva.can_draw = button_pressed
	pixel_canva.visible = button_pressed
	if button_pressed:
		pixel_canva.connect("custom_projectile", self, "update_custom_projectile")
	elif pixel_canva.is_connected("custom_projectile", self, "update_custom_projectile"):
		pixel_canva.disconnect("custom_projectile", self, "update_custom_projectile")

func _on_RotationDegreeSlider_value_changed(value):
	ControlManager.properties.rotation_degrees = value
	pixel_canva.rotation_degrees = value
