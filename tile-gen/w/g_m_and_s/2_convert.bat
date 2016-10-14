@echo off
prompt $G

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
		echo %convert_dir%%%~nf.png already exists, skipping conversion
	)
)

prompt $P$G
pause
@echo on
