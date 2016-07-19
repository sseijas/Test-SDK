ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7\lib"

copy .\src\Adapter.py "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7\bin"
copy .\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7\bin"
xcopy /s .\lib "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Python\v2.7\lib"

PAUSE
