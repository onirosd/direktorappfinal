<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RrHh_Integrantes extends Model
{
    use HasFactory;

    protected $fillable = [
        'codProyecto',
        'codRrHh',
        'codEstado',
        'dayFechaCreacion',
        'desUsuarioCreacion',
        'codProyIntegrante',
    ];

    protected $table = 'rrhh_integrantes';
    public $timestamps = false;
}
