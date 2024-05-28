<?php

namespace App\Http\Controllers;
use Illuminate\Testing\Fluent\Concerns\Has;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;

use App\Models\Restriction;
use App\Models\ProjectUser;
use App\Models\PhaseActividad;
use App\Models\RestrictionPerson;
use App\Models\RestrictionFront;
use App\Models\RestrictionPhase;
use App\Models\Ana_TipoRestricciones;
use App\Models\Proy_AreaIntegrante;
use App\Models\Conf_Estado;


use DB;
use Config;
use Helper; // Important
use Carbon\Carbon;


class IndicatorsController extends Controller
{


    public function get_project_indicators(Request $request) {
        $query = "

            select
            ad.codProyecto ,ad.desNombreProyecto,ad.codEstado, ad.id, ad.desEmpresa ,ad.numPlazo,
            ad.numAreaTechada,ad.codTipoProyecto, ad.codUbigeo,ad.dayFechaInicio, ad.numMontoReferencial,
            ad.numAreaTechada , ad.numAreaConstruida, ad.desPais, ad.desDireccion, ad.dayFechaCreacion,
            ad.desUsuarioCreacion, ad.codMoneda, ad.nombreEmpresa, ad.desUbigeo , min(ad.isInvitado) as isInvitado

            from (
            select  pp.* , mp.des_Empresa as nombreEmpresa, cu.desUbigeo  as desUbigeo, 0 as isInvitado
            from proy_proyecto pp
            inner join conf_maestro_empresas mp on pp.desEmpresa  = mp.cod_Empresa
            inner join conf_ubigeo cu on pp.codUbigeo  = cu.codUbigeo
            where pp.id  = ?

            union all

            select pp.* , mp.des_Empresa as nombreEmpresa, cu.desUbigeo  as desUbigeo , 1 as isInvitado
            from proy_proyecto pp
            inner join proy_integrantes pi2  on pp.codProyecto = pi2.codProyecto
            inner join conf_maestro_empresas mp on pp.desEmpresa  = mp.cod_Empresa
            inner join conf_ubigeo cu on pp.codUbigeo  = cu.codUbigeo
            where pi2.idIntegrante   = ? and pi2.codEstadoInvitacion  = ?
            ) ad
            group by
            ad.codProyecto ,ad.desNombreProyecto,ad.codEstado, ad.id, ad.desEmpresa ,ad.numPlazo,
            ad.numAreaTechada,ad.codTipoProyecto, ad.codUbigeo,ad.dayFechaInicio, ad.numMontoReferencial,
            ad.numAreaTechada , ad.numAreaConstruida, ad.desPais, ad.desDireccion, ad.dayFechaCreacion,
            ad.desUsuarioCreacion, ad.codMoneda, ad.nombreEmpresa, ad.desUbigeo


        ";

        $valores = array($request['coduser'], $request['coduser'] , 1);
        $project = DB::select($query, $valores);

        return $project;
    }

