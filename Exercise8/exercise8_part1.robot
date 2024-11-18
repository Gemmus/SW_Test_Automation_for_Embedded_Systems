*** Settings ***
Documentation     Testing functionalities of "Car Dealer" website. This file focuses on the 'plate'.

Resource          car_dealer.resource

Suite Setup       Environment Setup
Suite Teardown    Environment Teardown

*** Variables ***
# Plate related
${SPECIFIC_PLATE}                 ABC-123
${PLATE_ELEMENTS_PATH}            xpath=//div[contains(@class, 'car-specs') and contains(@class, 'car-plate')]/span[@class='field-value']

# Make scope related:
# param: limited                  randomisation from only hardcoded list
# param: unlimited                randomisation from Faker-Vehicle library
${MAKE_SCOPE}                     unlimited

# Screenshots related
${BEFORE_SCREENSHOOT_FILENAME}    before_part1.png
${AFTER_SCREENSHOOT_FILENAME}     after_part1.png

*** Test Cases ***
Add Three Random Cars
    Go To      ${LOCAL_HOST_URL}
    FOR  ${i}  IN RANGE  3
        ${make}    ${model}    ${mileage}    ${year}    ${plate}=    Get Random Car    ${MAKE_SCOPE}
        Add Car    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    END

Add Random Car Plate ABC-123
    Go To      ${LOCAL_HOST_URL}
    ${make}    ${model}    ${mileage}    ${year}    ${plate}=    Get Random Car    ${MAKE_SCOPE}
    Add Car    ${make}    ${model}    ${mileage}    ${year}    ${SPECIFIC_PLATE}

Add Two Random Cars
    Go To      ${LOCAL_HOST_URL}
    FOR  ${i}  IN RANGE  2
        ${make}    ${model}    ${mileage}    ${year}    ${plate}=    Get Random Car    ${MAKE_SCOPE}
        Add Car    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    END
    Screenshot    ${BEFORE_SCREENSHOOT_FILENAME}

Remove Specific Car Plate
    Go To                          ${LOCAL_HOST_URL}
    Remove Car                     ${SPECIFIC_PLATE}    ${PLATE_ELEMENTS_PATH}

Verify Specific Car Plate Does Not Exist
    Go To                          ${LOCAL_HOST_URL}
    Verify Does Not Exist          ${SPECIFIC_PLATE}    ${PLATE_ELEMENTS_PATH}
    Screenshot                     ${AFTER_SCREENSHOOT_FILENAME}

