#!/bin/bash

katalon_version=${KATALON_VERSION}
test_suite=${TEST_SUITE_NAME}
type_of_test=${TYPE_OF_TEST}
execution_profile=${EXEC_PROFILE}
api_key=${API_KEY}
project_name=${PROJECT_NAME}

main_function() {
    printf "===> SCRIPT FOR STARTING WEB BROWSER AND KATALON CASES <===\n"
        cd Katalon_Studio_Engine_Linux_64-${katalon_version}
        katalon_cmd
}

katalon_cmd() {
 ./katalonc -noSplash -runMode=console -projectPath="/empresa/${project_name}.prj" -retry=0 -testSuitePath="Test Suites/${test_suite}" -browserType="$type_of_test" -executionProfile="$execution_profile" -apiKey="$api_key" --config -webui.autoUpdateDrivers=true
}

control_c() {
    echo ""
    exit
}

trap control_c SIGINT SIGTERM SIGHUP

main_function

exit
