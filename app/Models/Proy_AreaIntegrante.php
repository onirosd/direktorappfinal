<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Sluggable\HasSlug;

class Proy_AreaIntegrante extends Model
{
    use HasFactory;
    protected $fillable = [
        'codArea',
        'desArea'
    ];
    protected $table = "Proy_AreaIntegrante";

    public $timestamps = false;

}
