*** Settings ***
Library    OperatingSystem
Library    Collections
Library    String
Library    Dialogs
Library    FakerLibrary    locale=fi_Fi

*** Variables ***
${FILE_NAME}    address_file.txt

*** Keywords ***
Get Random Names
    [Arguments]    ${number_of_random_names}
    ${list_of_random_names}=    Create List
    FOR  ${i}  IN RANGE  0  ${number_of_random_names}
        ${random_name}=    FakerLibrary.Name
        Append To List    ${list_of_random_names}    ${random_name}
    END
    RETURN    ${list_of_random_names}

Create Person and Address File
    [Arguments]    ${new_file_name}
    ${random_names}=   Get Random Names    5
    ${random_names_list}=    Convert To List    ${random_names}
    ${chosen_name}=  Get Selection From User    Select from these names:    @{random_names_list}
    ${street}=    FakerLibrary.Street Address
    ${postcode}=    FakerLibrary.Postcode
    ${city}=    FakerLibrary.City
    Create File    ${new_file_name}
    File Should Exist    ${new_file_name}
    Append To File    ${new_file_name}    ${chosen_name}\n
    Append To File    ${new_file_name}    ${street}
    Append To File    ${new_file_name}    ${postcode}\n
    Append To File    ${new_file_name}    ${city}

Check Address File Has Correct Lines
    [Arguments]    ${file_to_verify}
    ${number_of_correct_lines}    Set Variable    3
    File Should Exist    ${file_to_verify}
    ${file_content}=    Get File    ${file_to_verify}
    ${line_count}=    Get Line Count    ${file_content}
    Should Be Equal As Integers    ${line_count}    ${number_of_correct_lines}

Remove Address File
    [Arguments]    ${file_to_remove}
    ${file_exists}=    Run Keyword and Return Status    File Should Exist    ${file_to_remove}
    IF    ${file_exists}
        ${file_content}=    Get File    ${file_to_remove}
        ${read_name}=    Get Line    ${file_content}    0
        Log To Console    \nRemoving: ${read_name}
        Remove File    ${file_to_remove}
    END
    File Should Not Exist    ${file_to_remove}

*** Test Cases ***
Remove Non-Existing Address File
    Remove Address File    ${FILE_NAME}

Create Address File
    Create Person and Address File    ${FILE_NAME}

Verify Address File
    Check Address File Has Correct Lines    ${FILE_NAME}

Remove Existing Address File
    Remove Address File    ${FILE_NAME}
