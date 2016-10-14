@echo off
prompt $G

echo transparentizing scaled png files

set scale_dir=%~dp0scaled\
set transparentize_dir=%~dp0transparentized\

IF NOT EXIST "%scale_dir%" (
	echo scale directory does not exist : %scale_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%transparentize_dir%" MKDIR %transparentize_dir%

echo scale directory is %scale_dir%
echo transparentize directory is %transparentize_dir%

for /f %%f in ('dir /b "%scale_dir%*.png"') do ( 
	IF NOT EXIST "%transparentize_dir%%%~nf.png" (
		echo transparentizing %crop_dir%%%f
		convert "%scale_dir%%%f" -transparent black "%transparentize_dir%%%~nf.png"
	) ELSE (
		echo %transparentize_dir%%%~nf.png already exists, skipping transparentizing
	)
)

prompt $P$G
pause
@echo on
