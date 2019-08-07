<?php  
    
    /************ CONFIGURAÇÕES DO BANCO DE DADOS ********************/
    $connect = mysqli_connect("localhost","root","081187","dbvalor02");
    
    /************ CONSULTA A TABELA NO BANCO DE DADOS ****************/
    $sql = "SELECT * FROM unidade";
    $result = mysqli_query($connect, $sql);

    /************ SALVANDO DADOS DA CONSULTA NUM ARRAY*****************/    
    $json_array = array();
    while($row = mysqli_fetch_assoc($result))
    {
        $json_array[] = $row;
    } 
    $value = $json_array;            

    /**** CONVERTENDO O ARRAY PARA O FORMATO JSON E TRATANDO ERROS ****/
    function safe_json_encode($value, $options = 0, $depth = 512){
        $encoded = json_encode($value, $options, $depth);
            switch (json_last_error()) {
            case JSON_ERROR_NONE:
                return $encoded;
            case JSON_ERROR_DEPTH:
                return 'Maximum stack depth exceeded';
            case JSON_ERROR_STATE_MISMATCH:
                return 'Underflow or the modes mismatch';
            case JSON_ERROR_CTRL_CHAR:
                return 'Unexpected control character found';
            case JSON_ERROR_SYNTAX:
                return 'Syntax error, malformed JSON';
            case JSON_ERROR_UTF8:
                $clean = utf8ize($value);
                return safe_json_encode($clean, $options, $depth);
            default:
                return 'Unknown error';
        }
    }

    /************ FUNÇÃO PARA CORRIGIR O JSON_ERROR_UTF8 *************/
    function utf8ize($mixed) {
        if (is_array($mixed)) {
            foreach ($mixed as $key => $value) {
                $mixed[$key] = utf8ize($value);
            }
        } else if (is_string ($mixed)) {
            return utf8_encode($mixed);
        }
        return $mixed;
    }
    
    /********* SALVANDO RESULTADO NA VARIÁVEL $RESULT ***********/
    $result = safe_json_encode($value);           
?>