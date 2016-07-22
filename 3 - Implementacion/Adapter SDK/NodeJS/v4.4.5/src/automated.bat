ECHO OFF
DEL ..\..\..\Results\SDK-NodeJs\v4.4.5\Sample\*.out



node Adapter.js /c:SendAuthorizeRequest /i:..\..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\..\Results\SDK-NodeJs\v4.4.5\Sample\1_PaymentFlow.out /x:..\..\..\..\Scenarios\Sample\WS_Execute_Request.xml

PAUSE