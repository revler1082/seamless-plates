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

convert "%~dp0scaled\f4425.png" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 'f4425'" "%~dp0labeled\f4425.png"
convert "%~dp0scaled\f3519.png" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 'f3519'" "%~dp0labeled\f3519.png"
convert "%~dp0scaled\f4323.png" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 'f4323'" "%~dp0labeled\f4323.png"
convert "%~dp0scaled\f3750.png" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 'f3750'" "%~dp0labeled\f3750.png"
convert "%~dp0scaled\f4322.png" -shave 8x8 +repage -bordercolor "rgb(255,255,255)" -border 8x8 +repage -font Arial -pointsize 1500 -draw "gravity center fill rgba(255,255,255,.25) text 0,0 'f4322'" "%~dp0labeled\f4322.png"

prompt $P$G
pause
@echo on
