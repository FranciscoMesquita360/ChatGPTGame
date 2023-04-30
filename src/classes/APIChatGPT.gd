extends Node
class_name APIChatGPT
var api_key:String
var custom_headers:Array
var model:String
var requets_body:Dictionary
var temperature:float = 0.7
var url:String
var request
var result
var message_result:String
signal response_received
func _init(_model:String= "gpt-3.5-turbo",_url:String = "https://api.openai.com/v1/chat/completions",_api_key:String = "your_api_key", _temperature:float = 0.7):
	model = _model
	url = _url
	api_key =_api_key
	temperature = _temperature
	


func connect_api():
	if is_instance_valid(self):
		request = HTTPRequest.new()
		add_child(request)
		request.connect("request_completed", Callable(self, "_on_request_completed"))
		return request
	else:
		prints(self,"not is_instance_valid")


func _on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Erro: ", result)
		result = ""
		response_received.emit(result)
		return
	else:
		result  = body.get_string_from_utf8()
		response_received.emit(result)

func set_custom_headers_value(value:String):
	custom_headers.append(value)

func send_message(_message,method:int =  HTTPClient.METHOD_POST):
	if is_instance_valid(request):
		requets_body = {     "model": model,     "messages": [{"role": "user", "content":_message}],     "temperature": temperature   }
		var requets_body_str  = JSON.stringify(requets_body)
		request.request(url, custom_headers, method,requets_body_str)

