<?php
namespace TodoPago\Operations;

class GetByOperationId extends \TodoPago\Data\AbstractData {
	
	protected $merchant;
	protected $operationid;
	
	public function __construct(array $data) {
		$this->setRequiredFields(array(
			"merchant" => array(
				"name" => "Merchant",
				"xml" => "MERCHANT"
			), 
			"operationid" => array(
				"name" => "OperationId", 
				"xml" => "OPERATIONID"
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

	public function getOperationId(){
		return $this->operationid;
	}

	public function setOperationId($operationid){
		$this->operationid = $operationid;
	}
	
	public function getData() {
		
		$data = new \stdClass();
		$data->MERCHANT = $this->merchant;
		$data->OPERATIONID = $this->operationid;

		return $data;
	}
}