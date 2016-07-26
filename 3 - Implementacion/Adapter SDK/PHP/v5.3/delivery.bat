ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\TodoPago"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\Vendor"

copy .\src\Adapter.php "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
copy .\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
xcopy /s .\TodoPago "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\TodoPago"
xcopy /s .\vendor "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\vendor"

PAUSE
