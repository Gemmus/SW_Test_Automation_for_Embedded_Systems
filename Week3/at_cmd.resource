*** Settings ***
Library     AtCommandLibrary.py   ${COM_PORT}

*** Variables ***
# Suite Setup / Teardown
${AT_INIT}                     AT
${SUCCESSFUL_EXIT_CODE}        success

# Send AT Msg
${SEND_MSG_PREFIX}             AT+SEND
${VALID_RESPONSE_PREFIX}       SENT
${OK_RESPONSE}                 OK
${INVALID_RESPONSE}            INVALID

# Local Echo On / Off, Verify Echo State
${LOCAL_ECHO_VERIFY_CMD}       ATE
${LOCAL_ECHO_OFF_CMD}          ATE0
${LOCAL_ECHO_ON_CMD}           ATE1
${ECHO_ON_STATE_RESPONSE}      ON
${ECHO_OFF_STATE_RESPONSE}     OFF

*** Keywords ***
Suite Setup
    [Arguments]           ${COM_PORT}
    Log To Console        Initialising connection to ${COM_PORT}
    Send command          ${AT_INIT}
    Check Responses       ${OK_RESPONSE}
    Log To Console        Suite Setup: ${SUCCESSFUL_EXIT_CODE}
    Local Echo Off

Suite Teardown
    Local Echo On
    Log To Console        Suite Teardown: ${SUCCESSFUL_EXIT_CODE}

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

Verify Echo State
    [Arguments]           ${expected_state}
    Send command          ${LOCAL_ECHO_VERIFY_CMD}
    IF    $expected_state == "${ECHO_ON_STATE_RESPONSE}"
    Response should be    ${LOCAL_ECHO_VERIFY_CMD}
    END
    Response should be    ${expected_state}
    Log To Console        Echo state verified: ${expected_state}

Local Echo On
    Log To Console        Turning echo ${ECHO_ON_STATE_RESPONSE}
    Send command          ${LOCAL_ECHO_ON_CMD}
    Response should be    ${OK_RESPONSE}
    Verify Echo State     ${ECHO_ON_STATE_RESPONSE}

Local Echo Off
    Log To Console        Turning echo ${ECHO_OFF_STATE_RESPONSE}
    Send command          ${LOCAL_ECHO_OFF_CMD}
    Response should Be    ${LOCAL_ECHO_OFF_CMD}
    Response should Be    ${OK_RESPONSE}
    Verify Echo State     ${ECHO_OFF_STATE_RESPONSE}