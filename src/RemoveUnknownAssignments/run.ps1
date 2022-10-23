param($subscription)

Write-Host "Getting role assignments for $subscription"
Select-AzSubscription -SubscriptionId $subscription

$roleAssignments = Get-AzRoleAssignment | Where-Object {$_.DisplayName -eq $null}
if ($null -eq $roleAssignments -or $roleAssignments.Count -eq 0)
{
    Write-Host "No unknown role assignments to clean up"
}

# Fetching all role assignments as safety mechanism that it will not delete all assignments
$allRoleAssignments = Get-AzRoleAssignment
if ($allRoleAssignments.Count -eq $roleAssignments.Count)
{
    throw "Count of unknown role assignments and all role assignments is identical. Missing permissions on Graph / Subscription"
}

foreach($assignment in $roleAssignments)
{
    Write-Host "Removing ($($assignment.ObjectType)) $($assignment.ObjectId) for $($assignment.RoleDefinitionName) on $($assignment.Scope)"

    # Only remove the assignments if the whatif setting is not set or is not 1.
    if (-not ('1' -eq $env:whatif -or [string]::IsNullOrEmpty($env:whatif)))
    {
        Remove-AzRoleAssignment -InputObject $assignment
    }
}
