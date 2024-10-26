*** Settings ***
Documentation     Example of morse transmitter test
...
...               Change this example to use data driven style 
...               Test with different texts and speeds

Library           AtCommandLibrary.py

*** Variables ***
${SEND_MSG_PREFIX}             AT+SEND
${VALID_RESPONSE_PREFIX}       SENT
${OK_RESPONSE}                 OK
${INVALID_RESPONSE}            INVALID

*** Keywords ***
Send Valid AT Msg
    [Arguments]           ${message}    ${expected_response}    ${expected_status_code}
    Log To Console        \nSending: ${SEND_MSG_PREFIX}="${message}"
    Send text             ${message}
    Response should be    ${VALID_RESPONSE_PREFIX}="${expected_response}"
    Response should be    ${expected_status_code}

Send Invalid AT Msg
    [Arguments]           ${message}    ${expected_status_code}
    Log To Console        \nSending: ${SEND_MSG_PREFIX}="${message}"
    Send text             ${message}
    Response should be    ${expected_status_code}

*** Test Cases ***                    KEYWORD                MESSAGE                            EXPECTED RESPONSE                      EXPECTED STATUS CODE
Only Letters                          Send Valid AT Msg      Hello World                        HELLO WORLD                            ${OK_RESPONSE}
Only Numbers                          Send Valid AT Msg      0123456789                         0123456789                             ${OK_RESPONSE}
Only Special Chars                    Send Valid AT Msg      =/*~^+|                            XXXXXXX                                ${OK_RESPONSE}
Letter and Numbers                    Send Valid AT Msg      0xBAdC0fFeE                        0XBADC0FFEE                            ${OK_RESPONSE}
Letters and Special Chars             Send Valid AT Msg      hello,^&*() world!@#$%             HELLOXXXXXX WORLDXXXXX                 ${OK_RESPONSE}
Numbers and Special Chars             Send Valid AT Msg      -2§4/56?3<                         X2X4X56X3X                             ${OK_RESPONSE}
Letters, Numbers and Special Chars    Send Valid AT Msg      0xCaFeBaBe123%*£                   0XCAFEBABE123XXX                       ${OK_RESPONSE}
Empty Text                            Send Valid AT Msg      ${EMPTY}                           ${EMPTY}                               ${OK_RESPONSE}
Whitespaces                           Send Valid AT Msg      ${SPACE * 10}                      ${SPACE * 10}                          ${OK_RESPONSE}
One Double Quotation Mark             Send Valid AT Msg      "                                  ${EMPTY}                               ${OK_RESPONSE}
Two Double Quotation Marks            Send Valid AT Msg      ""                                 ${EMPTY}                               ${OK_RESPONSE}
Empty Single Quotation                Send Valid AT Msg      ''                                 XX                                     ${OK_RESPONSE}
Line Breaks                           Send Valid AT Msg      "\n\r"                             ${EMPTY}                               ${OK_RESPONSE}

Invalid Line Break                    Send Invalid AT Msg    \n\r                                                                      ${INVALID_RESPONSE}
Overflow                              Send Invalid AT Msg    This is a super super super super super long text that causes overflow    ${INVALID_RESPONSE}
Random Control Character              Send Invalid AT Msg    \x00Hello\x01World                                                        ${INVALID_RESPONSE}

