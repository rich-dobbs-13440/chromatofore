/*

GCODE implementation:

G28 C0 : Move clamp servo to home position signaled by limit switch.  

G1 E10 F10 : Extrude 10 mm of filament, feed rate currently ignore.

G1 C10  : Move clamp servo to an angle of 10 degrees

G1 X10  : Move move servo to an angle of 10 degres

*/


#include <TimeLib.h>
#include <Servo.h>
#include <string.h>
#include <ezButton.h>
#include <math.h>

float nan = sqrt(-1);


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
static int filamentClampAngle = 90;
static int filamentRotateAngle = 180;
static int extruderEngageAngle = 0;


static bool enableMoveServo = true;  // Axis X
static bool enableClampServo = true; // Axis C
static bool enableRotateServo = false;
static bool enableEngageServo = false;

const int CLAMP_LIMIT_PIN = 12;
ezButton clampLimitSwitch(CLAMP_LIMIT_PIN);  // create ezButton object that attach to pin 7;

int unclamp_angle = 10;
int clamp_angle = 170;

const int redLedPin = 14;
const int blueLedPin = 15;

unsigned long previousMillisLedHeartBeat = 0;
unsigned long previousMillisSerial = 0;  // Update the previousMillis value
int heartbeatPin = redLedPin;

int baudRate = 9600;
unsigned long ledHeartBeatInterval = 500;  // Time interval in milliseconds (1 second)
unsigned long intervalSerial = 20000;      // Time interval in milliseconds (1 second)
int ledHeatBeatState = LOW;                // Initial LED state

bool serialIsAvailable = false;

static const char* logPrefix = "-- debug --";

const int BUFFER_SIZE = 256;    // Size of the input buffer
char inputBuffer[BUFFER_SIZE];  // Input buffer to store characters
int bufferIndex = 0;            // Index to keep track of the buffer position

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
void updateFilamentClampAngle(const int angle) {
  if (enableMoveServo) {
    filamentClampAngle = angle;
    filamentClampServo.write(filamentClampAngle);
    debugLog("Current filamentClampAngle", filamentClampAngle);
  }
}

// Function to update filament rotate angle
void updateFilamentRotateAngle(const int angle) {
  if (enableRotateServo) {
    filamentRotateAngle = angle;
    filamentRotateServo.write(filamentRotateAngle);
  }
}

