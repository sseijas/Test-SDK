<?php
namespace TodoPago;

class BSA extends Client\Rest {
	
	public function __construct($endpoint, $header) {
		parent::__construct("BSA", $endpoint, $header);
	}
	
	public function transactions(\TodoPago\BSA\Transactions $data){
		$this->url = $this->endpoint . "api/" . $this->service . "/transaction";

		$response = $this->getClient($data->getData(), "POST", array("Content-Type: application/json"));
		$data->setResponse($response);
		return $data;
	}		

	public function discover() {
		$this->url = $this->endpoint . "api/" . $this->service . "/paymentMethod/discover";
		$response = $this->getClient(array(), "GET", array("Content-Type: application/json"));

		$discover = new \TodoPago\BSA\Discover();
		foreach($response as $mp) {
			$discover->add(new \TodoPago\BSA\PaymentMethod($mp));
		}
		
		return $discover;
	}
}