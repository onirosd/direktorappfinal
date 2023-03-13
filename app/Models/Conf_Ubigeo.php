<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Sluggable\HasSlug;

class Conf_Ubigeo extends Model
{
    use HasFactory;
    protected $fillable = [
        'codUbigeo',
        'desUbigeo'
    ];
    protected $table = "Conf_Ubigeo";

    public $timestamps = false;

}
