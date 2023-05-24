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

void setup() {
  Serial.begin(baudRate);
  Serial.println();
  Serial.println("--------------");
  Serial.println("Sketch Version: 1.0");
  Serial.print("Upload Date: ");
  Serial.println(__DATE__);
  Serial.print("Upload Time: ");
  Serial.println(__TIME__);
  Serial.print("Baud Rate: ");
  Serial.println(baudRate);
  Serial.println();
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
    //writePeriodicMessage();
    digitalWrite(blueLedPin, LOW);  //


    // Other code to be executed periodically...
  }
  if (Serial.available() > 0) {
    //serialIsAvailable = true;
    digitalWrite(blueLedPin, HIGH);
    String gcodeCommand = Serial.readStringUntil('\n');
    Serial.println(gcodeCommand);
    processCommand(gcodeCommand);
    writePeriodicMessage();
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
  Serial.print("Current time: ");
  Serial.print(currentHour);
  Serial.print(":");
  Serial.print(currentMinute);
  Serial.print(":");
  Serial.println(currentSecond);
  // Serial.print("Serial available: ");
  // Serial.println(serialIsAvailable);
  Serial.println("Periodic message!");
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
    Serial.print("Extruding ");
    Serial.print(extrusionAmount);
    Serial.println(" mm");
    //what G10 X[retract distance] Y[retract speed]

    // cold extrusion is M302 or M302 S0, while the command to enable cold retraction is M207 or M207 S1.

  } else {
    Serial.print("Unknown command: ");
    Serial.println(gcodeCommand);
  }
}
