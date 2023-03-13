<?php
/**
 * User: Zura
 * Date: 12/19/2021
 * Time: 3:49 PM
 */

namespace App\Http\Controllers;


use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Testing\Fluent\Concerns\Has;
use Illuminate\Validation\Rules\Password;

/**
 * Class AuthController
 *
 * @author  Zura Sekhniashvili <zurasekhniashvili@gmail.com>
 * @package App\Http\Controllers
 */
class AuthController extends Controller
{
    public function register(Request $request)
    {
        $data = $request->validate([
            'name' => 'required|string',
            'lastname' => 'required|string',
            'celular'  => 'required|numeric',
            'nombreempresa' => 'required|string',
            'email' => 'required|email|string|unique:users,email',
            'cargo' => 'required|numeric',
            'password' => [
                'required',
                'confirmed',
                Password::min(8)->mixedCase()->numbers()->symbols()
            ]
        ],
        [
            'name.required' => ' Campo nombre requerido! ',
            'lastname.required' => ' Campo apellido requerido ! ',
            'celular.required'  => ' Campo celular requerido ! ',
            'nombreempresa.required'  => ' Campo empresa requerido ! ',
            'email.required'  => ' Campo email con errores! ',
            'cargo.required'  => ' Campo cargo con errores! ',
            'password.required'  => ' Campo cargo con errores! ',
        ]

    );

        /** @var \App\Models\User $user */
        $user = User::create([
            'name' => $data['name'],
            'lastname' => $data['lastname'],
            'celular'  => $data['celular'],
            'nombreempresa'  => $data['nombreempresa'],
            'email' => $data['email'],
            'codCargo' => $data['cargo'],
            'password' => bcrypt($data['password'])
        ]);

        $token = $user->createToken('main')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ]);
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email|string|exists:users,email',
            'password' => [
                'required',
            ],
            'remember' => 'boolean'
        ]);
        $remember = $credentials['remember'] ?? false;
        unset($credentials['remember']);

        if (!Auth::attempt($credentials, $remember)) {
            return response([
                'error' => 'Ingrese las credenciales correctas! '
            ], 422);
        }
        $user = Auth::user();
        $token = $user->createToken('main')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ]);
    }

    public function logout()
    {
        /** @var User $user */
        $user = Auth::user();
        // Revoke the token that was used to authenticate the current request...
        $user->currentAccessToken()->delete();

        return response([
            'success' => true
        ]);
    }

    public function info_person (Request $request) {
        $project = User::where('id', $request['id'])->get();

        return $project;
    }

    public function upd_person (Request $request) {
          $res = User::where('id', $request['id'])->update([
            'celular' => $request['celular'],
            'email'   => $request['email'],
            'lastname' => $request['lastname'],
            'name'     => $request['name'],
            'nombreempresa' => $request['nombreempresa'],
            'codCargo' => $request['codcargo']
          ]);

        return $res;
    }


    public function get_search_person(Request $request){
        // $data = $request->validate([
        //     'buscar' => 'required|string'
        // ]);
        $buscar_mail  = trim($request['buscar']);
        return $buscar_mail == '' ? array() :  User::select("users.id as id", "users.email as email")->where('email',$buscar_mail)->orWhere('email','like',"%{$buscar_mail}%")->get();

    }

}
