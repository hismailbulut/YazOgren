extends Node2D

const REMOVE_ADS_SKU = "remove_ads"

var payment
var _is_connected = false

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment = Engine.get_singleton("GodotGooglePlayBilling")
		payment.connect("connected", self, "_on_connected") # No params
		payment.connect("disconnected", self, "_on_disconnected") # No params
		payment.connect("connect_error", self, "_on_connect_error") # Response ID (int), Debug message (string)
		payment.connect("purchases_updated", self, "_on_purchases_updated") # Purchases (Dictionary[])
		payment.connect("purchase_error", self, "_on_purchase_error") # Response ID (int), Debug message (string)
		payment.connect("sku_details_query_completed", self, "_on_sku_details_query_completed") # SKUs (Dictionary[])
		payment.connect("sku_details_query_error", self, "_on_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		payment.connect("purchase_acknowledged", self, "_on_purchase_acknowledged") # Purchase token (string)
		payment.connect("purchase_acknowledgement_error", self, "_on_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.connect("purchase_consumed", self, "_on_purchase_consumed") # Purchase token (string)
		payment.connect("purchase_consumption_error", self, "_on_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		payment.startConnection()

func show_alert(text: String, is_debug_message: bool = true, duration: int = 0):
	get_parent().popup_dialog.popup(text, is_debug_message, duration)

func check_purchase():
	if !_is_connected:
		return
	var query = payment.queryPurchases("inapp")
	if query.status == OK:
		for purchase in query.purchases:
			if purchase.sku == REMOVE_ADS_SKU:
				if SettingsManager.get_settings().ads == true:
					SettingsManager.disable_ads() # kullanıcının reklamlarını kaldırır
					show_alert("Reklamlar devre dışı bırakılmıştır. Desteğiniz için teşekkür ederiz. Keyifli oyunlar.", false)
					get_parent().remove_ads_button.hide()
					get_parent().admob_banner.close_banner()
				if !purchase.is_acknowledged:
					payment.acknowledgePurchase(purchase.purchase_token)

func _on_connected():
	_is_connected = true
	payment.querySkuDetails([REMOVE_ADS_SKU], "inapp")

func _on_disconnected():
	_is_connected = false
	var _w_sec = 10
	show_alert("Bağlantı kesildi. %s saniye içerisinde bağlantı sınanacak. Lütfen bekleyin." % _w_sec, false, _w_sec)
	yield(get_tree().create_timer(_w_sec), "timeout")
	payment.startConnection()

func _on_connect_error(response_id, debug_message):
	_is_connected = false
	show_alert("connect error %s: %s" % [response_id, debug_message])

func _on_purchases_updated(purchases: Dictionary):
	check_purchase()
	show_alert("purchases updated: %s" % to_json(purchases))

func _on_purchase_error(response_id, debug_message):
	show_alert("Satın alımda hata oluştu. Hata kodu: (%s) Hata mesajı: (%s)" % [response_id, debug_message], false)

func _on_sku_details_query_completed(sku_details):
	check_purchase()
	show_alert("squ details query completed %s" % to_json(sku_details))

func _on_sku_details_query_error(response_id, debug_message, queried_squs):
	show_alert("squ details query error %s: %s: %s" % [response_id, debug_message, queried_squs])

func _on_purchase_acknowledged(purchase_token):
	show_alert("purchase acknowledged %s" % purchase_token)

func _on_purchase_acknowledgement_error(response_id, debug_message, purchase_token):
	show_alert("purchase acknowledgement error %s: %s: %s" % [response_id, debug_message, purchase_token])

func _on_purchase_consumed(purchase_token):
	check_purchase()
	show_alert("purchase_consumed %s" % purchase_token)

func _on_purchase_consumption_error(response_id, debug_message, purchase_token):
	show_alert("purchase consumption error %s: %s: %s" % [response_id, debug_message, purchase_token])

func _on_remove_ads_button_pressed():
	if !_is_connected:
		show_alert("Google satın alma hizmetine bağlanılamadı. Lütfen daha sonra tekrar deneyin.", false)
		return
	var response = payment.purchase(REMOVE_ADS_SKU)
	if response.status != OK:
		show_alert("Satın alımda hata oluştu. Hata kodu: (%s)" % response.response_code, false)
