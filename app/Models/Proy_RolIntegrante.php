<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Sluggable\HasSlug;

class Proy_RolIntegrante extends Model
{
    use HasFactory;
    protected $fillable = [
        'codRolIntegrante',
        'desRolIntegrante'
    ];
    protected $table = "Proy_RolIntegrante";

    public $timestamps = false;

}
