# Manage the circleci build
ct-ng_circleci_build()
{
    # Build
    ct-ng build.4 &
    local build_pid=$!

    # Start a runner task to print a "still running" line every 5 minutes
    # to avoid circleci to think that the build is stuck
    {
        while true
        do
            sleep 300
            printf "Crosstool-NG is still running ...\r"
        done
    } &
    local runner_pid=$!

    # Wait for the build to finish and get the result
    wait $build_pid 2>/dev/null
    local result=$?

    # Stop the runner task
    kill $runner_pid
    wait $runner_pid 2>/dev/null

    # Return the result
    return $result
}

ct-ng_circleci_build
