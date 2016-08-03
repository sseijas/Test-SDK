<?php
namespace TodoPago;

class Operations extends Client\Rest {
	
	public function __construct($endpoint, $header) {
		parent::__construct("Operations", $endpoint, $header);
	}
	
	public function getByOperationId(\TodoPago\Operations\GetByOperationId $data){
		$this->setUrl("GetByOperationId", $data->toArray());
		$get_status = $this->getClient();

		$operations = json_decode(json_encode($get_status), TRUE);
		if(empty($operations))
			throw new \TodoPago\Exception\TodoPagoException("Transaccion Inexistente",404);
		else if(isset($operations["Status"]))
			throw new \TodoPago\Exception\TodoPagoException($operations["Status"]);
		$data->setResponse(new \TodoPago\Operations\GetByOperationId\Response($operations['Operations']));
		return $data;
	}

	public function getByRangeDateTime(\TodoPago\Operations\GetByRangeDateTime $data) {
		$this->setUrl("GetByRangeDateTime", $data->toArray());
		$get_status = $this->getClient();
		$operations = json_decode(json_encode($get_status), TRUE);
		if(empty($operations))
			throw new \TodoPago\Exception\TodoPagoException("Transaccion Inexistente",404);
		else if(isset($operations["Status"]))
			throw new \TodoPago\Exception\TodoPagoException($operations["Status"]);
		foreach($operations as $op) {
			$data->setResponse(new \TodoPago\Operations\GetByOperationId\Response($op));
		}
		return $data;
	}	
}