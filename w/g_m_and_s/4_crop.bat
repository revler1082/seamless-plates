@echo off
prompt $G

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
		for /F "tokens=1-5 delims= " %%A in ('convert %preprocess_dir%%%f -format "0x%%[fx:int(h**0.0411554)] 0x%%[fx:int(h**0.062372)] %%[fx:int(w**0.02981244)]x0" info:') do convert %preprocess_dir%%%f -gravity South -chop %%A -gravity North -chop %%B -shave %%C +repage -trim +repage -shave 1x1 +repage "%crop_dir%%%~nf.png"
	) ELSE (
		echo %crop_dir%%%~nf.png already exists, skipping cropping
	)
)

prompt $P$G
pause
@echo on

