*** Settings ***
Documentation     Testing functionalities of "Car Dealer" website. This file focuses on the 'make'.

Resource          car_dealer.resource

Suite Setup       Environment Setup
Suite Teardown    Environment Teardown

*** Variables ***
# Make related
${SPECIFIC_MAKE}                  Skoda
${MAKE_ELEMENTS_PATH}             xpath=//div[contains(@class, 'car-specs') and contains(@class, 'car-make')]/span[@class='field-value']

# Make scope related:
# param: limited                  randomisation from only hardcoded list
# param: unlimited                randomisation from Faker-Vehicle library
${MAKE_SCOPE}                     limited

# Screenshots related
${BEFORE_SCREENSHOOT_FILENAME}    before_part2.png
${AFTER_SCREENSHOOT_FILENAME}     after_part2.png

*** Test Cases ***
Add Ten Random Toyota Skoda or Audi
    Go To          ${LOCAL_HOST_URL}
    Screenshot     ${BEFORE_SCREENSHOOT_FILENAME}
    FOR  ${i}  IN RANGE  10
        ${make}    ${model}    ${mileage}    ${year}    ${plate}=    Get Random Car    ${MAKE_SCOPE}
        Add Car    ${make}    ${model}    ${mileage}    ${year}    ${plate}
    END

Remove All Specific Make
    Go To                         ${LOCAL_HOST_URL}
    Remove Car                    ${SPECIFIC_MAKE}

Verify No Specific Make Exist
    Go To                         ${LOCAL_HOST_URL}
    Verify Does Not Exist         ${SPECIFIC_MAKE}    ${MAKE_ELEMENTS_PATH}
    Screenshot                    ${AFTER_SCREENSHOOT_FILENAME}