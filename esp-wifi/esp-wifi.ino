

/*
 *  Simple HTTP get webclient test
 *  - code from https://learn.adafruit.com/adafruit-huzzah-esp8266-breakout/using-arduino-ide
 */
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid     = "Mathew's iPhone";
const char* password = "esp8266wifipass";
const char magic[4] = {0xDE, 0xAD, 0xBE, 0xEF};

int getPage(const char* url);
inline void sendTerminator();

void setup() {
  Serial.begin(19200);
  delay(100);

  // We start by connecting to a WiFi network
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(50);
    Serial.print(".");
  }
}



void loop() {
  getPage("https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png");
  delay(5000);
}


int getPage(const char* url)
{
  
  HTTPClient http;

  http.begin(url);
  http.GET();

  // get lenght of document (is -1 when Server sends no Content-Length header)
  int len = http.getSize();
  
  Serial.println(len);

  // create buffer for read
  uint8_t buff[128] = { 0 };

  // get tcp stream
  WiFiClient * stream = http.getStreamPtr();

  // read all data from server
  while(http.connected() && (len > 0 || len == -1)) {
      // get available data size
      size_t size = stream->available();
      if(size) {
          // read up to 128 byte
          int c = stream->readBytes(buff, ((size > sizeof(buff)) ? sizeof(buff) : size));

          // write it to Serial
          Serial.write(buff, c);

          if(len > 0) {
              len -= c;
          }
      }
      delay(1);
  }
  sendTerminator();
  Serial.flush();
}

inline void sendTerminator()
{
  Serial.write(magic, 4);
}
