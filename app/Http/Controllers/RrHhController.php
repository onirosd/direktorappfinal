<?php

namespace App\Http\Controllers;

use App\Models\RestrictionMember;
use App\Models\RrHh_IngresoPersonal; //agregado
use App\Models\RrHh_Integrantes; //agregado
use App\Models\Restriction; 
use App\Models\ProjectUser;
use App\Models\PhaseActividad;
use App\Models\PhaseActividadTrack;
use App\Models\RestrictionPerson;
use App\Models\RestrictionFront;
use App\Models\RestrictionPhase;
use App\Models\Conf_Estado;
use App\Models\Conf_MotivosRetraso;
use App\Models\Ana_TipoRestricciones;
use App\Models\Proy_AreaIntegrante;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Shared\Date;
// use Illuminate\Support\Facades\Auth;
use App\Models\User;
use DB;
use Config;
use Helper; // Important
use Carbon\Carbon;

use Illuminate\Http\Request;

class RrHhController extends Controller
{
    public function get_rrhh(Request $request) {
        $data = array();
        $query_restriction = "

        select
        ad.codProyecto , ad.codEstado , ad.dayFechaCreacion , ad.desUsuarioCreacion,
        ad.codRrHh, ad.desColOcultas, ad.desnombreproyecto , min(ad.isInvitado) as isInvitado,
        max(ad.rol) as rol

        from (
        select
        ar.*,
        pp.desNombreProyecto as desnombreproyecto,
        0 as isInvitado,
        3 as rol
        from rrhh_ingresopersonal ar
        inner join proy_proyecto pp  on ar.codProyecto  = pp.codProyecto
        where
        pp.id  =  ?

        union all

        select
        ar.*,
        pp.desNombreProyecto as desnombreproyecto,
        1 as isInvitado,
        pi2.codRolIntegrante as rol
        from rrhh_ingresopersonal ar
        inner join proy_proyecto pp  on ar.codProyecto  = pp.codProyecto
        inner join proy_integrantes pi2 on ar.codProyecto  = pi2.codProyecto
        inner join rrhh_integrantes ai on pi2.codProyIntegrante  = ai.codProyIntegrante
        where
        pi2.codEstadoInvitacion  = 1 and
        pi2.idIntegrante  = ?
        ) ad
        group BY ad.codProyecto , ad.codEstado , ad.dayFechaCreacion , ad.desUsuarioCreacion ,ad.indNoRetrasados,ad.indRetrasados,
        ad.codRrHh, ad.desColOcultas, ad.desnombreproyecto

        ";

        
        $valores      = array($request['id'],$request['id']);
        $restrictions = DB::select($query_restriction, $valores);
        $restrictions = array_map(function ($value) {
            return (array)$value;
        }, $restrictions);

        // $restrictions     = Restriction::select('anares_analisisrestricciones.*','proy_proyecto.desNombreProyecto as desnombreproyecto')
        // ->join('proy_proyecto', 'proy_proyecto.codProyecto', '=', 'anares_analisisrestricciones.codProyecto')
        // ->where('proy_proyecto.id', $request['id'])
        // ->get();

        foreach($restrictions as $eachdata) {

            $dataRestrictions = array();

            $dataRestrictions = [
                'desnombreproyecto' => $eachdata['desnombreproyecto'],
                'codProyecto'      => $eachdata['codProyecto'],
                'codEstado'        => $eachdata['codEstado'],
                'dayFechaCreacion' => $eachdata['dayFechaCreacion'],
                //'indNoRetrasados'  => $eachdata['indNoRetrasados'],
                //'indRetrasados'    => $eachdata['indRetrasados'],
                'codRrHh'        => $eachdata['codRrHh'],
                'isInvitado'       => $eachdata['isInvitado'],
                'rol'              => $eachdata['rol'],
                'integrantes'      => [],
                'integrantesProy'  => []
            ];

            // $members = RestrictionMember::where('codAnaRes', $eachdata['codAnaRes']);
            $integrantes = RrHh_Integrantes::select("rrhh_integrantes.*")
            // ->Join('proy_integrantes', function($join){
            //     $join->on('proy_integrantes.codProyIntegrante', '=', 'ana_integrantes.codProyIntegrante');
            //     $join->on('proy_integrantes.codProyecto', '=', 'ana_integrantes.codProyecto');

            // })
            ->where('rrhh_integrantes.codProyecto', $eachdata['codProyecto'])->get();

            $integrantes_Proy = ProjectUser::where('codProyecto', $eachdata['codProyecto'])->get();

            $dataIntegrantes = array();
            foreach($integrantes as $data1) {
                // $f = [
                //     'codProyecto' => $data['codProyecto'],
                //     'codAnaRes'   => $data['codAnaRes'],
                //     'codEstado'   => $data['codEstado'],
                //     'codProyIntegrante' => $data['codProyIntegrante'],
                //     'desProyIntegrante' => $data['desProyIntegrante'],
                // ];
                $dataIntegrantes[] = $data1['codProyIntegrante'];
                //array_push($dataIntegrantes, $f);
            }
            $dataRestrictions['integrantes'] = $dataIntegrantes;

            $dataIntegrantesProy = array();
            foreach($integrantes_Proy as $data2) {
                $d = [
                    'codProyIntegrante'  => $data2['codProyIntegrante'],
                    'codProyecto'        => $data2['codProyecto'],
                    'id'                 => $data2['id'],
                    'desCorreo'          => $data2['desCorreo']
                ];

                array_push($dataIntegrantesProy, $d);
            }
            $dataRestrictions['integrantesProy'] = $dataIntegrantesProy;

            array_push($data, $dataRestrictions);

        }


     return $data;

    }

    public function update_member(Request $request) {

        $restrictionid = RrHh_IngresoPersonal::where('codProyecto', $request['codProyecto'])->get('codRrHh');
        $enviar =  array();
        $enviar["mensaje"] = "";
        $enviar["estado"]  = false;

        try {

            $checkuser = RrHh_Integrantes::where('codProyecto', $request['codProyecto'])->delete();
            // print_r($request['users']);
            foreach($request['users'] as $user) {
                // print_r($user);
                //$projectuserid = ProjectUser::where('codProyecto', $request['codProyecto'])->where('desCorreo', $user)->get('codProyIntegrante');
                $restrictionmember = RrHh_Integrantes::create([
                    'codProyecto' => $request['codProyecto'],
                    'codRrHh' => $restrictionid[0]['codRrHh'],
                    'codEstado' => 1,
                    'dayFechaCreacion' => date('Y-m-d H:i:s'),
                    'desUsuarioCreacion' => '',
                    'codProyIntegrante' => (String)$user
                ]);
            }

            $enviar["estado"] = true;

        } catch (\Throwable $th) {
            $enviar["mensaje"] = "Tenemos errores y no se puede actualizar";
        }

        return $enviar;
    }

    public function update_state(Request $request) {
        //$restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar =  array();
        $enviar["mensaje"] = "";
        $enviar["estado"]  = false;

        try {

            $resultado = RrHh_IngresoPersonal::where('codProyecto',(int)$request['codProyecto'])->update([
                'codEstado' => $request['state']
            ]);

            $enviar["estado"]  = true;

        } catch (\Throwable $th) {
            $enviar["mensaje"] = "Tenemos errores y no se puede actualizar";
        }

     return $enviar;

    }

}
