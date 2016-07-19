ECHO OFF

DEL ..\..\..\..\Results\SDK-Ruby\v1.9.3\Sample\*.out

ruby Adapter.rb /c:PaymentFlow /i:..\..\..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\..\..\Results\SDK-Ruby\v1.9.3\Sample\Sample_01_PaymentFlow.out /x:..\..\..\..\..\Scenarios\Sample\WS_Execute_Request.xml
PAUSE