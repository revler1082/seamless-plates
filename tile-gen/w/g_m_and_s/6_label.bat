@echo off
prompt $G

echo labeling scaled png files

set scale_dir=%~dp0scaled\
set label_dir=%~dp0labeled\

IF NOT EXIST "%scale_dir%" (
	echo scale directory does not exist : %scale_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%label_dir%" MKDIR %label_dir%

echo scale directory is %scale_dir%
echo label directory is %label_dir%

for /f %%f in ('dir /b "%scale_dir%*.png"') do ( 
	IF NOT EXIST "%label_dir%%%~nf.png" (
		echo labeling %scale_dir%%%f
		convert "%scale_dir%%%f" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 '%%~nf'" "%label_dir%%%~nf.png"
	) ELSE (
		echo %label_dir%%%~nf.png already exists, skipping labeling
	)
)

prompt $P$G
pause
@echo on
