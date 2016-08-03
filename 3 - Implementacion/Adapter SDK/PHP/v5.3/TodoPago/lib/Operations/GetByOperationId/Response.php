<?php
namespace TodoPago\Operations\GetByOperationId;

class Response extends \TodoPago\Data\AbstractData {

	protected $resultcode;
	protected $resultmessage;
	protected $datetime;
	protected $operationid;
	protected $currencycode;
	protected $amount;
	protected $amountbuyer;
	protected $bankid;
	protected $promotionid;
	protected $type;
	protected $installmentpayments;
	protected $customeremail;
	protected $identificationtype;
	protected $identification;
	protected $cardnumber;
	protected $cardholdername;
	protected $ticketnumber;
	protected $authorizationcode;
	protected $barcode;
	protected $couponexpdate;
	protected $couponsecexpdate;
	protected $couponsubscriber;
	protected $paymentmethodcode;
	protected $paymentmethodname;
	protected $paymentmethodtype;
	protected $refunded;
	protected $pushnotifyendpoint;
	protected $pushnotifymethod;
	protected $pushnotifystates;
	protected $refunds;

	public function __construct(array $data) {
		
		$this->setOptionalFields(array(
			"resultcode" => array(
				"name" => "resultcode",
				"original" => "RESULTCODE"
			),			
			"resultmessage" => array(
				"name" => "resultmessage",
				"original" => "RESULTMESSAGE"
			),	
			"datetime" => array(
				"name" => "datetime",
				"original" => "DATETIME"
			),
			"operationid" => array(
				"name" => "operationid",
				"original" => "OPERATIONID"
			),
			"currencycode" => array(
				"name" => "currencycode",
				"original" => "CURRENCYCODE"
			),
			"amount" => array(
				"name" => "amount",
				"original" => "AMOUNT"
			),	
			"amountbuyer" => array(
				"name" => "amountbuyer",
				"original" => "AMOUNTBUYER"
			),
			"bankid" => array(
				"name" => "bankid",
				"original" => "BANKID"
			),
			"promotionid" => array(
				"name" => "promotionid",
				"original" => "PROMOTIONID"
			),
			"type" => array(
				"name" => "type",
				"original" => "TYPE"
			),
			"installmentpayments" => array(
				"name" => "installmentpayments",
				"original" => "INSTALLMENTPAYMENTS"
			),
			"customeremail" => array(
				"name" => "customeremail",
				"original" => "CUSTOMEREMAIL"
			),
			"identificationtype" => array(
				"name" => "identificationtype",
				"original" => "IDENTIFICATIONTYPE"
			),
			"identification" => array(
				"name" => "identification",
				"original" => "IDENTIFICATION"
			),
			"cardnumber" => array(
				"name" => "cardnumber",
				"original" => "CARDNUMBER"
			),
			"cardholdername" => array(
				"name" => "cardholdername",
				"original" => "CARDHOLDERNAME"
			),
			"ticketnumber" => array(
				"name" => "ticketnumber",
				"original" => "TICKETNUMBER"
			),	
			"authorizationcode" => array(
				"name" => "authorizationcode",
				"original" => "AUTHORIZATIONCODE"
			),	
			"barcode" => array(
				"name" => "barcode",
				"original" => "BARCODE"
			),	
			"couponexpdate" => array(
				"name" => "couponexpdate",
				"original" => "COUPONEXPDATE"
			),	
			"couponsecexpdate" => array(
				"name" => "couponsecexpdate",
				"original" => "COUPONSECEXPDATE"
			),	
			"couponsubscriber" => array(
				"name" => "couponsubscriber",
				"original" => "COUPONSUBSCRIBER"
			),	
			"paymentmethodcode" => array(
				"name" => "paymentmethodcode",
				"original" => "PAYMENTMETHODCODE"
			),	
			"paymentmethodname" => array(
				"name" => "paymentmethodname",
				"original" => "PAYMENTMETHODNAME"
			),	
			"paymentmethodtype" => array(
				"name" => "paymentmethodtype",
				"original" => "PAYMENTMETHODTYPE"
			),	
			"refunded" => array(
				"name" => "refunded",
				"original" => "REFUNDED"
			),	
			"pushnotifyendpoint" => array(
				"name" => "pushnotifyendpoint",
				"original" => "PUSHNOTIFYENDPOINT"
			),
			"pushnotifystates" => array(
				"name" => "pushnotifystates",
				"original" => "PUSHNOTIFYSTATES"
			),
			"pushnotifymethod" => array(
				"name" => "pushnotifymethod",
				"original" => "PUSHNOTIFYMETHOD"
			),
			"refunds" => array(
				"name" => "refunds",
				"original" => "REFUNDS"
			),
		));
		
		parent::__construct($data);
	}

