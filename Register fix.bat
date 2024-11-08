:: Created by: JJakaJonas
:: Created on: October 21, 2024
:: Updated on: November 8, 2024

@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\CompatMarkers" /f 2>NUL
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Shared" /f 2>NUL
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TargetVersionUpgradeExperienceIndicators" /f 2>NUL
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\HwReqChk" /f /v HwReqChkVars /t REG_MULTI_SZ /s , /d "SQ_SecureBootCapable=TRUE,SQ_SecureBootEnabled=TRUE,SQ_TpmVersion=2,SQ_RamMB=8192,"
reg.exe add "HKLM\SYSTEM\Setup\MoSetup" /f /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1