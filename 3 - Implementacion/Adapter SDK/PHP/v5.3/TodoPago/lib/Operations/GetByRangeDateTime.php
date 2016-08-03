<?php
namespace TodoPago\Operations;

class GetByRangeDateTime extends \TodoPago\Data\AbstractData {
	
	protected $merchant;
	protected $startdate;
	protected $enddate;
	protected $pagenumber;
	
	protected $response = array();
	
	public function __construct(array $data) {
		$this->setRequiredFields(array(
			"merchant" => array(
				"name" => "Merchant",
				"xml" => "MERCHANT"
			), 
			"startdate" => array(
				"name" => "StartDate", 
				"xml" => "STARTDATE"
			), 
			"enddate" => array(
				"name" => "EndDate",
				"xml" => "ENDDATE"
			), 
			"pagenumber" => array(
				"name" => "PageNumber", 
				"xml" => "PAGENUMBER"
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

	public function getStartDate(){
		return $this->startdate;
	}

	public function setStartDate($startdate){
		$this->startdate = $startdate;
	}

	public function getEndDate(){
		return $this->enddate;
	}

	public function setEndDate($enddate){
		$this->enddate = $enddate;
	}

	public function getPageNumber(){
		return $this->pagenumber;
	}

	public function setPageNumber($pagenumber){
		$this->pagenumber = $pagenumber;
	}
	
	public function setResponse(\TodoPago\Data\AbstractData $response) {
		$this->response[] = $response;
	}

	public function getResponse() {
		$data = array();
		foreach($this->response as $res) {
			$data[] = $res->toArray();
		}
		return $data;
	}

	public function getData() {
		
		$data = new \stdClass();
		$data->MERCHANT = $this->merchant;
		$data->STARTDATE = $this->startdate;
		$data->ENDDATE = $this->enddate;
		$data->PAGENUMBER = $this->pagenumber;

		return $data;
	}
}