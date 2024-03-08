@echo off
echo.
echo This will remove iTunes DRM tags with personal information from m4a and m4v files in this folder and all subfolders.
echo Unfortunately this will remove album covers from music video files (m4v).
echo You need to put ffmpeg.exe file in this folder to proceed.
echo.
pause

setlocal EnableDelayedExpansion

set "skipConfirmation="

for /r %%a in (*.m4a *.m4v) do (
    if not defined skipConfirmation (
        set /p "confirmation=To skip confirmation press R and ENTER or just press ENTER to continue: "
        if /i "!confirmation!"=="R" (
            set skipConfirmation=true
        )
    )

	echo Processing file: "%%a"
	ffmpeg -i "%%a" -metadata encoder="" -map_metadata 0 -fflags +bitexact -c copy "%%a_temp.m4a"
	IF !ERRORLEVEL! NEQ 0 (
		echo Error converting file: "%%a"
		set /p "continueOnError=Do you want to continue processing other files? (Y/N): "
			if /i "!continueOnError!"=="N" (goto end)
	)
	move "%%a_temp.m4a" "%%a"
	echo.
	echo "%%a" file processing completed.
	echo.
)

:end
pause
