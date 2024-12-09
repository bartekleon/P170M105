extends Node3D

@export var footsteps_sounds : Array[AudioStreamMP3]
@export var ground_pos : Marker3D
@onready var player := $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.step.connect(play_sound)

func play_sound():
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	var index = randi_range(0, footsteps_sounds.size() - 1)
	audio_player.stream = footsteps_sounds[index]
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	ground_pos.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
