@echo off
prompt $G

echo starting tiling process for labeled images

set label_dir=%~dp0labeled\
set tile_dir=\\ssaweb\projects\SeamlessMSPlates\images\w\g_m_and_s\labeled\
set zoom_level=8

IF %zoom_level% LSS 7 ( 
	echo zoom level %zoom_level% is not valid, only 7-12 available
	pause
	exit
)

set /a zoom_pow=%zoom_level%-7
set column_multiplier=1
set row_multiplier=1

IF %zoom_pow% GTR 0 (	
	FOR /L %%p IN (1,1,%zoom_pow%) DO (
		SET /A column_multiplier*=2
		SET /A row_multiplier*=2
	)
)

IF NOT EXIST "%label_dir%" (
	echo label directory does not exist : %label_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%tile_dir%" MKDIR %tile_dir%
IF NOT EXIST "%tile_dir%%zoom_level%" MKDIR %tile_dir%%zoom_level%

echo creating tile directory structure if non existant..
for /L %%a in (0,1,256) do ( IF NOT EXIST "%tile_dir%%zoom_level%\%%a" MKDIR %tile_dir%%zoom_level%\%%a )

echo label directory is %label_dir%
echo tile directory is %tile_dir%

setlocal enabledelayedexpansion

set row=0
set xoff=0
set yoff=0

for /F %%i in (%~dp0rows.txt) do (
	set column=0
	for /F %%j in (%~dp0columns.txt) do (
		
		IF NOT EXIST "%label_dir%%%i-%%j.png" (
			echo %label_dir%%%i-%%j" does not exist, continuing
		) ELSE (
			echo "%label_dir%%%i-%%j" exists, tiling from this image

			set /a xoff=!column!*column_multiplier
			set /a yoff=!row!*row_multiplier

			echo     creating level %zoom_level% zoom tiles
			convert "%label_dir%%%i-%%j.png" -scale 6.25000%% -crop 256x192 -set filename:tile "%zoom_level%\\%%[fx:page.x/256+!xoff!]\\%%[fx:page.y/192+!yoff!]" +repage +adjoin "%tile_dir%%%[filename:tile].png"
		)

		set /a column+=1
	)

	set /a row+=1
)

prompt $P$G
pause
@echo on
