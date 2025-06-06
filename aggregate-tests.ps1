# Define the path to .trx files
$trxFiles = Get-ChildItem -Path "$(Agent.TempDirectory)/*.trx"

# Initialize counters
$totalTests = 0
$passedTests = 0
$failedTests = 0
$skippedTests = 0

# Parse each .trx file
foreach ($file in $trxFiles) {
    [xml]$trxContent = Get-Content $file.FullName
    $ns = @{ns = "http://microsoft.com/schemas/VisualStudio/TeamTest/2010"}
    
    $totalTests += ($trxContent.SelectNodes("//ns:TestRun/ns:Results/ns:UnitTestResult", $ns)).Count
    $passedTests += ($trxContent.SelectNodes("//ns:TestRun/ns:Results/ns:UnitTestResult[@outcome='Passed']", $ns)).Count
    $failedTests += ($trxContent.SelectNodes("//ns:TestRun/ns:Results/ns:UnitTestResult[@outcome='Failed']", $ns)).Count
    $skippedTests += ($trxContent.SelectNodes("//ns:TestRun/ns:Results/ns:UnitTestResult[@outcome='NotExecuted']", $ns)).Count
}

# Output the results
Write-Host "##vso[task.setvariable variable=TotalTests]$totalTests"
Write-Host "##vso[task.setvariable variable=PassedTests]$passedTests"
Write-Host "##vso[task.setvariable variable=FailedTests]$failedTests"
Write-Host "##vso[task.setvariable variable=SkippedTests]$skippedTests"

Write-Host "Test Results Summary:"
Write-Host "Total Tests: $totalTests"
Write-Host "Passed: $passedTests"
Write-Host "Failed: $failedTests"
Write-Host "Skipped: $skippedTests"
