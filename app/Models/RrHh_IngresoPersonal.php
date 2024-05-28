<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RrHh_IngresoPersonal extends Model
{
    use HasFactory;

    protected $fillable = [
        'codProyecto',
        'codEstado',
        'dayFechaCreacion',
        'desUsuarioCreacion',
        'indNoRetrasados',
        'indRetrasados',
        'codRrHh',
        'desColOcultas'
    ];

    protected $table      = 'rrhh_ingresopersonal';
    protected $primaryKey = 'codRrHh';
    public $timestamps    = false;
}
