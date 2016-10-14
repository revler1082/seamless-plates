@echo off
prompt $G
SETLOCAL
SETLOCAL EnableDelayedExpansion

echo preprocessing converted cgm files for crop preparation

set convert_dir=%~dp0converted\
set preprocess_dir=%~dp0preprocessed\

IF NOT EXIST "%convert_dir%" (
	echo convert directory does not exist : %convert_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%preprocess_dir%" MKDIR %preprocess_dir%

echo convert directory is %convert_dir%
echo preproces directory is %preprocess_dir%

for /f %%f in ('dir /b "%convert_dir%*.png"') do ( 
	IF NOT EXIST "%preprocess_dir%%%~nf.png" (
		echo preprocessing %convert_dir%%%f
		convert "%convert_dir%%%f" -shave 100x100 +repage -trim +repage -trim +repage "%preprocess_dir%%%~nf.png"
	) ELSE (
		for %%m in ("%convert_dir%%%f") do set convert_time=%%~tm
		for %%n in ("%preprocess_dir%%%~nf.png") do set preprocess_time=%%~tn

		set convert_time=!convert_time:~6,4!!convert_time:~0,2!!convert_time:~3,2!
		set preprocess_time=!preprocess_time:~6,4!!preprocess_time:~0,2!!preprocess_time:~3,2!

		IF !convert_time! GTR !preprocess_time! (
			echo %convert_dir%%%f is newer than existing file %preprocess_dir%%%~nf.png, re-preprocessing..
			convert "%convert_dir%%%f" -shave 100x100 +repage -trim +repage -trim +repage "%preprocess_dir%%%~nf.png"
		) ELSE (
			echo %preprocess_dir%%%~nf.png already exists, skipping preprocessing
		)
	)
)

ENDLOCAL
prompt $P$G
@echo on
