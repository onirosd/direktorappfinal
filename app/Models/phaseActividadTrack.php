<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PhaseActividadTrack extends Model
{
    use HasFactory;

    protected $fillable = [
        'codAnaResActividadTrack',
        'codAnaResActividad',
        'codProyecto',
        'codEstadoActividadInicial',
        'codEstadoActividadFinal',
        'codRetrasoMotivo',

        'desRetrasoComentario',
        'dayFechaCreacion',
        'desUsuarioCreacion',
        'codUsuarioCreacion',

        'flagRetrasoAprobacion',
        'codEstadoAprobacion',
        'codUsuarioAprobacion',
        'dayFechaAprobacion',

        'desComentarioFinal'
    ];

    // tenemos algo fd dsfds fdsfd fd

    protected $table      = 'anares_actividad_tracking';
    protected $primaryKey = 'codAnaResActividadTrack';
    public $timestamps = false;

    //sd sdsd

}
