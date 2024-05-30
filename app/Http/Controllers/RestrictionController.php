<?php

namespace App\Http\Controllers;
use App\Models\RestrictionMember;
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
use Illuminate\Http\Request;
use DB;
use Config;
use Helper; // Important
use Carbon\Carbon;

class RestrictionController extends Controller
{

    public function get_date_dummy(Request $request){

        return array("nada", 1);
    }

    public function get_week_restrictions_by_date(Request $request){

        $fecha                   = $request['fecha'];
        $proyecto                = $request['codProyecto'];
        $coduser                 = $request['codUser'];
        $flgtodo                 = $request['flgtodo'];

        $defaultodo              = $flgtodo == false ? '0' : '1';

        $PR_restriccionesxproyectofecha =  "call PR_restriccionesxproyectofecha('".$fecha."',".$proyecto.",".$coduser.",".$defaultodo.")";
        $enviar                  = array();
        $query                   = "
                                    SELECT
                                        codEstado as value,
                                        desEstado as label,
                                        iconColor
                                    FROM conf_estado
                                    WHERE desModulo = 'ANARES'

                                    ";

        $datos_estado            = DB::select($query);
        $datos_estado            = array_map(function ($value) {
            return (array)$value;
        }, $datos_estado);


        $datos_motivosrestraso   = Conf_MotivosRetraso::all(); //  Conf_Estado::where('desModulo', 'ANARES')->get();
        $data_fecha              = DB::select("call PR_obtenerInfoSemana(?)", [$fecha]);
        $data_calendario         = DB::select($PR_restriccionesxproyectofecha);

        // $enviar['fechaActual']  = $data_fecha[0]['fechaActual'];
        $enviar['fechaFin']                 = $data_fecha[0]->fechaFin;
        $enviar['fechaIni']                 = $data_fecha[0]->fechaIni;
        $enviar['fechaActual']              = $data_fecha[0]->fechaActual;
        $enviar['numSemana']                = $data_fecha[0]->numSemana;
        $enviar['isSemanaActual']           = $data_fecha[0]->isSemanaActual;

        // $enviar['nada']                    ='asasa';
        $enviar['listaData']                = $data_calendario;
        $enviar['listaEstados']             = $datos_estado;
        $enviar['listaMotivos']             = $datos_motivosrestraso;
        // $enviar['listaestados']       = $datos_estado;
        // $enviar['listaData'] = $data_calendario;

        return $enviar;
    }

    public function get_restriction(Request $request) {
        $data = array();
        $query_restriction = "

        select fin.*,
        (
            select count(1) from anares_actividad aa
            where
            (aa.codEstadoActividad  < 3 and aa.dayFechaConciliada < DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '-05:00'), '%Y-%m-%d 00:00:00'))

