@echo off
rem ================================================================================
rem Change Log
rem ================================================================================

rem Editor:         RW
rem Date:           25-09-2017
rem Changes:        Created

rem Editor:         MJ
rem Date:           09-10-2017
rem Changes:        moved adding a external to seperate function.

rem --------------------------------------------------------------------------------
rem                                     PRE ACTIONS
rem --------------------------------------------------------------------------------

setlocal enableExtensions enableDelayedExpansion

rem Save info about self
set me=%~n0
set parent=%~dp0

rem Map this location to a drive if it doesn't exist. Enables running from network.
if not exist "%~nx0" (
    SET newDriveMapped=true
	pushd "%parent%"
)

rem --------------------------------------------------------------------------------
rem                                  EXTERNAL PACKAGES
rem --------------------------------------------------------------------------------

rem interfaces
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Interfaces/trunk                         Interfaces/Shared

rem resources
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Ad5Resources/trunk                       Resources

rem standards
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/InterfaceStandard/trunk			Packages/InterfaceStandard

rem shared components
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Generic/trunk                   Packages/Generic
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/System/trunk                    Packages/System
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Drivers/trunk                   Packages/Drivers
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/ReleaseCandidates/trunk         Packages/Candidates
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/RegisterProtocol/trunk          Packages/Register
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/SerialProtocol/trunk            Packages/Serial
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Nfc/trunk                       Packages/Nfc
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/FreeRtos/trunk                  Packages/FreeRtos
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Examples/trunk                  Packages/Examples
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Message/trunk                   Packages/Message
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Processing/trunk                Packages/Processing
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/CustomWireless/trunk            Packages/CustomWireless
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/LittlevGL/trunk            		Packages/LittlevGL

rem Targets
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/CortexMx/trunk          Packages/CortexMx
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/Simulation/trunk        Packages/Simulation
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/ST/trunk                Packages/ST
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/nRF51_SDK8/trunk        Packages/nRF51_SDK8
call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/nRF52_SDK15/trunk       Packages/nRF52_SDK15
rem call :add https://svn.sallandelectronics.nl/scm/svn/SallandElectronics/Ad5/Packages/Targets/nRF91_nrfx-1.6.1/trunk  Packages/nRF91

rem AntTail specific
call :add https://svn.sallandelectronics.nl/scm/svn/AntTailMit/Packages/AntTailMitBle/trunk                  		Packages/AntTailMitBle

rem --------------------------------------------------------------------------------
rem                                        MAIN
rem --------------------------------------------------------------------------------

rem apply externals list
svn propset svn:externals -F tempExternalsList.txt %parent%

rem remove tempory list
rm tempExternalsList.txt

rem update
TortoiseProc.exe /command:update /path:"%parent%"

rem --------------------------------------------------------------------------------
rem                                      POST ACTIONS
rem --------------------------------------------------------------------------------

rem Remove mapped drive if it was mapped
if "%newDriveMapped%" == "true" popd

exit /B %errno%

rem --------------------------------------------------------------------------------
rem                                      ADD EXTERNAL
rem --------------------------------------------------------------------------------

:add

rem get parameters
set extDir=%1
set extLoc=%2

rem get head revision for external
for /f %%i in ('svn info --show-item revision %%extDir%%') do set extPeg=%%i
echo %extDir%@%extPeg%

rem add to temp file
if exist tempExternalsList.txt (
    echo %extDir%@%extPeg% %extLoc%>>tempExternalsList.txt
) else (
    echo %extDir%@%extPeg% %extLoc%>tempExternalsList.txt
)

exit /B %errno%

rem --------------------------------------------------------------------------------
rem                                         END
rem --------------------------------------------------------------------------------