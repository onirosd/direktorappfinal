<?php

namespace App\Helpers;
use App\Models\conf_colacorreos;
use Config;

class HelperMail{

    public function enviarEmail($datos_enviar, $tipo_plantilla, $motivo, $codUsuarioRegistro ,$correoEnvio)
    {

        $plantilla  = "";
        if($tipo_plantilla == 'invitacion'){

            $plantilla =  'emails.invitation';
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

}
