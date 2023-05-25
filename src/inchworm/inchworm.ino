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

GCodeParser GCode = GCodeParser();

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
  filamentMoveAngle = angle;
  filamentMoveServo.write(filamentMoveAngle);
}

// Function to update filament clamp angle
void updateFilamentClampAngle(int angle) {
  filamentClampAngle = angle;
  filamentClampServo.write(filamentClampAngle);
}

// Function to update filament rotate angle
void updateFilamentRotateAngle(int angle) {
  filamentRotateAngle = angle;
  filamentRotateServo.write(filamentRotateAngle);
}

// Function to update extruder engage angle
void updateExtruderEngageAngle(int angle) {
  extruderEngageAngle = angle;
  extruderEngageServo.write(extruderEngageAngle);
}



// void handleExtrusionCommand(const String& command, bool& handled) {
//   // Check if the command has already been handled
//   if (handled) {
//     return;
//   }
//   MatchState ms;
//   ms
//   ms.Target(command);
//   char result = ms.Match ("^G1\\s+E([\\d.]+)(?:\\s+F([\\d.]+))?(?:\\s*;.*)?$");
//   if (result > 0) {}
//     // Extract the values
//     float amount = 12.0; // atof(extrusionPattern.matched(1));
//     float feedrate = 13.0; //extrusionPattern.matched(2) ? atof(extrusionPattern.matched(2)) : 0.0;
//     String comment = "The comment"; //  command.substring(command.indexOf(';') + 1);

//     // Log the extrusion command details
//     String logMessage = "Extrusion command detected. Amount: " + String(amount) + " mm";
//     if (feedrate > 0.0) {
//       logMessage += ", Feedrate: " + String(feedrate) + " mm/min";
//     }
//     if (comment.length() > 0) {
//       logMessage += ", Comment: " + comment;
//     }
//     debugLog(logMessage);

//     // Set handled to true
//     handled = true;
//   }
// }

// Code provided by ChatGPT
// void handleExtrusionCommand(const String& command, bool& handled) {
//   // Check if the command has already been handled
//   if (handled) {
//     return;
//   }

//   // Regular expression pattern for extrusion command
//   Regexp extrusionPattern("^G1\\s+E([\\d.]+)(?:\\s+F([\\d.]+))?(?:\\s*;.*)?$");

//   // Check if the command matches the extrusion pattern
//   if (extrusionPattern.match(command)) {
//     // Extract the values
//     float amount = atof(extrusionPattern.matched(1));
//     float feedrate = extrusionPattern.matched(2) ? atof(extrusionPattern.matched(2)) : 0.0;
//     String comment = command.substring(command.indexOf(';') + 1);

//     // Log the extrusion command details
//     String logMessage = "Extrusion command detected. Amount: " + String(amount) + " mm";
//     if (feedrate > 0.0) {
//       logMessage += ", Feedrate: " + String(feedrate) + " mm/min";
//     }
//     if (comment.length() > 0) {
//       logMessage += ", Comment: " + comment;
//     }
//     debugLog(logMessage);

//     // Set handled to true
//     handled = true;
//   }
// }

// // Function to parse extrusion command
// void handleExtrusionCommand(const String& command, bool& handled) {
//   // Check if the command has already been handled
//   if (handled) {
//     return;
//   }

//   // Regular expression pattern for extrusion command
//   std::regex extrusionPattern(R"(^G1\s+E([\d.]+)(?:\s+F([\d.]+))?(?:\s*;.*)?$)");

//   // Match object to store extracted values
//   std::smatch match;

//   // Check if the command matches the extrusion pattern
//   if (std::regex_match(command.c_str(), match, extrusionPattern)) {
//     // Extract the values
//     float amount = std::stof(match[1].str());
//     float feedrate = match[2].matched ? std::stof(match[2].str()) : 0.0;
//     String comment = command.substring(command.indexOf(';') + 1);

//     // Log the extrusion command details
//     String logMessage = "Extrusion command detected. Amount: " + String(amount) + " mm";
//     if (feedrate > 0.0) {
//       logMessage += ", Feedrate: " + String(feedrate) + " mm/min";
//     }
//     if (comment.length() > 0) {
//       logMessage += ", Comment: " + comment;
//     }
//     debugLog(logMessage);

//     // Set handled to true
//     handled = true;
//   }
// }


// void processCommand(String gcodeCommand) {
//   bool handled = false;
//   handleExtrusionCommand(gcodeCommand, handled);
//   if (!handled)
//     debugLog("Unknown command: ", gcodeCommand);
//   }
// }


String readCommand() {
  String command = Serial.readStringUntil('\n');  // Read the command from the host
  Serial.flush();
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
  Serial.flush();
}





void setup() {
  Serial.begin(baudRate);

  debugLog("--------------");
  debugLog("Sketch Version: 1.0");
  debugLog("Upload Date: ", __DATE__);
  debugLog("Upload Time: ", __TIME__);
  debugLog("Baud Rate: ", baudRate);
  debugLog("Millis: ", millis());

  // Initialize the digital pin as an output
  pinMode(redLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);
  writePeriodicMessage();
  digitalWrite(blueLedPin, HIGH);
  delay(5000);
  writePeriodicMessage();
  digitalWrite(blueLedPin, LOW);


  filamentMoveServo.attach(FILAMENT_MOVE_PIN);
  filamentClampServo.attach(FILAMENT_CLAMP_PIN);
  filamentRotateServo.attach(FILAMENT_ROTATE_PIN);
  extruderEngageServo.attach(EXTRUDER_ENGAGE_PIN);

  // Set initial servo angles

  (filamentMoveAngle);
  updateFilamentClampAngle(filamentClampAngle);
  updateFilamentRotateAngle(filamentRotateAngle);
  updateExtruderEngageAngle(extruderEngageAngle);
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
    char serialChar = Serial.read();
    debugLog("serialChar", serialChar);
    if (GCode.AddCharToLine(serialChar)) {
      debugLog("GCode.line", GCode.line);
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
        } else {
          debugLog("GWordValue", g);
        }
      }
      // Code to process the line of G-Code here…
    }

    // String gcodeCommand = readCommand(); // Receive the command from the host
    // debugLog("gcodeCommand: ", gcodeCommand);
    // processCommand(gcodeCommand);


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
  debugLog("Current time: ", currentHour, ":", currentMinute, ":", currentSecond, "Periodic message!");
  Serial.flush();
}





// // Example usage
// void setup() {
//   Serial.begin(9600);

//   // Test extrusion command
//   String command = "G1 E10 F1800 ; Extrude 10 mm of filament at 1800 mm/min";
//   bool handled = false;
//   parseExtrusionCommand(command, handled);

//   // Check if the command was handled
//   if (!handled) {
//     // Handle other commands
//     // ...
//   }
// }

// void loop() {
//   // Your code here
// }
