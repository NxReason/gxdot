class_name Kanji
extends RefCounted

var glyph: String

var meanings: Array[String] = []
var on_readings: Array[String] = []
var kun_readings: Array[String] = []

var tags: Array[String] = []


const FILE_PATH := "user://data/kanji.json"


static func read_store() -> Array[Kanji]:
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
		return []
	
	var result: Array[Kanji] = []
	for entry in kanji_json.data:
		var kanji := Kanji.parse(entry)
		if kanji:
			result.push_back(kanji)
	return result


static func save(kanji_entry) -> void:
	var kanji_file := FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)

	if not kanji_file:
		FileAccess.open(FILE_PATH, FileAccess.WRITE)
		kanji_file = FileAccess.open(FILE_PATH, FileAccess.READ_WRITE)
		kanji_file.store_string("[]")

	# read kanji
	var kanji_json_text = kanji_file.get_as_text()
	var kanji_json = JSON.new()
	var error = kanji_json.parse(kanji_json_text)

	if error != OK:
		print(kanji_json.get_error_message())
		return

	kanji_json.data.push_back(kanji_entry)
	kanji_file.store_string(JSON.stringify(kanji_json.data, '\t'))
	kanji_file.close()


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
