@echo off

title Kompilacja plik�w .sp

cls

rem Parametry
set notpause=0
if "%~1"=="-np" (
	set notpause=1
	shift
)

rem �cie�ka do kompilatora
set compiler=D:\Programy\Source Mod\1.6.4\addons\sourcemod\scripting\spcomp.exe

if not exist "%compiler%" ( echo Kompilator %compiler% nie istnieje & goto WYJSCIE )

rem �cie�ka do plik�w .inc
set include=D:\Programy\Source Mod\1.6.4\addons\sourcemod\scripting\include

rem �cie�ka do moich plik�w .inc
set my_include=E:\Documents\pluginy\sm\include

if not exist "%include%" ( echo Folder %include% nie istnieje & goto WYJSCIE )

rem Miejsce gdzie zostan� wrzucone pliki .smx
rem Zostaw tak jak jest je�li pliki .smx maj� by� w tym samym folderze co pliki .sp
rem UWAGA! Na ko�cu �cie�ki zawsze musi by� dodany znak \
rem . oznacza aktualny folder gdzie zosta� uruchomiony skrypt
set output=..\plugins\

rem Usuwanie starych log�w oraz tworzenie folderu gdzie maj� by� wrzucone pliki .smx
if exist logi.log del logi.log
if "%output%" == ".\" (
	goto KOMPILACJA
) else (
	if not exist "%output%" (
		( mkdir "%output%" && echo Folder %output% zosta� utworzony ) || ( echo Nie uda�o si� utworzy� folderu %output% & goto WYJSCIE )
	)
)

:KOMPILACJA

if %1X == X (
	goto KOMPILACJA_ALL
) else (
	goto KOMPILACJA_1
)

:KOMPILACJA_ALL

echo Rozpoczynam kompilacj� plik�w .sp

rem Przeszukanie ca�ego aktualnego folderu (sk�d zosta� uruchomiony skrypt) oraz kompilacja
for %%f in (*.sp) do (
echo *********** Plik: %%f *********** >> logi.log
"%compiler%" -i"%include%" -i"include" -i"%my_include%" -o"%output%%%f" "%%f" >> logi.log
echo ******************************************** >> logi.log
echo Plik %%f skompilowany )

goto KOMPILACJA_END

:KOMPILACJA_1

set plik=%1
for /f "useback tokens=*" %%a in ('%plik%') do set plik=%%~a

echo Kompilacja pliku %plik%
echo ****** Plik: %plik% ****** >> logi.log
"%compiler%" -i"%include%" -i"include" -i"%my_include%" -o"%plik:~0,-2%smx" "%plik%" >> logi.log

:KOMPILACJA_END

echo Kompilacja zako�czona.
echo Komunikaty z kompilacji znajduj� si� w pliku logi.log

:WYJSCIE

echo.
if %notpause% == 0 pause