    public function get_project_restricciones(Request $request) {

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
        pi2.codRolIntegrante
        from ana_integrantes ai
        inner join proy_integrantes pi2
        left  join users u on pi2.desCorreo  = u.email
        on
        ai.codProyIntegrante  = pi2 .codProyIntegrante and
        ai.codProyecto        = pi2.codProyecto
        where ai.codProyecto = ?

        ";



        $valores           = array($request['codProyecto']);
        $integrantesAnaRes = DB::select($query_integrantes, $valores);

        $integrantesAnaRes = array_map(function ($value) {
            return (array)$value;
        }, $integrantesAnaRes);





        $enviar            = array();
        $anarestricciones  = [];
        $query_actividades = "

        select
        a.*,
        af.desAnaResFrente,
        af2.desAnaResFase ,
        b.desTipoRestricciones as desTipoRestriccion,
        c.desCorreo as desUsuarioResponsable,
        c.idIntegrante,
        c.codRolIntegrante,
        c.codArea,
        pa.desArea,
        ce.desEstado as desEstadoActividad,
        u.name as name,
        u.lastname as lastname,
        d.id as codCreador,
        d.codProyecto as codProyecto,
        d.desNombreProyecto as desNombreProyecto,
        CONCAT('Sem.', LPAD(WEEK(a.dayFechaRequerida, 3), 2, '0')) as desNumSemana,
        fgetyearmonthnum(a.dayFechaRequerida) as numAnioMes,
        fgetyearmonthdesc(a.dayFechaRequerida) as desAnioMes,
        fgetweekyear(a.dayFechaRequerida) as numSemanaAnio
        from anares_actividad a
        inner join anares_frente af on a.codAnaResFrente = af.codAnaResFrente
        inner join anares_fase af2  on a.codAnaResFase   = af2.codAnaResFase
        left join anares_tiporestricciones b on a.codTipoRestriccion = b.codTipoRestricciones
        left join proy_integrantes c on c.codProyIntegrante = a.idUsuarioResponsable and c.codProyecto  = a.codProyecto
        left join proy_proyecto d on a.codProyecto = d.codProyecto
        left join proy_areaintegrante pa on pa.codArea = c.codArea
        left join conf_estado ce on a.codEstadoActividad  = ce.codEstado
        left join users u on a.codUsuarioSolicitante  = u.id
        where
        ce.desModulo       = 'ANARES' and
        a.codProyecto      = ?
        order by
        a.dayFechaRequerida asc


        ";

        $valores2      = array($request['codProyecto']);
        $Activedata    = DB::select($query_actividades, $valores2);
        $Activedata    = array_map(function ($value) {
            return (array)$value;
        }, $Activedata);


        foreach($Activedata as $data) {

            $des_usuarioResponsable = $data['desUsuarioResponsable'];
            foreach ($integrantesAnaRes as $integrante) {
                if ($integrante['codProyIntegrante'] == $data['idUsuarioResponsable']){
                    $des_usuarioResponsable  = $integrante['desProyIntegrante'];
                    break;
                }
            }

            $desc_estado_upd = ($data['codEstadoActividad'] == '3' && (Carbon::parse($data['dayFechaLevantamiento']) <=  Carbon::parse($data['dayFechaConciliada'])))   ? 'Comp.Plazo' : (
                ($data['codEstadoActividad'] == '3' && (Carbon::parse($data['dayFechaLevantamiento']) >  Carbon::parse($data['dayFechaConciliada']))) ? 'Comp.Retraso' : (

                    ( $data['codEstadoActividad']  != 3 && (Carbon::parse($data['dayFechaConciliada']) >= Carbon::now() ) ) ? 'Pendiente' :
                    ( ($data['codEstadoActividad'] != 3 && (Carbon::parse($data['dayFechaConciliada']) < Carbon::now())) ? 'Retrasado' : 0 )

                )
            );

            $cod_estado_upd  = $desc_estado_upd == 'Comp.Plazo' ? 4 : ($desc_estado_upd == 'Comp.Retraso' ? 3 :  ($desc_estado_upd == 'Retrasado' ? 2  : 1));
            $restricciones   = [
                    'id'              => $data['codAnaResActividad'],
                    'codProyecto'     => $data['codProyecto'],
                    'codAnaResFrente' => $data['codAnaResFrente'],
                    'desAnaResFrente' => $data['desAnaResFrente'],
                    'codAnaResFase'   => $data['codAnaResFase'],
                    'desAnaResFase'   => $data['desAnaResFase'],
                    'dayFechaRequerida'     => $data['dayFechaRequerida'] == null ? '' : date("Y/m/d", strtotime($data['dayFechaRequerida'])),
                    'dayFechaIdentificacion'    => $data['dayFechaCreacion'] == null ? '' : date("Y/m/d", strtotime($data['dayFechaCreacion'])),
                    'codEstadoActividad' => $cod_estado_upd,
                    'estado' => $desc_estado_upd ,  //$data['desEstadoActividad'],
                    'codresponsable'     => $data['idUsuarioResponsable'] == '' ? '9999' : $data['idUsuarioResponsable'] ,
                    'responsable'        => $des_usuarioResponsable == "" ? 'No Asignado' : $des_usuarioResponsable,
                    'desActividad'       => $data['desActividad'],
                    'codTipoRestriccion' => $data['codTipoRestriccion'],
                    'desTipoRestriccion' => $data['desTipoRestriccion'],
                    'dayFechaConciliada'    => $data['dayFechaConciliada'] == null ? '' : date("Y/m/d", strtotime($data['dayFechaConciliada'])),
                    'dayFechaLevantamiento' => $data['dayFechaLevantamiento'] == null ? '' : date("Y/m/d", strtotime($data['dayFechaLevantamiento'])),
                    'desRestriccion'        => $data['desRestriccion'],
                    'desNumSemana'          => $data['desNumSemana'],
                    'desAnioMes'            => $data['desAnioMes'],
                    'numSemanaAnio'         => $data['numSemanaAnio'],
                    'numAnioMes'            => $data['numAnioMes']

                ];
                array_push($anarestricciones, $restricciones);
            }




        $tipoRestricciones = Ana_TipoRestricciones::All();
        $areaIntegrante    = Proy_AreaIntegrante::all();
        $datos_estado      = Conf_Estado::where('desModulo', 'ANARES')->get();

        // $enviar['estadoRestriccion'] = $restriction[0]['codEstado'] == 0 ? true : false;
        $enviar['estados']           = $datos_estado;
        $enviar['integrantesAnaReS'] = $integrantesAnaRes;
        $enviar['areaIntegrante']    = $areaIntegrante;
        $enviar['tipoRestricciones'] = $tipoRestricciones;
        $enviar['restricciones']     = $anarestricciones;
        // $enviar['columnasOcultas']   = $restriction[0]['desColOcultas'];
        // $enviar['solicitanteActual'] = $usuario[0]['name']." ".$usuario[0]['lastname'];
        // $enviar['rolUsuario']        = $rolUsuario;
        // $enviar['areaUsuario']       = $areaUsuario;

        return $enviar;
        }


}

