@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%"=="" @echo off
@rem ##########################################################################
@rem
@rem  Gradle startup script for Windows
@rem
@rem ##########################################################################

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%DIRNAME%") do set APP_HOME=%%~fi

set APP_BASE_NAME=%~n0
set DEFAULT_JVM_OPTS="-Xmx64m" "-Xms64m"

set CLASSPATH=%APP_HOME%\gradle\wrapper\gradle-wrapper.jar

if not exist "%CLASSPATH%" (
    echo Downloading Gradle wrapper jar...
    for /f "tokens=*" %%a in ('findstr /r "distributionUrl" "%APP_HOME%\gradle\wrapper\gradle-wrapper.properties"') do set "LINE=%%a"
    for /f "tokens=2 delims=-" %%a in ("%LINE%") do set "GRADLE_VER=%%a"
    powershell -Command "$url='https://services.gradle.org/distributions/gradle-%GRADLE_VER%-bin.zip'; $tmp='%TEMP%\gradle.zip'; $ext='%TEMP%\gradle-extract'; Invoke-WebRequest -Uri $url -OutFile $tmp; Expand-Archive -Path $tmp -DestinationPath $ext; Get-ChildItem -Path $ext -Recurse -Filter gradle-wrapper*.jar | Select-Object -First 1 | %% { Copy-Item $_.FullName '%CLASSPATH%' }"
    echo Done.
)

"%JAVA_HOME%\bin\java.exe" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
