@echo off
prompt $G
SETLOCAL
SETLOCAL EnableDelayedExpansion

echo starting cgm to png conversion process

set cgm_dir=%~dp0cgms\
set convert_dir=%~dp0converted\

IF NOT EXIST "%cgm_dir%" (
	echo cgm directory does not exist : %cgm_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%convert_dir%" MKDIR %convert_dir%

echo cgm directory is %cgm_dir%
echo convert directory is %convert_dir%

for /f %%f in ('dir /b "%cgm_dir%*.cgm"') do ( 
IF NOT EXIST "%convert_dir%%%~nf.png" (
		echo converting %cgm_dir%%%f
		"C:\Program Files (x86)\TotalCADConverter\CADConverter.exe" "%cgm_dir%%%f" "%convert_dir%%%~nf.png" -kfs -c PNG -npr 0,0 -s "0 x 0" -tiffpi rgb -TM 0 -LM 0 -BM 0 -RM 0 -ps A4 -autosize True -fitpage True -pc M -PDFAuthor Softplicity -pdfver 1.4 -wmf [Tahoma,8,#080000] -wmm [10,10,10,10] 
	) ELSE (
		for %%m in ("%cgm_dir%%%f") do set cgm_time=%%~tm
		for %%n in ("%convert_dir%%%~nf.png") do set convert_time=%%~tn

		set cgm_time=!cgm_time:~6,4!!cgm_time:~0,2!!cgm_time:~3,2!
		set convert_time=!convert_time:~6,4!!convert_time:~0,2!!convert_time:~3,2!

		IF !cgm_time! GTR !convert_time! (
			echo %cgm_dir%%%f is newer than existing file %convert_dir%%%~nf.png, re-converting..
			"C:\Program Files (x86)\TotalCADConverter\CADConverter.exe" "%cgm_dir%%%f" "%convert_dir%%%~nf.png" -kfs -fo -c PNG -npr 0,0 -s "0 x 0" -tiffpi rgb -TM 0 -LM 0 -BM 0 -RM 0 -ps A4 -autosize True -fitpage True -pc M -PDFAuthor Softplicity -pdfver 1.4 -wmf [Tahoma,8,#080000] -wmm [10,10,10,10]
		) ELSE (
			echo %cgm_dir%%%f is older than %convert_dir%%%~nf.png, skipping..
		)
	)
)

ENDLOCAL
prompt $P$G
@echo on
