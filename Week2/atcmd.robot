*** Settings ***
Documentation     Example of morse transmitter test
...
...               Change this example to use data driven style 
...               Test with different texts and speeds

Library           AtCommandLibrary.py
Test Template     Send AT Msg

*** Variables ***
${SEND_MSG_PREFIX}             AT+SEND
${VALID_RESPONSE_PREFIX}       SENT
${OK_RESPONSE}                 OK
${INVALID_RESPONSE}            INVALID

*** Keywords ***
Send AT Msg
    [Arguments]           ${message}    ${expected_response}    ${expected_status_code}=${INVALID_RESPONSE}
    Log To Console        \nSending: ${SEND_MSG_PREFIX}="${message}"
    Send text             ${message}
    IF    $expected_status_code == "${INVALID_RESPONSE}"
    Response should be    ${expected_status_code}
    ELSE IF    $expected_status_code == "${OK_RESPONSE}"
    Response should be    ${VALID_RESPONSE_PREFIX}="${expected_response}"
    Response should be    ${expected_status_code}
    END

*** Test Cases ***                    MESSAGE                            EXPECTED RESPONSE                      EXPECTED STATUS CODE
Only Letters                          Hello World                        HELLO WORLD                            ${OK_RESPONSE}
Only Numbers                          0123456789                         0123456789                             ${OK_RESPONSE}
Only Special Chars                    =/*~^+|                            XXXXXXX                                ${OK_RESPONSE}
Letter and Numbers                    0xBAdC0fFeE                        0XBADC0FFEE                            ${OK_RESPONSE}
Letters and Special Chars             hello,^&*() world!@#$%             HELLOXXXXXX WORLDXXXXX                 ${OK_RESPONSE}
Numbers and Special Chars             -2§4/56?3<                         X2X4X56X3X                             ${OK_RESPONSE}
Letters, Numbers and Special Chars    0xCaFeBaBe123%*£                   0XCAFEBABE123XXX                       ${OK_RESPONSE}
Empty Text                            ${EMPTY}                           ${EMPTY}                               ${OK_RESPONSE}
Whitespaces                           ${SPACE * 10}                      ${SPACE * 10}                          ${OK_RESPONSE}
One Double Quotation Mark             "                                  ${EMPTY}                               ${OK_RESPONSE}
Two Double Quotation Marks            ""                                 ${EMPTY}                               ${OK_RESPONSE}
Empty Single Quotation                ''                                 XX                                     ${OK_RESPONSE}
Line Breaks                           "\n\r"                             ${EMPTY}                               ${OK_RESPONSE}

Invalid Line Break                    \n\r                                                                      ${INVALID_RESPONSE}
Overflow                              This is a super super super super super long text that causes overflow    ${INVALID_RESPONSE}
Random Control Character              \x00Hello\x01World                                                        ${INVALID_RESPONSE}

