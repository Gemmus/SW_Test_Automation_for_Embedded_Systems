*** Settings ***
Documentation     Setup, Teardown, Create Three Cars, Document with Screenshots

Resource          car_dealer.resource

Suite Setup       Open Browser    ${LOCAL_HOST_URL}    ${BROWSER}
Suite Teardown    Close Browser
Test Setup        Screenshot Before
Test Teardown     Screenshot After

*** Test Cases ***
Add Cars To Car Dealer Website
    [Documentation]    Adds three cars to the "Car Dealer" website.
    [Setup]    Set Selenium Speed    ${SELENIUM_SPEED}
    Go To      ${LOCAL_HOST_URL}
    Screenshot Before
    Add Car    ${CAR_1_MAKE}    ${CAR_1_MODEL}    ${CAR_1_MILEAGE}    ${CAR_1_YEAR}    ${CAR_1_PLATE}
    Add Car    ${CAR_2_MAKE}    ${CAR_2_MODEL}    ${CAR_2_MILEAGE}    ${CAR_2_YEAR}    ${CAR_2_PLATE}
    Add Car    ${CAR_3_MAKE}    ${CAR_3_MODEL}    ${CAR_3_MILEAGE}    ${CAR_3_YEAR}    ${CAR_3_PLATE}
    Screenshot After
