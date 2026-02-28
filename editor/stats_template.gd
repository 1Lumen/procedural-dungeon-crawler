@tool
@abstract
class_name NewStats
extends EditorScript

var file_dialog: EditorFileDialog = null


func _run():
	file_dialog = EditorFileDialog.new()
	file_dialog.mode = Window.MODE_WINDOWED
	file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
	file_dialog.file_selected.connect(_on_file_selected)
	var viewport = EditorInterface.get_base_control()
	viewport.add_child(file_dialog)
	file_dialog.set_meta("_created_by", self) # needed so the script is not directly freed after the run function. Would disconnect all signals otherwise
	file_dialog.add_filter("*.tres")
	file_dialog.popup_file_dialog()


@abstract func create_resource() -> Stats


func save(filename: String) -> void:
	var stats := create_resource()
	ResourceSaver.save(stats, filename)


func _on_file_selected(filename: String) -> void:
	save(filename)
	if file_dialog != null:
		file_dialog.queue_free()
