@echo off
cls
echo ************************************************************************
echo * QUICK AND DIRTY MICROSOFT WINDOWS SEVEN ALL-IN-ONE-INSTALLER CREATOR *
echo *                       by UncleDan 24/09/2014                         *
echo ************************************************************************
echo You will need:
echo - WAIK 3.0
echo   http://www.microsoft.com/en-us/download/details.aspx?id=5753
echo - WAIK 3.1 Supplement
echo   http://www.microsoft.com/en-us/download/details.aspx?id=5188
echo - 7-Zip
echo   http://www.7-zip.org/
echo - PATIENCE!
echo Based on:
echo - http://technet.microsoft.com/en-us/library/dd744261(v=ws.10).aspx
echo.
echo All trademarks mentioned belong to their owners; third party brands,
echo product names, trade names, corporate names and company names mentioned
echo may be trademarks of their respective owners or registered trademarks
echo of other companies and are used for purposes of explanation and to the
echo owner's benefit, without implying a violation of copyright law.
echo.
echo Copyright (c) 2014, Daniele Lolli a.k.a. UncleDan ^<uncledan@uncledan.it^>
echo.
echo Permission to use, copy, modify, and/or distribute this software
echo for any purpose with or without fee is hereby granted, provided
echo that the above copyright notice and this permission notice
echo appear in all copies.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
echo WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
echo MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
echo ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
echo WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
echo ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
echo OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE
echo.
pause

rem VARIABLES

set SOURCE32=I:\Microsoft Windows 7 Professional (i386).iso
set SOURCE64=I:\Microsoft Windows 7 Professional (amd64).iso
set DESTINATION=J:\WIN7_UNI_x86-x64
set SEVENZIPPATH=C:\Program Files\7-Zip

rem SCRIPT

echo.
echo Extracting 32-bit image...
echo.
"%SEVENZIPPATH%\7z.exe" x "%SOURCE32%" -o"%DESTINATION%"
md %DESTINATION%\temp
move %DESTINATION%\sources\install.wim  %DESTINATION%\temp\x86.wim

echo.
echo Extracting 64-bit image...
echo.
"%SEVENZIPPATH%\7z.exe" x "%SOURCE64%" -o"%DESTINATION%" install.wim -r
move %DESTINATION%\sources\install.wim  %DESTINATION%\temp\x64.wim

echo.
echo Mixing...
echo.
imagex /EXPORT "%DESTINATION%\temp\x86.wim" 5 "%DESTINATION%\sources\install.wim" "Windows 7 Ultimate x86"
imagex /EXPORT "%DESTINATION%\temp\x64.wim" 4 "%DESTINATION%\sources\install.wim" "Windows 7 Ultimate x64"
imagex /EXPORT "%DESTINATION%\temp\x86.wim" 4 "%DESTINATION%\sources\install.wim" "Windows 7 Professional x86"
imagex /EXPORT "%DESTINATION%\temp\x64.wim" 3 "%DESTINATION%\sources\install.wim" "Windows 7 Professional x64"
imagex /EXPORT "%DESTINATION%\temp\x86.wim" 3 "%DESTINATION%\sources\install.wim" "Windows 7 Home Premium x86"
imagex /EXPORT "%DESTINATION%\temp\x64.wim" 2 "%DESTINATION%\sources\install.wim" "Windows 7 Home Premium x64"
imagex /EXPORT "%DESTINATION%\temp\x86.wim" 2 "%DESTINATION%\sources\install.wim" "Windows 7 Home Basic x86"
imagex /EXPORT "%DESTINATION%\temp\x64.wim" 1 "%DESTINATION%\sources\install.wim" "Windows 7 Home Basic x64"
imagex /EXPORT "%DESTINATION%\temp\x86.wim" 1 "%DESTINATION%\sources\install.wim" "Windows 7 Starter x86"

echo.
echo Doing latest tricks...
echo.
del "%DESTINATION%\sources\ei.cfg"
del "%DESTINATION%\sources\cversion.ini"
rd /S /Q "%DESTINATION%\temp"
echo CREATED WITH:>"%DESTINATION%\readme.txt"
echo.>>"%DESTINATION%\readme.txt"
type %0>>"%DESTINATION%\readme.txt"

echo.
echo Packaging ISO image...
echo.
oscdimg -n -m -b"%DESTINATION%\boot\etfsboot.com" "%DESTINATION%" "%DESTINATION%.iso"

echo.
echo Cleaning up...
echo.
rd /S /Q %DESTINATION%

echo.
echo ALL DONE.
echo.
pause
exit
