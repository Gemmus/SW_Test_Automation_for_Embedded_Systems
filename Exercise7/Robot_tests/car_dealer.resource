*** Settings ***
Library              SeleniumLibrary

*** Variables ***
# Generic settings
${BROWSER}           Chrome
${LOCAL_HOST_URL}    http://localhost:3000
${SELENIUM_SPEED}    0.2

# Screenshot related settings
${BEFORE_SCREENSHOT_NAME}    before_test.png
${AFTER_SCREENSHOT_NAME}     after_test.png

# Car related settings
${CAR_1_MAKE}        Toyota
${CAR_1_MODEL}       Camry
${CAR_1_MILEAGE}     13297
${CAR_1_YEAR}        2019
${CAR_1_PLATE}       XYZ-1234

${CAR_2_MAKE}        Honda
${CAR_2_MODEL}       Accord
${CAR_2_MILEAGE}     4560
${CAR_2_YEAR}        2018
${CAR_2_PLATE}       ABC-5678

${CAR_3_MAKE}        Ford
${CAR_3_MODEL}       Focus
${CAR_3_MILEAGE}     35123
${CAR_3_YEAR}        2020
${CAR_3_PLATE}       DEF-9876

*** Keywords ***
Add Car
    [Arguments]     ${make}    ${model}    ${mileage}    ${year}    ${plate}
    Click Link      xpath=//a[contains(text(),'Add a car')]
    Input Text      id=make-input       ${make}
    Input Text      id=model-input      ${model}
    Input Text      id=mileage-input    ${mileage}
    Input Text      id=year-input       ${year}
    Input Text      id=plate-input      ${plate}
    Click Button    xpath=//input[@type='submit' and @value='Add a new car']

Screenshot Before
    Capture Page Screenshot    ${BEFORE_SCREENSHOT_NAME}

Screenshot After
    Capture Page Screenshot    ${AFTER_SCREENSHOT_NAME}