	public function getResultcode(){
		return $this->resultcode;
	}

	public function getResultmessage(){
		return $this->resultmessage;
	}

	public function getDatetime(){
		return $this->datetime;
	}

	public function getOperationid(){
		return $this->operationid;
	}

	public function getCurrencycode(){
		return $this->currencycode;
	}

	public function getAmount(){
		return $this->amount;
	}

	public function getAmountbuyer(){
		return $this->amountbuyer;
	}

	public function getBankid(){
		return $this->bankid;
	}

	public function getPromotionid(){
		return $this->promotionid;
	}

	public function getType(){
		return $this->type;
	}
	
	public function getInstallmentpayments(){
		return $this->installmentpayments;
	}

	public function getCustomeremail(){
		return $this->customeremail;
	}

	public function getIdentificationtype(){
		return $this->identificationtype;
	}

	public function getIdentification(){
		return $this->identification;
	}

	public function getCardnumber(){
		return $this->cardnumber;
	}
	
	public function getCardholdername(){
		return $this->cardholdername;
	}

	public function getTicketnumber(){
		return $this->ticketnumber;
	}

	public function getAuthorizationcode(){
		return $this->authorizationcode;
	}

	public function getBarcode(){
		return $this->barcode;
	}

	public function getCouponexpdate(){
		return $this->couponexpdate;
	}

	public function getCouponsecexpdate(){
		return $this->couponsecexpdate;
	}

	public function getCouponsubscriber(){
		return $this->couponsubscriber;
	}

	public function getPaymentmethodcode(){
		return $this->paymentmethodcode;
	}

	public function getPaymentmethodname(){
		return $this->paymentmethodname;
	}

	public function getPaymentmethodtype(){
		return $this->paymentmethodtype;
	}

	public function getRefunded(){
		return $this->refunded;
	}
	
	public function getPushnotifyendpoint(){
		return $this->pushnotifyendpoint;
	}

	public function getPushnotifystates(){
		return $this->pushnotifystates;
	}
	
	public function getPushnotifymethod(){
		return $this->pushnotifymethod;
	}
	
	public function getRefunds(){
		return $this->refunds;
	}

	public function toArray() {
		return array(
			"RESULTCODE" => $this->resultcode,
			"RESULTMESSAGE" => $this->resultmessage,
			"DATETIME" => $this->datetime,
			"OPERATIONID" => $this->operationid,
			"CURRENCYCODE" => $this->currencycode,
			"AMOUNT" => $this->amount,
			"BANKID" => $this->bankid,
			"PROMOTIONID" => $this->promotionid,
			"TYPE" => $this->type,
			"INSTALLMENTPAYMENTS" => $this->installmentpayments,
			"CUSTOMEREMAIL" => $this->customeremail,
			"IDENTIFICATIONTYPE" => $this->identificationtype,
			"IDENTIFICATION" => $this->identification,
			"CARDNUMBER" => $this->cardnumber,
			"CARDHOLDERNAME" => $this->cardholdername,
			"TICKETNUMBER" => $this->ticketnumber,
			"AUTHORIZATIONCODE" => $this->authorizationcode,
			"BARCODE" => $this->barcode,
			"COUPONEXPDATE" => $this->couponexpdate,
			"COUPONSECEXPDATE" => $this->couponsecexpdate,
			"COUPONSUBSCRIBER" => $this->couponsubscriber,
			"PAYMENTMETHODCODE" => $this->paymentmethodcode,
			"PAYMENTMETHODNAME" => $this->paymentmethodname,
			"PAYMENTMETHODTYPE" => $this->paymentmethodtype,
			"REFUNDED" => $this->refunded,
			"PUSHNOTIFYENDPOINT" => $this->pushnotifyendpoint,
			"PUSHNOTIFYSTATES" => $this->pushnotifystates,
			"PUSHNOTIFYMETHOD" => $this->pushnotifymethod,
			"REFUNDS" => $this->refunds
		);
	}
}
