extends Label

@export var damage: int = 0
var timer: float = 0

func _ready() -> void:
	text = String.num_int64(damage)

func _process(delta: float) -> void:
	if(timer >= 1):
		self.queue_free()
	else:
		timer += delta
