@echo off
prompt $G

echo copying cgm files to local directory

set cgm_dir=\\10.151.33.51\CGMs\Manhattan\E_M_and_S\*.cgm
set copy_dir=%~dp0cgms\

IF NOT EXIST "%cgm_dir%" (
	echo cgm directory does not exist : %cgm_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%copy_dir%" MKDIR %copy_dir%

echo cgm directory is %cgm_dir%
echo copy directory is %copy_dir%

xcopy %cgm_dir% %copy_dir% /D /y

prompt $P$G
@echo on
