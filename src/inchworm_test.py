

import serial

def send_command_to_arduino(command):
    # Configure the serial port
    port = '/dev/ttyACM0'  # Change this to match your Arduino's port
    baud_rate = 9600  # Set the baud rate to match your Arduino's configuration

    # Open the serial port
    ser = serial.Serial(port, baud_rate)

    # Send the command to Arduino
    ser.write(command.encode())

    # Read the response from Arduino
    response = ser.readline()
    print("Response:", response.decode())

    # Close the serial port
    ser.close()


command = 'G1 E10\n'  # Example extrusion command
send_command_to_arduino(command)

