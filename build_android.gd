@tool
extends EditorScript

enum Mode { DEBUG, RELEASE }

@export var build_mode: Mode = Mode.DEBUG
@export var android_sdk_path: String = ""
@export var keystore_path: String = ""
@export var keystore_user: String = "android"
@export var keystore_password: String = "android"

const EXPORT_PRESET: String = "Android"


func _run() -> void:
	if android_sdk_path.is_empty():
		android_sdk_path = _detect_sdk()
	if android_sdk_path.is_empty():
		printerr("Android SDK not found. Set ANDROID_SDK_ROOT or fill android_sdk_path.")
		return

	_ensure_build_dir()
	var apk_path: String = "res://build/android_%s.apk" % ["debug", "release"][build_mode]

	var export_result: int
	match build_mode:
		Mode.DEBUG:
			print("Exporting Android DEBUG APK ...")
			export_result = EditorInterface.export_project("Android", apk_path, true, false)
		Mode.RELEASE:
			print("Exporting Android RELEASE APK ...")
			export_result = EditorInterface.export_project("Android", apk_path, false, true)

	if export_result == OK:
		print("Export successful: %s" % apk_path)
	else:
		printerr("Export failed with code %d." % export_result)


func _detect_sdk() -> String:
	var candidates: Array[String] = [
		OS.get_environment("ANDROID_SDK_ROOT"),
		OS.get_environment("ANDROID_HOME"),
		OS.get_environment("HOME") + "/Android/Sdk",
	]
	for c in candidates:
		if not c.is_empty() and DirAccess.dir_exists_absolute(c):
			print("Android SDK detected: %s" % c)
			return c
	print("ANDROID_SDK_ROOT not set. Attempting export anyway ...")
	return ""


func _ensure_build_dir() -> void:
	var err := DirAccess.make_dir_recursive_absolute("res://build")
	if err != OK:
		printerr("Failed to create build directory.")
