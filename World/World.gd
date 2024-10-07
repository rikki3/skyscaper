extends Node2D

@onready var popup = get_node("Window")
@onready var key = get_node("Area2D2")
@onready var player = get_node("Player")
@onready var landingTimer = get_node("Timer")
@onready var chest = get_node("Area2D/Chest")
@onready var sndPickup = get_node("Area2D2/Pickup")
@onready var sndManager = get_node("Area2D2/Pickup")

var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()

func _ready():
	PlayerVariables.initialLand = false
	PlayerVariables.invKey = false
	PlayerVariables.playerExists = true
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded
	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		destroy()
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
	InterstitialAdLoader.new().load("ca-app-pub-4758330002839843/4382314396", AdRequest.new(), interstitial_ad_load_callback)
	landingTimer.start()
	
func _on_button_pressed() -> void:
	popup.hide()
	if interstitial_ad:
		interstitial_ad.show()
	get_tree().change_scene_to_file("res://World/World.tscn")

func _on_button_2_pressed() -> void:
	popup.hide()
	get_tree().change_scene_to_file("res://World/World.tscn")
	
func _on_window_close_requested() -> void:
	_on_button_2_pressed()
	get_tree().change_scene_to_file("res://World/World.tscn")

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	print("interstitial ad loaded" + str(interstitial_ad._uid))
	interstitial_ad.full_screen_content_callback = full_screen_content_callback
	self.interstitial_ad = interstitial_ad

func _on_destroy_pressed():
	destroy()

func destroy():
	if interstitial_ad:
		interstitial_ad.destroy()
		interstitial_ad = null #need to load again


func _on_area_2d_body_entered(body: Node2D) -> void:
	if PlayerVariables.invKey:
		PlayerVariables.invKey = false
		sndManager = get_node("Area2D/Unlock")
		sndManager._set_playing(true)
		chest.hide()
		chest = get_node("Area2D/ChestOpen")
		sndManager = get_node("Area2D/Enter")
		sndManager._set_playing(true)
		chest.show()
		chest = get_node("Area2D/Portal")
		chest.show()
		popup.show()
		player.queue_free()
		PlayerVariables.playerExists = false
	else:
		print("Player has not collected key.")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	PlayerVariables.invKey = true
	sndManager._set_playing(true)
	key.hide()
	key = get_node("Area2D2/CollisionShape2D")
	key.set_shape(null)


func _on_timer_timeout() -> void:
	PlayerVariables.initialLand = true
	landingTimer.queue_free()
