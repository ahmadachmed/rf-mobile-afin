from testrail_api import TestRailAPI
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
import pprint, datetime, os


@keyword('Create Test Run')
def create_test_run(project_id, suite_id, milestone_id, suite_name):

    testrailAccount = os.environ.get('TESTRAIL_USER', 'default_value')
    testrailPassword = os.environ.get('TESTRAIL_PASSWORD', 'default_value')
    api = TestRailAPI("https://amarthaqa.testrail.io/", testrailAccount,testrailPassword)

    if suite_name == None:
        suite_name = BuiltIn().get_variable_value("${SUITE_NAME}")
        suite_name = str(suite_name).replace("Api-Robot.", "")
        suite_name = suite_name.split(".")
        suite_name = suite_name[0]

    status = BuiltIn().get_variable_value("${STANDALONE}")

    if status == "True":
        run = api.runs.add_run(
            project_id=project_id,
            milestone_id=milestone_id,
            suite_id=suite_id,
            name="%s" % suite_name,
            include_all=True
        )

    return run['id']

@keyword('Add Test Case To Test Run')
def add_test_case_to_test_run(case_id):
    testrailAccount = os.environ.get('TESTRAIL_USER', 'default_value')
    testrailPassword = os.environ.get('TESTRAIL_PASSWORD', 'default_value')
    api = TestRailAPI("https://amarthaqa.testrail.io/", testrailAccount,testrailPassword)

    run_id = BuiltIn().get_variable_value("${TEST_RUN_ID}")

    api.runs.update_run(run_id=int(run_id),
                        case_ids=[case_id]
                        )

@keyword('Add Test Result')
def add_result_to_test_run():
    testrailAccount = os.environ.get('TESTRAIL_USER', 'default_value')
    testrailPassword = os.environ.get('TESTRAIL_PASSWORD', 'default_value')
    api = TestRailAPI("https://amarthaqa.testrail.io/", testrailAccount,testrailPassword)


    case_id = BuiltIn().get_variable_value("${test_id}")
    test_status = BuiltIn().get_variable_value("${TEST_STATUS}")
    resp = BuiltIn().get_variable_value("${response}")
    response = pprint.pformat(resp)
    run_id = BuiltIn().get_variable_value("${TEST_RUN_ID}")
    status = BuiltIn().get_variable_value("${STANDALONE}")
    err = _get_message()

    print("%s" % test_status)

    if case_id != "None" and test_status == "PASS" and status == "True":
        api.results.add_result_for_case(
            run_id=int(run_id),
            case_id=int(case_id),
            status_id=1,
            comment="API response : %s" % response,
        )
    elif test_status == 'FAIL' and status == "True":
        api.results.add_result_for_case(
            run_id=int(run_id),
            case_id=int(case_id),
            status_id=5,
            comment="API response : %s \n Error: %s" % (response, err),
        )


def _get_message():
    err_msg = BuiltIn().get_variable_value("${TEST_MESSAGE}")
    return err_msg