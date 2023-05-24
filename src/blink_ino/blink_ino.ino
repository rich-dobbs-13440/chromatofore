
const int redLedPin = 14;
const int blueLedPin = 15;

unsigned long previousMillis = 0;
unsigned long interval = 1000; // Time interval in milliseconds (1 second)
int ledState = LOW; // Initial LED state

void setup() {
  Serial.begin(9600);
  Serial.println();
  Serial.println("--------------");
  Serial.println("Sketch Version: 1.0");
  Serial.print("Upload Date: ");
  Serial.println(__DATE__);
  Serial.print("Upload Time: ");
  Serial.println(__TIME__);
  Serial.println("Baud Rate: 9600");
  Serial.println();  
  // Initialize the digital pin as an output
  pinMode(redLedPin, OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();

  // Check if the specified interval has elapsed
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis; // Update the previousMillis value

    // Toggle the state of the red LED
    if (ledState == LOW) {
      ledState = HIGH;
    } else {
      ledState = LOW;
    }

    digitalWrite(redLedPin, ledState); // Update the LED state
  }
}
