*** Settings ***
Library                  SeleniumLibrary
Library                  Process
Library                  FakerVehicleLibrary.py

*** Variables ***
# Flag to enable / disable Docker
${DOCKER_MODE}           True

# Generic settings
${BROWSER}               Chrome
${LOCAL_HOST_URL}        http://localhost:3000
${SELENIUM_SPEED}        0.1

# Car make scope related
${UNLIMITED}             unlimited
${LIMITED}               limited

# Car button description
${ADD_CAR_BUTTON}        xpath=//a[contains(text(),'Add a car')]
${ADD_NEW_CAR_BUTTON}    xpath=//input[@type='submit' and @value='Add a new car']

# Array first element's index
${FIRST_ELEMENT}         0

*** Keywords ***
Environment Setup
    IF  '${DOCKER_MODE}' == 'True'
        Run Process     docker-compose    up    --detach
        Sleep    5s
    END
    Open Browser    ${LOCAL_HOST_URL}    ${BROWSER}
    [Setup]    Set Selenium Speed    ${SELENIUM_SPEED}

Environment Teardown
    Close Browser
    IF  '${DOCKER_MODE}' == 'True'
        Run Process     docker-compose    down
    END

Get Random Car
    [Arguments]    ${make_scope}
    IF  '${make_scope}' == '${LIMITED}'
        ${limited_makes}=    Create List    Toyota    Skoda    Audi
        ${make}=   Evaluate          random.choice(${limited_makes})                            modules=random
    ELSE IF  '${make_scope}' == '${UNLIMITED}'
        ${make}=   Generate Vehicle Make
    END
    ${model}=      Generate Vehicle Model
    ${mileage}=    Evaluate          random.randint(0, 500000)                                  modules=random
    ${year}=       Evaluate          random.randint(1960, 2024)                                 modules=random
    ${letters}=    Evaluate       ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=3))    modules=random
    ${numbers}=    Evaluate       ''.join(random.choices('0123456789', k=3))                    modules=random
    ${plate}=      Set Variable      ${letters}-${numbers}
    RETURN    ${make}    ${model}    ${mileage}    ${year}   ${plate}

Add Car
    [Arguments]    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    Click Link                       ${ADD_CAR_BUTTON}
    Wait Until Element Is Visible    ${ADD_NEW_CAR_BUTTON}    timeout=10
    Input Text                       id=make-input       ${make}
    Input Text                       id=model-input      ${model}
    Input Text                       id=mileage-input    ${mileage}
    Input Text                       id=year-input       ${year}
    Input Text                       id=plate-input      ${plate}
    Click Button                     ${ADD_NEW_CAR_BUTTON}

Remove Car
    [Arguments]    ${car_param}
    ${cars_to_remove}    Set Variable    xpath=//*[@id="car-container"]//span[text()='${car_param}']
    ${cars_to_remove_list}=    Get WebElements    ${cars_to_remove}
    WHILE  ${cars_to_remove_list}
        Open Context Menu    ${cars_to_remove_list}[${FIRST_ELEMENT}]
        Handle Alert         ACCEPT
        ${cars_to_remove_list}=    Get WebElements    ${cars_to_remove}
    END

Verify Does Not Exist
    [Arguments]      ${car_param}    ${car_param_path}
    ${car_list}=    Get WebElements    ${car_param_path}
    FOR  ${current_car}  IN  @{car_list}
        ${current_car_param}=    Get Text   ${current_car}
        IF  '${current_car_param}' == '${car_param}'
            Fatal Error    ${car_param} exists on the page.
        END
    END

Screenshot
    [Arguments]                ${screenshot_name}
    Capture Page Screenshot    ${screenshot_name}
