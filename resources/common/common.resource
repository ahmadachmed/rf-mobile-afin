*** Settings ***
Library    AppiumLibrary
Library    RequestsLibrary
Library    OperatingSystem
Library    PostgreSQLDB
Library    ${CURDIR}/../custom/implicit-wait.py
Library    ${CURDIR}/../custom/mark-test-status.py
Library    ${CURDIR}/../custom/upload_app_to_bs.py
Library    ../custom/slack/get_sms_otp.py
Variables       cloudEnv.py

*** Variables ***
${LOCAL_APP_ID}=           ${CURDIR}/../../apps/app-minApi21-uat.apk
${LOCAL_REMOTE_URL}=        http://127.0.0.1:4723/wd/hub

# ${APP_ID}=                  ${appUrl}
${USERNAME}=                ${userNames}
${ACCESSKEY}=               ${accessKeys}
${REMOTE_URL}=              https://${USERNAME}:${ACCESSKEY}@hub-cloud.browserstack.com/wd/hub


*** Keywords ***
Open app in cloud
    ${APP_ID}        UPLOAD APP        ${USERNAME}    ${ACCESSKEY}        app-minApi21-uat.apk
    # ${APP_ID}         Get environment variable           BS_APP_URL
    open application    app=${APP_ID}
    ...                 remote_url=${REMOTE_URL}
    ...                 interactiveDebugging=true
    ...                 platformName=android
    ...                 deviceName=Samsung Galaxy S22
    ...                 name=single_test
    ...                 build=test-robot
    ...                 autoGrantPermissions=true
    IMPLICIT WAIT    5

Open app in local
    open application    app=${LOCAL_APP_ID}
    ...                 remote_url=${LOCAL_REMOTE_URL}
    ...                 device=emulator-5554
    ...                 platformName=android
    ...                 build=browserstack-robot-framework
    ...                 autoGrantPermissions=true
    IMPLICIT WAIT    5
    
Close cloud app
    run keyword if test passed    TEST STATUS    passed    Test results have been validated.
    run keyword if test failed    TEST STATUS    failed    Something went wrong!
    close application

Add Implicit Wait
    [Arguments]    ${duration}
    IMPLICIT WAIT   ${duration}

Mark Test Status
    [Arguments]    ${status}    ${reason}
    TEST STATUS    ${status}    ${reason}

Get otp in lists
    [Arguments]    ${phone_number}
    Get otp in slack by phone    ${phone_number}

Connect to PostgresDB
    Connect to postgresql    amartha_plus_db    amarthaplus    gacHVKtCnFv69x3K    localhost    15431
    @{query}        Execute sql string
    ...    select * from user_mitras     
    ...    where phone = '081378513209'
    log   @{query}
    Close All Postgresql Connections


    

