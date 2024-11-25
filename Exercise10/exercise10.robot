*** Settings ***
Library    SSHLibrary
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_Fi

*** Variables ***
${FILE_NAME}          address_file.txt
#${REMOTE_HOST}       must be passed from command line as parameter
#${REMOTE_USERNAME}   must be passed from command line as parameter
${SSH_KEY_PATH}       ${REMOTE_USERNAME}-448.pem   # must be added locally
${REMOTE_PATH}        ./

*** Keywords ***
Get Random Names
    [Arguments]    ${number_of_random_names}
    ${list_of_random_names}=    Create List
    FOR  ${i}  IN RANGE  0  ${number_of_random_names}
        ${random_name}=    FakerLibrary.Name
        Append To List    ${list_of_random_names}    ${random_name}
    END
    RETURN    ${list_of_random_names}

Connect To SSH
    Open Connection          ${REMOTE_HOST}
    Login With Public Key    ${REMOTE_USERNAME}    ${SSH_KEY_PATH}

Disconnect From SSH
    Close Connection

Create Person and Address File
    [Arguments]    ${new_file_name}
    ${random_names}=         Get Random Names    5
    ${random_names_list}=    Convert To List    ${random_names}
    ${chosen_name}=          Get Selection From User    Select from these names:    @{random_names_list}
    ${street}=               FakerLibrary.Street Address
    ${postcode}=             FakerLibrary.Postcode
    ${city}=                 FakerLibrary.City

    Connect To SSH

    ${file_path}=      Set Variable    ${REMOTE_PATH}${new_file_name}

    Execute Command    echo "${chosen_name}" >> ${file_path}
    Execute Command    echo "${street}" >> ${file_path}
    Execute Command    echo "${postcode} ${city}" >> ${file_path}

    File Should Exist    ${new_file_name}

    Disconnect From SSH

Check Address File Has Correct Lines
    [Arguments]    ${file_to_verify}
    ${number_of_correct_lines}    Set Variable    3

    Connect To SSH

    ${file_content}=    Execute Command    cat ${file_to_verify}
    ${line_count}=    Get Length    ${file_content.split('\n')}
    Should Be Equal As Integers    ${line_count}    ${number_of_correct_lines}

    Disconnect From SSH

Remove Address File
    [Arguments]    ${file_to_remove}

    Connect To SSH

    ${file_first_line}=    Execute Command    head -n 1 ${file_to_remove}
    Log To Console    \nRemoving: ${file_first_line}

    Execute Command    rm -f ${file_to_remove}
    File Should Not Exist    ${file_to_remove}

    Disconnect From SSH

*** Test Cases ***
Remove Existing Address File
    Remove Address File    ${FILE_NAME}

Create Address File
    Create Person and Address File    ${FILE_NAME}

Verify Address File
    Check Address File Has Correct Lines    ${FILE_NAME}
