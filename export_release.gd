@tool
extends EditorPlugin

const EXPORT_PRESET: String = "Android"
const APK_PATH: String = "res://build/space_shooter_release.apk"

var export_button: Button


func _enter_tree() -> void:
	export_button = Button.new()
	export_button.text = "Export Android Release"
	export_button.pressed.connect(_on_export_pressed)
	export_button.theme_type_variation = "FlatButton"
	add_control_to_container(
		EditorPlugin.CONTAINER_TOOLBAR,
		export_button
	)


func _exit_tree() -> void:
	if export_button:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, export_button)
		export_button.queue_free()


func _on_export_pressed() -> void:
	DirAccess.make_dir_recursive_absolute("res://build")

	print("Exporting Android release APK ...")

	var result := EditorInterface.export_project(
		EXPORT_PRESET,
		APK_PATH,
		false,
		true
	)

	if result == OK:
		print("Release APK exported: %s" % APK_PATH)
		DisplayServer.notification(DisplayServer.NOTIFICATION_WM_WINDOW_FOCUS_IN)
	else:
		printerr("Export failed with code %d." % result)