// Function to update extruder engage angle
void updateExtruderEngageAngle(const int angle) {
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



void writePeriodicMessage() {
  // Get the current time
  int currentHour = hour();
  int currentMinute = minute();
  int currentSecond = second();

  int state = clampLimitSwitch.getState();
  String message;
  if (state == HIGH)
    message = "The clamp limit switch: UNTOUCHED";
  else
    message = "The clamp limit switch: TOUCHED";

  // Display the periodic message with the current time
  debugLog("Current time: ", currentHour, ":", currentMinute, ":", currentSecond, message);
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

void extrude(const float mm_of_filament, const float feedrate_mm_per_minute) {
  if (mm_of_filament > 0) {
    updateFilamentClampAngle(unclamp_angle);
    delay(2000);  // Time interval to allow  clamp to open
    updateFilamentMoveAngle(0);
    delay(2000);  // Time interval to allow  traveller to get into position
    updateFilamentClampAngle(clamp_angle);
    // Ignore feedrate for now!
    updateFilamentMoveAngle(mm_of_filament);
    delay(4000);
  } else {
    updateFilamentClampAngle(unclamp_angle);  // Unclamp
    delay(2000);                              // Time interval to allow  clamp to open
    updateFilamentMoveAngle(135);
    delay(2000);                            // Time interval to allow  traveller to get into position
    updateFilamentClampAngle(clamp_angle);  // Clamp
    // Ignore feedrate for now!
    updateFilamentMoveAngle(135 + mm_of_filament);
    delay(4000);
  }
}


void home_clamp_servo() {
  float increment = 1;
  float clamp_angle = 90;
  delay(1000);
  updateFilamentClampAngle(clamp_angle);
  clampLimitSwitch.loop();
  while(clampLimitSwitch.getState() == LOW) {
    delay(1000);
    clampLimitSwitch.loop();
  }
  for (clamp_angle = 90; clamp_angle < 180; clamp_angle += increment) {
    updateFilamentClampAngle(clamp_angle);
    clampLimitSwitch.loop();
    int state = clampLimitSwitch.getState();
    if (state == LOW) {
      break;
    }
  }
  debugLog("Fast find clamp limit:", clamp_angle);
}



void handleSerial() {
  if (Serial.available() > 0) {
    digitalWrite(blueLedPin, HIGH);
    char serialChar = Serial.read();

    if (serialChar != '\n' && serialChar != '\r') {
      // Add character to the buffer
      inputBuffer[bufferIndex] = serialChar;
      bufferIndex++;

      // Check if buffer is full
      if (bufferIndex >= BUFFER_SIZE - 1) {
        inputBuffer[bufferIndex] = '\0';  // Null-terminate the buffer
        bufferIndex = 0;                  // Reset buffer index
        processInputBuffer();             // Process the received line
      }
    } else {
      // Line ending character encountered
      inputBuffer[bufferIndex] = '\0';  // Null-terminate the buffer
      bufferIndex = 0;                  // Reset buffer index
      processInputBuffer();             // Process the received line
    }
    digitalWrite(blueLedPin, LOW);
  }
}



void processInputBuffer() {
  String gcode_line(inputBuffer);
  acknowledgeCommand(gcode_line);
  debugLog("Received ", gcode_line);
  char* token;
  char delimiter = ' ';
  token = strtok(inputBuffer, &delimiter);
  
  float c = nan;
  float e = nan;
  float f = nan;
  float g = nan;
  float x = nan;

  //debugLog("e", e);
  while (token != NULL) {
    String word = token;
    //debugLog("word", word);
    if (word.startsWith("C")) {
      c = word.substring(1).toFloat();
    } else if (word.startsWith("E")) {
      e = word.substring(1).toFloat();
    } else if (word.startsWith("E")) {
      e = word.substring(1).toFloat();
    } else if (word.startsWith("F")) {
      f = word.substring(1).toFloat();
    } else if (word.startsWith("G")) {
      g = word.substring(1).toFloat();
    } else if (word.startsWith("X")) {
      x = word.substring(1).toFloat();      
    } 
    token = strtok(NULL, &delimiter);
  }
  // debugLog("c:", c);
  // debugLog("e:", e);
  // debugLog("f:", f);
  // debugLog("g:", g);

  switch (int(g)) {
    case 1:
      if (!isnan(c)) {
        debugLog("Handle clamp command. Angle:", c);
        float angle = c;
        updateFilamentClampAngle(angle);
      }      
      if (!isnan(e)) {
        debugLog("Handle extrusion command.");
        float mm_of_filament = e;
        float feedrate_mm_per_minute = f;
        extrude(mm_of_filament, feedrate_mm_per_minute);
      }
      if (!isnan(x)) {
        debugLog("Handle move command. Angle:", x);
        float angle = x;
        updateFilamentMoveAngle(angle);
      }

      break;
    case 10:
      // Code to execute when g is 10.0
      debugLog("Value of g is 10");
      break;
    case 28:
      // Home axis
      if (c != 0) {
        home_clamp_servo();
      }
      break;
    default:
      // Code to execute when g doesn't match any case
      debugLog("Value of g doesn't match any case");
      break;
  }
}

void setupServos() {
  if (enableMoveServo) {
    filamentMoveServo.attach(FILAMENT_MOVE_PIN);
  }
  if (enableClampServo) {
    clampLimitSwitch.setDebounceTime(50);  // set debounce time to 50 milliseconds
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
  debugLog("Sketch Version: 1.1");
  debugLog("Upload Date: ", __DATE__);
  debugLog("Upload Time: ", __TIME__);
  debugLog("Baud Rate: ", baudRate);
  debugLog("Millis: ", millis());
}

void setupLedHeartBeat(const int pin) {
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
  enableClampServo = true;
  enableRotateServo = true;
  enableEngageServo = true;
  setupServos();
  digitalWrite(blueLedPin, LOW);
}

void loop() {
  clampLimitSwitch.loop();
  if (clampLimitSwitch.isPressed())
    debugLog("The limit switch: UNTOUCHED -> TOUCHED");

  if (clampLimitSwitch.isReleased())
    debugLog("The limit switch: TOUCHED -> UNTOUCHED");
  ledHeartBeat();
  serialHeartBeat();
  handleSerial();
}
