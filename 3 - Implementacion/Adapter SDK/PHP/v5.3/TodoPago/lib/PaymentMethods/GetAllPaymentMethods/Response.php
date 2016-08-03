<?php
namespace TodoPago\PaymentMethods\GetAllPaymentMethods;

class Response extends \TodoPago\Data\AbstractData {

	protected $payment_methods;
	protected $banks;
	protected $payment_methods_banks;

	public function __construct(array $data) {
		
		$this->setOptionalFields(array(
			"payment_methods" => array(
				"name" => "Medios de Pago",
				"original" => "PaymentMethodsCollection"
			),			
			"banks" => array(
				"name" => "Bancos",
				"original" => "BanksCollection"
			),	
			"payment_methods_banks" => array(
				"name" => "Medios de Pago - Bancos",
				"original" => "PaymentMethodBanksCollection"
			),
		));
		
		parent::__construct($data);
	}
	
	public function getPayment_methods(){
		return $this->payment_methods;
	}

	public function getBanks(){
		return $this->banks;
	}

	public function getPayment_methods_banks(){
		return $this->payment_methods_banks;
	}
	
	public function toArray() {
		return array(
			"PaymentMethodsCollection" => $this->payment_methods,
			"BanksCollection" => $this->banks,
			"PaymentMethodBanksCollection" => $this->payment_methods_banks
		);
	}
}