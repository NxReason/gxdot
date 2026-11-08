class_name Connections
extends Control


var lines: Array[TalentConnection] = []


func set_lines(value: Array[TalentConnection]) -> void:
	lines = value
	queue_redraw()


func add(t_conn: TalentConnection) -> void:
	lines.append(t_conn)
	queue_redraw()


func _draw() -> void:
	for conn in lines:
		draw_line(conn.from, conn.to, conn.color, conn.width, true)