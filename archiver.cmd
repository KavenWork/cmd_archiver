
@echo off
setlocal
setlocal enabledelayedexpansion

rem *^*^*^*^*^*^*^*^*^*^*^*
rem Jens Jap - 2013.05.06
rem Beer license applies
rem *^*^*^*^*^*^*^*^*^*^*^*
echo.
echo.

set yyyy_mm_dd=%date:~-4,4%_%date:~-10,2%_%date:~-7,2%
set ZIPEX=D:\utilities\zip.exe
set LOG=D:\utilities\ziperror.txt
set ARCHIVE_DIR=D:\Ruby\srdr-dev\log\archives\
set CMD="dir /A-D /S /B D:\Ruby\srdr-dev\log\archives\*.log"

echo archiver started - %yyyy_mm_dd% >>%LOG%

if not exist %ZIPEX% goto :ERROR1

for /f %%L in (' %CMD% ') do (
    echo INFO: Zipping %%L now...
    %ZIPEX% %ARCHIVE_DIR%archive_%yyyy_mm_dd%.zip %%L
    echo.
)

if ERRORLEVEL 0 goto :CLEANUP
goto :ERROR2

:CLEANUP
for /f %%L in ('%CMD%') do (
    set filename=%%L
    echo INFO: Deleting %%L now...
    del %%L
    if exist %%L call :ERROR3
    echo.
)
goto :END

:ERROR1
echo CRITICAL: zip utility not found in D:\utilities\        >>%LOG%
echo CRITICAL: Please ensure it exists before trying again   >>%LOG%
echo CRITICAL: Terminating now                               >>%LOG%
goto :END

:ERROR2
echo CRITICAL: Creating zip file failed                      >>%LOG%
echo CRITICAL: Terminating now                               >>%LOG%
goto :END

:ERROR3
echo ERROR: Problem deleting !filename!                      >>%LOG%
goto :EOF

:END
echo archiver finished - %yyyy_mm_dd% >>%LOG%
echo. >>%LOG%
endlocal
