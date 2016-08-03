<?php
namespace TodoPago\BSA;

class Transactions {

	protected $generalData = array();
	protected $operationData = array();
	protected $technicalData = array();
	protected $response = array();

	private $generalDataKeys = array("merchant","security","operationDatetime","remoteIpAddress","channel");
	private $operationDataKeys = array("operationType","operationID","currencyCode","concept","amount","availablePaymentMethods","buyerPreselection");
	private $technicalDataKeys = array("pluginversion","ecommercename","ecommerceversion","cmsversion");
	private $responseKeys = array("publicRequestKey","url_HibridFormResuorces","requestKey","transactionid","channel");
	
	public function __construct($generalData, $operationData, $technicalData) {
		$this->setGeneralData($generalData);
		$this->setOperationData($operationData);
		$this->setTechnicalData($technicalData);

		$this->technicalData["sdk"] = "PHP";
		$this->technicalData["sdkversion"] = TODOPAGO_VERSION;
		$this->technicalData["lenguageversion"] = phpversion();

	}

	public function setGeneralData($generalData) {
		foreach($generalData as $key => $value) {
			if(in_array($key, $this->generalDataKeys)) {
				$this->generalData[$key] = $value;
				unset($this->generalDataKeys[array_search($key,$this->generalDataKeys)]);
			}
		}		
	}

	public function setOperationData($operationData) {
		foreach($operationData as $key => $value) {
			if(in_array($key, $this->operationDataKeys)) {
				if($key == "buyerPreselection") {
					if(!is_array($value) || (!array_key_exists("paymentMethodId", $value) && !array_key_exists("bankId", $value))) {
						continue;
					}
				}
				$this->operationData[$key] = $value;
				unset($this->operationDataKeys[array_search($key,$this->operationDataKeys)]);
			}
		}

		foreach($this->operationDataKeys as $key) {
			if(in_array($key,array("availablePaymentMethods","buyerPreselection"))) {
				unset($this->operationDataKeys[array_search($key,$this->operationDataKeys)]);
			}
		}
	}

	public function setTechnicalData($technicalData) {
		foreach($technicalData as $key => $value) {
			if(in_array($key, $this->technicalDataKeys)) {
				$this->technicalData[$key] = $value;
				unset($this->technicalDataKeys[array_search($key,$this->technicalDataKeys)]);
			}
		}
	}

	public function getGeneralData() {
		return $this->generalData;
	}

	public function getOperationData() {
		return $this->operationData;
	}

	public function getTechnicalData() {
		return $this->technicalData;
	}

	public function getResponse() {
		return $this->response;
	}

	public function setResponse($response) {
		if(isset($response["errorCode"])) {
			throw new \TodoPago\Exception\ResponseException($response["errorMessage"],$response["errorCode"]);
		} else {
			foreach($response as $key => $value) {
				if(in_array($key, $this->responseKeys)) {
					$this->response[$key] = $value;
					unset($this->responseKeys[array_search($key,$this->responseKeys)]);
				}
			}
		}
	}

	public function getData() {
		if(!empty($this->generalDataKeys)) {
			throw new \TodoPago\Exception\Data\EmptyFieldException('generalData["'.array_pop($this->generalDataKeys).'"]');
		}
				
		if(!empty($this->operationDataKeys)) {
			throw new \TodoPago\Exception\Data\EmptyFieldException('operationData["'.array_pop($this->operationDataKeys).'"]');
		}

		return array(
			"generalData" => $this->generalData,
			"operationData" => $this->operationData,
			"technicalData" => $this->technicalData
		);
	}
}