*** Settings ***
Library  OperatingSystem
Library  String
Library  DateTime
Library  Collections
Library  Process
Library  ${CURDIR}/../custom/testrail_integration.py

*** Variables ***
### Test ID Initials ###
${TEST_STATUS}=                PASS
${RESULT_ID}=                  1
${TEST_ID}=                    example
${existing_run_id}=            None
${PUBLIC_IP}=                  127.0.0.1
${PORT}=                       8080
${timeout}=                    15
${STANDALONE}=                 True
${paramTag}=                   None

*** Keywords ***
Set Test ID
	[Arguments]             ${test_id}=None
	run keyword if          '${test_id}'=='None'
	...                     Set Test Variable           ${TEST_ID}          None
	...                     ELSE
    ...                     Set Test Variable    ${TEST_ID}          ${test_id}
    # ...                     Set Variable Test Id And Add To Test Run    ${test_id}

Set Variable Test Id And Add To Test Run
    [Arguments]    ${test_id}=None
    Add Test Case To Test Run  ${test_id}    
    Set Test Variable    ${TEST_ID}          ${test_id}

Set Testrails Attribute
    [Arguments]             ${project_id}               ${suite_id}    ${milestone_id}    ${suite_name}
    
    # Log    'OPTION INCLUDE : '${OPTIONS.include}
    # ${a}  ${OPTIONS.include}
    # Log    ${a}
    # Run Keyword If    ${OPTIONS.include}==[Smoke]    Set Test Variable    ${paramTag}= Smoke
    # Run Keyword If    ${OPTIONS.include}==[Sanity]    Set Test Variable    ${paramTag}= Sanity

    # IF    $OPTIONS.include == [Smoke]
    #     Log    Smoke
    #     ${paramTag}= Smoke
    # ELSE IF    $OPTIONS.include == [Sanity]
    #     Log    Sanity
    #     ${paramTag}= Sanity
    # END

    # Log    ${paramTag}
    
    ${TEST_RUN_ID}=         Create Test Run             ${project_id}
    ...                     ${suite_id}    ${milestone_id}    ${suite_name}
    Set Global Variable                                 ${TEST_RUN_ID}
    Set Global Variable                                 ${project_id}
    Set Global Variable                                 ${suite_id}
    Set Global Variable                                 ${milestone_id}