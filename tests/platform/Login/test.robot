*** Settings ***
Resource    ${CURDIR}/../../../resources/common/common.resource
Library    PostgreSQLDB

*** Keywords ***
get slack message
    [Arguments]    ${input_phone}
    ${phone}    Get otp in slack by phone    ${input_phone}
    Log to console   ${phone}
    @{otp}=        Evaluate    [char for char in '${phone}']  
    Log many    @{otp}

*** Test Cases ***
Success get slack message
    get slack message    081211459702
