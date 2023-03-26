<?php

namespace App\Helpers;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;
use App\Models\conf_colacorreos;
use App\Jobs\SendEmails;
use Config;
use DB;

class Helper{

    public static function enviarEmail($datos_enviar, $tipo_plantilla, $motivo, $codUsuarioRegistro ,$correoEnvio)
    {

        $plantilla  = "";
        if($tipo_plantilla == 'invitacion'){

            $plantilla =  'emails.invitation';
        }elseif ($tipo_plantilla == 'alerta') {
            $plantilla =  'emails.notificacion';
        }


        $conf_colacorreos                     = new conf_colacorreos;
        $conf_colacorreos->desMensaje         = view($plantilla , $datos_enviar)->render();
        $conf_colacorreos->dayFechaRegistro   = date('Y-m-d H:i:s');
        $conf_colacorreos->desMotivo          = $motivo;
        // "dayFechaEnvio" => date('Y-m-d H:i:s'),
        $conf_colacorreos->codUsuarioRegistro = $codUsuarioRegistro;
        $conf_colacorreos->desCorreoEnvio     = $correoEnvio;
        if($conf_colacorreos->save()) $mail   = true;

    }

    public static function provamos (){
        echo ">>> eentrando";
    }

}
