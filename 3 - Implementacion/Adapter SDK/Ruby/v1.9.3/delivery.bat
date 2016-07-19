ECHO OFF
RD /s /Q "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3"

MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3\bin"
MKDIR "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3\lib"

copy .\Adapter\src\Adapter.rb    "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3\bin"
copy .\automated.bat "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3\bin"
xcopy /s .\Adapter\lib "..\..\..\..\5 - Deployment\Delivery\v0.1\Adapter\Ruby\v1.9.3\lib"

PAUSE