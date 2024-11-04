import serial

class AtCommandLibrary(object):
    ''' Library for interacting with a simple device using AT commands
    '''
    ROBOT_LIBRARY_SCOPE = 'SUITE'

    def __init__(self, com_port):
        self._port = serial.Serial(com_port, 115200, timeout = 1)

    def send_command(self, cmd):
        self._port.reset_input_buffer()
        self._port.write(bytes(cmd + '\n', 'iso-8859-1'))

    def check_responses(self, expected_response):
        first_response = self._port.readline().strip().decode('iso-8859-1')
        if first_response != expected_response:
            second_response = self._port.readline().strip().decode('iso-8859-1')
            if second_response != expected_response:
                raise AssertionError('first_response: ' + first_response + ' second_response: ' + second_response)

    def send_text(self, text):
        self._port.reset_input_buffer()
        self._port.write(bytes('AT+SEND="' + text + '"\n', 'iso-8859-1'))

    def response_should_be(self, expected_text):
        text = self._port.readline().strip().decode('iso-8859-1')
        if text != expected_text:
            raise AssertionError('Expected: ' + expected_text + ' got: ' + text)
