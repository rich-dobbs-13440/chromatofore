#include <TimeLib.h>

const int redLedPin = 14;
const int blueLedPin = 15;

unsigned long previousMillisBlink = 0;
unsigned long previousMillisSerial = 0;  // Update the previousMillis value

int baudRate = 9600;
unsigned long intervalBlink = 3000;   // Time interval in milliseconds (1 second)
unsigned long intervalSerial = 5000;  // Time interval in milliseconds (1 second)
int ledState = LOW;                   // Initial LED state

bool serialIsAvailable = false;

static const char* logPrefix = "-- debug --";

template <typename T, typename... Args>
void debugLog(T first, Args... args) {
  Serial.print(logPrefix);
  Serial.print(" ");
  Serial.print(first);
  ((Serial.print(" "), Serial.print(args)), ...);
  Serial.println();
}



void setup() {
  Serial.begin(baudRate);



  debugLog();
  debugLog("--------------");
  debugLog("Sketch Version: 1.0");
  debugLog("Upload Date: ", __DATE__);
  debugLog("Upload Time: ", __TIME__);
  debugLog("Baud Rate: ", baudRate);

  // Initialize the digital pin as an output
  pinMode(redLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);
  writePeriodicMessage();
  digitalWrite(blueLedPin, HIGH);
  delay(5000);
  writePeriodicMessage();
  digitalWrite(blueLedPin, LOW);
}

void loop() {
  unsigned long currentMillis = millis();

  // Check if the specified interval has elapsed
  if (currentMillis - previousMillisBlink >= intervalBlink) {
    previousMillisBlink = currentMillis;  // Update the previousMillis value

    // Toggle the state of the red LED
    if (ledState == LOW) {
      ledState = HIGH;
    } else {
      ledState = LOW;
    }

    digitalWrite(redLedPin, ledState);  // Update the LED state
    //Serial.print("blink ");
    //Serial.println(currentMillis);
  }

  if (currentMillis - previousMillisSerial >= intervalSerial) {
    previousMillisSerial = currentMillis;  // Update the previousMillis value
    writePeriodicMessage();
    //digitalWrite(blueLedPin, LOW);  //


    // Other code to be executed periodically...
  }
  if (Serial.available() > 0) {
    //serialIsAvailable = true;
    digitalWrite(blueLedPin, HIGH);
    String gcodeCommand = readCommand(); // Receive the command from the host
    Serial.println(gcodeCommand);
    processCommand(gcodeCommand);
    
    delay(2000);
    digitalWrite(blueLedPin, LOW);
  }
}



void writePeriodicMessage() {
  // Get the current time
  int currentHour = hour();
  int currentMinute = minute();
  int currentSecond = second();

  // Display the periodic message with the current time
  debugLog("Current time: ", currentHour, ":", currentMinute, ":", currentSecond, "Periodic message!" );
}



void processCommand(String gcodeCommand) {

  // Check if the command is an extrusion command (e.g., G1 E10)
  if (gcodeCommand.startsWith("G1") && gcodeCommand.indexOf("E") != -1) {
    // Extract the extrusion value from the command
    float extrusionAmount = 0.0;
    int eIndex = gcodeCommand.indexOf("E");
    if (eIndex != -1) {
      extrusionAmount = gcodeCommand.substring(eIndex + 1).toFloat();
    }

    // Perform extrusion based on the extrusion amount
    // (Add your extrusion logic here)
    debugLog("Extruding ", extrusionAmount, " mm");
    //what G10 X[retract distance] Y[retract speed]

    // cold extrusion is M302 or M302 S0, while the command to enable cold retraction is M207 or M207 S1.

  } else {
    debugLog("Unknown command: ", gcodeCommand);
  }
}


String readCommand() {
  String command = Serial.readStringUntil('\n'); // Read the command from the host

  // Calculate the checksum
  byte checksum = calculateChecksum(command);

  // Send the "ok" response with the checksum
  sendResponse("ok", checksum);

  return command;
}

byte calculateChecksum(const String& command) {
  byte checksum = 0;
  for (size_t i = 0; i < command.length(); i++) {
    checksum ^= command[i];
  }
  return checksum;
}

void sendResponse(const String& response, byte checksum) {
  Serial.print(response);
  Serial.print(" ");
  Serial.println(checksum, HEX);
}
