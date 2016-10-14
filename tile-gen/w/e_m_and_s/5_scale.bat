@echo off
prompt $G

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
		echo %scale_dir%%%~nf.png already exists

	)
)

prompt $P$G
pause
@echo on
