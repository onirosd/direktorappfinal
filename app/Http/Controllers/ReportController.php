<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ReportController extends Controller
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
        $hoja->setCellValue('A1', '');
        $hoja->setCellValue('F1', 'REGISTRO');
        $hoja->setCellValue('K1', 'Revision');
        $hoja->setCellValue('F2', 'GESTION DE PROYECTOS');
        $hoja->setCellValue('F3', 'ANALISIS DE RESTRICCIONES');
        $hoja->setCellValue('K3', 'Pagina 1');
        $hoja->setCellValue('A4', 'CODIGO DEL PROYECTO');
        $hoja->setCellValue('G4', 'Area:');
        $hoja->setCellValue('L4', 'Ubicacion:');
        $hoja->setCellValue('A6', $qproyecto['nproyecto']);
        $hoja->setCellValue('G6', 'Cliente:');
        $hoja->setCellValue('A8', 'Fecha:');
        $hoja->setCellValue('G8', 'Semana:');
        $hoja->setCellValue('H8', 'Numero Total de nuevas restricciones:');
        $hoja->setCellValue('A9', date('d/m/Y'));
        $hoja->setCellValue('H9', '% de nuevas retricciones identificadas x semana:');

        // Fusionar celdas para ajustar las columnas
        $hoja->mergeCells('A1:E3');
        $hoja->mergeCells('F1:K1');
        $hoja->mergeCells('K1:O1');
        $hoja->mergeCells('F2:K2');
        $hoja->mergeCells('K2:O2');
        $hoja->mergeCells('F3:K3');
        $hoja->mergeCells('K3:O3');
        $hoja->mergeCells('A4:F4');
        $hoja->mergeCells('G4:K4');
        $hoja->mergeCells('L4:O4');
        $hoja->mergeCells('A6:F6');
        $hoja->mergeCells('G6:G7');
        $hoja->mergeCells('H6:O7');
        $hoja->mergeCells('A8:F8');
        $hoja->mergeCells('G8:G9');
        $hoja->mergeCells('H8:O9');

        // Establecer estilos para las celdas
        $hoja->getStyle('A1:O9')->getFont()->setBold(true);
        $hoja->getStyle('A1:O9')->getAlignment()->setVertical(\PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER);
        $hoja->getStyle('A1:O9')->getBorders()->getAllBorders()->setBorderStyle(\PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN);
        $hoja->getStyle('A1:E3')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER);
        $hoja->getStyle('F1:O3')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER_CONTINUOUS);
        $hoja->getStyle('A4:F4')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('G4:K4')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('L4:O4')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('A6:F7')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('G6:G7')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('A8:F9')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('G8:G9')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);
        $hoja->getStyle('H8:O9')->getAlignment()->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_LEFT);

        // Llenar los encabezados de la décima fila
        $hoja->setCellValue('A10', 'SEMANA');
        $hoja->setCellValue('B10', 'TIPO');
        $hoja->setCellValue('C10', 'FRENTE');
        $hoja->setCellValue('D10', 'SUBFRENTE');
        $hoja->setCellValue('E10', 'RESPONSABLE DE ASIGNACION');
        $hoja->setCellValue('F10', 'DESCRIPCION DE LA ACTIVIDAD');
        $hoja->setCellValue('G10', 'DESCRIPCION DE LA RESTRICCION');
        $hoja->setCellValue('H10', 'FECHA DE IDENTIFICACION');
        $hoja->setCellValue('I10', 'FECHA REQUERIDA');
        $hoja->setCellValue('J10', 'RESPONSABLE DE LEVANTAMIENTO');
        $hoja->setCellValue('K10', 'FECHA REAL DE FIN LEVANTAMIENTO');
        $hoja->setCellValue('L10', 'ETAPA');
        $hoja->setCellValue('M10', 'ESTADO');
        $hoja->setCellValue('N10', 'DELTA EN DIAS');
        $hoja->setCellValue('O10', 'OBSERVACION');

        // Establecer estilo para la décima fila
        $hoja->getStyle('A10:O10')->getFont()->setBold(true);
        $hoja->getStyle('A10:O10')->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)->getStartColor()->setRGB('0000FF');
        $hoja->getStyle('A10:O10')->getFont()->getColor()->setRGB('FFFFFF');

        // Llenar los registros en las filas siguientes
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

        // Establecer el ancho de las columnas
        $hoja->getColumnDimension('A')->setWidth(15);
        $hoja->getColumnDimension('B')->setWidth(15);
        $hoja->getColumnDimension('C')->setWidth(15);
        $hoja->getColumnDimension('D')->setWidth(15);
        $hoja->getColumnDimension('E')->setWidth(25);
        $hoja->getColumnDimension('F')->setWidth(40);
        $hoja->getColumnDimension('G')->setWidth(40);
        $hoja->getColumnDimension('H')->setWidth(20);
        $hoja->getColumnDimension('I')->setWidth(20);
        $hoja->getColumnDimension('J')->setWidth(30);
        $hoja->getColumnDimension('K')->setWidth(30);
        $hoja->getColumnDimension('L')->setWidth(15);
        $hoja->getColumnDimension('M')->setWidth(15);
        $hoja->getColumnDimension('N')->setWidth(15);
        $hoja->getColumnDimension('O')->setWidth(40);

        // Establecer los estilos de la hoja de cálculo
        $hoja->getStyle('A1:O9')->getFont()->setBold(true);
        $hoja->getStyle('A1:O9')->getAlignment()->setVertical(\PhpOffice\PhpSpreadsheet\Style\Alignment::VERTICAL_CENTER);
        $hoja->getStyle('A1:O9')->getBorders()->getAllBorders()->setBorderStyle(\PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN);

        // Crear el objeto Writer y guardar el archivo
        $writer = new Xlsx($spreadsheet);
        $filename = 'reporte.xlsx';
        $writer->save($filename);

        // Descargar el archivo
        return response()->download($filename)->deleteFileAfterSend(true);
    }
}
