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

        //     return "salimos con exito";
        //  print(">>> llegamos has aqiui");

          Mail::send('emails.forgetPassword', ['token' => $token], function($message) use($request){
              $message->to($request->email);
              $message->subject('Reset Password');
          });

          return "terminamos enviando";

        //   return back()->with('message', 'We have e-mailed your password reset link!');
      }

}
