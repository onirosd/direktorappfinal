<?php
namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Mail;
use App\Mail\InvitationEmail;
use App\Models\conf_colacorreos;

class SendEmails implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct()
    {

    }

    // public function handle()
    // {
    //     $correosPendientes = conf_colacorreos::whereNull('dayFechaEnvio')->get();
    //     foreach ($correosPendientes as $correo) {
    //         $correosBCC = json_decode($correo->desCorreosBCC, true);

    //         Mail::send('emails.emailTemplate', ['content' => $correo->desMensaje], function ($message) use ($correo, $correosBCC) {
    //             $message->to($correo->desCorreoEnvio);  // Correo principal
    //             $message->subject($correo->desMotivo);

    //             if (!empty($correosBCC)) {
    //                 foreach ($correosBCC as $bcc) {
    //                     $message->bcc($bcc);  // Agregar correos BCC
    //                 }
    //             }
    //         });

    //         // $correo->update(['dayFechaEnvio' => now()]);
    //         conf_colacorreos::where('codColaCorreo',$correo->codColaCorreo)->update(["dayFechaEnvio" => date('Y-m-d H:i:s')]);
    //     }
    // }


    public function handle()
    {
        $results = conf_colacorreos::whereNull('dayFechaEnvio')->get();
        foreach ($results as $mail) {
            $correosBCC = json_decode($mail->desCorreosBCC, true); // Asume que los correos BCC están almacenados en formato JSON en la columna desCorreosBCC

            // Crear una instancia del Mailable
            $email = new InvitationEmail($mail->desMensaje, $mail->desMotivo);

            // Configurar el destinatario principal y los BCC
            Mail::to($mail->desCorreoEnvio)
                ->bcc($correosBCC) // Añadir BCC si existen
                ->send($email);

            // Actualizar el registro para marcarlo como enviado
            conf_colacorreos::where('codColaCorreo', $mail->codColaCorreo)->update([
                "dayFechaEnvio" => now()
            ]);
        }
    }

    // public function handle()
    // {
    //     $results = conf_colacorreos::whereNull('dayFechaEnvio')->get();
    //     if($results){
    //         foreach ($results as $key => $mail){
    //             Mail::to($mail->desCorreoEnvio)->send(new InvitationEmail($mail->desMensaje, $mail->desMotivo));
    //             $insertMail = conf_colacorreos::where('codColaCorreo',$mail->codColaCorreo)->update([
    //                 "dayFechaEnvio" => date('Y-m-d H:i:s')
    //             ]);
    //         }
    //     }
    // }


}


?>