            and aa.codProyecto  = fin.codProyecto
         ) as indRetrasados,
         (
            select count(1) from anares_actividad aa
            where
            (aa.codEstadoActividad  < 3 and aa.dayFechaConciliada > DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '-05:00'), '%Y-%m-%d 00:00:00'))

            and aa.codProyecto  = fin.codProyecto
         ) as indNoRetrasados

        from (
        select
        ad.codProyecto , ad.codEstado , ad.dayFechaCreacion , ad.desUsuarioCreacion,
        ad.codAnaRes, ad.desColOcultas, ad.desnombreproyecto , min(ad.isInvitado) as isInvitado,
        max(ad.rol) as rol

        from (
        select
        ar.*,
        pp.desNombreProyecto as desnombreproyecto,
        0 as isInvitado,
        3 as rol
        from anares_analisisrestricciones  ar
        inner join proy_proyecto pp  on ar.codProyecto  = pp.codProyecto
        where
        pp.id  =  ?

        union all

        select
        ar.*,
        pp.desNombreProyecto as desnombreproyecto,
        1 as isInvitado,
        pi2.codRolIntegrante as rol
        from anares_analisisrestricciones  ar
        inner join proy_proyecto pp  on ar.codProyecto  = pp.codProyecto
        inner join proy_integrantes pi2 on ar.codProyecto  = pi2.codProyecto
        inner join ana_integrantes ai on pi2.codProyIntegrante  = ai.codProyIntegrante
        where
        pi2.codEstadoInvitacion  = 1 and
        pi2.idIntegrante  = ?
        ) ad
        group BY ad.codProyecto , ad.codEstado , ad.dayFechaCreacion , ad.desUsuarioCreacion ,ad.indNoRetrasados,ad.indRetrasados,
        ad.codAnaRes, ad.desColOcultas, ad.desnombreproyecto
        ) fin

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
                'indNoRetrasados'  => $eachdata['indNoRetrasados'],
                'indRetrasados'    => $eachdata['indRetrasados'],
                'codAnaRes'        => $eachdata['codAnaRes'],
                'isInvitado'       => $eachdata['isInvitado'],
                'rol'              => $eachdata['rol'],
                'integrantes'      => [],
                'integrantesProy'  => []
            ];

            // $members = RestrictionMember::where('codAnaRes', $eachdata['codAnaRes']);
            $integrantes = RestrictionMember::select("ana_integrantes.*")
            // ->Join('proy_integrantes', function($join){
            //     $join->on('proy_integrantes.codProyIntegrante', '=', 'ana_integrantes.codProyIntegrante');
            //     $join->on('proy_integrantes.codProyecto', '=', 'ana_integrantes.codProyecto');

            // })
            ->where('ana_integrantes.codProyecto', $eachdata['codProyecto'])->get();

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

    public function upd_numOrden(Request $request) {
        //$restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar =  array();
        $enviar["mensaje"] = "";
        $enviar["estado"]  = false;

        try {

            foreach($request['data'] as $info) {

                $resultado1 = PhaseActividad::where('codProyecto',(int)$request['codProyecto'])
                ->where('codAnaResActividad', $info['codAnaResActividad'])
                ->update([
                    'numOrden' =>  $info['index']
                ]);

            }

            $enviar["estado"]  = true;

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

            $resultado = Restriction::where('codProyecto',(int)$request['codProyecto'])->update([
                'codEstado' => $request['state']
            ]);

            $enviar["estado"]  = true;

        } catch (\Throwable $th) {
            $enviar["mensaje"] = "Tenemos errores y no se puede actualizar";
        }

     return $enviar;

    }
    public function update_state_restriction_with_retraso(Request $request) {
        //$restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar            = array();
        $enviar["mensaje"] = "Se actualizo con exito el registro.";
        $enviar["estado"]  = false;

        $rolProyecto             = $request['rol_proyecto'];
        $codrestriccion          = $request['cod_restriccion'];
        $codestado               = $request['cod_estado'];
        $cod_proyecto            = $request['cod_proyecto'];
        $cod_motivo_retraso      = $request['cod_motivo_retraso'];
        $des_motivo_retraso      = $request['desc_motivo_retraso'];
        $user_id                 = $request['user_id'];

        // los usuarios que tengan rol como cliente, siempre tendran que justificar la
        // tardanza de sus actividades

        $flag_cliente            = $rolProyecto == 8 ? 1: 0;
        $codestado               = $flag_cliente == 1 ? 4 : $codestado;

        try {

            $actividad    = PhaseActividad::find($codrestriccion);
            $dataTracking = PhaseActividadTrack::insertGetId([
                'codAnaResActividad'   => $codrestriccion,
                'codProyecto'          => $cod_proyecto,
                'codEstadoActividadInicial' => $actividad->codEstadoActividad,
                'codEstadoActividadFinal'   =>  $codestado,
                // 'codEstadoActividad'   => $codestado,
                'codRetrasoMotivo'     => $cod_motivo_retraso,
                'desRetrasoComentario' => $des_motivo_retraso,
                // 'codEstadoAprobacion'  => 0,
                // 'flagUseAprobacion'    => 0,
                'dayFechaCreacion' => date('Y-m-d H:i:s'),
                'desUsuarioCreacion' => '',
                'codUsuarioCreacion' => $user_id,
                'flagRetrasoAprobacion' => $flag_cliente == 1 ? 1 : -1,
                'codEstadoAprobacion' => $flag_cliente == 1 ? 0 : -1,
                'codUsuarioAprobacion' => -1
                // 'codProyIntegrante' => (String)$user
            ]);
            // $trackdata->dayfec   = date('Y-m-d H:i:s');
            $resultado = PhaseActividad::where('codProyecto',(int)$cod_proyecto)
            ->where('codAnaResActividad', $codrestriccion)
            ->update([
                'codEstadoActividad'          => $codestado,
                'codAnaResActividadTrackLast' => $dataTracking,
                'dayFechaLevantamiento'       => date('Y-m-d H:i:s')
            ]);

            $enviar["estado"]         = true;
            $enviar["estadoCambiado"] = $codestado;

            } catch (\Throwable $th) {

            $enviar["mensaje"] = "No se puede actualizar el registro , recargue la pagina.";
        }

     return $enviar;

    }
    public function update_state_restriction(Request $request) {
        //$restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar            = array();
        $enviar["mensaje"] = "Se actualizo con exito el registro.";
        $enviar["estado"]  = false;


        $codrestriccion    = $request['cod_restriccion'];
        $codestado         = $request['cod_estado'];
        $cod_proyecto      = $request['cod_proyecto'];
        $user_id           = $request['user_id'];

        try {


            // $dataTracking = PhaseActividadTrack::insertGetId([
            //     'codAnaResActividad'   => $codrestriccion,
            //     'codProyecto'          => $cod_proyecto,
            //     'codEstadoActividad'   => $codestado,
            //     'codRetrasoMotivo'     => 0,
            //     'desRetrasoComentario' => "",
            //     'codEstadoAprobacion'  => 0,
            //     'flagUseAprobacion'    => 0,
            //     'dayFechaCreacion' => date('Y-m-d H:i:s'),
            //     'desUsuarioCreacion' => '',
            //     'codUsuarioCreacion' => $user_id
            //     // 'codProyIntegrante' => (String)$user
            // ]);
            $actividad    = PhaseActividad::find($codrestriccion);
            $dataTracking = PhaseActividadTrack::insertGetId([
                'codAnaResActividad'   => $codrestriccion,
                'codProyecto'          => $cod_proyecto,
                'codEstadoActividadInicial' => $actividad->codEstadoActividad,
                'codEstadoActividadFinal'   =>  $codestado,
                // 'codEstadoActividad'   => $codestado,
                'codRetrasoMotivo'     => -1,
                'desRetrasoComentario' => '',
                // 'codEstadoAprobacion'  => 0,
                // 'flagUseAprobacion'    => 0,
                'dayFechaCreacion' => date('Y-m-d H:i:s'),
                'desUsuarioCreacion' => '',
                'codUsuarioCreacion' => $user_id,
                'flagRetrasoAprobacion' => -1,
                'codEstadoAprobacion' => -1,
                'codUsuarioAprobacion' => -1
                // 'codProyIntegrante' => (String)$user
            ]);

            $resultado = PhaseActividad::where('codProyecto',(int)$cod_proyecto)
            ->where('codAnaResActividad', $codrestriccion)
            ->update([
                'codEstadoActividad'          => $codestado,
                'codAnaResActividadTrackLast' => $dataTracking
            ]);

            $enviar["estado"]  = true;

            } catch (\Exception $e) {

            $enviar["mensaje"] = "No se puede actualizar el registro , recargue la pagina.";
            $enviar["error"]   = $e;
        }

     return $enviar;

    }
    public function update_hidden(Request $request) {
        //$restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar =  array();
        $enviar["mensaje"] = "";
        $enviar["estado"]  = false;

        try {

            $resultado = Restriction::where('codProyecto',(int)$request['codProyecto'])->update([
                'desColOcultas' => trim($request['hidecolumns']) == "" ? " " : $request['hidecolumns']
            ]);

            $enviar["estado"]  = true;

        } catch (\Throwable $th) {
            $enviar["mensaje"] = "Tenemos errores y no se puede actualizar";
        }

     return $enviar;

    }
    public function update_member(Request $request) {

        $restrictionid = Restriction::where('codProyecto', $request['codProyecto'])->get('codAnaRes');
        $enviar =  array();
        $enviar["mensaje"] = "";
        $enviar["estado"]  = false;

        try {

            $checkuser = RestrictionMember::where('codProyecto', $request['codProyecto'])->delete();
            // print_r($request['users']);
            foreach($request['users'] as $user) {
                // print_r($user);
                //$projectuserid = ProjectUser::where('codProyecto', $request['codProyecto'])->where('desCorreo', $user)->get('codProyIntegrante');
                $restrictionmember = RestrictionMember::create([
                    'codProyecto' => $request['codProyecto'],
                    'codAnaRes' => $restrictionid[0]['codAnaRes'],
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
    public function add_front(Request $request) {
        $codAnaRes = Restriction::where('codProyecto', $request['id'])->get('codAnaRes');
        $resFrente = RestrictionFront::insertGetId([
            'desAnaResFrente' => $request['name'],
            'dayFechaCreacion' => $request['date'],
            'desUsuarioCreacion' => '',
            'codProyecto' => $request['id'],
            'codAnaRes' => $codAnaRes[0]['codAnaRes'],
        ]);
        $enviar = array();
        $enviar["codFrente"] = $resFrente;
        return $enviar;
    }

    public function add_phase(Request $request) {
        $codAnaRes = Restriction::where('codProyecto', $request['projectid'])->get('codAnaRes');
        $resFase  = RestrictionPhase::insertGetId([
            'desAnaResFase' => $request['name'],
            'dayFechaCreacion' => $request['date'],
            'desUsuarioCreacion' => '',
            'codAnaResFrente' => $request['frontid'],
            'codProyecto' => $request['projectid'],
            'codAnaRes' => $codAnaRes[0]['codAnaRes'],
        ]);
        $enviar = array();
        $enviar["codFase"] = $resFase;
        return $enviar;
    }

    /* DEPRECADO !! */
    public function add_Actividad(Request $request) {
        $codAnaRes = Restriction::where('codProyecto', $request['projectid'])->get('codAnaRes');

        $resFront = PhaseActividad::create([
            'desActividad' => $request['name'],
            'desRestriccion' => "",
            'codTipoRestriccion' => 0,
            'dayFechaRequerida' => $request['date'],
            // 'idUsuarioResponsable' => 'Lizeth Marzano',
            // 'desAreaResponsable' => 'Lizeth Marzano',
            // 'codEstadoActividad' => 'En proceso',
            // 'codUsuarioSolicitante' => 'Lizeth Marzano',
            'codAnaResFase' => $request['phaseid'],
            'codAnaResFrente' => $request['frontid'],
            'codProyecto' => $request['projectid'],
            'codAnaRes' => $codAnaRes[0]['codAnaRes'],
        ]);
        return $request;
    }

    public function cron_enviar_notificacionDiaria(){
        $query_proyectos_retrasados = "


            select pp.codProyecto , pp.desNombreProyecto as desproyecto
            from  proy_proyecto pp
            where
            pp.codEstado   = 0 and
            (
                        select count(1) from anares_actividad aa
                        where
                        (aa.codEstadoActividad  < 3 and aa.dayFechaConciliada < DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '-05:00'), '%Y-%m-%d 00:00:00'))

                        and aa.codProyecto  = pp.codProyecto
            ) > 0

        ";

        $proyectos  = DB::select($query_proyectos_retrasados);
        $proyectos = array_map(function ($value) {
            return (array)$value;
        }, $proyectos);

        foreach($proyectos as $proy) {

            $codProyecto       = $proy['codProyecto'];
            $desProyecto       = $proy['desproyecto'];

            $query_actividades = "

                select
                aa.codAnaResActividad,
                af.desAnaResFrente as Frente ,
                af2.desAnaResFase as Fase,
                aa.desActividad as Actividad ,
                aa.desRestriccion as Restriccion,
                IFNULL(at2.desTipoRestricciones ,'sin elegir') as Tipo_Restriccion,
                IFNULL(concat(u.name,' '+u.lastname) , pi2.desCorreo) as Usuario_Responsable,
                pa.desArea as Area_Responsable,
                ce.desEstado as Estado_Actividad,
                concat(u2.name,' ',u2.lastname) as Usuario_Solicitante,
                aa.dayFechaRequerida,
                aa.dayFechaConciliada,
                aa.numOrden
                from
                anares_actividad aa
                inner join anares_frente af on aa.codAnaResFrente  = af.codAnaResFrente
                inner join anares_fase af2 on aa.codAnaResFase  = af2.codAnaResFase
                left join anares_tiporestricciones at2 on aa.codTipoRestriccion  = at2.codTipoRestricciones
                left join proy_integrantes pi2 on aa.idUsuarioResponsable = pi2.codProyIntegrante
                left join users u on pi2.idIntegrante  = u.id
                left join proy_areaintegrante pa on pi2.codArea  = pa.codArea
                left join conf_estado ce on aa.codEstadoActividad  = ce.codEstado and ce.desModulo = 'ANARES'
                left join users u2 on aa.codUsuarioSolicitante  = u2.id
                where aa.codProyecto = ? and
                (aa.codEstadoActividad  < 3 and aa.dayFechaConciliada < DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '-05:00'), '%Y-%m-%d 00:00:00'))
                order by aa.codAnaResFrente,aa.codAnaResFase, aa.numOrden

            ";

            $valores        = array($codProyecto);
            $actividades    = DB::select($query_actividades, $valores);


            $query_integrantes = "

                select pi2.desCorreo as correo, pp.desNombreProyecto as proyecto, pi2.idIntegrante as idIntegrante
                from ana_integrantes ai
                inner join  proy_proyecto pp on ai.codProyecto = pp.codProyecto
                left  join  proy_integrantes pi2 on pi2.codProyIntegrante  = ai.codProyIntegrante and pi2.codProyecto = ai.codProyecto
                where ai.codProyecto = :codProyecto and pi2.codEstadoInvitacion  = 1

            ";

            $integrantes            = DB::select($query_integrantes, ['codProyecto' => $codProyecto]);
            $integrantes            = collect($integrantes);

            if($integrantes->isNotEmpty()) {

                $correoPrincipal = Config::get('global.MAIL_FROM_ADDRESS'); //$integrantes->first()->correo;
                $correosBCC      = $integrantes->pluck('correo')->toArray();

                print_r($correosBCC);

                $datos_enviar = [
                    'actividades'         => $actividades,
                    'des_proyecto'        => $desProyecto,
                    'des_correo'          => "Usuario ",
                    'des_link'            => Config::get('global.URL'),
                    'des_direktor_icon'   => Config::get('global.ICON_DIREKTOR')
                ];

                Helper::enviarEmailconCopia($datos_enviar, 'retrasos', "Actividades con Retrasos en el proyecto " . $desProyecto, null, $correoPrincipal, $correosBCC);

            }


            // foreach ($integrantes as $key => $value) {

            //     $datos_enviar = array();
            //     $datos_enviar['actividades']       = $actividades;
            //     $datos_enviar['des_correo']        = $value['correo'];
            //     $datos_enviar['des_proyecto']      = $value['proyecto'];
            //     $datos_enviar['des_link']          = Config::get('global.URL');
            //     $datos_enviar['des_direktor_icon'] = Config::get('global.ICON_DIREKTOR');

            //     Helper::enviarEmail($datos_enviar, 'retrasos', "Actividades con Retrasos en el proyecto ".$value['proyecto'], $value['idIntegrante'] ,$value['correo']);
            // }

        }


    }


    public function push_enviar_notificaciones (Request $request){

        $enviar             = array();
        $enviar["flag"]     = 0;
        $enviar["mensaje"]  = "";
        $codProyecto        = $request['id'];
        $query_actividades  = "


        select
        pr.desNombreProyecto as proyecto,
        aa.codAnaResActividad,
        af.desAnaResFrente as Frente ,
        af2.desAnaResFase as Fase,
        aa.desActividad as Actividad ,
        aa.desRestriccion as Restriccion,
        IFNULL(at2.desTipoRestricciones ,'sin elegir') as Tipo_Restriccion,
        IFNULL(concat(u.name,' '+u.lastname) , pi2.desCorreo) as Usuario_Responsable,
        pa.desArea as Area_Responsable,
        ce.desEstado as Estado_Actividad,
        concat(u2.name,' ',u2.lastname) as Usuario_Solicitante,
        aa.dayFechaRequerida,
        aa.dayFechaConciliada,
        aa.numOrden
        from
        anares_actividad aa
        inner join proy_proyecto pr on aa.codProyecto = pr.codProyecto
        inner join anares_frente af on aa.codAnaResFrente  = af.codAnaResFrente
        inner join anares_fase af2 on aa.codAnaResFase  = af2.codAnaResFase
        left join anares_tiporestricciones at2 on aa.codTipoRestriccion  = at2.codTipoRestricciones
        left join proy_integrantes pi2 on aa.idUsuarioResponsable = pi2.codProyIntegrante
        left join users u on pi2.idIntegrante  = u.id
        left join proy_areaintegrante pa on pi2.codArea  = pa.codArea
        left join conf_estado ce on aa.codEstadoActividad  = ce.codEstado and ce.desModulo = 'ANARES'
        left join users u2 on aa.codUsuarioSolicitante  = u2.id
        where aa.flgNoti = 0 and aa.codProyecto = ?
        order by aa.codAnaResFrente,aa.codAnaResFase, aa.numOrden


        ";

        // try {


            $valores      = array($codProyecto);
            $actividades  = DB::select($query_actividades, $valores);
            $integrantes  = RestrictionMember::select("proy_integrantes.desCorreo as correo", "proy_proyecto.desNombreProyecto as proyecto", "proy_integrantes.idIntegrante as idIntegrante")
            ->Join('proy_proyecto', 'proy_proyecto.codProyecto','=','ana_integrantes.codProyecto')
            ->leftJoin('proy_integrantes', function($join){
                $join->on('proy_integrantes.codProyIntegrante', '=', 'ana_integrantes.codProyIntegrante');
                $join->on('proy_integrantes.codProyecto', '=', 'ana_integrantes.codProyecto');

            })
            ->where('ana_integrantes.codProyecto', $codProyecto)
            ->where('proy_integrantes.codEstadoInvitacion', 1)
            ->get();

            /* Enviamos los correos de notificación */

            foreach ($integrantes as $key => $value) {

                $datos_enviar = array();
                $datos_enviar['actividades']       = $actividades;
                $datos_enviar['des_correo']        = $value['correo'];
                $datos_enviar['des_proyecto']      = $value['proyecto'];
                $datos_enviar['des_link']          = Config::get('global.URL');
                $datos_enviar['des_direktor_icon'] = Config::get('global.ICON_DIREKTOR');

                Helper::enviarEmail($datos_enviar, 'alerta', "Correo de Seguimiento de Analisis de Restricciones - Proyecto ".$value['proyecto'], $value['idIntegrante'] ,$value['correo']);
            }

            // // notificacion para el mobil
            // foreach ($actividades as $key => $value) {


            //     $proyecto  = str_replace(' ', '', $value->proyecto);
            //     $mensaje   =  "La restriccion ".$value->codAnaResActividad." con nombre :".$value->Actividad." y de estado actual :  ".$value->Estado_Actividad.", fue actualizada, si requiere mas detalle del cambio consultar la web.";

            //     Helper::callNotification("ACTUALIZACIONES : Proyecto ".$value->proyecto, $mensaje, $proyecto);


            // }

            /* Actualizamos el estado de la notificacion */
            $arr_ids = array();
            foreach ($actividades as $key0 => $value0) {
                $arr_ids[] = $value0->codAnaResActividad;
                $resultado = PhaseActividad::where('codAnaResActividad',(int)$value0->codAnaResActividad)->update([

                    'flgNoti' => 1,

                ]);


            }

            $enviar["flag"]                   =  1;
            $enviar["mensaje"]                = "Registros Actualizados !";
            $enviar["idsupd"]                 = $arr_ids;

        return $enviar;


    }

    public function upd_restricciones (Request $request){

        // $data = json_decode($request);
        $enviar = array();
        $enviar["flag"]     = 0;
        $enviar["inserciones"]     = array();
        $enviar["actualizaciones"]     = array();
        $enviar["mensaje"]  = "";
        // print_r($request);

        try {
            // print_r($request);
            foreach ($request['data'] as $value) {


                    $fecha     = str_replace("T", " ", $value['dayFechaRequerida']);
                    $fecha     = str_replace("Z", "", $fecha);

                    $fechac    = str_replace("T", " ", $value['dayFechaConciliada']);
                    $fechac    = str_replace("Z", "", $fechac);
                    $resultado = "";
                    $tiporesultado = "";
                    $fechaLeva     = "";



                    if($value['codAnaResActividad'] > 0){

                        $actividad    = PhaseActividad::find($value['codAnaResActividad']);
                        $dataTracking = PhaseActividadTrack::insertGetId([
                            'codAnaResActividad'   => $value['codAnaResActividad'],
                            'codProyecto'          => $request['projectId'],
                            'codEstadoActividadInicial' => $actividad->codEstadoActividad,
                            'codEstadoActividadFinal'   =>  $value['codEstadoActividad'],
                            // 'codEstadoActividad'   => $codestado,
                            'codRetrasoMotivo'     => -1,
                            'desRetrasoComentario' => '',
                            // 'codEstadoAprobacion'  => 0,
                            // 'flagUseAprobacion'    => 0,
                            'dayFechaCreacion' => date('Y-m-d H:i:s'),
                            'desUsuarioCreacion' => '',
                            'codUsuarioCreacion' => $request['userId'],
                            'flagRetrasoAprobacion' => -1,
                            'codEstadoAprobacion' => -1,
                            'codUsuarioAprobacion' => -1
                            // 'codProyIntegrante' => (String)$user
                        ]);

                        $resultado = PhaseActividad::where('codAnaResActividad',(int)$value['codAnaResActividad'])->update([
                            'codTipoRestriccion' => $value['codTipoRestriccion'],
                            'desActividad'       => (string)$value['desActividad'],
                            'desRestriccion'     => (string)$value['desRestriccion'],
                            'idUsuarioResponsable'   => $value['idUsuarioResponsable'],
                            'codEstadoActividad'     => $value['codEstadoActividad'],
                            'dayFechaRequerida'      => ($fecha == 'null' || $fecha == '') ? null : $fecha,
                            'dayFechaConciliada'     => ($fechac == 'null' || $fechac == '') ? null : $fechac,
                            'flgNoti'                => 0,
                            'dayFechaLevantamiento'  => $value['codEstadoActividad'] == 3 ? Carbon::now() : null,
                            'codAnaResActividadTrackLast' => $dataTracking
                            // 'numOrden'               => $value['numOrden']
                        ]);

                        if($value['codEstadoActividad'] == 3){
                            $datos                        = array();

                            //$fechaLevantamiento = PhaseActividad::where('codAnaResActividad', (int)$value['codAnaResActividad'])->value('dayFechaCreacion');
                            $datos["idReal"]              = (int)$value['codAnaResActividad'];
                            $datos["fechaLevantamiento"]  = date("Y-m-d", strtotime(Carbon::now()));
                            $enviar["actualizaciones"][]  = $datos;

                        }



                        $tiporesultado = "upd";

                    }else{

                        $codAnaRes              = Restriction::where('codProyecto', $request['projectId'])->get('codAnaRes');
                        $idactividad            = PhaseActividad::insertGetId([
                            'codTipoRestriccion'     => $value['codTipoRestriccion'],
                            'desActividad'           => (string)$value['desActividad'],
                            'desRestriccion'         => (string)$value['desRestriccion'],
                            'idUsuarioResponsable'   => $value['idUsuarioResponsable'],
                            'codEstadoActividad'     => $value['codEstadoActividad'],
                            'dayFechaRequerida'      => ($fecha == 'null' || $fecha == '') ? null : $fecha,
                            'dayFechaConciliada'     => ($fechac == 'null' || $fechac == '') ? null : $fechac,
                            'codProyecto'            => $request['projectId'],
                            'codAnaRes'              => $codAnaRes[0]['codAnaRes'],
                            'codAnaResFase'          => $value['codAnaResFase'],
                            'codAnaResFrente'        => $value['codAnaResFrente'],
                            'codUsuarioSolicitante'  => $request['userId'],
                            'numOrden'               => $value['idrestriccion'] + 0.01,
                            'flgNoti'                => 0,
                            'dayFechaCreacion'       => Carbon::now()
                        ]);

                        $actividad    = PhaseActividad::find($value['codAnaResActividad']);
                        $dataTracking = PhaseActividadTrack::insertGetId([
                            'codAnaResActividad'   => $idactividad,
                            'codProyecto'          => $request['projectId'],
                            'codEstadoActividadInicial' => -1 ,
                            'codEstadoActividadFinal'   =>  $value['codEstadoActividad'],
                            // 'codEstadoActividad'   => $codestado,
                            'codRetrasoMotivo'     => -1,
                            'desRetrasoComentario' => 'Creacion de la actividad',
                            // 'codEstadoAprobacion'  => 0,
                            // 'flagUseAprobacion'    => 0,
                            'dayFechaCreacion' => date('Y-m-d H:i:s'),
                            'desUsuarioCreacion' => '',
                            'codUsuarioCreacion' => $request['userId'],
                            'flagRetrasoAprobacion' => -1,
                            'codEstadoAprobacion' => -1,
                            'codUsuarioAprobacion' => -1
                            // 'codProyIntegrante' => (String)$user
                        ]);

                        PhaseActividad::where('codAnaResActividad', $idactividad)->update(['codAnaResActividadTrackLast' => $dataTracking]);

                        $tiporesultado = "ins";

                        // $fechaCreacion = PhaseActividad::where('codAnaResActividad', $idactividad)->value('dayFechaCreacion');

                        $datos                    = array();
                        $datos['idPivote']        = $value['codAnaResActividad'];
                        $datos["idReal"]          = $idactividad;
                        $datos["fechaIdentificacion"] = date("Y-m-d", strtotime(Carbon::now()));
                        $enviar["inserciones"][]  = $datos;

                    }


            }

            $enviar["flag"]                   =  1;
            $enviar["mensaje"]                = "Registros Actualizados !";
            $enviar["datos"]                  = $resultado;


        } catch (Throwable $e) {

            $enviar["mensaje"]  = $e;

        }

         return $enviar;

    }

    public function get_restrictionsMember(Request $request){
        $devolvemos_data = RestrictionMember::select("ana_integrantes.*", "proy_integrantes.desCorreo as desProyIntegrante", "proy_integrantes.codArea")
        ->leftJoin('proy_integrantes', function($join){
            $join->on('proy_integrantes.codProyIntegrante', '=', 'ana_integrantes.codProyIntegrante');
            $join->on('proy_integrantes.codProyecto', '=', 'ana_integrantes.codProyecto');

         })
         ->where('ana_integrantes.codProyecto', $request['id'])->get();
        // ->join('anares_analisisrestricciones', 'ana_integrantes.codAnaRes', '=', 'anares_analisisrestricciones.codAnaRes')
        // ->join('proy_integrantes', 'proy_integrantes.codProyIntegrante', '=', 'ana_integrantes.codProyIntegrante', ' and ','ana_integrantes.codProyecto','=','ana_integrantes.codProyecto')
        // ->where('anares_analisisrestricciones.codProyecto', $request['id'])->get();
        return $devolvemos_data;
    }

    public function get_estado(Request $request) {

        $datos_estado = Conf_Estado::where('desModulo', 'ANARES')->get();

        return $datos_estado;
    }

    public function get_data_restricciones(Request $request) {

        $codTipoRestriccionCliente = 11;
        $query_integrantes = "

        select
        ai.*,
        case
        when isnull(u.name)
        then pi2.desCorreo
        else concat(u.name,' ',u.lastname)
        end as desProyIntegrante,
        pi2.codArea,
        pi2.idIntegrante,
        pi2.codRolIntegrante,
        pr.desRolIntegrante
        from ana_integrantes ai
        inner join proy_integrantes pi2
        left  join users u on pi2.desCorreo  = u.email
        left  join proy_rolintegrante pr on pi2.codRolIntegrante = pr.codRolIntegrante
        on
        ai.codProyIntegrante  = pi2 .codProyIntegrante and
        ai.codProyecto        = pi2.codProyecto
        where ai.codProyecto = ?

        ";
        $rolUsuario   = 0; // en estos momentos el rolusuario cero es el creador del proyecto.
        $areaUsuario  = 0;
        $desrolUsuario= "";
        $coduser      = $request['codsuser'];
        $valores      = array($request['id']);
        $integrantesAnaRes = DB::select($query_integrantes, $valores);
        $integrantesAnaRes = array_map(function ($value) {
            return (array)$value;
        }, $integrantesAnaRes);

        foreach ($integrantesAnaRes as $integrante) {
            if ($integrante['idIntegrante'] == $coduser){
                $rolUsuario    = $integrante['codRolIntegrante'];
                $desrolUsuario = $integrante['desRolIntegrante'];
                $areaUsuario   = $integrante['codArea'];
                break;
            }
        }

        $validar_rol  = $rolUsuario == 8 ? 1 : 0;
        $query_frente = "


                    select distinct
                    af.codAnaResFrente ,
                    af.desAnaResFrente ,
                    af.dayFechaCreacion ,
                    af.codProyecto ,
                    af.codAnaRes
                    from anares_frente af
                    inner join anares_actividad aa
                    on af.codAnaResFrente = aa.codAnaResFrente
                    where
                    (1 = ?  and  (af.codProyecto = ? and  aa.codTipoRestriccion = ?)) or
                    (0 = ?  and  (af.codProyecto = ? ))


        ";

        $valores_frente      = array($validar_rol , $request['id'] , $codTipoRestriccionCliente , $validar_rol , $request['id']);
        $frontdata           = DB::select($query_frente, $valores_frente);
        $frontdata           = array_map(function ($value) {
            return (array)$value;
        }, $frontdata);

        // $frontdata   = RestrictionFront::where('codProyecto', $request['id'])->get();
        $restriction = Restriction::where('codProyecto', $request['id'])->get();
        $usuario     = $project = User::select('users.name','users.lastname')->where('id', $coduser)->get();

        //Auth::select('users.name','users.lastname')->where('id',$coduser)->get();

        $enviar      = array();
        $anaresdata  = [];
        $conteo      = 0;

        foreach($frontdata as $eachdata) {
            $dataFrente = [
                'codFrente'   => $eachdata['codAnaResFrente'],
                'desFrente'   => $eachdata['desAnaResFrente'],
                'isOpen'      => $conteo == 0 ? true : false,
                'listaFase'   => [],
            ];

            // $phasedata   = RestrictionPhase::where('codAnaResFrente', $eachdata['codAnaResFrente'])->get();
            $query_fase = "
            select
            distinct
            af.codAnaResFase ,
            af.desAnaResFase ,
            af.dayFechaCreacion ,
            af.codAnaResFrente ,
            af.codProyecto ,
            af.codAnaRes
            from anares_fase af
            inner join anares_actividad aa
            on af.codAnaResFase = aa.codAnaResFase
            where
            (1 = ?  and  (af.codAnaResFrente = ? and  aa.codTipoRestriccion = ?)) or
            (0 = ?  and  (af.codAnaResFrente = ? ))


            ";

            $valores_fase        = array($validar_rol , $eachdata['codAnaResFrente'] , $codTipoRestriccionCliente , $validar_rol , $eachdata['codAnaResFrente']);
            $phasedata           = DB::select($query_fase, $valores_fase);
            $phasedata           = array_map(function ($value) {
                return (array)$value;
            }, $phasedata);



            $conteo_fase = 0;
            foreach($phasedata as $sevdata) {
                $dataFase = [
                    'codFase' => $sevdata['codAnaResFase'],
                    'desFase' => $sevdata['desAnaResFase'],
                    'isOpen'  => true, //$conteo_fase == 0 ? true : false,
                    // 'notDelayed' => $restriction[0]['indNoRetrasados'],
                    // 'delayed' => $restriction[0]['indRetrasados'],
                    'listaRestricciones' => [],
                    'hideCols' => [],
                ];

                $Activedata = PhaseActividad::select("anares_actividad.*" , "anares_tiporestricciones.desTipoRestricciones as desTipoRestriccion" , "proy_integrantes.desCorreo as desUsuarioResponsable","proy_integrantes.idIntegrante", "proy_integrantes.codRolIntegrante",  "proy_integrantes.codArea"  ,"proy_areaintegrante.desArea", "conf_estado.desEstado as desEstadoActividad", "users.name as name", "users.lastname as lastname", "proy_proyecto.id as codCreador")
                ->leftjoin('anares_tiporestricciones', 'anares_actividad.codTipoRestriccion', '=', 'anares_tiporestricciones.codTipoRestricciones')
                ->leftJoin('proy_integrantes', function($join){
                    $join->on('proy_integrantes.codProyIntegrante', '=', 'anares_actividad.idUsuarioResponsable');
                    $join->on('proy_integrantes.codProyecto', '=', 'anares_actividad.codProyecto');
                 })
                 ->leftJoin('proy_proyecto', function($join){
                    $join->on('anares_actividad.codProyecto', '=', 'proy_proyecto.codProyecto');
                 })
                 ->leftJoin('proy_areaintegrante', function($join){
                    $join->on('proy_integrantes.codArea', '=', 'proy_areaintegrante.codArea');
                 })
                 ->leftJoin('conf_estado', function($join){
                    $join->on('anares_actividad.codEstadoActividad', '=', 'conf_estado.codEstado');
                 })
                 ->leftJoin('users', function($join){
                    $join->on('anares_actividad.codUsuarioSolicitante', '=', 'users.id');
                 })
                 ->where(function ($query) use ($validar_rol, $sevdata, $eachdata, $codTipoRestriccionCliente) {
                    $query->whereRaw('1 = ?', [$validar_rol])
                        ->where('conf_estado.desModulo','=',  'ANARES')
                        ->where('anares_actividad.codAnaResFase','=',  $sevdata['codAnaResFase'])
                        ->where('anares_actividad.codAnaResFrente','=', $eachdata['codAnaResFrente'])
                        ->where('anares_actividad.codTipoRestriccion','=', $codTipoRestriccionCliente);
                })
                ->orWhere(function ($query) use ($validar_rol, $sevdata, $eachdata) {
                    $query->whereRaw('0 = ?', [$validar_rol])
                        ->where('conf_estado.desModulo','=',  'ANARES')
                        ->where('anares_actividad.codAnaResFase','=',  $sevdata['codAnaResFase'])
                        ->where('anares_actividad.codAnaResFrente','=', $eachdata['codAnaResFrente']);
                })
                ->orderBy('anares_actividad.numOrden', 'ASC')
                ->get();

                    foreach($Activedata as $data) {
                        $des_usuarioResponsable = $data['desUsuarioResponsable'];
                        foreach ($integrantesAnaRes as $integrante) {
                            if ($integrante['codProyIntegrante'] == $data['idUsuarioResponsable']){
                                $des_usuarioResponsable  = $integrante['desProyIntegrante'];
                                break;
                            }
                        }

                        $habilitado = false;
                        $frequerida_enabled  = false;
                        $fconciliada_enabled = false;
                        // Verificamos si esta habilitado el acceso a la modificacion.

                        if ( $data['codCreador'] == $coduser  || $rolUsuario == 3){

                            $habilitado = true;
                            $frequerida_enabled  = true;
                            $fconciliada_enabled = true;

                        }elseif (($data['codRolIntegrante'] == 2)  && $data['idIntegrante']  == $coduser ) {

                            $habilitado = true;


                        }else{

                            $habilitado = false;
                        }

                        // $data['idIntegrante']

                        $restricciones = [
                            'codAnaResActividad' => $data['codAnaResActividad'],
                            'desActividad'       => $data['desActividad'],
                            'desRestriccion'     => $data['desRestriccion'],
                            'codTipoRestriccion' => $data['codTipoRestriccion'],
                            'desTipoRestriccion' => $data['desTipoRestriccion'],
                            'dayFechaRequerida'     => $data['dayFechaRequerida'] == null ? '' : date("Y-m-d", strtotime($data['dayFechaRequerida'])),  //$data['dayFechaRequerida'] == null ? '' : $data['dayFechaRequerida'],
                            'dayFechaConciliada'    => $data['dayFechaConciliada'] == null ? '' : date("Y-m-d", strtotime($data['dayFechaConciliada'])),  //$data['dayFechaConciliada'] == null ? '' : $data['dayFechaConciliada'],
                            'dayFechaIdentificacion'    => $data['dayFechaCreacion'] == null ? '' : date("Y-m-d", strtotime($data['dayFechaCreacion'])),
                            'dayFechaLevantamiento'    => $data['dayFechaLevantamiento'] == null ? '' : date("Y-m-d", strtotime($data['dayFechaLevantamiento'])),
                            'idUsuarioResponsable'  => $data['idUsuarioResponsable'],
                            'desUsuarioResponsable' => $des_usuarioResponsable ,
                            'desUsuarioSolicitante' => $data['name']." ".$data["lastname"],
                            'idUsuarioSolicitante' => (int)$data['codUsuarioSolicitante'],
                            'codEstadoActividad' => $data['codEstadoActividad'],
                            'desEstadoActividad' => $data['desEstadoActividad'],
                            'desAreaResponsable' => $data['desArea'],
                            'codAreaRestriccion' => $data['codArea'],
                            'numOrden'           => $data['numOrden'],
                            'flgNoti'            => $data['flgNoti'],
                            'isEnabled'          =>  $habilitado,
                            'isEnabledFRequerida' => $frequerida_enabled,
                            'isEnabledFConciliada'=> $fconciliada_enabled,
                            'isupdate'           => false
                            // 'applicant' => "Lizeth Marzano",
                        ];
                        array_push($dataFase['listaRestricciones'], $restricciones);
                    }
                array_push($dataFrente['listaFase'], $dataFase);
                $conteo_fase++;
            }
            array_push($anaresdata, $dataFrente);
            $conteo++;
        }

        $tipoRestricciones = Ana_TipoRestricciones::All();
        $areaIntegrante    = Proy_AreaIntegrante::all();
        $datos_estado      = Conf_Estado::where('desModulo', 'ANARES')->get();
        $data_fecha        = DB::select('call PR_ObtenerDiaActual()');


        // PhaseActividad::where('codEstadoActividad', '4')
        //               ->where('codProyecto', $request['id'])

        $canPendienteAprobacion     = PhaseActividad::where('codEstadoActividad', '4')
        ->where('codProyecto', $request['id'])
        ->count();

        $enviar['estadoRestriccion'] = $restriction[0]['codEstado'] == 0 ? true : false;
        $enviar['estados']           = $datos_estado;
        $enviar['integrantesAnaReS'] = $integrantesAnaRes;
        $enviar['areaIntegrante']    = $areaIntegrante;
        $enviar['tipoRestricciones'] = $tipoRestricciones;
        $enviar['restricciones']     = $anaresdata;
        $enviar['columnasOcultas']   = $restriction[0]['desColOcultas'];
        $enviar['solicitanteActual'] = $usuario[0]['name']." ".$usuario[0]['lastname'];
        $enviar['rolUsuario']        = $rolUsuario;
        $enviar['desrolUsuario']     = $desrolUsuario;
        $enviar['areaUsuario']       = $areaUsuario;
        $enviar['fechaActual']       = $data_fecha[0]->FechaActual;
        $enviar['canAprobacion']     = $canPendienteAprobacion;


        return $enviar;
    }
    public function get_front(Request $request) {
        $frontdata = RestrictionFront::where('codProyecto', $request['id'])->get();
        $restriction = Restriction::where('codProyecto', $request['id'])->get();
        // $frontdata = RestrictionFront::where('codProyecto', '107')->get();
        // $restriction = Restriction::where('codProyecto', '107')->get();
        $anaresdata = [];

        foreach($frontdata as $eachdata) {
            $tempdata = [
                'id' => $eachdata['codAnaResFrente'],
                'name' => $eachdata['desAnaResFrente'],
                'isOpen' => false,
                'info' => [],
            ];

            $phasedata = RestrictionPhase::where('codAnaResFrente', $eachdata['codAnaResFrente'])->get();
            foreach($phasedata as $sevdata) {
                $temp = [
                    'id' => $sevdata['codAnaResFase'],
                    'name' => $sevdata['desAnaResFase'],
                    'notDelayed' => $restriction[0]['indNoRetrasados'],
                    'delayed' => $restriction[0]['indRetrasados'],
                    'tableData' => [],
                    'hideCols' => [],
                ];
                $Activedata = PhaseActividad::where('codAnaResFase','=',  $sevdata['codAnaResFase'])
                                    ->where('codAnaResFrente','=', $eachdata['codAnaResFrente'])
                                    ->get();
                    foreach($Activedata as $data) {
                        $temptable = [
                            'exercise' => $data['desActividad'],
                            // 'restriction' => $data['desRestriccion'],
                            'restriction' => "restriction",
                            'date_required' =>$data['dayFechaRequerida'],
                            'responsible' => $data['desActividad'],
                            'responsible_area' => "Arquitectura",
                            'applicant' => "Lizeth Marzano",
                        ];
                        array_push($temp['tableData'], $temptable);
                    }
                array_push($tempdata['info'], $temp);
            }
            array_push($anaresdata, $tempdata);
        }
        return $anaresdata;
    }


    public function delete_restriction(Request $request){
        $resultado = array();
        $resultado['flag']          = 0;
        $resultado['resultado']     = "";

        try {

            $resultado['resultado'] =  PhaseActividad::where('codAnaResActividad', $request['codAnaResActividad'])->delete();
            $resultado['flag']      =  1;

        } catch (\Throwable $th) {

            $resultado['resultado'] =  $th;


        }

      return $resultado;
    }

    public function duplicate_restriction(Request $request){
        $resultado = array();
        $resultado['flag']          = 0;
        $resultado['resultado']     = "";

        try {

            // $consulta  =  PhaseActividad::where('codAnaResActividad', 19)->get();
            // $consulta2 = $consulta->replicate()->save();
            // $consulta2 = $consulta2->codAnaResActividad;
            $consulta        = PhaseActividad::find($request['codAnaResActividad'])->replicate();
            $arrayconsulta   = $consulta->toArray();
            $arrayconsulta['numOrden']         =  $arrayconsulta['numOrden'] + 0.001;
            $arrayconsulta['dayFechaCreacion'] =  Carbon::now();
            $arrayconsulta['dayFechaLevantamiento'] =  Carbon::now();
            $newCreatedModel = PhaseActividad::create($arrayconsulta);
            // $newID      = $consulta->id;

            $resultado['resultado']              =  $newCreatedModel['codAnaResActividad'];
            $resultado['dayFechaIdentificacion'] =  date("Y-m-d", strtotime($newCreatedModel['dayFechaCreacion']));
            $resultado['flag']      =  1;

        } catch (\Throwable $th) {

            $resultado['resultado'] =  $th;


        }

      return $resultado;
    }

    public function delete_front(Request $request) {

        // if ($request['phaseLen'] == 0 || $request['phaseId'] == '-999') {

        if ($request['phaseId'] == '-999' || $request['phaseId'] == 0 || $request['phaseId'] == null) {

            try {

            PhaseActividad::where('codAnaResFrente', $request['frontId'])->delete();
            RestrictionPhase::where('codAnaResFrente', $request['frontId'])->delete();
            RestrictionFront::where('codAnaResFrente', $request['frontId'])->delete();

                 }
            catch (\Throwable $th) {}
            // RestrictionFront::where('codAnaResFrente', $request['frontId'])->delete();
            // try {
            //     RestrictionPhase::where('codAnaResFrente', $eachdata['frontId'])->delete();
            // } catch (\Throwable $th) {}

        } else {

            try {
            PhaseActividad::where('codAnaResFase', $request['phaseId'])->delete();
            } catch (\Throwable $th) {}
            RestrictionPhase::where('codAnaResFase', $request['phaseId'])->delete();
            // $frontdata = RestrictionFront::where('codAnaResFrente', $request['frontId'])->get();
            // foreach($frontdata as $eachdata) {
            //     RestrictionPhase::where('codAnaResFase', $request['phaseId'])->delete();
            // }
        }
        return $request;
    }

    public function get_restriction_p(Request $request) {
        $TipoRestricciones = RestrictionPerson::where('codTipoRestricciones', '>=', 0)->get();
        return $TipoRestricciones;
    }

    public function add_restriction(Request $request) {
        $TipoRestricciones = RestrictionPerson::where('codTipoRestricciones', '>=', 0)->delete();
        $index = $request['index'];
        for ($i=0; $i < $index; $i++) {
            if($request['data'][$i]['value'] == '') {
                $i -= 1;
                $index -= 1;
            }
            else {
                $resFront = RestrictionPerson::create([
                    'codTipoRestricciones' => $i,
                    'desTipoRestricciones' => $request['data'][$i]['value'],
                ]);
            }
        }
        $TipoRestricciones = RestrictionPerson::where('codTipoRestricciones', '>=', 0)->get();
        return $TipoRestricciones;
    }

    /* Upload Excel */
    public function uploadExcel(Request $request,$id,$projectId){
        try{
            // Get the uploaded file
            $file = $request->excelFile;
            // Load the spreadsheet
            $spreadsheet = IOFactory::load($file);
            // Get the active sheet
            $worksheet = $spreadsheet->getActiveSheet();
            // Get the highest row number and column letter
            $highestRow = $worksheet->getHighestRow();
            $highestColumn = $worksheet->getHighestColumn();
            // Loop through each row of the sheet
            $error = false;
            $success = false;
            $errors = [];
            for ($row = 2; $row <= $highestRow; $row++) {
                $error_ar = NULL;
                // Get the row data as an array
                $rowData = $worksheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, null, true, false)[0];
                $Frente = $rowData[0];
                $Fase = $rowData[1];
                $Actividad = $rowData[2];
                $Restriccion = $rowData[3];
                $TipoRestriccion = $rowData[4];
                $FechaRequerida = $rowData[5];
                $FechaConciliada = $rowData[6];
                $Responsable = $rowData[7];
                $Estado = $rowData[8];
                $Solicitante = $rowData[9];
                if(gettype($FechaConciliada)=="integer"){
                    if(gettype($FechaRequerida)=="integer"){
                        /* check in anares_tiporestricciones */
                        $check_anares_tiporestricciones = Ana_TipoRestricciones::where('desTipoRestricciones',$TipoRestriccion)->first();
                        if($check_anares_tiporestricciones){
                            /* check in proy_integrantes*/
                            $sql_proy_integrantes = "

                            select * from (
                                select
                                a.codProyIntegrante,
                                case when u.id is not null then
                                concat(u.name,' ', u.lastname)
                                else
                                a.desCorreo
                                end as nombre
                                from proy_integrantes a
                                left join users u on a.idIntegrante  = u.id
                                where codProyecto = ".$projectId."
                            ) c where c.nombre  = '".$Responsable."'

                            ";

                            // $valores      = array($projectId, $Responsable);
                            $proy_integrantes = DB::select($sql_proy_integrantes);
                            $proy_integrantes = collect($proy_integrantes)->first();

                            // $proy_integrantes = array_map(function ($value) {
                            //     return (array)$value;
                            // }, $proy_integrantes);

                            // $proy_integrantes = ProjectUser::where(['codProyecto'=>$projectId,'desCorreo'=>$Responsable])->first();
                            if(!empty($proy_integrantes)){
                                /* check in ana_integrantes */
                                $check_ana_integrantes = RestrictionMember::where('codProyIntegrante',$proy_integrantes->codProyIntegrante);
                                if($check_ana_integrantes){
                                    /* check in conf_estado */
                                    $conf_estado = Conf_Estado::where(['desEstado'=>$Estado,'desModulo'=>'ANARES'])->first();
                                    if($conf_estado){
                                        $anaRes = Restriction::where('codProyecto', $projectId)->get('codAnaRes');
                                        $codAnaRes = $anaRes[0]['codAnaRes'];

                                        $anares_actividad = new PhaseActividad;

                                        /* Check already frente exists */
                                        $frente_already = false;
                                        $fase_already = false;
                                        $anares_frente = RestrictionFront::where(['desAnaResFrente'=>$Frente,'codProyecto'=>$projectId,'codAnaRes'=>$codAnaRes])->first();
                                        if($anares_frente){
                                            $frente_already = true;
                                            $anares_fase = RestrictionPhase::where(['codAnaRes'=>$codAnaRes,'desAnaResFase'=>$Fase,'codProyecto'=>$projectId,'codAnaResFrente'=>$anares_frente->codAnaResFrente])->first();
                                            if($anares_fase){
                                                $fase_already = true;
                                            }
                                            else{
                                                $anares_fase = new RestrictionPhase;
                                                $anares_fase->desAnaResFase = $Fase;
                                                $anares_fase->codProyecto = $projectId;
                                                $anares_fase->codAnaRes = $codAnaRes;
                                            }
                                        }
                                        else{
                                            $anares_frente = new RestrictionFront;
                                            $anares_fase = new RestrictionPhase;

                                            /* Add Values */
                                            $anares_frente->desAnaResFrente = $Frente;
                                            $anares_frente->codProyecto = $projectId;
                                            $anares_frente->codAnaRes = $codAnaRes;

                                            $anares_fase->desAnaResFase = $Fase;
                                            $anares_fase->codProyecto = $projectId;
                                            $anares_fase->codAnaRes = $codAnaRes;
                                        }
                                        $anares_actividad->desActividad = $Actividad;
                                        // $anares_actividad->codEstadoActividad = $conf_estado->codEstado;
                                        $anares_actividad->desRestriccion = $Restriccion;

                                        $anares_actividad->codProyecto = $projectId;
                                        $anares_actividad->codAnaRes = $codAnaRes;

                                        $anares_actividad->codTipoRestriccion    = $check_anares_tiporestricciones->codTipoRestricciones;
                                        $anares_actividad->dayFechaRequerida     = gettype($FechaRequerida)=="integer" ? (Date::excelToDateTimeObject($FechaRequerida))->format('Y-m-d') : date('Y-m-d H:i:s');
                                        $anares_actividad->dayFechaConciliada    = gettype($FechaConciliada)=="integer" ? (Date::excelToDateTimeObject($FechaConciliada))->format('Y-m-d') : date('Y-m-d H:i:s');
                                        $anares_actividad->dayFechaCreacion      = Carbon::now();
                                        $anares_actividad->idUsuarioResponsable  = $proy_integrantes->codProyIntegrante;
                                        $anares_actividad->codUsuarioSolicitante = $id;

                                        $anares_actividad->codEstadoActividad = $conf_estado->codEstado;
                                        if($Solicitante){
                                            // $anares_actividad->codEstadoActividad = $id;
                                        }
                                        if(!$frente_already) $anares_frente->save();
                                        if($anares_frente){
                                            if(!$fase_already){
                                                $anares_fase->codAnaResFrente = $anares_frente->codAnaResFrente;
                                                $anares_fase->save();
                                            }
                                            if($anares_fase){
                                                $anares_actividad->codAnaResFrente = $anares_frente->codAnaResFrente;
                                                $anares_actividad->codAnaResFase = $anares_fase->codAnaResFase;
                                                if($anares_actividad->save()){
                                                    $success = true;
                                                }
                                                else $error = true;
                                            }
                                            else $error = true;
                                        }
                                        else $error = true;
                                    }
                                    else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'desEstado' and 'desModulo'=>'ANARES' no coinciden en esta fila."];
                                }
                                else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'codProyIntegrante' el valor no se encuentra en la fila"];
                            }
                            else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'codProyecto'=>$projectId and 'desCorreo'=>$Responsable no se encuentran"];
                        }
                        else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'desTipoRestricciones'=>$TipoRestriccion no se encontro el valor en el maestro de tipo de restricciones"];
                    }
                    else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'dayFechaRequerida'=>$FechaRequerida la fecha no se puede ingresar, el formato es incorrecto."];
                }
                else $error_ar = ["row" => "> Error en la fila: ".$row,'value' => "'dayFechaConciliada'=>$FechaConciliada la fecha no se puede ingresar, el formato es incorrecto."];
                if($error_ar){
                    $error = true;
                    array_push($errors,$error_ar);
                }
            }
            return ["success"=>$success,"error" => $error,"successMessage"=> "Los registros fuerón importados con exito ! ", "errorMessage"=>"Algunos registros no pueden ser importados !","errors" => $errors];
        }
        catch (\Exception $e) {
            return ["error"=>true,"message"=>$e->getMessage()];
        }
    }


    public function push_enviar_aprobaciones(Request $request) {
        //  estado  = 0 , pendiente de aprobacion  ,
        //  estado  = 1 , indicado aprobado  ,
        //  estado  = 2 , indica no aprovado , por lo tanto regresa a su estado anterior

         $codProyecto       = $request['codProyecto'];
         $codUser           = $request['codUser'];
         $idAprobacion      = $request['idAprobacion'];
         $estAprobacion     = $request['estAprobacion'];
         $comentario        = $request['comentario'];

         $trackdata         = PhaseActividadTrack::find($idAprobacion);
         if (!$trackdata) {
            // Manejar el caso en que el cliente no se encontró
            return response()->json(['error' => 'Track Id no encontrado'], 404);
        }

        if($estAprobacion == '1'){

            $trackdata->codEstadoAprobacion  = 1;// ya no esta en esta pendiente la solicitud
            $trackdata->codUsuarioAprobacion = $codUser;
            $trackdata->desComentarioFinal   = $comentario;
            $trackdata->dayFechaAprobacion   = date('Y-m-d H:i:s');

            $estado = $trackdata->save();

            if ($estado) {

                $codActividad   = $trackdata->codAnaResActividad;
                $actividadData  = PhaseActividad::find($codActividad);
                $actividadData->codEstadoActividad = 3; // despues de confirmar  la aprobacion para a cerrado.
                $estado2        = $actividadData->save();
                // $actividadData->codEstadoActividad = $trackdata->codEstadoActividadFinal;
                return response()->json(['success' => 'Aprobacion Finalizada con exito', ]);

            } else {
                return response()->json(['error' => 'Error al actualizar el cliente']);
            }

        }else{

            if($estAprobacion == '2'){

                $trackdata->codEstadoAprobacion  = 2; // ya no esta en esta pendiente la solicitud
                $trackdata->codUsuarioAprobacion = $codUser;
                $trackdata->desComentarioFinal   = $comentario;
                $trackdata->dayFechaAprobacion   = date('Y-m-d H:i:s');

                $estado = $trackdata->save();

                if ($estado) {

                    $codActividad   = $trackdata->codAnaResActividad;
                    $actividadData  = PhaseActividad::find($codActividad);
                    $actividadData->codEstadoActividad    = $trackdata->codEstadoActividadInicial;
                    $actividadData->dayFechaLevantamiento = null;

                    $estado2        = $actividadData->save();

                    if($estado2){

                            $query_rechazos = "

                                    select
                                    af.desAnaResFrente as frente ,
                                    af2.desAnaResFase as fase,
                                    aa2.desActividad ,
                                    aa2.desRestriccion ,
                                    case when aa.codEstadoAprobacion  = '1' then 'Aprobado'
                                        when aa.codEstadoAprobacion  = '2' then 'Rechazado'
                                    else ''
                                    end as estado,
                                    DATE_FORMAT(aa2.dayFechaRequerida, '%Y-%m-%d')  as fecharequerida,
                                    DATE_FORMAT(aa2.dayFechaConciliada, '%Y-%m-%d')  as fechaconciliada ,
                                    DATE_FORMAT(aa.dayFechaAprobacion, '%Y-%m-%d') as fecharechazo,
                                    aa.desComentarioFinal as observacion,
                                    u.email as correo,
                                    pp.desNombreProyecto as proyecto
                                    from anares_actividad_tracking aa
                                    inner join anares_actividad aa2 on aa.codAnaResActividad  = aa2.codAnaResActividad
                                    inner join anares_frente af on aa2.codAnaResFrente = af.codAnaResFrente
                                    inner join anares_fase   af2  on aa2.codAnaResFase  = af2.codAnaResFase
                                    inner join users u            on aa.codUsuarioCreacion = u.id
                                    inner join proy_proyecto pp on aa2.codProyecto = pp.codProyecto
                                    where aa.codAnaResActividadTrack  =  ?


                            ";

                            $valores          = array($idAprobacion);
                            $rechazosData = DB::select($query_rechazos, $valores);
                            $rechazosData = array_map(function ($value) {
                            return (array)$value;
                            }, $rechazosData);


                            if (!empty($rechazosData)) {

                                $datos_enviar = array();
                                $datos_enviar['actividades']       = $rechazosData;
                                $datos_enviar['des_correo']        = $rechazosData[0]['correo'];
                                $datos_enviar['des_proyecto']      = $rechazosData[0]['proyecto'];
                                $datos_enviar['des_link']          = Config::get('global.URL');
                                $datos_enviar['des_direktor_icon'] = Config::get('global.ICON_DIREKTOR');

                                Helper::enviarEmail($datos_enviar, 'rechazo', "Aprobaciones rechazadas para el proyecto  -  ".$rechazosData[0]['proyecto'], $codUser , $rechazosData[0]['correo']);

                            }

                    }

                    // $actividadData->codEstadoActividad = $trackdata->codEstadoActividadFinal;
                    return response()->json(['success' => 'Desaprobación Finalizada con exito', 'correo' => 'Se envio notificación de rechazo con exito !!.' ]);

                } else {

                    return response()->json(['error' => 'Error al actualizar el cliente']);
                }


            }
        }



    }

    public function get_data_aprobaciones(Request $request) {

         $codProyecto       = $request['codProyecto'];
         $codUser           = $request['codUser'];
         $rol               = $request['rolUsuario'];
        //  $data_aprobaciones = PhaseActividadTrack::where('codProyecto', '=', $codProyecto)
        //                       ->where('flagRetrasoAprobacion', '=', 1)
        //                       ->where('codEstadoAprobacion', '=', 0)
        //                       ->get();

         $condicion_admin    = ($rol == '0' || $rol == '3') ? " and aat.codEstadoAprobacion = 0 " : " and aat.codUsuarioCreacion=".$codUser." ";
         $query_aprobaciones = "

                                select
                                    aat.codAnaResActividadTrack  as id,
                                    aa.desActividad as actividad,
                                    aa.desRestriccion as restriccion,
                                    CASE
                                        WHEN aat.codEstadoAprobacion = '0' THEN 'Pendiente'
                                        WHEN aat.codEstadoAprobacion = '1' THEN 'Aprobado'
                                        WHEN aat.codEstadoAprobacion = '2' THEN 'Desaprobado' -- Asumiendo que '2' es para 'Desaprobado'
                                    END AS estado,
                                    aat.codEstadoAprobacion,
                                    aat.dayFechaCreacion as fechaJustificacion,
                                    aat.desRetrasoComentario as justificacion,
                                    aat.desComentarioFinal as comentarioFinal
                                from anares_actividad_tracking aat
                                inner join anares_actividad aa on aat.codAnaResActividad  = aa.codAnaResActividad
                                where aat.codProyecto  = ? and aat.flagRetrasoAprobacion  = 1 ".$condicion_admin." order by aat.codEstadoAprobacion desc

                              ";


         $valores          = array($codProyecto);
         $aprobacionesData = DB::select($query_aprobaciones, $valores);
         $aprobacionesData = array_map(function ($value) {
           return (array)$value;
         }, $aprobacionesData);

         return $aprobacionesData;

    }
}
