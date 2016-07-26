ECHO OFF

DEL ..\..\..\Results\SDK-PHP\v5.3\Sample\*.out

php -f Adapter.php /c:PaymentFlow /i:..\..\..\..\Scenarios\Sample\Sample_01_PaymentFlow.ini /o:..\..\..\..\Results\SDK-PHP\v5.3\Sample\1_PaymentFlow.out /x:..\..\..\..\Scenarios\Sample\WS_Execute_Request.xml
PAUSE
