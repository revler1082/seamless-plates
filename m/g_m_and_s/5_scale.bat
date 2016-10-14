@echo off
prompt $G
SETLOCAL
SETLOCAL EnableDelayedExpansion

echo scaling cropped png files

set crop_dir=%~dp0cropped\
set scale_dir=%~dp0scaled\

IF NOT EXIST "%crop_dir%" (
	echo crop directory does not exist : %crop_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%scale_dir%" MKDIR %scale_dir%

echo crop directory is %crop_dir%
echo scale directory is %scale_dir%

for /f %%f in ('dir /b "%crop_dir%*.png"') do ( 
	IF NOT EXIST "%scale_dir%%%~nf.png" (
		echo scaling %crop_dir%%%f
		convert %crop_dir%%%f -scale 8192x +repage "%scale_dir%%%~nf.png"
	) ELSE (
		for %%m in ("%crop_dir%%%f") do set crop_time=%%~tm
		for %%n in ("%scale_dir%%%~nf.png") do set scale_time=%%~tn

		set crop_time=!crop_time:~6,4!!crop_time:~0,2!!crop_time:~3,2!
		set scale_time=!scale_time:~6,4!!scale_time:~0,2!!scale_time:~3,2!

		IF !crop_time! GTR !scale_time! (
			echo %crop_dir%%%f is newer than existing file %scale_dir%%%~nf.png, re-scaling..
			convert %crop_dir%%%f -scale 8192x +repage "%scale_dir%%%~nf.png"
		) ELSE (
			echo %scale_dir%%%~nf.png already exists
		)
	)
)

ENDLOCAL
prompt $P$G
@echo on
