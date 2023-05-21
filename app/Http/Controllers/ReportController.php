<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Illuminate\View\View;

class ReportController extends Controller implements FromView, ShouldAutoSize
{
    public function generarReporte()
    {
        return Excel::download($this, 'reporte.xlsx');
    }

    public function view(): View
    {
        $qproyecto = (object) [
            'codigo' => 'PROJ001',
            'nombre' => 'Proyecto de ejemplo',
            'area' => 'Área de ejemplo',
            'ubicacion' => 'Ubicación de ejemplo',
        ];

        $qregistros = [
            (object) [
                'nsemana' => 'Semana 1',
                'ntipo' => 'Tipo 1',
                'nfrente' => 'Frente 1',
                'nsubfrente' => 'Subfrente 1',
                'nresponsableasignacion' => 'Responsable Asignación 1',
                'ndescripcionactividad' => 'Descripción Actividad 1',
                'ndescripcionrestriccion' => 'Descripción Restricción 1',
                'nfechaidentificacion' => '2023-05-20',
                'nfecharequerida' => '2023-05-25',
                'nresponsablelevantamiento' => 'Responsable Levantamiento 1',
                'nfecharealfinlevantamiento' => '2023-05-30',
                'netapa' => 'Etapa 1',
                'nestado' => 'Estado 1',
                'ndeltadias' => 5,
                'nobservacion' => 'Observación 1',
            ],
            (object) [
                'nsemana' => 'Semana 2',
                'ntipo' => 'Tipo 2',
                'nfrente' => 'Frente 2',
                'nsubfrente' => 'Subfrente 2',
                'nresponsableasignacion' => 'Responsable Asignación 2',
                'ndescripcionactividad' => 'Descripción Actividad 2',
                'ndescripcionrestriccion' => 'Descripción Restricción 2',
                'nfechaidentificacion' => '2023-05-22',
                'nfecharequerida' => '2023-05-27',
                'nresponsablelevantamiento' => 'Responsable Levantamiento 2',
                'nfecharealfinlevantamiento' => '2023-06-01',
                'netapa' => 'Etapa 2',
                'nestado' => 'Estado 2',
                'ndeltadias' => 6,
                'nobservacion' => 'Observación 2',
            ],
            // Otros registros
        ];

        return view('reports.restrictions', [
            'qproyecto' => $qproyecto,
            'qregistros' => $qregistros,
        ]);
    }
}
