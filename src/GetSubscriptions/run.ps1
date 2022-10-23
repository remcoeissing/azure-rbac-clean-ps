param( $tenantId )

$subscriptions = Get-AzSubscription | Select-Object Id

if (-not ($subscriptions -is [array]))
{
    $subscriptions = @($subscriptions)
}

$subscriptions
