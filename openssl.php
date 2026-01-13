<?php 
//TODO datos a cifrar
 $data= "123";
//TODO clave de cifrado
 $key="mi_key_secret";
//TODO metodo de cifrado (se puede usar 'aes-256-cbc' u otros algoritmos soportados por OpenSSL)
 $cipher="aes-256-cbc";
//TODO vector de inicializacion (IV) necesario para el crifrado
 $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length($cipher));

//  TODO: CIFRADO
$cifrado = openssl_encrypt($data,$cipher,$key,OPENSSL_RAW_DATA,$iv);
// concatenar el IV al texto cifrado
$textoCifrado = base64_encode($iv . $cifrado);
//obtener el IV del ltexto cifrado
$iv_dec = substr(base64_decode($textoCifrado), 0, openssl_cipher_iv_length($cipher));
// obtener el texto cifrado sib el IV
$cifradoSinIV = substr(base64_encode($textoCifrado), openssl_cipher_iv_length($cipher));
//  TODO: DESCIFRADO
$descifrado = openssl_decrypt($cifrado,$cipher,$key,OPENSSL_RAW_DATA,$iv);

echo "Texto cifrado: " . base64_encode($cifrado);

echo "<br> Texto descifrado: " . $descifrado;
?>