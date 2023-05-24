
#include <TimeLib.h>

int baudRate = 57600;

unsigned long previousMillis = 0;
unsigned long interval = 5000; // Time interval in milliseconds (5 seconds)


void setup() {
  // Initialize serial communication
  Serial.begin(baudRate);

  Serial.println();  
  Serial.println("--------------");
  Serial.println("Sketch Version: 1.1");

  // Print the version number and upload time
  Serial.print("Upload Date: ");
  Serial.println(__DATE__);
  Serial.print("Upload Time: ");
  Serial.println(__TIME__);
  Serial.print("Baud Rate: ");
  Serial.println(baudRate);  
  Serial.println();  
}

void loop() {
  delay(1000)
  //unsigned long currentMillis = millis();

  // Check if the specified interval has elapsed
  // if (currentMillis - previousMillis >= interval) {
  //   previousMillis = currentMillis; // Update the previousMillis value
  //   // Get the current time
  //   int currentHour = hour();
  //   int currentMinute = minute(); 
  //   int currentSecond = second(); 

  //   // Display the periodic message with the current time
  //   Serial.print("Current time: ");
  //   Serial.print(currentHour);
  //   Serial.print(":");
  //   Serial.print(currentMinute); // Changed the variable name here as well
  //   Serial.print(":");
  //   Serial.println(currentSecond); // Changed the variable name here as well
  //   Serial.println("Periodic message!");

  //   // Other code to be executed periodically...

  // }  
  // if (Serial.available() > 0) {
  //   // Read incoming G-code command
  //   String gcodeCommand = Serial.readStringUntil('\n');
  //   gcodeCommand.trim(); // Remove leading/trailing whitespace
    
  //   // Check if the command is an extrusion command (e.g., G1 E10)
  //   if (gcodeCommand.startsWith("G1") && gcodeCommand.indexOf("E") != -1) {
  //     // Extract the extrusion value from the command
  //     float extrusionAmount = 0.0;
  //     int eIndex = gcodeCommand.indexOf("E");
  //     if (eIndex != -1) {
  //       extrusionAmount = gcodeCommand.substring(eIndex + 1).toFloat();
  //     }
      
  //     // Perform extrusion based on the extrusion amount
  //     // (Add your extrusion logic here)
  //     Serial.print("Extruding ");
  //     Serial.print(extrusionAmount);
  //     Serial.println(" mm");
  //   }
  // }
}

