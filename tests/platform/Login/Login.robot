*** Settings ***
Library     AppiumLibrary
Resource    ${CURDIR}/../../../resources/common/testrail_int.resource
Resource    ${CURDIR}/../../../resources/keywords/loginPage.resource

# Suite Setup      Run Keyword    Set Testrails Attribute                7            698    1979    platform-test
# Test Teardown    Run Keywords    Add Test Result    Close application

*** Variables ***
${phone}             0895800630333
@{pin}               1   4   7   3   6   9
    

*** Test Cases ***

Login - Success login with valid phone number
    # [Tags]    Smoke
    # Set Test ID    94655
    Open app in cloud
    Click masuk button
    input phone number and click masuk button    ${phone}
    input valid pin    @{pin}
    Sleep    5s
    input valid otp    ${phone}
    Success login as non mitra
