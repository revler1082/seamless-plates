@echo off
prompt $G

echo starting tiling process for labeled images

set scale_dir=%~dp0scaled\
set tile_dir=\\ssaweb\projects\SeamlessMSPlates\images\s\g_m_and_s\normal\
set zoom_level=11

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

IF NOT EXIST "%scale_dir%" (
	echo scale_dir directory does not exist : %scale_dir%
	echo unable to continue
	exit
)

IF NOT EXIST "%tile_dir%" MKDIR %tile_dir%
IF NOT EXIST "%tile_dir%%zoom_level%" MKDIR %tile_dir%%zoom_level%

echo creating tile directory structure if non existant..
for /L %%a in (0,1,2048) do ( IF NOT EXIST "%tile_dir%%zoom_level%\%%a" MKDIR %tile_dir%%zoom_level%\%%a )

echo scale directory is %scale_dir%
echo tile directory is %tile_dir%

setlocal enabledelayedexpansion

set row=0
set xoff=0
set yoff=0

for /F %%i in (%~dp0rows.txt) do (
	set column=0
	for /F %%j in (%~dp0columns.txt) do (
		
		IF NOT EXIST "%scale_dir%%%j%%i.png" (
			echo %scale_dir%%%j%%i does not exist, continuing
		) ELSE (
			echo "%scale_dir%%%j%%i" exists

			set /a xoff=!column!*column_multiplier
			set /a yoff=!row!*row_multiplier

			IF NOT EXIST "%tile_dir%%zoom_level%\!xoff!\!yoff!.png" (
				echo     creating level %zoom_level% zoom tiles
				convert "%scale%%%j%%i.png" -scale 50.0000%% -crop 257x256 -set filename:tile "%zoom_level%\\%%[fx:page.x/257+!xoff!]\\%%[fx:page.y/256+!yoff!]" +repage +adjoin "%tile_dir%%%[filename:tile].png"
			) ELSE (
				for %%m in ("%scale_dir%%%j%%i.png") do set scale_time=%%~tm
				for %%n in ("%tile_dir%%zoom_level%\!xoff!\!yoff!.png") do set tile_time=%%~tn

				set scale_time=!scale_time:~6,4!!scale_time:~0,2!!scale_time:~3,2!
				set tile_time=!tile_time:~6,4!!tile_time:~0,2!!tile_time:~3,2!

				IF !scale_time! GTR !tile_time! (
					echo     %scale_dir%%%j%%i is newer than existing tile imagery
					echo     creating level %zoom_level% zoom tiles
					convert "%scale_dir%%%j%%i.png" -scale 50.0000%% -crop 257x256 -set filename:tile "%zoom_level%\\%%[fx:page.x/257+!xoff!]\\%%[fx:page.y/256+!yoff!]" +repage +adjoin "%tile_dir%%%[filename:tile].png"
				) ELSE (
					echo     tile imagery is up to date, skipping re-tiling
				)
			)
		)

		set /a column+=1
	)

	set /a row+=1
)

prompt $P$G
@echo on
