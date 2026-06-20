@if "%DEBUG%"=="" @echo off
set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
for %%i in ("%DIRNAME%") do set APP_HOME=%%~fi

set APP_BASE_NAME=%~n0
set CLASSPATH=%APP_HOME%\gradle\wrapper\gradle-wrapper.jar

if not exist "%CLASSPATH%" (
    echo Downloading Gradle wrapper jar...
    for /f "tokens=*" %%a in ('findstr /r "^distributionUrl" "%APP_HOME%\gradle\wrapper\gradle-wrapper.properties"') do set "LINE=%%a"
    for /f "tokens=2 delims=-" %%a in ("%LINE%") do set "GRADLE_VER=%%a"
    for /f "tokens=1 delims=-" %%a in ("%GRADLE_VER%") do set "GRADLE_VER=%%a"
    powershell -Command "$url='https://services.gradle.org/distributions/gradle-%GRADLE_VER%-bin.zip'; $tmp='%TEMP%\gradle.zip'; $ext='%TEMP%\gradle-extract'; Invoke-WebRequest -Uri $url -OutFile $tmp; Expand-Archive -Path $tmp -DestinationPath $ext; Get-ChildItem -Path $ext -Recurse -Filter gradle-wrapper*.jar | Select-Object -First 1 | %% { Copy-Item $_.FullName '%CLASSPATH%' }"
    echo Done.
)

if not exist "%CLASSPATH%" (
    echo ERROR: Gradle wrapper jar not found.
    exit /b 1
)

"%JAVA_HOME%\bin\java.exe" %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
