@echo off
prompt $G

echo inverting scaled png files

set scale_dir=%~dp0scaled\
set invert_dir=%~dp0inverted\

IF NOT EXIST "%scale_dir%" (
	echo scale directory does not exist : %scale_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%invert_dir%" MKDIR %invert_dir%

echo scale directory is %scale_dir%
echo invert directory is %invert_dir%

for /f %%f in ('dir /b "%scale_dir%*.png"') do ( 
	IF NOT EXIST "%invert_dir%%%~nf.png" (
		echo inverting %scale_dir%%%f
		convert "%scale_dir%%%f" -negate "%invert_dir%%%~nf.png"
	) ELSE (
		echo %invert_dir%%%~nf.png already exists, skipping inversion
	)
)

prompt $P$G
pause
@echo on
