#include "file_config.h"
#include <FS.h>

#define FS_NO_GLOBALS

// Загрузка данных сохраненных в файл  config.json
bool loadConfig()
{
	String passwordIn;
  // Проверяем наличие файла и открываем для чтения
  if (!SPIFFS.exists("/config.json")) { // Файл не найден
    Serial.println("Failed to open config.json file");
    // Создаем файл записав в него даные по умолчанию
    saveConfig();
    return false;
  }
  
  fs::File configFile = SPIFFS.open("/config.json", "r");
  Serial.println("File config.json present");
  // Проверяем размер файла, будем использовать файл размером меньше 2048 байта
  size_t size = configFile.size();
  if (size > 2048) {
    Serial.println("Config file size is too large");
    configFile.close();
    return false;
  }

	// загружаем файл конфигурации в глобальную переменную
	jsonConfig = configFile.readString();
	configFile.close();
	// Резервируем памяь для json обекта буфер может рости по мере необходимти предпочтительно для ESP8266
	DynamicJsonBuffer jsonBuffer;
	//  вызовите парсер JSON через экземпляр jsonBuffer
	//  строку возьмем из глобальной переменной String jsonConfig
	JsonObject& root = jsonBuffer.parseObject(jsonConfig);
	// Теперь можно получить значения из root
	_ssidAP = root["ssidAPName"].as<String>(); // Так получаем строку
	passwordIn = root["ssidAPPassword"].as<String>();
	if (passwordIn.length() >= 8) _passwordAP = passwordIn;
	timezone = root["timezone"];               // Так получаем число
	SSDP_Name = root["SSDPName"].as<String>();
	_ssid = root["ssidName"].as<String>();
	passwordIn = root["ssidPassword"].as<String>();
	if (passwordIn.length() >= 8) _password = passwordIn;
	return true;
}

// Запись данных в файл config.json
bool saveConfig()
{
	// Резервируем память для json объекта, буфер может расти по мере необходимости, предпочтительно для ESP8266
	DynamicJsonBuffer jsonBuffer;
	//  вызовите парсер JSON через экземпляр jsonBuffer
	JsonObject& json = jsonBuffer.parseObject(jsonConfig);
	// Заполняем поля json
	json["SSDPName"] = SSDP_Name;
	json["ssidAPName"] = _ssidAP;
	json["ssidAPPassword"] = _passwordAP;
	json["ssidName"] = _ssid;
	json["ssidPassword"] = _password;
	json["timezone"] = timezone;

	// Помещаем созданный json в глобальную переменную json.printTo(jsonConfig);
	json.printTo(jsonConfig);
	// Открываем файл для записи
	fs::File configFile = SPIFFS.open("/config.json", "w");
	if (!configFile)
	{
		//Serial.println("Failed to open config file for writing");
		configFile.close();
		return false;
	}
	// Записываем строку json в файл
	json.printTo(configFile);
	configFile.close();
	return true;
}
