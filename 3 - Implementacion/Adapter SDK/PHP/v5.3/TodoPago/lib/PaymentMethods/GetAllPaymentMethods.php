<?php
namespace TodoPago\PaymentMethods;

class GetAllPaymentMethods extends \TodoPago\Data\AbstractData {
	
	protected $merchant;
	
	public function __construct(array $data) {
		$this->setRequiredFields(array(
			"merchant" => array(
				"name" => "Merchant",
				"xml" => "MERCHANT",
			),
		));
		
		parent::__construct($data);

	}
	
	public function getMerchant(){
		return $this->merchant;
	}

	public function setMerchant($merchant){
		$this->merchant = $merchant;
	}
	
	public function getData() {
		
		$data = new \stdClass();
		$data->MERCHANT = $this->merchant;

		return $data;
	}
}