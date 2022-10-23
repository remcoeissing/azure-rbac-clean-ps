param($Context)

$output = @()

$subscriptionsToCheck = Invoke-DurableActivity -FunctionName 'GetSubscriptions'

Write-Output $subscriptionsToCheck
if ($null -eq $subscriptionsToCheck -or $subscriptionsToCheck.Count -eq 0)
{
    throw "No subscriptions found"
}

$cleanTasks =
    foreach ($subscription in $subscriptionsToCheck) {
        Invoke-DurableActivity -FunctionName 'RemoveUnknownAssignments' -Input $subscription['Id'] -NoWait
    }

$output = Wait-ActivityFunction -Task $cleanTasks