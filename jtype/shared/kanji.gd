class_name Kanji
extends RefCounted

var glyph: String

var meanings: Array[String] = []
var on_readings: Array[String] = []
var kun_readings: Array[String] = []

var tags: Array[String] = []


const FILE_PATH := "user://data/kanji.json"


static func read() -> Dictionary[String, Kanji]:
	DirAccess.make_dir_recursive_absolute("user://data")
	var kanji_file := FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)

	if not kanji_file:
		FileAccess.open(FILE_PATH, FileAccess.WRITE)
		kanji_file = FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)
		kanji_file.store_string("[]")

	# read kanji
	var kanji_json_text = kanji_file.get_as_text()
	var kanji_json = JSON.new()
	var error = kanji_json.parse(kanji_json_text)
	kanji_file.close()

	if error != OK:
		print(kanji_json.get_error_message())
		return {}
	
	var result: Dictionary[String, Kanji] = {}
	for id in kanji_json.data:
		var kanji := Kanji.parse(kanji_json.data[id])
		if kanji:
			result[id] = kanji
	return result


static func save(kanji_entry) -> void:
	var res := read_file()

	if res.error != OK:
		print(res.json.get_error_message())
		return

	res.json.data[Utils.uuid()] = kanji_entry
	save_file(res.file, res.json.data)


static func delete(id: String):
	var res := read_file()

	if res.error != OK:
		print(res.json.get_error_message())
		return

	var data = res.json.data
	data.erase(id)

	save_file(res.file, data)


static func read_file() -> ReadResponse:
	var kanji_file := FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)

	if not kanji_file:
		FileAccess.open(FILE_PATH, FileAccess.WRITE)
		kanji_file = FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)
		kanji_file.store_string("[]")

	var kanji_json_text := kanji_file.get_as_text()
	var kanji_json := JSON.new()
	var error := kanji_json.parse(kanji_json_text)

	return ReadResponse.new(error, kanji_json, kanji_file)


static func save_file(file: FileAccess, data):
	file.resize(0)
	file.store_string(JSON.stringify(data, '\t'))
	file.close()


static func parse(json_entry) -> Kanji:
	var kanji = Kanji.new()
	if !json_entry.has('glyph'):
		print('Kanji missing glyph')
		return null

	kanji.glyph = json_entry.get('glyph')
	kanji.meanings.assign(json_entry.get('meanings', []))
	kanji.on_readings.assign(json_entry.get('on_readings', []))
	kanji.kun_readings.assign(json_entry.get('kun_readings', []))
	kanji.tags.assign(json_entry.get('tags', []))

	return kanji


class ReadResponse:
	var error: Error
	var json: JSON
	var file: FileAccess

	func _init(err: Error, j: JSON, f: FileAccess) -> void:
		error = err
		json = j
		file = f
