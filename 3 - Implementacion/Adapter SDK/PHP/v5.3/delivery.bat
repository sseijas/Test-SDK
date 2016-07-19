ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\lib"

copy .\src\Adapter.php "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
copy .\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\bin"
xcopy /s .\lib "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\PHP\v5.3\lib"

PAUSE
