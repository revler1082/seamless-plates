@echo off
prompt $G

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
		echo %preprocess_dir%%%~nf.png already exists, skipping preprocessing
	)
)

prompt $P$G
pause
@echo on
