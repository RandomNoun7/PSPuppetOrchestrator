properties {
    # Controls whether to "compile" module into single PSM1 or not
    $PSBPreference.Build.CompileModule = $true
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.3.0'

task UploadTestResults {
    # upload results to AppVeyor
    $wc = New-Object 'System.Net.WebClient'
    $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Join-Path -Path $ENV:BHBuildOutput -ChildPath 'testResults.xml'))
} -description 'Uploading tests'
