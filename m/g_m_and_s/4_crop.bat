@echo off
prompt $G
SETLOCAL
SETLOCAL EnableDelayedExpansion

echo cropping pre-processed png files

set preprocess_dir=%~dp0preprocessed\
set crop_dir=%~dp0cropped\

IF NOT EXIST "%preprocess_dir%" (
	echo preprocess directory does not exist : %preprocess_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%crop_dir%" MKDIR %crop_dir%

echo preprocess directory is %preprocess_dir%
echo crop directory is %crop_dir%

for /f %%f in ('dir /b "%preprocess_dir%*.png"') do ( 
	IF NOT EXIST "%crop_dir%%%~nf.png" (
		echo cropping %preprocess_dir%%%f
		for /F "tokens=1-5 delims= " %%A in ('convert %preprocess_dir%%%f -format "0x%%[fx:int(h**0.051248)] 0x%%[fx:int(h**0.075339)] %%[fx:int(w**0.037075)]x0" info:') do convert %preprocess_dir%%%f -gravity South -chop %%A -gravity North -chop %%B -shave %%C +repage -trim +repage -shave 1x1 +repage "%crop_dir%%%~nf.png"
	) ELSE (
		for %%m in ("%preprocess_dir%%%f") do set preprocess_time=%%~tm
		for %%n in ("%crop_dir%%%~nf.png") do set crop_time=%%~tn

		set preprocess_time=!preprocess_time:~6,4!!preprocess_time:~0,2!!preprocess_time:~3,2!
		set crop_time=!crop_time:~6,4!!crop_time:~0,2!!crop_time:~3,2!

		IF !preprocess_time! GTR !crop_time! (
			echo %preprocess_dir%%%f is newer than existing file %crop_dir%%%~nf.png, re-cropping..
			for /F "tokens=1-5 delims= " %%A in ('convert %preprocess_dir%%%f -format "0x%%[fx:int(h**0.051248)] 0x%%[fx:int(h**0.075339)] %%[fx:int(w**0.037075)]x0" info:') do convert %preprocess_dir%%%f -gravity South -chop %%A -gravity North -chop %%B -shave %%C +repage -trim +repage -shave 1x1 +repage "%crop_dir%%%~nf.png"
		) ELSE (
			echo %crop_dir%%%~nf.png already exists, skipping cropping
		)
	)
)

ENDLOCAL
prompt $P$G
@echo on
