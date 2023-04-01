<?php

namespace App\Http\Controllers;

// use App\Http\Controllers\Controller;

use Carbon\Carbon;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Mail;
use Illuminate\Support\Str;
use Hash;
use DB;
use Helper; // Important

class ForgotPasswordController extends Controller
{



      public function submitForgetPasswordForm(Request $request)
      {
          $request->validate([
              'email' => 'required|email|exists:users',
          ]);

          $token = Str::random(64);

          DB::table('password_resets')->insert([
              'email' => $request->email,
              'token' => $token,
              'created_at' => Carbon::now()
            ]);

          $datos_enviar = array();
        //   $datos_enviar['actividades']       = $actividades;
          $datos_enviar['des_correo']        = $request->email;
          $datos_enviar['des_proyecto']      = 'Testeamos';
          $datos_enviar['token       ']      = $token;
          $datos_enviar['des_link']          = Config::get('global.URL');
          $datos_enviar['des_direktor_icon'] = Config::get('global.ICON_DIREKTOR');

        Helper::enviarEmail($datos_enviar, 'recuperar', "Correo de Recuperacion de contraseña ", 0 ,$request->email);

        //     return "salimos con exito";
        //  print(">>> llegamos has aqiui");

        //   Mail::send('emails.forgetPassword', ['token' => $token], function($message) use($request){
        //       $message->to($request->email);
        //       $message->subject('Reset Password');
        //   });

          return "terminamos enviando";

        //   return back()->with('message', 'We have e-mailed your password reset link!');
      }

}
