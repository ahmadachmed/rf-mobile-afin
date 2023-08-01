*** Settings ***
Library         AppiumLibrary
Library        ${CURDIR}/../custom/slack/get_sms_otp.py
Resource        ${CURDIR}/../common/common.resource
Variables       ${CURDIR}/../../object/login/loginPage.py

*** Keywords ***
Click masuk button
    wait until element is visible      ${masuk_btn}     10s
    click element       ${masuk_btn}

input phone number and click masuk button
    [Arguments]     ${phone}
    wait until element is visible   ${login_phone_field}     10s
    input text      ${login_phone_field}     ${phone}
    wait until element is visible      ${masuk_phone_btn}      10s
    click element       ${masuk_phone_btn}

input valid pin
    [Arguments]       @{pin}
    FOR    ${i}    IN    @{pin}
        wait until element is visible     //android.widget.Button[contains(@text,'${i}')]    10s   
        click element   //android.widget.Button[contains(@text,'${i}')]
    END

input valid otp
    [Arguments]    ${phone}
    ${string}=     Get otp in slack by phone    ${phone}
    @{otp}=        Evaluate    [char for char in '${string}']  
    FOR    ${i}    IN    @{otp}
        wait until element is visible     //android.widget.Button[contains(@text,'${i}')]    10s   
        click element   //android.widget.Button[contains(@text,'${i}')]
    END

validate error pin massage
    [Arguments]        ${message}
    wait until element is visible        ${err_pin_msg}    10s
    Element should contain text    ${err_pin_msg}        ${message}

Success login as non mitra
    Wait Until Element Is Visible    ${self_loan_acc_btn}