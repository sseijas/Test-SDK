ECHO OFF
DEL ..\out\*.out

node Adapter.js /c:SendAuthorizeRequest /I:..\..\..\_Common\Samples\Sample_01_PaymentFlow.ini /o:..\out\Sample_01_PaymentFlow.out /x:..\..\..\_Common\Samples\WS_Execute_Request.xml
PAUSE