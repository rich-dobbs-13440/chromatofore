from flask import Flask, render_template
from flask import request
import serial
import time


class InchwormException(RuntimeError):
    pass

class ChecksumMismatchException(InchwormException):
    pass

class InvalidResponseException(InchwormException):
    pass


app = Flask(__name__)

# @app.route('/')
# def index():
#     return render_template('index.html')

# def send_command_to_arduino(command):
#     # Configure the serial port
#     port = '/dev/ttyACM0'  # Change this to match your Arduino's port
#     baud_rate = 9600  # Set the baud rate to match your Arduino's configuration

#     # Open the serial port
#     ser = serial.Serial(port, baud_rate)

#     # Send the command to Arduino
#     ser.write(command.encode())

#     # Read the response from Arduino
#     response = ser.readline()
#     print("Response:", response.decode())

#     # Close the serial port
#     ser.close()



# def send_command_to_arduino(command):
#     port = '/dev/ttyACM0'  # Change this to match your Arduino's port
#     baud_rate = 9600  # Set the baud rate to match your Arduino's configuration

#     with serial.Serial(port, baud_rate, timeout=1) as ser:
#         # Send the command to Arduino
#         ser.write(command.encode())

#         # Read the response from Arduino
#         response = read_response(ser)


def send_command_to_arduino(command):
    # Configure the serial port
    port = '/dev/ttyACM0'  # Change this to match your Arduino's port
    baud_rate = 9600  # Set the baud rate to match your Arduino's configuration

    # Open the serial port
    with serial.Serial(port, baud_rate, timeout=10) as ser:

        # Send the command to Arduino
        ser.write(command.encode())

        # Read the response from Arduino
        arduino_response = read_response(ser)

        return arduino_response
    



# def read_response(ser):
#     response = ""
#     checksum = 0

#     # Read lines until the "ok" message is received
#     while True:
#         line = ser.readline().decode().strip()
#         if line.startswith("ok"):
#             # Parse the line to extract the verb and checksum
#             parts = line.split()
#             verb = parts[0]
#             received_checksum = int(parts[1])

#             # Check if the received checksum matches the calculated checksum
#             if received_checksum != calculate_checksum(response):
#                 raise Exception("Checksum mismatch")

#             if verb == "ok":
#                 return response
#             else:
#                 raise Exception("Invalid response: {}".format(line))
#         else:
#             response += line

#         # Update the checksum
#         for char in line:
#             checksum ^= ord(char)

def read_response(ser):
    response = ""

    # Read lines until the "ok" message is received
    timeout = 30
    start_time = time.time()
    while True:
        line = ser.readline().decode().strip()
        print(f"Arduino response: {line}")
        if line.startswith("ok"):
            # Parse the line to extract the verb and checksum
            parts = line.split()
            verb = parts[0]
            received_checksum = int(parts[1])
            print(f"Arduino received_checksum: {received_checksum}")

            # Check if the received checksum matches the calculated checksum
            if received_checksum != calculate_checksum(response):
                raise ChecksumMismatchException("Checksum mismatch")
            return response

        else:
            response += line

        elapsed_time = time.time() - start_time
        if elapsed_time >= timeout:
            raise TimeoutError()            


def calculate_checksum(data):
    checksum = 0
    for char in data:
        checksum ^= ord(char)
    return checksum

# # Example usage
# command = "G1 X100 Y100"
# response = send_command_to_arduino(command)
# print("Response:", response)           


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        if 'extrude' in request.form:
            # Perform the extrusion action here
            # Add your extrusion code or function call
            print("Extrusion initiated!")
            extrude = 'G1 E10'  # Example extrusion command 
            try:
                response = send_command_to_arduino(extrude)
                print("Response:", response)
                print("Extrusion completed:")
            except ChecksumMismatchException as e:
                print("Checksum mismatch:", str(e))
            except InvalidResponseException as e:
                print("Invalid response:", str(e))
            except InchwormException as e:
                print("An InchwormException occurred:", str(e))
            except TimeoutError:
                print("Timeout error")

    return render_template('index.html')


if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=5000, debug=True)


