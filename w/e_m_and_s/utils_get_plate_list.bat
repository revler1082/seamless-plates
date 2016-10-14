@echo off
set cgm_dir=%~dp0cgms\
for /F %%i in (rows.txt) do (
	set column=0
	for /F %%j in (columns.txt) do (
		IF EXIST "%cgm_dir%%%i-%%j.cgm" (
			echo %%i%%j
		)
	)
)
@echo on
