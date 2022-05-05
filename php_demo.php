<?php

//тест создания сделки
$data = json_encode( array(
	'deal' => [
		'name' => 'Заявка на обратный звонок',
		'client_id' => 885071,
		'stage_id' => 65265
	]
), JSON_UNESCAPED_UNICODE );	

$url = 'https://api.pachca.com/api/shared/v1/deals';
$ch = curl_init( $url );
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt( $ch, CURLOPT_POSTFIELDS, $data );
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
	'Content-Type: application/json',
	'Content-Length: ' . strlen($data),
	'Authorization: Bearer <Token>'
)		
);
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
$result = curl_exec($ch);	
$info = curl_getinfo($ch);
print_r($info);
curl_close($ch);
print_r($result);
