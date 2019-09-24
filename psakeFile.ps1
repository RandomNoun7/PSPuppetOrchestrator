properties {
    # Controls whether to "compile" module into single PSM1 or not
    $PSBPreference.Build.CompileModule = $true
    # Output file path Pester will save test results to
    $outputDir       = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    $outputModDir    = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    $manifest        = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    $testResultsFile = Join-Path -Path $outputModVerDir -ChildPath 'testResults.xml'
    $PSBPreference.Test.OutputFile = $testResultsFile
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.3.0'

task UploadTestResults {
    # upload results to AppVeyor
    $wc = New-Object 'System.Net.WebClient'
    $wc.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $testResultsFile  )
} -description 'Uploading tests'
