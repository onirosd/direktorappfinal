<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\Sluggable\HasSlug;

class Conf_MotivosRetraso extends Model
{
    use HasFactory;
    protected $fillable = [
        'codRetrasoMotivo',
        'desRetrasoMotivo'
    ];
    protected $table = "conf_motivosretraso";

    public $timestamps = false;

}
