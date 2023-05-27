#include <TimeLib.h>
#include <Servo.h>
#include <GCodeParser.h>

// Servo pins
const int FILAMENT_MOVE_PIN = 8;
const int FILAMENT_CLAMP_PIN = 9;
const int FILAMENT_ROTATE_PIN = 10;
const int EXTRUDER_ENGAGE_PIN = 11;

// Servo objects
Servo filamentMoveServo;
Servo filamentClampServo;
Servo filamentRotateServo;
Servo extruderEngageServo;


// Servo angles
static int filamentMoveAngle = 90;
static int filamentClampAngle = 45;
static int filamentRotateAngle = 180;
static int extruderEngageAngle = 0;


static bool enableMoveServo = false;
static bool enableClampServo = false;
static bool enableRotateServo = false;
static bool enableEngageServo = false;

GCodeParser GCode = GCodeParser();

const int redLedPin = 14;
const int blueLedPin = 15;

unsigned long previousMillisLedHeartBeat = 0;
unsigned long previousMillisSerial = 0;  // Update the previousMillis value
int heartbeatPin = redLedPin;  

int baudRate = 9600;
unsigned long ledHeartBeatInterval = 500;   // Time interval in milliseconds (1 second)
unsigned long intervalSerial = 20000;  // Time interval in milliseconds (1 second)
int ledHeatBeatState = LOW;                   // Initial LED state

bool serialIsAvailable = false;

static const char* logPrefix = "-- debug --";

template<typename T, typename... Args>
void debugLog(T first, Args... args) {
  Serial.print(logPrefix);
  Serial.print(" ");
  Serial.print(first);
  ((Serial.print(" "), Serial.print(args)), ...);
  Serial.println();
}


// Function to update filament move angle
void updateFilamentMoveAngle(int angle) {
  if (enableMoveServo) {
    filamentMoveAngle = angle;
    filamentMoveServo.write(filamentMoveAngle);
  }
}

// Function to update filament clamp angle
void updateFilamentClampAngle(int angle) {
  if (enableMoveServo) {
    filamentClampAngle = angle;
    filamentClampServo.write(filamentClampAngle);
  }
}

// Function to update filament rotate angle
void updateFilamentRotateAngle(int angle) {
  if (enableRotateServo) {
    filamentRotateAngle = angle;
    filamentRotateServo.write(filamentRotateAngle);
  }
}

// Function to update extruder engage angle
void updateExtruderEngageAngle(int angle) {
  if (enableEngageServo) {
    extruderEngageAngle = angle;
    extruderEngageServo.write(extruderEngageAngle);
  }
}




void acknowledgeCommand(const String& command) {
  // Calculate the checksum
  byte checksum = calculateChecksum(command);

  Serial.print("OK");
  Serial.print(" ");
  Serial.println(checksum, HEX);
  Serial.flush();
}

byte calculateChecksum(const String& command) {
  byte checksum = 0;
  for (size_t i = 0; i < command.length(); i++) {
    checksum ^= command[i];
  }
  return checksum;
}

void sendResponse(const String& response, byte checksum) {

}


void writePeriodicMessage() {
  // Get the current time
  int currentHour = hour();
  int currentMinute = minute();
  int currentSecond = second();

  // Display the periodic message with the current time
  debugLog("Current time: ", currentHour, ":", currentMinute, ":", currentSecond, "Periodic message!");
  Serial.flush();
}




void ledHeartBeat() {
  unsigned long currentMillis = millis();

  // Check if the specified interval has elapsed
  if (currentMillis - previousMillisLedHeartBeat >= ledHeartBeatInterval) {
    previousMillisLedHeartBeat = currentMillis; 

    // Toggle the state of the red LED
    if (ledHeatBeatState == LOW) {
      ledHeatBeatState = HIGH;
    } else {
      ledHeatBeatState = LOW;
    }

    digitalWrite(heartbeatPin, ledHeatBeatState);  // Update the LED state
  }
}


void serialHeartBeat() {
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillisSerial >= intervalSerial) {
    previousMillisSerial = currentMillis;  // Update the previousMillis value
    writePeriodicMessage();
  }
}

void handleSerial() {
  if (Serial.available() > 0) {
    //serialIsAvailable = true;
    digitalWrite(blueLedPin, HIGH);
    char serialChar = Serial.read();
    debugLog("serialChar", serialChar);
    if (GCode.AddCharToLine(serialChar)) {
      debugLog("GCode.line", GCode.line);
      acknowledgeCommand(GCode.line);
      GCode.ParseLine();
      if (GCode.HasWord('G')) {
        float g = GCode.GetWordValue('G');
        if (g == 1) {
          debugLog("Handle extrusion command.");
          updateFilamentMoveAngle(0);
          delay(1000);
          updateFilamentMoveAngle(180);
          delay(1000);
          updateFilamentMoveAngle(0);
          delay(1000);  
          debugLog("Done with Handle extrusion command.");        

        } else if (g == 10) {
          debugLog("Handle retraction command."); 
          updateFilamentMoveAngle(45);         
        } else {
          debugLog("GWordValue", g);
        }
      }
    }
    if (GCode.HasWord('C')) {
      debugLog("Invoking C as a fake close servo command"); 
      updateFilamentMoveAngle(15);
      updateFilamentClampAngle(15);
      updateFilamentRotateAngle(15);
      updateExtruderEngageAngle(15);
    }    
    if (GCode.HasWord('O')) {
      debugLog("Invoking O as a fake open servo command"); 
      updateFilamentMoveAngle(135);
      updateFilamentClampAngle(135);
      updateFilamentRotateAngle(135);
      updateExtruderEngageAngle(135);
    }
    delay(1000);
    digitalWrite(blueLedPin, LOW);
  }
}

void setupServos() {
  if (enableMoveServo) {
    filamentMoveServo.attach(FILAMENT_MOVE_PIN);
  }
  if (enableClampServo) {
    filamentClampServo.attach(FILAMENT_CLAMP_PIN);
  }
  if (enableRotateServo) {
    filamentRotateServo.attach(FILAMENT_ROTATE_PIN);
  }
  if (enableEngageServo) {
    extruderEngageServo.attach(EXTRUDER_ENGAGE_PIN);
  }

  // Set initial servo angles
  updateFilamentMoveAngle(filamentMoveAngle);
  updateFilamentClampAngle(filamentClampAngle);
  updateFilamentRotateAngle(filamentRotateAngle);
  updateExtruderEngageAngle(extruderEngageAngle);  

  delay(10000);
}

void setupSerial() {
  Serial.begin(baudRate);

  debugLog("--------------");
  debugLog("Sketch Version: 1.0");
  debugLog("Upload Date: ", __DATE__);
  debugLog("Upload Time: ", __TIME__);
  debugLog("Baud Rate: ", baudRate);
  debugLog("Millis: ", millis());
}

void setupLedHeartBeat(int pin) {
  heartbeatPin = pin;
  pinMode(heartbeatPin, OUTPUT);
}

void setup() {

  // Initialize the digital pin as an output
  pinMode(redLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);

  setupLedHeartBeat(redLedPin);

  digitalWrite(redLedPin, HIGH);
  setupSerial();
  digitalWrite(redLedPin, LOW);

  digitalWrite(blueLedPin, HIGH);
  enableMoveServo = true;
  enableClampServo = false;
  enableRotateServo = false;
  enableEngageServo = false;
  setupServos();
  digitalWrite(blueLedPin, LOW);

}

void loop() {
  ledHeartBeat();
  serialHeartBeat();
  handleSerial();
}





