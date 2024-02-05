:: ********************************************
:: ********************************************
:: **										 **
:: **	   Local User Account Management	 **
:: **			Jimuel Servandil			 **
:: **			 BSCS 4A - AI			     **
:: **		   Operating Systems			 **
:: **										 **
:: ********************************************
:: ********************************************

:: Start
@echo off

:: Request Admin Access to avoid any error in running the program
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

title Local User Management Toolkit ^| Jimuel Servandil BSCS 4A - AI ^| #24

:: Menu Pane
:menu
	cls
	cd \
	echo.
	echo [36m                                         LL       UU   UU  MM   MM  TTTTTTTTT[0m
	echo [36m     =================================   LL       UU   UU  MMM MMM     TT     =================================[0m    
	echo [36m     =================================   LL       UU   UU  MM M MM     TT     =================================[0m   
	echo [36m                                         LL       UU   UU  MM   MM     TT[0m    
	echo [36m                                         LLLLLL    UUUUU   MM   MM     TT[0m    
	echo.
	echo                                             [93mG R E E T I N G S, User[0m
	echo               This program will help you easily manage your local users with the use of Command Line Interface.
	echo            [31mNOTE: SOME SCRIPTS ARE DESTRUCTIVE. I AM NOT RESPONSIBLE FOR ANY DAMAGE OR DATA LOSS THAT MAY OCCUR.[0m
	echo.
	
	echo  ^> Please enter the number before the task that you want to perform.
	echo.

	echo ^>^>^>^>^>^>^>^> [94mUser Management Tools[0m ^<^<^<^<^<^<^<^<
	echo   1. Show Local User Accounts
	echo   2. Create User Account
	echo   3. Delete User Account
	echo   4. Change User Password
	echo   5. Enable or Disable an Account
	
	echo.
	echo ^>^>^>^>^>^>^>^>[94m Utilities[0m ^<^<^<^<^<^<^<^<
	echo   6. Check Residual files of Deleted User Account
	echo   7. Restart to Advanced Boot Menu
	echo   8. Kill all Tasks
	echo   9. Generate Password
	echo. 
	echo   0. Exit

	set "choice="
	echo.
	set /p choice="Enter your choice (0 to exit): "
	
	IF "%choice%"=="1" goto showUsers
	IF "%choice%"=="2" goto createUser
	IF "%choice%"=="3" goto deleteUser
	IF "%choice%"=="4" goto changePass
	IF "%choice%"=="5" goto enableDisableAcct
	IF "%choice%"=="6" goto scanResidual
	IF "%choice%"=="7" goto advancedBoot
	IF "%choice%"=="8" goto killTasks
	IF "%choice%"=="9" goto passGen

	
	IF "%choice%"=="0" goto end

	echo Invalid choice. Please enter a valid option.
	pause > nul
	goto menu


:: ==================== Utility Scripts ====================

:: Close the program
:end
	echo [33mProgram Terminated...[0m
	timeout /t 2 > nul
	exit /b\
	

:: Progress Bar for processes
:progressBar
	setlocal EnableDelayedExpansion

	:: Define the progress bar variables
	set "progress="
	set "fill=[102m>[0m"
	set "total=5"

	:: Loop to update the progress bar
	for /L %%i in (1, 1, %total%) do (
		set /a "percent=%%i * 100 / %total%"
		set "progress="
		for /L %%j in (1, 1, !percent!) do (
			set "progress=!progress!!fill!"
		)
		cls
		echo Progress: [!progress!]
		echo Percent: !percent!%%
		timeout /t 1 /nobreak >nul
	)
	goto :eof


:: Exit the function; Go back to Menu
:terminated
	echo [33mYou chose to terminate the program. Press Any Key to go back to MENU...[0m
	pause > nul
	goto menu

:: Task ran successfully
:successTask
	echo [92mProgram ran successfully. Press Any Key to go back to MENU...[0m
	pause > nul
	goto menu

	
:: ==================== Function Scripts ====================


:: Restarting to Advanced Boot Menu, for troubleshooting
:advancedBoot
	cls
	echo --This script will restart your computer to Advanced Boot Menu--
	echo [31mCAUTION: This will restart your PC immediately. Please save all your work before continuing...[0m

	set /p "check=Are you sure you want to restart? (Enter Y to proceed, N to decline): "
		
		:: Perform 3 confirmations if the user wants to proceed.
		:check1																																						
		if /i "%check%"=="Y" (
			goto check2
			) else (
			goto terminated
			)

		:check2
			set /p "secondCH=Remember that we are not responsible for data loss. Proceed? (Enter YES to proceed, N to decline): "
			set "secondCH=%secondCH: =%"
			if /i "%secondCH%"=="YES" (
				goto check3
			) else (
				goto terminated
			)
		:check3	
			set /p "thirdCH=This is your last chance. Restart? (Enter CERTAIN to proceed, N to decline): "		
				set "thirdCH=%thirdCH: =%"																														
				if /i "%thirdCH%"=="CERTAIN" (
					echo Restarting the computer into Advanced Boot Menu...																								
					timeout /t 5 /nobreak > nul				
					:: /r =initiates restart, /o = restart to advanced boot options menu, /f = force apps to close. /t 0 = restart immediately
					shutdown /r /o /f /t 0																														
					)
		
		goto terminated


:: Change User Password 
:changePass
	cls
	echo --This script will change the password of the username specified by the user--
	echo [31mNOTE: YOU CANNOT CHANGE YOUR PASSWORD IN THIS SCRIPT IF YOUR ACCOUNT IS CREATED USING MICROSOFT ACCOUNT.[0m

	net user
	goto setUsername
	
	:userEmpty
		echo The username is empty. Please enter again.
		goto setUsername
	
	:setUsername
		:: Set this to avoid changing the password of the current user when we click enter without any inputs
		set "username="
		set /p "username=Enter the username to change password (Enter "0" to go back to MENU):"
		if "%username%"=="" goto userEmpty
		if "%username%"=="0" goto terminated
		goto changesPassfx
		
	:changesPassfx
	:: If username does not exist, move the error to nul, and redirect the output of net user command to findstr func., a command used for string searching, and will be used to find the username specified by user.
	net user "%username%" 2>nul | findstr /C:"User name" >nul
	:: If an error has occured
	if errorlevel 1 (
		echo User "%username%" does not exist.
		timeout /t 2 > nul
		goto setUsername
	)

	:: Syntax for changing the password
	net user %username% *
	echo Password of %username% successfully changed.

	goto successTask
	

:: Create New Local User 
:createUser
	cls
	echo What account will you create?
	echo 1. Administrator
	echo 2. Standard User
	echo 3. Enable Guest Account
	echo 0. Go back to MENU
	echo. 
	set /p "acct=Choice: "
	echo. 

	IF "%acct%"=="1" goto createAdmin
	IF "%acct%"=="2" goto createStd
	IF "%acct%"=="3" goto enableGuest
	IF "%acct%"=="0" goto terminated
	IF "%acct%" == "" (
		echo Empty Choice. 
		pause
		goto createUser
		)
	goto invalidInput
	
	:: Create an Administrator Account
	:createAdmin
		cls
		echo You will create an ADMINISTRATOR account.
		set /p "adminName=Username: "
		set /p "adminPass=Password: "
		IF "%adminName%" == "" (
			echo Empty Username. Enter Again.
			pause > nul
			goto createAdmin
		)
		net user "%adminName%" 2>nul | find /i "%adminName%" >nul
		IF %ERRORLEVEL% EQU 0 (
			echo The user "%adminName%" already exists. Enter Again.
			pause
			goto createAdmin
		)
		:: Add user account
		net user %adminName% %adminPass% /add > nul
		:: Convert account to Administrator
		net localgroup Administrators %adminName% /add >nul
		
		echo Administrator account %adminName% has been created
		goto successTask
		
	:: Create a Standard User Account	
	:createStd
		echo You will create a STANDARD USER account.
		
		echo What restrictions will you put in the standard account?
		echo 1. Normal Account (No Restrictions)
		echo 2. Account with Expiration
		echo 3. Account with Specific Time Access
		echo 0. Go back to MENU
		set /p "stdChoice= Choice: "
		IF "%stdChoice%" == "" (
			echo Empty Choice. Enter Again.
			pause > nul
			goto createStd
		)
		
		if "%stdChoice%"=="1" goto normAccount
		if "%stdChoice%"=="2" goto expStd
		if "%stdChoice%"=="3" goto timeStd
		if "%stdChoice%"=="0" goto terminated
		
		set /p "stdName= Username: "
		set /p "stdPass= Password: "
		
		
		:: Standard Account with no restrictions
		:normAccount
		cls
		echo Normal User Account Creation
		echo.

		:normAccount
		set /p "stdName= Username: "
		set /p "stdPass= Password: "

		IF "%stdName%" == "" (
			echo Empty Username. Enter Again.
			pause > nul
			goto normAccount
		)

		REM Check if the user exists
		net user "%stdName%" 2>nul | find /i "%stdName%" >nul
		IF %ERRORLEVEL% EQU 0 (
			echo The user "%stdName%" already exists. Enter Again.
			pause
			goto normAccount
		) ELSE (
			net user %stdName% %stdPass% /add /EXPIRES:NEVER /ACTIVE:YES > nul
			echo Standard Account [92m%stdName%[0m has been created. 
			goto successTask
		)


		:: Standard Account that can only be accessed until a specified date
		:expStd
			cls
			echo -- Set Expiration Date for a User Account --
			set /p "stdName=Enter the Username: "
			set /p "stdPass=Enter the Password: "
			IF "%stdName%" == "" (
				echo Empty Username. Enter Again.
				pause > nul
				goto expStd
			)
			REM Check if the user exists

			net user "%stdName%" 2>nul | find /i "%stdName%" >nul
			IF %ERRORLEVEL% EQU 0 (
				echo The user "%stdName%" already exists. Enter Again.
				pause
				goto expStd
			) ELSE (
				goto expFx
			)
			
			net user "%stdName%" | findstr /i /c:"User name" > nul
			:expFx
				:: Add the user account
				net user %stdName% %stdPass% /add /EXPIRES:NEVER /ACTIVE:YES > nul
				echo Standard Account [92m%stdName%[0m has been created. 
				
				:: Check if the user account was successfully created
				net user "%stdName%" 2>nul | find /i /c "The command completed successfully" >nul
				if not errorlevel 1 (
					:getDateInput
						set /p "dd=Enter Expiration Day (dd): "
						set /p "mm=Enter Expiration Month (mm): "
						set /p "yyyy=Enter Expiration Year (yyyy): "
						goto applyExp
					
					:: Set the expiry date
					:applyExp
						echo Setting expiration date for user "%stdName%" to %dd%/%mm%/%yyyy%...
						:: Set the expiration date using mm-dd-yyyy format
						net user %stdName% /EXPIRES:%dd%-%mm%-%yyyy% > nul
						
					:: Check if setting expiration date was successful
					if errorlevel == 1 goto getDateInput
					
					echo Standard Account [92m%stdName%[0m has been created. 
					echo Expiration date for user "%stdName%" has been set to %dd%/%mm%/%yyyy%.
					goto successTask
			
					)
				) else (
					echo Failed to create the user "%stdName%" or it is an invalid username/password.
					echo Please enter a valid username and password.
					goto expStd
				)
			

		:: Standard account which can only be accessed during a specified time on a specified day
		:timeStd
			cls
			echo This script will set time-based logon restrictions for a user account.
			set /p "stdName=Username: "
			set /p "stdPass=Password: "
			IF "%stdName%" == "" (
				echo Empty Username. Enter Again.
				pause > nul
				goto timeStd
			)
			net user "%stdName%" 2>nul | find /i "%stdName%" >nul
			IF %ERRORLEVEL% EQU 0 (
				echo The user "%stdName%" already exists. Enter Again.
				pause
				goto timeStd
			) ELSE (
				goto timeFx
			)
		
			:timeFx
			:: Create Account
			net user %stdName% %stdPass% /add /EXPIRES:NEVER /ACTIVE:YES > nul

			:: Check if the entered user exists
			net user "%stdName%" 2>nul | find /i /c "The command completed successfully" >nul
			
			if not errorlevel 1 (
				:getTimeInput
					echo If you want to specify the days the user can log in, please refer to this:
					echo M = Monday
					echo Tu = Tuesday
					echo W = Wednesday
					echo Th = Thursday
					echo F = Friday
					echo S = Saturday
					echo Su = Sunday
					echo.
					set /p "dys=Enter Days (If multiple days, enter the letter separated by comma, without space): "
					
					echo NOTE: Use 24-hour format.
					set /p "st=Start Time (HH:MM): "
					set /p "et=End Time (HH:MM): "
					goto applyTime
					
					
				:: Set the time and day
				:applyTime
					:: Set the expiration date using mm-dd-yyyy format
					net user %stdName% /time:%dys%,%st%-%et%

				:: Check if setting expiration date was successful
				if errorlevel == 1 goto getTimeInput
				
				echo Expiration date for user "%stdName%" has been set to %dys% of %st%-%et%.
				goto successTask
				)
			) else (
				echo Failed to create the user "%stdName%" or it is an invalid username/password.
				echo Please enter a valid username and password.
				goto timeStd
			)


	:: Delete Local User Account; THIS SCRIPT IS DESTRUCTIVE
	:deleteUser
		cls
		echo --This script will remove the user specified by the user
		echo [101;93mCAUTION: This script is destructive. Data might NOT be recovered. Please think carefully before proceeding[0m

		set /p "check=Are you sure you want to proceed? (Enter Y to proceed, N to decline): "
		
		:: Perform 3 confirmations if the user wants to proceed.
		:mcheck1																																						
		if /i "%check%"=="Y" (
			goto mcheck2
			) else (
			goto terminated
			)

		:mcheck2
			set /p "secondCH=Remember that we are not responsible for data loss. Proceed? (Enter YES to proceed, N to decline): "
			set "secondCH=%secondCH: =%"
			if /i "%secondCH%"=="YES" (
				echo Here is the list of users on this machine...
				echo.
				timeout /t 1 > nul
				::Display list of User Accounts
				net user
				goto delUserfx
				
			) else (
				goto terminated
				)
	
		:: Deletion Function
		:delUserfx
			:getUserInput
			set /p "delUser=Enter the username you want to delete (Enter '0' to go back to MENU): "

			if "%delUser%"=="0" goto menu
			IF "%delUser%" == "" (
				echo Empty Username. Enter Again.
				pause > nul
				goto getUserInput
			)

			:: Check if the entered user exists
			net user %delUser% 2>nul | find /i /c "The command completed successfully" >nul
			if not errorlevel 1 (
				echo This is the information about the user [32m%delUser%[0m
				net user %delUser%
				goto mcheck3
			) else (
				echo The user "%delUser%" does not exist or is an invalid username.
				echo Please enter a valid username.
				goto getUserInput
			)

		:mcheck3	
			:: Last check for confirmation
			set /p "thirdCH= [101;93mThis is your last chance. Delete the Account? (Enter CERTAIN to proceed, N to decline): [0m"		
				set "thirdCH=%thirdCH: =%"		
		
				if /i "%thirdCH%"=="0" goto menu (
				
				if /i "%thirdCH%"=="CERTAIN" (
					net user %delUser% /delete
					call :progressBar
					goto askScan
				)
				echo Invalid Input. Deletion Completed. 
				goto successTask
				
				:askScan
					set /p "scanRes=Do you want to scan for residual files? (Y or N): "
					if /i "%scanRes%"=="Y" goto delDef 
		goto terminated


:: Scan for residual files of deleted user account
:scanResidual
	cls
	echo ^> This script will scan for residual files of the deleted user. 
	timeout /t 1 > nul
	echo This may take some time...
	dir C:\Users
	timeout /t 2 > nul
		
	:: Cleaning Function
	:askDel
	set /p "delUser=Enter the Username (Enter 0 to cancel): "
	if "%delUser%"=="" (
		echo No username provided. Enter again.
		goto askDel
	)
	if "%delUser%"=="0" goto terminated

		:: Check if User folder exists
		:: Reused this function to scan for deleted accounts on delete accounts function
		:delDef
		set "userFolder=C:/Users/%delUser%"
		if exist "%userFolder%" (
			echo Residual files found in the user's folder:
			dir /p "%userFolder%"
			goto askConfirm
		) else (
			echo User not found.
			goto scanend
		)
			:: Ask for user confirmation before deleting the folder
			:askConfirm
			set /p "scanChoice=Do you want to delete the user folder %delUser% and its contents? (Y/N)"
			if /i "%scanChoice%"=="Y" goto confirmationresidual
			if /i "%scanchoice%"=="N" goto retainRes
			goto terminated
			
			:confirmationresidual
				set /p "check=Are you sure you want to [101mDELETE[0m the residual files? (Enter YES to proceed, N to decline): "
				if %check% == "YES" goto deleteRes
			
				:: Deletion function for scanning residuals
				:deleteRes
				echo Deleting user folder %delUser% and its contents...
				timeout /t 3 > nul
				rd /s /q "%userFolder%"

				if exist "%userFolder%" (
					echo.
					echo Failed to delete user folder %delUser% because some files are in use.
					echo Please ensure no programs are using files within the folder and try again.
					goto scanend
				) else (
					echo User folder %delUser% deleted successfully.
					goto scanend
				)
				
				:: User did not proceed to deletion
				:retainRes
				echo User chose not to delete the folder. Exiting...
				pause
				goto menu
		
		:: Scanning completed
		:scanend
		echo Residual file scanning complete.
		goto successTask
		

:enableGuest
	echo Enabling the Guest account...
	net user guest /active:yes

	echo Guest account has been enabled.
	goto successTask
		

:: Kill all Active tasks
:killTasks
	cls 
	echo.
	echo [92mHere are the tasks currently running...[0m
	timeout /t 2 > nul
	
	:: Locate script directory
	set "script_dir=%~dp0"
	
	:: Create tasklist file
	tasklist > "%script_dir%list.txt"
	
	:: Display tasklist
	type "%script_dir%list.txt" | more
	pause
	
	:: remove tasklist file
	del %script_dir%list.txt
	
	echo.
	echo [101mCAUTION: This will terminate all your tasks EXCEPT this window. Please save all your work before continuing...[0m
	set /p "check=Are you sure you want to KILL ALL tasks? (Enter Y to proceed, N to decline): "

	:check1
	if /i "%check%"=="Y" (
		goto check2
		) else (
		goto terminated
		)

	:check2
		set /p "secondCH=Remember that we are not responsible for data loss. Proceed? (Enter YES to proceed, N to decline): "
		set "secondCH=%secondCH: =%"
		if /i "%secondCH%"=="YES" (
			goto check3
		) else (
			goto terminated
		)
	:check3
		set /p "thirdCH=This is your last chance. KILL ALL TASKS? (Enter CERTAIN to proceed, N to decline): "
			set "thirdCH=%thirdCH: =%"
			if /i "%thirdCH%"=="CERTAIN" (
				echo closing all programs...
				call captcha
				:: Kill all tasks, restart Windows Explorer
				taskkill /f /t /im explorer.exe
				start explorer.exe
				)
	
	goto successTask
		

:: Generate Passwords
:passGen
	cls
	echo --This script will generate a random password and store it in a file--
	echo off

	:: Generate a random password
	
	:: allows variables to be expanded at execution time within loops or blocks
	setlocal EnableDelayedExpansion
	set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.()?!"
	set "password="
	set /a length=12

	for /l %%i in (1,1,%length%) do (
		set /a index=!random! %% 71
		for %%a in (!index!) do set "password=!password!!chars:~%%a,1!"
	)

	:: Ask user what the password is for
	set /p purpose="Enter the purpose for this password: "

	set "batchDir=%~dp0"
	
	:: Set to .dat file to avoid direct access to password list
	set "file=%batchDir%\Qbttxpse.dat"

	rem Check if the file exists
	if not exist "%file%" (
		echo ====This is your list of Passwords==== > "%file%"
	)

	echo Purpose: %purpose% >> "%file%"
	echo Password: %password% >> "%file%"
	echo. >> "%file%"

	echo Password Generated: %password%
	echo Password generated and saved to %file%
	pause

	echo.
	set /p open="Do you want to open the password list? (Y/N): "
	if /i "%open%" == "Y" (
		echo Opening Password List...
		type "%file%"
		goto successTask
	) else (
		echo You chose not to open the password list. Going back to MENU...
		timeout /t 2 > nul
		goto menu
	)

:: Enable or Disable a Local Account
:enableDisableAcct
	cls
	echo This script will enable or disable a user account.
	net users
	set "username="
	set /p "userName=Enter the username you want to modify (or type '0' to quit): "

	if /i "%userName%"=="0" (
		echo Exiting the script.
		goto terminated
	)
	
	if /i "%userName%"=="" (
		echo Empty Username. Please Enter Again.
		pause
		goto enableDisableAcct
	)

	:: Check if the entered user exists
	net user "%userName%" 2>nul | find /i /c "The command completed successfully" > nul
	if not errorlevel 1 (
		net user "%userName%" >nul | find /i "Account active               Yes" >nul
		if errorlevel 1 (
			goto disableAccount
		) else (
			goto enableAccount
		)
	) else (
		echo The user "%userName%" does not exist or is an invalid username.
		echo Please enter a valid username.
		pause
		goto enableDisableAcct
	)
	:disableAccount
	echo The account "%userName%" is currently disabled.
	set /p "action=Do you want to enable this account? (Yes/No): 
		if /i "%action%"=="Yes" (
			net user "%userName%" /active:yes
			echo User account "%userName%" has been enabled.
		) else (
			echo No changes have been made to the account "%userName%".
		)
		goto successTask
		

	:enableAccount
		echo The account "%userName%" is currently enabled.
		set /p "action=Do you want to disable this account? (Yes/No): "

		if /i "%action%"=="Yes" (
			net user "%userName%" /active:no
			echo User account "%userName%" has been disabled.
		) else (
			echo No changes have been made to the account "%userName%".
		)
		goto successTask
		
:: Show Users
:showUsers
	cls
	net users
	goto successTask
		
goto end