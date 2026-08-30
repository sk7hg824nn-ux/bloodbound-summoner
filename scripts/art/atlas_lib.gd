extends RefCounted
class_name AtlasLib
const ROOT := "res://art/atlas/"

static func tex(sheet: String, frame: String) -> Texture2D:
	var path := "%s%s.sprites/%s.tres" % [ROOT, sheet, frame]
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null

static func has_sheet(sheet: String) -> bool:
	return DirAccess.dir_exists_absolute(ROOT + sheet + ".sprites") or ResourceLoader.exists(ROOT + sheet + ".tpsheet")
