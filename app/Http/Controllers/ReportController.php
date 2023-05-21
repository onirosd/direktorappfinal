<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ReporteController extends Controller
{
    public function generarReporte()
    {
        // Simulación de los datos de las consultas
        $qproyecto = [
            'nproyecto' => 'Proyecto de ejemplo',
        ];

        $qregistros = [
            [
                'nsemana' => 'Semana 1',
                'ntipo' => 'Tipo 1',
                'nfrente' => 'Frente 1',
                'nsubfrente' => 'Subfrente 1',
                'nresponsableasignacion' => 'Responsable 1',
                'ndescripcionactividad' => 'Descripción actividad 1',
                'ndescripcionrestriccion' => 'Descripción restricción 1',
                'nfechaidentificacion' => 'Fecha identificación 1',
                'nfecharequerida' => 'Fecha requerida 1',
                'nresponsablelevantamiento' => 'Responsable levantamiento 1',
                'nfecharealfinlevantamiento' => 'Fecha fin levantamiento 1',
                'netapa' => 'Etapa 1',
                'nestado' => 'Estado 1',
                'ndeltadias' => 'Delta en días 1',
                'nobservacion' => 'Observación 1',
            ],
            // Agregar más registros si es necesario
        ];

        // Crear un nuevo objeto Spreadsheet
        $spreadsheet = new Spreadsheet();

        // Crear una hoja de cálculo activa
        $hoja = $spreadsheet->getActiveSheet();

        // Establecer los valores en la hoja de cálculo
        $hoja->setCellValue('B1', 'REGISTRO');
        $hoja->setCellValue('C1', 'Revision');
        $hoja->setCellValue('B2', 'GESTION DE PROYECTOS');
        $hoja->setCellValue('B3', 'ANALISIS DE RESTRICCIONES');
        $hoja->setCellValue('C3', 'Pagina 1');
        $hoja->setCellValue('A4', 'CODIGO DEL PROYECTO');
        $hoja->setCellValue('C4', 'Area:');
        $hoja->setCellValue('D4', 'Ubicacion:');
        $hoja->setCellValue('A6', $qproyecto['nproyecto']);
        $hoja->setCellValue('B6', 'Cliente:');
        $hoja->setCellValue('A8', 'Fecha:');
        $hoja->setCellValue('B8', 'Semana:');
        $hoja->setCellValue('C8', 'NUMERO TOTAL DE NUEVAS RESTRICCIONES:');
        $hoja->setCellValue('G8', '% DE NUEVAS RESTRICCIONES IDENTIFICADAS POR SEMANA:');
        $hoja->setCellValue('A9', date('d/m/Y'));
        $hoja->setCellValue('C9', 'Valor total');
        $hoja->setCellValue('G9', 'Valor por semana');

        // Fusionar celdas para ajustar las columnas
        $hoja->mergeCells('A8:F8');
        $hoja->mergeCells('G8:G9');

        // Llenar los registros en la hoja de cálculo
        $fila = 11;
        foreach ($qregistros as $registro) {
            $hoja->setCellValue('A' . $fila, $registro['nsemana']);
            $hoja->setCellValue('B' . $fila, $registro['ntipo']);
            $hoja->setCellValue('C' . $fila, $registro['nfrente']);
            $hoja->setCellValue('D' . $fila, $registro['nsubfrente']);
            $hoja->setCellValue('E' . $fila, $registro['nresponsableasignacion']);
            $hoja->setCellValue('F' . $fila, $registro['ndescripcionactividad']);
            $hoja->setCellValue('G' . $fila, $registro['ndescripcionrestriccion']);
            $hoja->setCellValue('H' . $fila, $registro['nfechaidentificacion']);
            $hoja->setCellValue('I' . $fila, $registro['nfecharequerida']);
            $hoja->setCellValue('J' . $fila, $registro['nresponsablelevantamiento']);
            $hoja->setCellValue('K' . $fila, $registro['nfecharealfinlevantamiento']);
            $hoja->setCellValue('L' . $fila, $registro['netapa']);
            $hoja->setCellValue('M' . $fila, $registro['nestado']);
            $hoja->setCellValue('N' . $fila, $registro['ndeltadias']);
            $hoja->setCellValue('O' . $fila, $registro['nobservacion']);
            $fila++;
        }

        // Establecer los estilos de la hoja de cálculo
        $hoja->getStyle('A1:O9')->getFont()->setBold(true);
        $hoja->getStyle('A11:O11')->getFont()->getColor()->setRGB('FFFFFF');
        $hoja->getStyle('A11:O11')->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)->getStartColor()->setRGB('0000FF');

        // Crear el objeto Writer y guardar el archivo
        $writer = new Xlsx($spreadsheet);
        $filename = 'reporte.xlsx';
        $writer->save($filename);

        // Descargar el archivo
        return response()->download($filename)->deleteFileAfterSend(true);
    }
}
