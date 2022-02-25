class_name ConfigManager
extends Reference

const METADATA_FILE_NAME := "metadata.json"

var logger := Logger.new("ConfigManager")

var save_data_path := ""

var metadata := Metadata.new()
var model_config := ModelConfig.new()

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _init() -> void:
	if not OS.is_debug_build():
		save_data_path = "user://"
	else:
		save_data_path = "res://export"
	
	if AM.ps.connect("metadata_changed", self, "_on_metadata_changed") != OK:
		logger.error("Unable to subscribe to metadata_changed")

	if AM.ps.connect("model_config_data_changed", self, "_on_model_config_data_changed") != OK:
		logger.error("Unable to subscribe to model_config_data_changed")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_metadata_changed(key: String, data) -> void:
	metadata.set_data(key, data)

func _on_model_config_data_changed(key: String, data) -> void:
	model_config.set_data(key, data)

###############################################################################
# Private functions                                                           #
###############################################################################

func _save_to_file(path: String, data: String) -> Result:
	var file := File.new()
	if file.open("%s/%s" % [save_data_path, path], File.WRITE) != OK:
		return Result.err(Error.Code.FILE_WRITE_FAILURE)

	file.store_string(data)

	return Result.ok()

###############################################################################
# Public functions                                                            #
###############################################################################

func save() -> Result:
	var result := _save_to_file(METADATA_FILE_NAME, metadata.get_as_json_string())
	if result.is_err():
		return result

	result = _save_to_file("%.json" % model_config.config_name, model_config.get_as_json_string())
	if result.is_err():
		return result

	return Result.ok()