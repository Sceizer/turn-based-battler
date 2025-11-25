class_name UnitAnim extends Marker2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.connect("animation_finished", _on_animation_finished)


func _on_animation_finished(anim_name: String) -> void:
	print("%s finished" % anim_name)
	animation_player.play("idle")
