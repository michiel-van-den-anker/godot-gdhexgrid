# Script to attach to a node which represents a hex grid
extends Node3D

var HexGrid = preload("./HexGrid.gd").new()

@onready var highlight = get_node("Highlight")
@onready var hex_coords_label = get_node("Highlight/HexCoords")
@onready var camera = get_node("/root/Spatial/Camera")
@onready var canvas = get_node("Canvas")
@onready var plane_coords_label = get_node("Canvas/PlaneCoords")


func _on_HexGrid_input_event(_camera, _event, click_position, _click_normal, _shape_idx):
	# It's called click_position, but you don't need to click
	var plane_coords = self.transform.affine_inverse() * click_position
	plane_coords = Vector2(plane_coords.x, plane_coords.z)
	# Display the coords used
	if plane_coords_label != null:
		plane_coords_label.text = str(plane_coords)
	if hex_coords_label != null:
		hex_coords_label.text = str(HexGrid.get_hex_at(plane_coords).axial_coords)
	
	# Snap the highlight to the nearest grid cell
	if highlight != null:
		var plane_pos = HexGrid.get_hex_center3(HexGrid.get_hex_at(plane_coords))
		highlight.position.x = plane_pos.x
		highlight.position.z = plane_pos.z
		var screen_pos = camera.unproject_position(plane_pos)
		canvas.offset = Vector2(screen_pos)
