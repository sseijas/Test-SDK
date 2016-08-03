<?php
namespace TodoPago;

class PaymentMethods extends Client\Rest {
	
	public function __construct($endpoint, $header) {
		parent::__construct("PaymentMethods", $endpoint, $header);
	}
	
	public function getAllPaymentMethods(\TodoPago\PaymentMethods\GetAllPaymentMethods $data){
		$this->setUrl("Get", $data->toArray());
		$get_status = $this->getClient();
		$paymentmethods = json_decode(json_encode($get_status), TRUE);
		$data->setResponse(new \TodoPago\PaymentMethods\GetAllPaymentMethods\Response($paymentmethods));
		return $data;
	}		
}