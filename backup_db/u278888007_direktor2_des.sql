-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 19, 2024 at 05:37 AM
-- Server version: 10.11.7-MariaDB-cll-lve
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u278888007_direktor2_des`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`u278888007_direktor2_des`@`127.0.0.1` PROCEDURE `GetDateTimeLima` ()  BEGIN
    -- Cambiar la zona horaria a Lima, Perú (UTC-05:00)
    SET time_zone = '-05:00';
    
    -- Obtener y devolver la fecha y hora actual
    SELECT NOW() AS DateTimeLima;
END$$

CREATE DEFINER=`u278888007_direktor2_des`@`127.0.0.1` PROCEDURE `PR_ObtenerDiaActual` ()  BEGIN
    SET time_zone = '-05:00';   
    SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS FechaActual;
END$$

CREATE DEFINER=`u278888007_direktor2_des`@`127.0.0.1` PROCEDURE `PR_obtenerInfoSemana` (IN `pFecha` DATE)  BEGIN
    SET time_zone = '-05:00';
    
    -- Calcula la fecha de inicio (lunes) basándose en la fecha proporcionada
    SET @diasParaRestar = CASE 
        WHEN DAYOFWEEK(pFecha) = 1 THEN 6  -- Si es domingo, restamos 6 días para llegar al lunes anterior
        ELSE DAYOFWEEK(pFecha) - 2  -- En otros casos, restamos los días necesarios para llegar al lunes
    END;
    SET @fechaInicio = DATE_SUB(pFecha, INTERVAL @diasParaRestar DAY);
    
    -- Calcula la fecha de fin (domingo) sumando 6 días a la fecha de inicio
    SET @fechaFin = DATE_ADD(@fechaInicio, INTERVAL 6 DAY);
    
    -- Calcula el número de semana del año considerando que la semana comienza el lunes
    SET @numeroSemana = WEEK(pFecha, 3);
   
   
    SET @siSemana = case when WEEK(pFecha, 3) = WEEK(NOW(), 3) then 1 else -1 end;
    
    -- Devuelve la fecha de inicio, la fecha de fin y el número de semana
    SELECT pFecha AS fechaActual , @fechaInicio AS fechaIni, @fechaFin AS fechaFin, @numeroSemana AS numSemana, @siSemana as isSemanaActual;
    SELECT @fechaInicio AS FechaInicio, @fechaFin AS FechaFin, @numeroSemana AS NumeroDeSemana;
END$$

$$

CREATE DEFINER=`u278888007_direktor2_des`@`127.0.0.1` PROCEDURE `PR_restriccionesxproyectoyrango` (IN `pFechaIni` DATE, IN `pFechaFin` DATE, IN `pCodProyecto` INT)  BEGIN

  -- Cambiar la zona horaria a Lima, Perú (UTC-05:00)
    SET time_zone = '-05:00';
   
   select 
	aa.codAnaResActividad as cod_restriccion,
	aa.desRestriccion as desc_restriccion, 
	aa.desActividad as desc_actividad, 
	af.desAnaResFrente as desc_frente,
	af.codAnaResFrente  as cod_frente,
	case when aa.dayFechaConciliada is null then aa.dayFechaRequerida  else aa.dayFechaConciliada end  as fec_conciliada,
	aa.dayFechaLevantamiento as fec_real,
	ce.desEstado as desc_estado,
	aa.codEstadoActividad as cod_estado,
	case when aa.dayFechaConciliada < NOW() and codEstadoActividad < 3 then  1 else 0 end as isretrasado
	from anares_actividad aa 
	inner join anares_frente af on aa.codAnaResFrente = af.codAnaResFrente 
	inner join conf_estado ce on aa.codEstadoActividad = ce.codEstado and ce.desModulo  = 'ANARES' 
	where 
	aa.codProyecto  = pCodProyecto  and 
	case when aa.dayFechaConciliada is null then aa.dayFechaRequerida else aa.dayFechaConciliada end between pFechaIni and pFechaFin; 


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `anares_actividad`
--

CREATE TABLE `anares_actividad` (
  `codAnaResActividad` bigint(20) NOT NULL,
  `desActividad` varchar(255) DEFAULT NULL,
  `desRestriccion` varchar(255) DEFAULT NULL,
  `codTipoRestriccion` int(11) DEFAULT NULL,
  `dayFechaRequerida` datetime DEFAULT NULL,
  `idUsuarioResponsable` bigint(20) DEFAULT NULL,
  `desAreaResponsable` char(18) DEFAULT NULL,
  `codEstadoActividad` char(18) DEFAULT NULL,
  `codUsuarioSolicitante` char(18) DEFAULT NULL,
  `codAnaResFase` bigint(20) DEFAULT NULL,
  `codAnaResFrente` bigint(20) DEFAULT NULL,
  `codProyecto` bigint(20) DEFAULT NULL,
  `codAnaRes` bigint(20) DEFAULT NULL,
  `dayFechaConciliada` datetime DEFAULT NULL,
  `dayFechaLevantamiento` datetime DEFAULT NULL,
  `numOrden` decimal(10,5) DEFAULT 0.00000,
  `flgNoti` int(11) DEFAULT 1,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `codAnaResActividadTrackLast` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `anares_actividad`
--

INSERT INTO `anares_actividad` (`codAnaResActividad`, `desActividad`, `desRestriccion`, `codTipoRestriccion`, `dayFechaRequerida`, `idUsuarioResponsable`, `desAreaResponsable`, `codEstadoActividad`, `codUsuarioSolicitante`, `codAnaResFase`, `codAnaResFrente`, `codProyecto`, `codAnaRes`, `dayFechaConciliada`, `dayFechaLevantamiento`, `numOrden`, `flgNoti`, `dayFechaCreacion`, `codAnaResActividadTrackLast`) VALUES
(1, 'x<x<zx<ldsada ssdsd asdsasasasasasasaasasssdssasasasa', 'Prueba modificcamos', 6, '2020-01-01 12:00:00', 2, NULL, '1', '19', 1, 1, 1, 129, '2020-10-15 12:00:00', NULL, '1.00000', 1, '2020-01-01 12:00:00', NULL),
(4, 'Constatación notarial a edificios aledaños (1)', 'Conciliar reunión con junta de propietarios y notaría', 10, '2023-03-27 12:00:00', 11, NULL, '3', '31', 2, 2, 4, 132, '2023-03-27 12:00:00', '2023-03-27 12:00:00', '1.00000', 1, '2023-03-13 00:00:00', NULL),
(11, 'Emplazamiento de campamento', 'Realizar pedido de materiales', 10, '2023-03-27 12:00:00', 11, NULL, '3', '31', 2, 2, 4, 132, '2023-03-27 12:00:00', '2023-03-27 00:00:00', '2.00000', 1, '2023-03-13 00:00:00', NULL),
(18, 'Enchape de terrazas', 'Pintura fachada', 5, '2024-03-18 12:00:00', 9, NULL, '3', '31', 2, 2, 4, 132, '2024-03-25 12:00:00', '2024-04-01 13:23:58', '0.00000', 1, '2023-03-13 00:00:00', 1210),
(20, 'actividad10', 'vemrosds 3 sds ds', 3, '2023-03-23 12:00:00', 1, NULL, '2', '19', 1, 1, 1, 129, NULL, NULL, '2.00000', 1, '2023-03-23 12:00:00', NULL),
(21, 'TOPOGRAFIA', 'INGRESO DE CUADRILLA PARA INICIAR TRABAJOS', 7, '2023-03-21 12:00:00', 15, NULL, '3', '33', 4, 5, 5, 133, '2023-04-01 12:00:00', '2023-04-01 12:00:00', '0.00000', 0, '2023-03-21 12:00:00', NULL),
(22, 'MOVIMIENTO DE TIERRAS', 'CIERR DE ADJUDICACIÒN PARA COMENZAR A COORDINAR TRABAJOS', 7, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '1.00000', 0, '2023-03-21 12:00:00', NULL),
(23, 'ANCLAJES', 'CIERRE DE ADJUDICACIÒN PARA COMENZAR A COORDINAR TRABAJOS', 7, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '2.00000', 0, '2023-03-21 12:00:00', NULL),
(24, 'ENCOFRADO', 'CIERRE DE ADJUDICACIÒN PARA SOLICITAR MODULACIONES DE ENCOFRADO', 7, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '3.00000', 0, '2023-03-21 12:00:00', NULL),
(25, 'CERCO PERIMETRICO', 'INSTALACIÒN DE CERCO', 7, '2023-04-10 12:00:00', 17, NULL, '3', '33', 7, 6, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '0.00000', 0, '2023-04-10 12:00:00', NULL),
(26, 'CERCO PERIMETRICO', 'COLOCACIÒN DE POSTES Y MALLA RATCHEL', NULL, '2023-03-28 12:00:00', 17, NULL, '3', '33', 7, 6, 5, 133, '2023-04-11 12:00:00', '2023-04-11 12:00:00', '1.00000', 0, '2023-03-28 12:00:00', NULL),
(27, 'ACERO', 'CIERRE DE ADJUDICACIÒN PARA ENVIAR PROGRAMACION', 5, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '4.00000', 0, '2023-03-21 12:00:00', NULL),
(28, 'CONCRETO', 'CIERRE DE ADJUDICACIÒN PARA ENVIAR PROGRAMACION', 5, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '5.00000', 0, '2023-03-21 12:00:00', NULL),
(29, 'CERCO PERIMETRICO', 'AUTORIZACIÒN DE INGRESO PARA INICIAR LABORES', 11, '2023-03-27 12:00:00', 15, NULL, '3', '33', 7, 6, 5, 133, '2023-03-31 12:00:00', '2023-03-31 12:00:00', '2.00000', 0, '2023-03-27 12:00:00', NULL),
(30, 'ENCOFRADO', 'LLEGADA DE MATERIALES', 5, '2023-03-21 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '6.00000', 0, '2023-03-21 12:00:00', NULL),
(31, 'CONCRETO', 'LLEGADA DE MATERIALES', 5, '2023-03-21 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '7.00000', 0, '2023-03-21 12:00:00', NULL),
(32, 'ACERO', 'LLEGADA DE MATERIALES', 5, '2023-03-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '8.00000', 0, '2023-03-21 12:00:00', NULL),
(33, 'CERCO PERIMETRICO', 'CIERRE DE SUBCONTRATISTA PARA INICIAR TRABAJOS', 7, '2023-03-27 12:00:00', 17, NULL, '3', '33', 7, 6, 5, 133, '2023-04-04 12:00:00', '2023-04-04 12:00:00', '3.00000', 0, '2023-03-27 12:00:00', NULL),
(34, 'Aqui tenemos lo siguiente , veremores como podemos añadir estos', 'dsds', 4, '2024-04-17 12:00:00', 2, NULL, '1', '19', 1, 1, 1, 129, '2024-05-12 12:00:00', NULL, '3.00000', 0, NULL, 2422),
(36, 'Eliminación de material excavado', 'Permiso de uso de vías', 10, '2023-05-16 12:00:00', 11, NULL, '3', '31', 8, 3, 4, 132, '2023-05-16 12:00:00', '2023-05-16 12:00:00', '1.00000', 1, '2023-05-02 00:00:00', NULL),
(38, 'Encofrado de muros pantalla', 'Arribo de material a obra', 5, '2023-05-17 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-05-17 12:00:00', '2023-06-22 11:30:25', '2.00000', 1, '2023-05-02 00:00:00', NULL),
(39, 'Acero de muros pantalla', 'Arribo de material a obra', 5, '2023-05-16 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-05-16 12:00:00', '2023-05-16 12:00:00', '3.00000', 1, '2023-05-02 00:00:00', NULL),
(40, 'Instalación de escuadras', 'Se requiere las escuadras para evitar la ocupación de espacio del campamento', 7, '2023-06-01 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-06-01 12:00:00', '2023-06-22 11:49:48', '9.00000', 1, '2023-05-23 00:00:00', NULL),
(41, 'Emplazamiento de contenedores', 'Se requiere las escuadras para evitar la ocupación de espacio del campamento', 7, '2023-06-01 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-06-01 12:00:00', '2023-06-22 11:49:56', '10.00000', 1, '2023-05-23 00:00:00', NULL),
(47, 'ACERO', 'INGRESO DE CUADRILLA PARA INICIAR TRABAJOS', 4, '2023-04-04 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '9.00000', 0, '2023-04-04 12:00:00', NULL),
(48, 'CONCRETO', 'INGRESO DE CUADRILLA PARA INICIAR TRABAJOS', 4, '2023-04-04 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '10.00000', 0, '2023-04-04 12:00:00', NULL),
(51, 'CARPINTERIA', 'INGRESO DE CUADRILLA PARA INICIAR TRABAJOS', 4, '2023-04-04 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '11.00000', 0, '2023-04-04 12:00:00', NULL),
(52, 'TOPOGRAFIA', 'LLEGADA DE MATERIALES', 5, '2023-04-04 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-04-10 12:00:00', '2023-04-10 12:00:00', '12.00000', 0, '2023-04-04 12:00:00', NULL),
(53, 'MOVIMIENTO TIERRAS', 'PERFILADO DE BANQUETA PAÑO G-K/14', 11, '2023-04-17 12:00:00', 16, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '13.00000', 0, '2023-04-17 12:00:00', NULL),
(54, 'ANCLAJES', 'PERFORACION Y ANCLAJE PAÑO 1.01', 11, '2023-04-17 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-17 12:00:00', '2023-04-17 12:00:00', '14.00000', 0, '2023-04-17 12:00:00', NULL),
(55, 'TOPOGRAFIA', 'COLOCACIÒN DE NIVELES', 11, '2023-04-17 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-17 12:00:00', '2023-04-17 12:00:00', '15.00000', 0, '2023-04-17 12:00:00', NULL),
(56, 'TOPOGRAFIA', 'COLOCACIÒN DE PUNTOS DE ANCLAJE', 11, '2023-04-17 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-17 12:00:00', '2023-04-17 12:00:00', '16.00000', 0, '2023-04-17 12:00:00', NULL),
(57, 'ANCLAJES', 'PERFORACIÒN DE PAÑOS', 11, '2023-04-17 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-17 12:00:00', '2023-04-17 12:00:00', '17.00000', 0, '2023-04-17 12:00:00', NULL),
(58, 'MOVIMIENTO TIERRAS', 'NIVELACION DE TERRENO', 11, '2023-04-17 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-17 12:00:00', '2023-04-17 12:00:00', '18.00000', 0, '2023-04-17 12:00:00', NULL),
(59, 'MOVIMIENTO TIERRAS', 'APERTURA DE PAÑO', 11, '2023-04-18 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '19.00000', 0, '2023-04-18 12:00:00', NULL),
(60, 'ACERO', 'COLOCACION DE ACERO Y PROYECCIONES DEL PRIMER PISO', 11, '2023-04-18 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '20.00000', 0, '2023-04-18 12:00:00', NULL),
(61, 'ENCOFRADO', 'ENCOFRADO DE MURO ANCLADO', 11, '2023-04-18 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-18 12:00:00', '2023-04-18 12:00:00', '21.00000', 0, '2023-04-18 12:00:00', NULL),
(62, 'MOVIMIENTO TIERRAS', 'APERTURA DE PAÑOS', 11, '2023-04-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '22.00000', 0, '2023-04-21 12:00:00', NULL),
(63, 'TOPOGRA', 'TRAZOS DE LOS MUROS', 11, '2023-04-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '23.00000', 0, '2023-04-21 12:00:00', NULL),
(64, 'ACERO', 'HABILITACION Y COLOCACIÒN DE ACERO', 11, '2023-05-21 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '24.00000', 0, '2023-05-21 12:00:00', NULL),
(65, 'CONCRETO', 'VACIADO DE MURO ANCLADO', 11, '2023-04-20 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-24 12:00:00', '2023-04-24 12:00:00', '25.00000', 0, '2023-04-20 12:00:00', NULL),
(66, 'MOVIMIENTO TIERRAS', 'PERFILADO DE PAÑOS 1.08-1.10-1.15', 2, '2023-04-24 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-28 12:00:00', '2023-04-28 12:00:00', '26.00000', 0, '2023-04-24 12:00:00', NULL),
(67, 'ACERO', 'ACERO DE PAÑO 1.08-1.10-1.15', 2, '2023-04-24 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-28 12:00:00', '2023-04-28 12:00:00', '27.00000', 0, '2023-04-24 12:00:00', NULL),
(68, 'ENCOFRADO - CONCRETO', 'CONCRETO/ENCOFRADO 1.08-1.10-1.15', 2, '2023-05-24 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-28 12:00:00', '2023-04-28 12:00:00', '28.00000', 0, '2023-05-24 12:00:00', NULL),
(69, 'MOVIMIENTO TIERRAS', 'PERFILADO DE PAÑO 1.17-1.19', 2, '2023-04-27 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-30 12:00:00', '2023-04-30 12:00:00', '29.00000', 0, '2023-04-27 12:00:00', NULL),
(70, 'ACERO', 'ACERO DE PAÑO 1.17-1.19', 2, '2023-04-27 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-04-30 12:00:00', '2023-04-30 12:00:00', '30.00000', 0, '2023-04-27 12:00:00', NULL),
(71, 'MOVIMIENTO TIERRAS', 'ACCESO PARA TRABAJAR EN DOS PARTIDAS EN SIMULTANEO', 6, '2023-04-29 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-05-05 12:00:00', '2023-05-05 12:00:00', '31.00000', 0, '2023-04-29 12:00:00', NULL),
(72, 'OBRA CIVIL', 'PEFILADO Y PICADO DE CONCRETO CISTERNA', 7, '2023-04-29 12:00:00', 17, NULL, '3', '33', 4, 5, 5, 133, '2023-05-05 12:00:00', '2023-05-05 12:00:00', '32.00000', 0, '2023-04-29 12:00:00', NULL),
(73, 'CONCRETO', 'ACCESO POR E.BARRON Y MONTERO ROSAS', 10, '2023-04-26 12:00:00', 18, NULL, '3', '33', 4, 5, 5, 133, '2023-05-24 12:00:00', '2023-06-06 17:39:22', '33.00000', 0, '2023-04-26 12:00:00', NULL),
(75, 'ACTIVITI 1', 'REST 2', 2, NULL, 1, NULL, '1', '19', 10, 7, 1, 129, NULL, NULL, '0.00000', 1, NULL, NULL),
(76, 'ACITVI 2', '', 4, NULL, 1, NULL, '2', '19', 10, 7, 1, 129, NULL, NULL, '1.00000', 1, NULL, NULL),
(77, 'provando 001', 'AS', 2, NULL, 1, NULL, '2', '19', 11, 8, 1, 129, NULL, NULL, '0.00000', 1, NULL, NULL),
(80, 'Apertura de paños', 'Una sola excavadora no da abasto a todas las actividades requeridas', 7, '2023-06-02 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-06-02 12:00:00', '2023-06-22 11:33:31', '6.00000', 1, '2023-05-15 00:00:00', NULL),
(107, 'primer reporte veremos', 'asasasa', 4, NULL, 1, NULL, '1', '19', 1, 1, 1, 129, '2023-08-02 12:00:00', NULL, '0.00000', 0, '2023-06-04 23:56:54', 2420),
(112, 'Aqui tenemos lo siguiente , veremores com', 'DSADSADSADSADSADSADSADaasasasasasasasSADSADSADSADSADSADSADSADSADSADSA', 4, NULL, 2, NULL, '2', '19', 1, 1, 1, 129, NULL, NULL, '3.00100', 1, '2023-06-05 00:20:25', NULL),
(113, 'actividad10', 'vemrosds 3', 3, '2023-03-23 12:00:00', 1, NULL, '1', '19', 1, 1, 1, 129, NULL, NULL, '2.00100', 1, '2023-06-05 00:23:24', NULL),
(115, 'Actividad 002', 'actividad de prueba', 10, '2023-06-28 12:00:00', 1, NULL, '1', '19', 11, 8, 1, 129, NULL, NULL, '1.00000', 1, '2023-06-25 00:47:09', NULL),
(117, 'bt actividdad 001 act', 'actualizamos esta restricciona', 2, '2023-06-20 12:00:00', 25, NULL, '3', '19', 13, 9, 6, 134, NULL, '2023-06-25 10:21:19', '0.00000', 1, '2023-06-25 02:12:10', NULL),
(118, 'bt actividad 002', 'vemos la restriccion', 4, '2024-04-17 12:00:00', 25, NULL, '1', '19', 13, 9, 6, 134, '2024-05-12 12:00:00', NULL, '1.00000', 0, '2023-06-25 09:59:26', 2481),
(121, 'Obras provisionales', 'Se requiere volver a instalar la escalera de acceso a las escuadras, precisando del material para ello', 5, '2023-06-26 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-06-26 12:00:00', '2023-06-28 09:22:02', '12.00000', 1, '2023-06-28 09:17:31', NULL),
(123, 'Colocación de acero', 'Llegada y descarga del acero para el segundo anillo', 5, '2023-06-26 12:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-06-26 12:00:00', '2023-06-28 09:20:58', '14.00000', 1, '2023-06-28 09:17:41', NULL),
(124, 'Tensado de anclajes', 'Romper probetas para ver la resistencia de algunos muros vaciado, para realizar el tensado', 9, '2023-06-28 12:00:00', 12, NULL, '3', '31', 8, 3, 4, 132, '2023-06-28 12:00:00', '2023-06-28 09:20:56', '15.00000', 1, '2023-06-28 09:17:44', NULL),
(127, 'Muros anclados', 'Debe llegar el material para la ejecución de los muros anclados del anillo 2', 5, '2023-06-26 12:00:00', 11, NULL, '3', '31', 8, 3, 4, 132, '2023-06-26 12:00:00', '2023-06-28 09:21:57', '17.00000', 1, '2023-06-28 09:18:07', NULL),
(132, 'CAMINOasaff122aa<<<a', 'NO TENEMOS ACAsaS', 5, '2023-07-02 12:00:00', 26, NULL, '2', '50', 14, 10, 7, 135, NULL, NULL, '0.00000', 1, '2023-07-01 16:24:05', NULL),
(133, 'ACT2', 'cosas que pasan', 11, '2023-07-03 12:00:00', 28, NULL, '3', '38', 14, 10, 7, 135, NULL, '2023-07-03 04:38:49', '1.00000', 1, '2023-07-01 23:46:38', NULL),
(139, 'JULIOaa1zs2aaasas ssssfdfaaa', 'actualizacion2', 2, NULL, 26, NULL, '2', '50', 14, 10, 7, 135, '2023-07-25 12:00:00', NULL, '2.00000', 1, '2023-07-03 04:11:22', NULL),
(146, 'AGOSAATO', 'restruccio julio', 7, NULL, 28, NULL, '1', '38', 15, 11, 7, 135, NULL, NULL, '0.01000', 1, '2023-07-22 10:12:20', NULL),
(153, 'Encofrado de verticales', 'Llegada de encofrado de verticales de la cisterna', 5, '2023-07-27 00:00:00', 9, NULL, '3', '31', 16, 3, 4, 132, '2023-07-27 00:00:00', '2023-07-27 00:00:00', '4.00000', 1, '2023-07-27 00:00:00', NULL),
(154, 'Verticales cisterna', 'Llegada de 4 cuerpos de andamios para la ejecución de la cisterna', 5, '2023-07-04 12:00:00', 9, NULL, '3', '31', 16, 3, 4, 132, '2023-07-05 12:00:00', '2023-08-08 09:17:08', '8.00000', 1, '2023-07-04 12:00:00', NULL),
(158, 'Instalaciones Cisterna', 'Detalle de acero para las pozas de succión de las cisternas', 3, '2023-08-01 00:00:00', 9, NULL, '3', '31', 16, 3, 4, 132, '2023-08-01 00:00:00', '2023-08-01 00:00:00', '5.00000', 1, '2023-08-01 00:00:00', NULL),
(162, 'Acero de losa de piso - Cisterna', 'Llegada de epóxico para colocación de acero', 5, '2023-08-15 12:00:00', 11, NULL, '3', '31', 16, 3, 4, 132, '2023-08-15 12:00:00', '2023-08-17 07:24:36', '10.00000', 1, '2023-08-15 12:00:00', NULL),
(163, 'Eliminación de material', 'Arribo de excavadora neumática para la eliminación', 7, '2023-07-26 00:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-07-26 00:00:00', '2023-07-26 00:00:00', '0.00000', 1, '2023-07-26 00:00:00', NULL),
(164, 'Eliminación de material', 'Modificación de cerco de castro virreyna para poder eliminar con la excavadora en la vereda', 7, '2023-07-31 00:00:00', 9, NULL, '3', '31', 8, 3, 4, 132, '2023-07-31 00:00:00', '2023-07-31 00:00:00', '0.00000', 1, '2023-07-31 00:00:00', NULL),
(165, 'Montaje de torre', 'Desarmado de plataforma voladizo de plataforma provisional ', 7, '2023-07-31 00:00:00', 9, NULL, '3', '31', 17, 3, 4, 132, '2023-07-31 00:00:00', '2023-07-31 00:00:00', '2.00000', 1, '2023-07-31 00:00:00', NULL),
(166, 'Montaje de torre', 'Llegada de grupo electrógeno para la grúa torre', 7, '2023-08-01 00:00:00', 9, NULL, '3', '31', 17, 3, 4, 132, '2023-08-01 00:00:00', '2023-08-01 00:00:00', '4.00000', 1, '2023-08-01 00:00:00', NULL),
(167, 'Instalación de ventanas F4', 'Tarrajeo de fachada F4', 1, '2024-04-06 12:00:00', 64, NULL, '3', '31', 17, 3, 4, 132, '2024-04-04 12:00:00', '2024-04-09 08:34:28', '0.00000', 1, '2023-09-12 12:00:00', 1443),
(169, 'Operación de grúa', 'Requerimiento aparejos de izaje para grúa torre', 5, '2023-08-07 12:00:00', 11, NULL, '3', '31', 17, 3, 4, 132, '2023-08-07 12:00:00', '2023-08-08 09:16:19', '1.00000', 1, '2023-08-07 12:00:00', NULL),
(171, 'Colocación de acero vertical y horizontal', 'Arribo de acero para la ejecución de verticales y horizontales de los sótanos', 5, '2023-08-07 12:00:00', 11, NULL, '3', '31', 9, 3, 4, 132, '2023-08-07 12:00:00', '2023-08-08 09:17:35', '1.00000', 1, '2023-08-07 12:00:00', NULL),
(173, 'Encofrado horizontal para la ejecución de los sótanos', 'Llegada de encofrado para la ejecución de los sótanos', 5, '2023-08-09 12:00:00', 9, NULL, '3', '31', 9, 3, 4, 132, '2023-08-09 12:00:00', '2023-08-11 09:24:45', '2.00000', 1, '2023-08-09 12:00:00', NULL),
(174, 'Colocación de prelosas', 'Arribo de prelosas para el sótano 3', 5, '2023-08-14 12:00:00', 9, NULL, '3', '31', 9, 3, 4, 132, '2023-08-14 12:00:00', '2023-08-11 09:24:40', '3.00000', 1, '2023-08-14 12:00:00', NULL),
(176, 'Relleno y comptactación', 'Ensayar afirmado en obra (para las primeras 3 cisternas de cantera)', 7, '2023-08-08 12:00:00', 9, NULL, '3', '31', 16, 3, 4, 132, '2023-08-08 12:00:00', '2023-08-17 07:24:31', '12.00000', 1, '2023-08-08 11:10:33', NULL),
(180, 'Colocación de acero de horizontales en sótano', 'Replanteo de mechas de acero en muros', 3, '2023-08-08 12:00:00', 9, NULL, '3', '31', 9, 3, 4, 132, '2023-08-08 12:00:00', '2023-08-11 09:24:34', '4.00000', 1, '2023-08-08 11:14:13', NULL),
(183, 'PRUEBA2', 'Prueba', 12, '2020-01-01 00:00:00', 1, NULL, '3', '19', 1, 1, 1, 129, '2020-10-15 00:00:00', '2020-10-15 00:00:00', '0.00000', 1, '2020-01-01 00:00:00', NULL),
(184, 'PRUEBA2', 'Prueba', 12, '2020-01-01 00:00:00', 1, NULL, '3', '19', 1, 1, 1, 129, '2020-10-15 00:00:00', '2020-10-15 00:00:00', '0.00000', 1, '2020-01-01 00:00:00', NULL),
(185, 'PRUEBA2', 'Prueba', 12, '2020-01-01 00:00:00', 1, NULL, '3', '19', 1, 1, 1, 129, '2020-10-15 00:00:00', '2020-10-15 00:00:00', '0.00000', 1, '2020-01-01 00:00:00', NULL),
(186, 'PRUEBA2', 'Prueba', 12, '2020-01-01 00:00:00', 1, NULL, '3', '19', 1, 1, 1, 129, '2020-10-15 00:00:00', '2020-10-15 00:00:00', '0.00000', 1, '2020-01-01 00:00:00', NULL),
(187, 'paint my room', 'other restriction', 9, '2020-01-01 00:00:00', 25, NULL, '2', '19', 13, 9, 6, 134, '2020-10-15 00:00:00', NULL, '0.00000', 1, '2020-01-01 00:00:00', NULL),
(188, 'PRUEBA2', 'Prueba', 12, '2020-01-01 00:00:00', 1, NULL, '3', '19', 1, 1, 1, 129, '2020-10-15 00:00:00', '2020-10-15 00:00:00', '0.00000', 1, '2020-01-01 00:00:00', NULL),
(189, 'Excavación', 'Adjudicación SC Mov. tierras', 12, '2023-09-01 12:00:00', 50, NULL, '3', '51', 18, 13, 14, 140, '2023-09-01 12:00:00', '2024-05-04 20:31:18', '2.00000', 1, '2023-08-31 16:36:36', 1846),
(193, 'Movimiento de tierras', 'Adjudicación Izaje de equipos excav.', 10, '2023-09-07 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-07 12:00:00', '2023-09-08 09:27:23', '9.00000', 1, '2023-09-02 12:44:06', NULL),
(196, 'Acero cimentaciones', 'Adjudicación Sum. Acero', 7, '2023-09-04 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-04 12:00:00', '2023-09-05 10:14:37', '8.00000', 1, '2023-09-02 12:44:06', NULL),
(197, 'Acero cimentaciones', 'Adjudicación SC MO Acero', 7, '2023-09-04 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-04 12:00:00', '2023-09-05 10:13:51', '12.00000', 1, '2023-09-02 12:44:06', NULL),
(200, 'Encofrado cimentaciones', 'Envío PET Encofrado', 9, '2023-09-12 12:00:00', 48, NULL, '3', '51', 20, 13, 14, 140, '2023-09-12 12:00:00', '2023-09-09 23:50:20', '6.00000', 1, '2023-09-02 12:44:06', NULL),
(201, 'Encofrado cimentaciones', 'Envío FT Desmoldante', 9, '2023-09-09 12:00:00', 52, NULL, '3', '51', 20, 13, 14, 140, '2023-09-07 12:00:00', '2023-09-11 10:54:21', '10.00000', 1, '2023-09-02 12:44:06', NULL),
(202, 'Vaciado contrapisos', 'Levantamiento topográfico niveles', 4, '2024-04-26 12:00:00', 105, NULL, '3', '51', 21, 14, 14, 140, '2024-04-29 12:00:00', '2024-05-05 00:25:06', '0.00000', 1, '2023-09-02 12:44:06', 1862),
(208, 'Relleno y compactación', 'Selección cantera afirmado con sc', 12, '2023-09-13 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-11 12:00:00', '2023-09-13 11:47:56', '0.00000', 1, '2023-09-02 12:44:06', NULL),
(209, 'Waterstop', 'Envío FT waterstop', 9, '2023-09-15 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-13 11:48:09', '0.00000', 1, '2023-09-02 12:44:06', NULL),
(210, 'Waterstop', 'Compra waterstop', 12, '2023-09-23 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-15 12:00:00', '2023-09-08 09:28:02', '0.00000', 1, '2023-09-02 12:44:06', NULL),
(211, 'Acero verticales', 'Llegada de material', 12, '2023-09-14 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-08 09:28:10', '0.00000', 1, '2023-09-02 12:44:06', NULL),
(213, 'Encofrado horizontales', 'Llegada de material', 12, '2023-09-30 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-28 12:00:00', '2023-09-13 10:26:36', '0.00000', 1, '2023-09-02 12:44:06', NULL),
(216, 'Zapata torre grúa', 'Aprobación diseño y ubicación', 11, '2023-09-09 12:00:00', 49, NULL, '3', '51', 20, 13, 14, 140, '2023-09-05 12:00:00', '2023-09-05 10:04:45', '4.00000', 1, '2023-09-02 12:44:36', NULL),
(217, 'Movimiento de tierras', 'Adjudicación SC Mov. Tierras', 7, '2023-09-04 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-02 12:00:00', '2023-09-05 10:14:35', '3.00000', 1, '2023-09-02 12:44:36', NULL),
(223, 'Ejecución poyos para transformador3es', 'Pendiente respuesta RFI N°247', 11, '2024-01-14 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2024-01-14 12:00:00', '2024-05-05 00:15:35', '1.00000', 1, '2023-09-02 12:44:36', 1849),
(224, 'Encofrado cimentaciones', 'Adjudicación proveedor encofrado', 7, '2023-09-09 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-06 12:00:00', '2023-09-16 12:21:04', '7.00000', 1, '2023-09-02 12:44:36', NULL),
(233, 'Relleno y compactación', 'Selección cantera afirmado con sc', 12, '2023-09-13 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-11 12:00:00', '2023-09-13 11:48:04', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(234, 'Waterstop', 'Envío FT waterstop', 9, '2023-09-15 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-11 10:59:42', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(235, 'Waterstop', 'Compra waterstop', 12, '2023-09-23 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-15 12:00:00', '2023-09-08 09:28:19', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(236, 'Acero verticales', 'Llegada de material', 12, '2023-09-14 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-08 09:27:50', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(237, 'Encofrado verticales', 'Llegada de material', 12, '2023-09-15 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-13 10:26:27', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(239, 'Encofrado horizontales', 'Llegada de material', 12, '2023-09-30 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-28 12:00:00', '2023-09-13 10:26:33', '0.00000', 1, '2023-09-02 12:44:36', NULL),
(243, 'Movimiento de tierras', 'Adjudicación SC Mov. Tierras', 7, '2023-09-04 12:00:00', 50, NULL, '3', '51', 20, 13, 14, 140, '2023-09-02 12:00:00', '2023-09-05 10:13:42', '11.00000', 1, '2023-09-02 12:46:18', NULL),
(245, 'Movimiento de tierras', 'Envío documentación izaje', 8, '2023-09-06 12:00:00', 51, NULL, '3', '51', 20, 13, 14, 140, '2023-09-05 12:00:00', '2023-09-09 23:50:24', '2.00000', 1, '2023-09-02 12:46:18', NULL),
(246, 'Movimiento de tierras', 'Envío PET Mov. Tierras', 9, '2023-09-05 12:00:00', 52, NULL, '3', '51', 20, 13, 14, 140, '2023-09-04 12:00:00', '2023-09-09 23:49:58', '5.00000', 1, '2023-09-02 12:46:18', NULL),
(255, 'Vaciado contrapisos bloque II', 'Verificar posibilidad de vaciado con bomba pluma', 7, '2024-04-03 12:00:00', 48, NULL, '3', '51', 21, 14, 14, 140, '2024-04-03 12:00:00', '2024-04-21 15:23:54', '0.00000', 1, '2023-09-02 12:46:18', 1652),
(256, 'EJECUCIÓN POYOS PARA TRANSFORMADORES', '', 11, '2024-01-09 12:00:00', 50, NULL, '3', '51', 21, 14, 14, 140, '2024-01-14 12:00:00', '2024-04-21 15:56:10', '0.00000', 1, '2023-09-02 12:46:18', 1662),
(259, 'Relleno y compactación', 'Selección cantera afirmado con sc', 12, '2023-09-13 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-11 12:00:00', '2023-09-13 11:48:01', '0.00000', 1, '2023-09-02 12:46:18', NULL),
(260, 'Waterstop', 'Envío FT waterstop', 9, '2023-09-15 12:00:00', 52, NULL, '3', '51', 22, 14, 14, 140, '2023-09-13 12:00:00', '2023-09-13 11:48:06', '0.00000', 1, '2023-09-02 12:46:18', NULL),
(261, 'INICIO CARPINTERÍA METÁLICA', 'ADJUDICACIÓN SC CARPINTERÍA Y EEMM', 11, '2024-02-17 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2024-02-24 12:00:00', '2024-04-14 11:06:04', '0.00000', 1, '2023-09-02 12:46:18', 1528),
(262, 'Ejecución poyos para transformador3es', 'Pendiente respuesta RFI N°247', 11, '2024-01-14 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2024-01-14 12:00:00', '2024-03-24 15:12:36', '0.00000', 1, '2023-09-02 12:46:18', 1150),
(263, 'IMPERMEABILIZACIÓN CISTERNAS', 'PENDIENTE INGRESO PERSONAL POR PAGO DEL ADELANTO', 7, '2024-02-09 12:00:00', 47, NULL, '3', '51', 22, 14, 14, 140, '2024-02-12 12:00:00', '2024-03-17 12:06:33', '0.00000', 1, '2023-09-02 12:46:18', 955),
(264, 'Encofrado verticales', 'Llegada bridas', 12, '2023-09-21 12:00:00', 55, NULL, '3', '51', 22, 14, 14, 140, '2023-09-21 12:00:00', '2023-09-22 15:14:54', '0.00000', 1, '2023-09-02 12:46:18', NULL),
(265, 'Encofrado horizontales', 'Llegada de material', 12, '2023-09-30 12:00:00', 50, NULL, '3', '51', 22, 14, 14, 140, '2023-09-28 12:00:00', '2023-09-13 10:26:30', '0.00000', 1, '2023-09-02 12:46:18', NULL),
(267, 'Limpieza/Solaqueo y tarrajeo', 'Confirmar si se realizará con SC o casa', 7, '2023-09-22 12:00:00', 9, NULL, '3', '31', 17, 3, 4, 132, '2023-09-22 12:00:00', '2023-10-02 10:22:29', '6.00000', 1, '2023-09-13 10:42:16', NULL),
(270, 'Losa sobre terreno', 'Aprobación de material de préstamo para sub base', 9, '2023-09-22 12:00:00', 12, NULL, '3', '31', 17, 3, 4, 132, '2023-09-22 12:00:00', '2023-10-04 14:03:36', '9.00000', 1, '2023-09-13 10:54:18', NULL),
(271, 'Losa sobre terreno', 'Ingreso de personal y para rellenos localizados', 7, '2023-09-25 12:00:00', 9, NULL, '3', '31', 17, 3, 4, 132, '2023-09-25 12:00:00', '2023-10-02 10:22:41', '10.00000', 1, '2023-09-13 10:59:05', NULL),
(274, 'Limpieza/Solaqueo', 'Confirmar si se realizará con SC o casa', 1, '2023-09-14 12:00:00', 9, NULL, '3', '31', 9, 3, 4, 132, '2023-09-14 12:00:00', '2023-10-04 17:32:10', '7.00000', 1, '2023-09-13 11:04:15', NULL),
(280, 'Construccion nivel  1', 'texto de restriccion inicial  , esto es para cargar los datos.', 4, '2023-10-10 12:00:00', 57, NULL, '3', '19', 23, 15, 15, 141, '2023-10-12 12:00:00', '2024-04-26 11:25:09', '1.00000', 0, '2023-09-20 10:07:32', 1708),
(281, 'Desarrollo nivel 3', 'texto de restriccion inicial  , esto es para cargar los datos.', 5, '2023-10-10 00:00:00', 57, NULL, '3', '19', 23, 15, 15, 141, '2023-10-18 00:00:00', '2023-10-18 00:00:00', '3.00000', 1, '2023-09-20 10:07:32', NULL),
(282, 'Mesedura nivel 1', 'texto de restriccion inicial  , esto es para cargar los datos.', 6, '2023-10-10 12:00:00', 57, NULL, '3', '19', 23, 15, 15, 141, '2023-10-20 12:00:00', '2024-04-26 11:25:12', '2.00000', 0, '2023-09-20 10:07:32', 1709),
(284, 'Desarrollo Bilial', 'texto de restriccion inicial  , esto es para cargar los datos.', 5, '2023-10-10 12:00:00', 57, NULL, '3', '19', 23, 15, 15, 141, '2023-10-18 12:00:00', '2024-04-26 11:25:09', '0.00000', 0, '2023-09-20 10:20:14', 1707),
(285, 'Mesura de ambitos', 'no tenemos nada , se indica que debe hacerse comunicación', 11, '2023-10-10 00:00:00', 57, NULL, '2', '19', 23, 15, 15, 141, '2023-10-20 00:00:00', NULL, '4.00000', 1, '2023-09-20 10:20:14', NULL),
(286, 'ACTIVIDAD1AS', 'ASASASA', 6, '2020-10-20 12:00:00', 57, NULL, '2', '19', 24, 16, 15, 141, '2020-10-20 12:00:00', NULL, '0.00000', 1, '2023-09-22 09:45:16', NULL),
(297, 'Mallas anticaídas', 'Coordinar con SC de mallas la instalación en el techo del piso 5.', 7, '2023-10-23 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-10-23 12:00:00', '2023-10-23 10:39:21', '1.00000', 1, '2023-10-08 21:31:36', NULL),
(298, 'Devolución de encofrado', 'Programar con Alsina la devolución de equipo a partir del 02/11', 12, '2023-11-02 12:00:00', 9, NULL, '3', '57', 36, 21, 4, 132, '2023-10-27 12:00:00', '2023-10-24 11:15:01', '0.00000', 1, '2023-10-08 21:31:36', NULL),
(299, 'Impermeabilización de cisternas', 'Adjudicar SC para impermeabilización de cisternas', 7, '2023-11-02 12:00:00', 9, NULL, '3', '57', 37, 21, 4, 132, '2023-10-30 12:00:00', '2023-10-25 15:50:36', '2.00000', 1, '2023-10-08 21:31:36', NULL),
(300, 'Impermeabilización de cisternas', 'Instalación de conexiones y válvulas en cisternas', 1, '2023-11-03 12:00:00', 62, NULL, '3', '57', 37, 21, 4, 132, '2023-11-13 12:00:00', '2023-11-09 16:50:16', '0.00000', 1, '2023-10-08 21:31:36', NULL),
(301, 'Limpieza y solaqueo', 'Llegada de requerimiento de extractor', 6, '2023-11-17 12:00:00', 11, NULL, '3', '57', 39, 21, 4, 132, '2023-11-16 12:00:00', '2023-10-16 18:05:22', '0.00000', 1, '2023-10-08 21:31:36', NULL),
(302, 'Limpieza interior de cisternas', 'Llegada de requerimiento de extractor', 6, '2023-10-11 12:00:00', 11, NULL, '3', '57', 37, 21, 4, 132, '2023-10-10 12:00:00', '2023-10-12 15:53:36', '1.00000', 1, '2023-10-08 21:31:36', NULL),
(303, 'Limpieza y solaqueo', 'Ingreso de personal para cuadrilla de acabados húmedos', 4, '2023-10-20 12:00:00', 62, NULL, '3', '57', 39, 21, 4, 132, '2023-10-20 12:00:00', '2023-10-21 10:40:48', '1.00000', 1, '2023-10-08 21:31:36', NULL),
(304, 'Tabiquería', 'Adjudicar sc para tabiquería en pisos pares', 7, '2023-10-13 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2023-10-13 12:00:00', '2023-10-09 14:34:34', '1.00000', 1, '2023-10-08 21:31:36', NULL),
(305, 'Tabiquería', 'Inducción de de procedimiento a personal de tabiquería', 9, '2023-10-16 12:00:00', 12, NULL, '3', '57', 42, 22, 4, 132, '2023-10-19 12:00:00', '2023-10-23 10:40:33', '2.00000', 1, '2023-10-08 21:31:36', NULL),
(306, 'Nivelación de piso', 'Levantamiento de niveles de campo de pisos', 9, '2023-10-30 12:00:00', 12, NULL, '3', '57', 42, 22, 4, 132, '2023-10-27 12:00:00', '2023-10-27 12:10:00', '3.00000', 1, '2023-10-08 21:31:36', NULL),
(307, 'Enchape de terrazas', 'Pintura fachada', 5, '2024-03-18 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2024-03-28 12:00:00', '2024-04-01 13:24:17', '0.00000', 1, '2023-10-08 21:31:36', 1211),
(308, 'Instalación de ventanas F4', 'Tarrajeo de fachada F4', 1, '2024-04-06 12:00:00', 64, NULL, '3', '57', 43, 22, 4, 132, '2024-04-06 12:00:00', '2024-04-09 08:35:06', '0.00000', 1, '2023-10-08 21:31:36', 1448),
(309, 'Enchape de baños y cocinas', 'Definir SC para MO de enchape', 4, '2023-10-24 12:00:00', 59, NULL, '3', '57', 43, 22, 4, 132, '2023-10-24 12:00:00', '2023-10-16 18:06:07', '1.00000', 1, '2023-10-08 21:31:36', NULL),
(310, 'Enchape de baños y cocinas', 'Adjudicar SC para instalación de enchape', 7, '2023-10-27 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2023-10-27 12:00:00', '2023-10-16 18:06:09', '2.00000', 1, '2023-10-08 21:31:36', NULL),
(311, 'Sello cortafuego', 'Adjudicar SC para colocación de sello CF', 7, '2023-11-30 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2023-11-27 12:00:00', '2023-11-29 11:06:37', '3.00000', 1, '2023-10-08 21:31:36', NULL),
(312, 'Conformación de S7 y S8', 'Coordinar con JLM reinicio de trabajos en sótano 3 para el 23-10', 7, '2023-10-23 12:00:00', 9, NULL, '3', '57', 38, 21, 4, 132, '2023-10-16 12:00:00', '2023-10-16 18:04:00', '0.00000', 1, '2023-10-08 21:31:36', NULL),
(313, 'Losa de techo piso 11 sector 4', 'Respuesta a RFI 48 sobre apoyo de placas P20 y P21', 3, '2023-11-03 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-11-03 12:00:00', '2023-11-09 16:04:58', '2.00000', 1, '2023-10-08 21:31:36', NULL),
(314, 'Losa de techo piso 9 sector 3', 'Respuesta a RFI 47 sobre corte de viga en hall de ascensores', 3, '2023-10-26 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-10-26 12:00:00', '2023-10-27 14:54:46', '0.00000', 1, '2023-10-08 21:31:36', NULL),
(315, 'Losa de techo sótano 1 sobre rampa', 'Adjudicar SC para montaje de columna metálica CM1', 7, '2023-10-16 12:00:00', 9, NULL, '3', '57', 36, 21, 4, 132, '2023-10-16 12:00:00', '2023-10-23 10:37:38', '1.00000', 1, '2023-10-10 08:48:59', NULL),
(316, 'Plano pases tabiqueria piso 4 y 5', 'Compatibilización sc instalaciones', 3, '2024-04-02 12:00:00', 55, NULL, '3', '51', 45, 23, 14, 140, '2024-04-02 12:00:00', '2024-04-28 12:49:08', '0.00000', 1, '2023-10-11 11:45:55', 1775),
(317, 'Ingreso 2da cuadrilla pintura', 'Envío documentacion personal para charla', 7, '2024-04-04 12:00:00', 48, NULL, '3', '51', 45, 23, 14, 140, '2024-04-04 12:00:00', '2024-04-28 12:30:13', '0.00000', 1, '2023-10-11 11:45:55', 1766),
(318, 'Revoques fachada', 'Incremento de personal', 7, '2024-04-01 12:00:00', 48, NULL, '3', '51', 18, 13, 14, 140, '2024-04-01 12:00:00', '2024-04-26 11:57:31', '1.00000', 1, '2023-10-11 11:45:55', 1717),
(319, 'Drywall', 'PENDIENTE RESPUESTA RFI N°298 DEFINICIÓN REFUERZOS EN DRYWALL', 11, '2024-02-24 12:00:00', 50, NULL, '3', '51', 47, 13, 14, 140, '2024-02-29 12:00:00', '2024-03-16 10:10:27', '0.00000', 1, '2023-10-11 11:45:55', 935),
(320, 'Techo cisterna y cto bombas', 'Llegada encofrado techo cisterna', 5, '2023-10-10 12:00:00', 50, NULL, '3', '51', 18, 13, 14, 140, '2023-10-11 12:00:00', '2024-04-26 11:58:24', '4.00000', 1, '2023-10-11 11:45:55', 1718),
(321, 'Techo cisterna y cto bombas', 'Llegada pedido fenólico', 12, '2023-10-11 12:00:00', 53, NULL, '3', '51', 18, 13, 14, 140, '2023-10-11 12:00:00', '2024-01-08 11:01:57', '3.00000', 1, '2023-10-11 11:45:55', NULL),
(322, 'Pendiente respuesa rfi 2770 ubicación de junta sismica', '', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 48, 23, 14, 140, '2024-01-27 12:00:00', '2024-03-27 10:56:29', '0.00000', 1, '2023-10-11 11:45:55', 1173),
(323, 'Techo sotano 2', 'Llegada acero techo sotano 2', 5, '2023-10-13 12:00:00', 48, NULL, '3', '51', 46, 23, 14, 140, '2023-10-13 12:00:00', '2023-10-16 07:50:37', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(324, 'Techo sotano 2', 'Llegada viguetas y bovedillas', 7, '2023-10-16 12:00:00', 48, NULL, '3', '51', 46, 23, 14, 140, '2023-10-19 12:00:00', '2023-10-26 19:05:03', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(325, 'Techo sotano 2', 'Llegada pedido fenólico', 5, '2023-10-16 12:00:00', 53, NULL, '3', '51', 46, 23, 14, 140, '2023-10-16 12:00:00', '2023-12-30 10:22:44', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(326, 'Techo sotano 2', 'Gestión ingreso personal carpintería', 4, '2023-10-02 12:00:00', 48, NULL, '3', '51', 46, 23, 14, 140, '2023-10-10 12:00:00', '2023-10-16 07:51:20', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(327, 'Llenado de cisternas', 'Tapones en válvulas', 1, '2024-04-22 12:00:00', 55, NULL, '3', '51', 18, 13, 14, 140, '2024-04-22 12:00:00', '2024-05-10 10:53:53', '0.00000', 0, '2023-10-11 11:45:55', 2360),
(328, 'Refuerzos de pases', 'Respuesta incompleta del RFI N°73', 11, '2023-10-03 12:00:00', 98, NULL, '3', '51', 18, 13, 14, 140, '2023-09-30 12:00:00', '2023-12-13 23:22:43', '5.00000', 1, '2023-10-11 11:45:55', NULL),
(329, 'Incompatibilidad detalle de columna C-7', 'Respuesta RFI N°76', 11, '2023-10-07 12:00:00', 98, NULL, '3', '51', 46, 23, 14, 140, '2023-10-10 12:00:00', '2023-10-26 19:04:35', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(330, 'Encofrado techo sotano 2 - Incompatibilidad de aberturas en losa', 'Respuesta RFI N°77', 11, '2023-10-07 12:00:00', 98, NULL, '3', '51', 46, 23, 14, 140, '2023-10-11 12:00:00', '2023-11-24 13:35:10', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(331, 'Encofrado techo sotano 2 - Ubicación de rejilla en desnivel', 'Respuesta RFI N°78', 11, '2023-10-07 12:00:00', 98, NULL, '3', '51', 46, 23, 14, 140, '2023-10-11 12:00:00', '2023-10-26 19:05:15', '0.00000', 1, '2023-10-11 11:45:55', NULL),
(332, 'Losa de techo  S2 - SE', 'Envío de detalles de estructuras de vigas en cambio comunicado el 18/10/23', 3, '2023-10-27 12:00:00', 59, NULL, '3', '57', 36, 21, 4, 132, '2023-10-27 12:00:00', '2023-10-28 10:51:48', '2.00000', 1, '2023-10-21 10:42:40', NULL),
(333, 'Losa de techo S1-SA', 'Respuesta a RFI N°50 Enviado el 16/10/23', 3, '2023-10-23 12:00:00', 9, NULL, '3', '57', 36, 21, 4, 132, '2023-10-23 12:00:00', '2023-10-23 17:43:25', '3.00000', 1, '2023-10-21 10:47:48', NULL),
(334, 'Tabiquería Piso 4', 'Coordinar con JM subida de elevador', 6, '2023-11-07 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2023-11-03 12:00:00', '2023-11-03 14:03:06', '4.00000', 1, '2023-10-23 10:41:07', NULL),
(335, 'EEMM Piso 18', 'Definir SC de EEMM para piso 18', 7, '2023-11-26 12:00:00', 59, NULL, '3', '57', 41, 22, 4, 132, '2023-11-26 12:00:00', '2023-11-12 23:15:34', '3.00000', 1, '2023-10-23 10:44:59', NULL),
(336, 'Malla anticaídas', 'Coordinar con SC de mallas la instalación en el techo del piso 8', 7, '2023-11-06 12:00:00', 11, NULL, '3', '57', 41, 22, 4, 132, '2023-11-06 12:00:00', '2023-11-07 07:58:10', '4.00000', 1, '2023-10-23 10:48:55', NULL),
(338, 'Instalaciones enterradas', 'Ingreso de personal de SC para trabajos de instalaciones enterradas', 4, '2023-11-15 12:00:00', 62, NULL, '3', '57', 38, 21, 4, 132, '2023-11-13 12:00:00', '2023-11-09 16:50:34', '1.00000', 1, '2023-10-23 10:53:31', NULL),
(339, 'Sobremuros de drywall', 'Adjudicar SC de drywall', 7, '2023-11-06 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2023-11-06 12:00:00', '2023-11-08 08:01:57', '4.00000', 1, '2023-10-25 11:44:37', NULL),
(340, 'Losa de techo sótano 01 sector 08', 'Respuesta de RFI 51', 3, '2023-11-04 12:00:00', 9, NULL, '3', '34', 49, 24, 4, 132, '2023-11-04 12:00:00', '2023-10-26 15:32:10', '0.00000', 1, '2023-10-26 15:29:46', NULL),
(342, 'Malla anticaídas', 'Coordinar con SC de mallas la instalación en el techo del piso 11', 7, '2023-11-23 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-11-23 12:00:00', '2023-11-17 12:09:41', '5.00000', 1, '2023-11-09 13:33:27', NULL),
(343, 'Tabiquería Piso 7', 'Coordinar con JM telescopaje de elevador', 6, '2023-11-23 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2023-11-23 12:00:00', '2023-11-17 08:20:33', '5.00000', 1, '2023-11-09 13:37:13', NULL),
(344, 'Derrames de vanos de escaleras y piso 1', 'Adjudicar SC de PCF para definir medidas de vanos.', 3, '2023-11-17 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2023-11-17 12:00:00', '2023-11-16 16:04:12', '7.00000', 1, '2023-11-09 14:27:59', NULL),
(346, 'Almacenamiento de papel mural', 'Armado de almacén para papel mural', 12, '2023-12-04 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2023-12-04 12:00:00', '2023-12-04 02:24:50', '8.00000', 1, '2023-11-09 14:31:53', NULL),
(347, 'Enchape de baños y cocinas', 'Definir color de fraguas a usar', 3, '2023-11-24 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2023-11-24 12:00:00', '2023-11-25 15:48:27', '5.00000', 1, '2023-11-09 14:35:46', NULL),
(348, 'EEMM Azotea', 'Realizar proceso de adjudicación de SCs para EEMM en azotea', 10, '2023-11-24 12:00:00', 11, NULL, '3', '57', 41, 22, 4, 132, '2023-11-24 12:00:00', '2023-11-25 15:48:15', '7.00000', 1, '2023-11-12 23:17:21', NULL),
(349, 'EEMM Azotea', 'Definir SC que realizará EEMM del piso18', 7, '2023-11-27 12:00:00', 59, NULL, '3', '57', 41, 22, 4, 132, '2023-11-27 12:00:00', '2023-11-30 09:54:36', '8.00000', 1, '2023-11-12 23:19:26', NULL),
(350, 'Limpieza y Solaqueo', 'Retiro total de encofrado de verticales y vigas', 1, '2023-11-22 12:00:00', 64, NULL, '3', '57', 39, 21, 4, 132, '2023-11-21 12:00:00', '2023-11-23 11:03:58', '2.00000', 1, '2023-11-12 23:27:29', NULL),
(351, 'Ingreso sc acabados', 'Adjudicación sc tabiquería', 7, '2023-11-30 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2023-12-06 12:00:00', '2024-01-03 10:09:12', '0.00000', 1, '2023-11-24 13:44:16', NULL),
(352, 'INICIO LOSA CONTRATERRENO EN CUARTO DE BOMBAS', 'GESTION DE INGRESO PERSONAL/SC', 4, '2023-11-20 12:00:00', 48, NULL, '3', '51', 50, 23, 14, 140, '2023-11-27 12:00:00', '2023-11-29 19:18:32', '0.00000', 1, '2023-11-24 13:44:16', NULL),
(353, 'INICIO LOSA CONTRATERRENO EN CUARTO DE BOMBAS', 'GESTION DE INGRESO PERSONAL/SC', 7, '2023-11-18 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2023-12-01 12:00:00', '2023-12-13 23:22:20', '0.00000', 1, '2023-11-24 13:44:16', NULL),
(354, 'EEMM Azotea', 'Llegada de planchas para embebir en losa de techo', 5, '2023-12-21 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-12-21 12:00:00', '2023-12-22 10:58:02', '9.00000', 1, '2023-11-30 07:55:50', NULL),
(355, 'Vestuarios de obreros', 'Habilitar Duchas y vestuarios en piso 1', 2, '2023-12-07 12:00:00', 64, NULL, '3', '57', 2, 2, 4, 132, '2023-12-07 12:00:00', '2023-12-07 09:09:45', '3.00000', 1, '2023-11-30 07:58:48', NULL),
(356, 'Tabiquería Piso 10', 'Coordinar con JM telescopaje de elevador', 6, '2023-12-15 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2023-12-15 12:00:00', '2023-12-16 11:15:52', '6.00000', 1, '2023-11-30 08:01:23', NULL),
(357, 'Malla anticaídas', 'Coordinar con SC de mallas la instalación en el techo del piso 14', 7, '2023-12-13 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-12-13 12:00:00', '2023-12-12 16:21:42', '6.00000', 1, '2023-11-30 08:05:39', NULL),
(358, 'Carpintería metálica', 'Adjudicar SC para escaleras y ventanas en cisternas', 7, '2023-12-22 12:00:00', 9, NULL, '3', '57', 37, 21, 4, 132, '2023-12-20 12:00:00', '2023-12-20 10:03:47', '3.00000', 1, '2023-11-30 08:11:34', NULL),
(359, 'Losa de piso cuarto de bombas', 'Detalle de bases y sardineles para equipos en cuarto de bombas', 3, '2024-01-16 12:00:00', 62, NULL, '3', '57', 37, 21, 4, 132, '2024-01-15 12:00:00', '2024-01-16 18:07:14', '4.00000', 1, '2023-11-30 08:12:29', NULL),
(360, 'Instalaciones enterradas', 'Ingreso de personal de SC para trabajos de instalaciones enterradas', 4, '2023-12-20 12:00:00', 62, NULL, '3', '57', 38, 21, 4, 132, '2023-12-19 12:00:00', '2023-12-22 10:57:52', '2.00000', 1, '2023-11-30 08:13:17', NULL),
(361, 'EEMM Azotea', 'Envío de planos para aprobación', 3, '2023-12-08 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-12-08 12:00:00', '2023-12-08 07:32:45', '10.00000', 1, '2023-12-04 23:52:33', NULL),
(362, 'EEMM en ascensor', 'Envío de planos para aprobación', 3, '2023-12-12 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2023-12-12 12:00:00', '2023-12-12 16:21:56', '11.00000', 1, '2023-12-04 23:53:39', NULL),
(368, 'Mov. Tierras sala grupos electrogenos', 'Definición cimentacion grupos', 11, '2024-04-12 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-04-17 12:00:00', '2024-05-07 13:59:41', '0.00000', 1, '2023-12-05 07:01:27', 1883),
(370, 'EJECUCIÓN POYOS PARA TRANSFORMADORES', '', 11, '2024-01-09 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-01-14 12:00:00', '2024-02-27 11:06:41', '0.00000', 1, '2023-12-05 07:01:27', 715),
(371, 'Ejecución poyos para transformador3es', 'Pendiente respuesta RFI N°247', 11, '2024-01-14 12:00:00', 50, NULL, '3', '51', 53, 23, 14, 140, '2024-01-14 12:00:00', '2024-04-10 17:29:50', '0.00000', 1, '2023-12-05 07:01:27', 1492),
(373, 'ENTREGA TABIQUERÍA', 'PENDIENTE RESPUESTA RFI N°288 POR INCOMPATIBILIDADES EN VENTANAS S1, S2 Y P1', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-16 10:11:47', '0.00000', 1, '2023-12-05 07:01:35', 940),
(374, 'TABIQUERÍA SOTANOS', 'PENDIENTE RESPUESTA RFI N°289 TIPO DE TABIQUE DEBIDO A ABERTURAS DE UMAS', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-27 10:57:08', '0.00000', 1, '2023-12-05 07:01:35', 1176),
(377, 'TABIQUERÍA SOTANOS', 'PENDIENTE RESPUESTA RFI N°289 TIPO DE TABIQUE DEBIDO A ABERTURAS DE UMAS', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-02-21 12:00:00', '2024-04-01 09:41:27', '0.00000', 1, '2023-12-05 07:01:35', 1208),
(379, 'TABIQUERÍA SOTANOS', 'PENDIENTE RESPUESTA RFI N°289 TIPO DE TABIQUE DEBIDO A ABERTURAS DE UMAS', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-22 14:01:09', '0.00000', 1, '2023-12-05 07:01:35', 1098),
(382, 'Ejecución poyos para transformador3es', 'Pendiente respuesta RFI N°247', 11, '2024-01-14 12:00:00', 50, NULL, '3', '51', 53, 23, 14, 140, '2024-01-14 12:00:00', '2024-04-22 07:31:25', '0.00000', 1, '2023-12-05 07:01:35', 1671),
(385, 'Tarrajeo fachadas', 'Grua para izaje', 7, '2024-04-15 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-04-15 12:00:00', '2024-04-22 07:31:20', '0.00000', 1, '2023-12-05 07:01:39', 1670),
(386, 'EJECUCIÓN POYOS PARA TRANSFORMADORES', '', 11, '2024-01-09 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-01-14 12:00:00', '2024-02-15 11:35:43', '0.00000', 1, '2023-12-05 07:01:39', 434),
(387, 'Asentado ladrillo', 'Pendiente adjudicación sc sardineles', 7, '2024-01-11 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-01-10 12:00:00', '2024-01-22 11:12:24', '0.00000', 1, '2023-12-05 07:01:39', NULL),
(388, 'EJECUCIÓN POYOS PARA TRANSFORMADORES', '', 11, '2024-01-09 12:00:00', 50, NULL, '3', '51', 51, 23, 14, 140, '2024-01-14 12:00:00', '2024-04-02 10:09:06', '0.00000', 1, '2023-12-05 07:01:39', 1221),
(394, 'Excavación de Cerco de Cárcamo', 'No hay volquete de eliminación para liberar espacio y poder trazar y comenzar a excavar', 6, '2023-11-27 12:00:00', 113, NULL, '3', '33', 54, 25, 22, 142, NULL, '2024-01-15 12:22:41', '0.00000', 1, '2023-12-06 11:13:45', NULL),
(395, 'Relleno y compactación', 'No se tiene las áreas liberadas para poder descargar el afirmado para el relleno y compactación', 6, '2023-11-27 12:00:00', 80, NULL, '3', '33', 54, 25, 22, 142, '2023-12-08 12:00:00', '2023-12-25 23:58:06', '1.00000', 1, '2023-12-06 11:20:15', NULL),
(396, 'Control de eliminación y llegada de afirmado', 'Enviar la cantidad de volquetes de eliminación y afirmado que ha ingresado a obra', 3, '2023-11-27 12:00:00', 93, NULL, '3', '33', 54, 25, 22, 142, NULL, '2024-05-03 21:44:40', '2.00000', 0, '2023-12-06 11:23:37', 1835),
(397, 'Colocación de ojos chino', 'Llegada de los ojos chinos para la colocación en las columnas del activo 471', 5, '2023-12-04 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, '2023-12-22 12:00:00', '2023-12-25 23:57:55', '0.00000', 1, '2023-12-06 12:10:31', NULL),
(398, 'Asentado de ladrillo', 'Adjudicación de contratista para poder realizar las coordinaciones de programación', 7, '2023-12-04 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, '2023-12-15 12:00:00', '2024-01-07 22:00:09', '1.00000', 1, '2023-12-06 12:19:35', NULL),
(399, 'Asentado de ladrillo', 'Llegada de ladrillo , embolsado para su ejecución', 5, '2023-12-04 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, '2023-12-14 12:00:00', '2024-01-07 22:00:14', '2.00000', 1, '2023-12-07 09:37:41', NULL),
(400, 'Asentado de ladrillo', 'Llegada de acero para el acero vertical y horizontal', 5, '2023-12-04 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, '2024-01-08 12:00:00', '2024-01-13 00:06:06', '3.00000', 1, '2023-12-07 09:39:19', NULL),
(401, 'Asentado de ladrillo', 'Llegada de andamios para el asentado de ladrillo', 6, '2023-12-04 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-01-22 22:43:59', '4.00000', 1, '2023-12-07 09:40:17', NULL),
(402, 'Asentado de ladrillo', 'Envío y aprobación de procedimiento de acentado de ladrillo', 10, '2023-12-04 12:00:00', 120, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-06 03:47:23', '5.00000', 1, '2023-12-07 09:42:21', 114),
(403, 'Tarrajeo de fachada', 'Definir sistema de andamios a usar', 1, '2023-12-26 12:00:00', 64, NULL, '3', '57', 44, 22, 4, 132, '2023-12-26 12:00:00', '2023-12-22 10:58:21', '0.00000', 1, '2023-12-07 10:06:45', NULL),
(404, 'Tarrajeo de fachada', 'Definir SC para tarrajeo de fachada', 7, '2023-12-26 12:00:00', 9, NULL, '3', '57', 44, 22, 4, 132, '2023-12-26 12:00:00', '2023-12-16 13:54:19', '1.00000', 1, '2023-12-07 10:07:17', NULL),
(406, 'Pintura de baños, cocinas y CR', 'Adjudicar SC para pintura de baños y cocinas', 10, '2024-01-15 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2024-01-06 12:00:00', '2024-01-09 08:02:00', '9.00000', 1, '2023-12-14 09:32:09', NULL),
(407, 'Pintura de baños, cocinas y CR', 'Ingreso de personal para pintura de baños y cocinas', 7, '2024-01-30 12:00:00', 132, NULL, '3', '57', 42, 22, 4, 132, '2024-01-30 12:00:00', '2024-01-31 13:41:20', '10.00000', 1, '2023-12-14 10:35:31', 89),
(408, 'Pintura de baños, cocinas y CR', 'Establecer PETS de Pintura', 3, '2024-01-15 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2024-01-10 12:00:00', '2024-01-10 07:33:11', '11.00000', 1, '2023-12-14 10:36:49', NULL),
(409, 'Papel Mural', 'Adjudicar SC para colocación de papel Mural', 10, '2024-01-15 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2024-01-15 12:00:00', '2023-12-14 10:42:14', '12.00000', 1, '2023-12-14 10:41:21', NULL),
(410, 'Papel Mural', 'Establecer PETS de colocación de papel', 3, '2024-02-19 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2024-02-19 12:00:00', '2024-02-20 10:02:33', '13.00000', 1, '2023-12-14 10:44:24', 572),
(411, 'Papel Mural', 'Ingreso de personal para Empaste de muros con papel', 7, '2024-02-14 12:00:00', 132, NULL, '3', '57', 42, 22, 4, 132, '2024-02-14 12:00:00', '2024-02-13 17:53:17', '14.00000', 1, '2023-12-14 10:45:37', 397),
(412, 'Espuma CF en tabiques', 'Ingreso de personal de SC para colocación de espuma CF', 4, '2023-12-18 12:00:00', 132, NULL, '3', '57', 42, 22, 4, 132, '2023-12-18 12:00:00', '2023-12-19 10:58:41', '15.00000', 1, '2023-12-14 13:57:31', NULL),
(413, 'Ventanas y mamparas', 'Adjudicar SC de ventanas y Mamparas', 10, '2024-01-18 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2024-01-08 12:00:00', '2023-12-14 14:02:50', '16.00000', 1, '2023-12-14 13:58:59', NULL);
INSERT INTO `anares_actividad` (`codAnaResActividad`, `desActividad`, `desRestriccion`, `codTipoRestriccion`, `dayFechaRequerida`, `idUsuarioResponsable`, `desAreaResponsable`, `codEstadoActividad`, `codUsuarioSolicitante`, `codAnaResFase`, `codAnaResFrente`, `codProyecto`, `codAnaRes`, `dayFechaConciliada`, `dayFechaLevantamiento`, `numOrden`, `flgNoti`, `dayFechaCreacion`, `codAnaResActividadTrackLast`) VALUES
(414, 'Ventanas y Mamparas', 'Establecer PETS de colocación de ventanas y mamparas', 3, '2024-02-19 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2024-02-19 12:00:00', '2024-02-20 10:02:38', '17.00000', 1, '2023-12-14 14:01:47', 573),
(415, 'Ventanas y Mamparas', 'Llegada de Marcos, ventas y mamparas', 5, '2024-03-04 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2024-03-04 12:00:00', '2024-03-02 08:04:57', '18.00000', 1, '2023-12-14 14:03:14', 753),
(416, 'Ventanas y Mamparas', 'Ingreso de personal para instalación', 4, '2024-02-19 12:00:00', 132, NULL, '3', '57', 42, 22, 4, 132, '2024-02-19 12:00:00', '2024-02-20 10:02:51', '20.00000', 1, '2023-12-14 14:04:29', 576),
(417, 'Ingreso sc acabados', 'Adjudicación sc tabiquería', 7, '2023-11-30 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2023-12-06 12:00:00', '2024-01-03 09:02:13', '0.00000', 1, '2023-12-19 07:06:25', NULL),
(419, 'Instalación de EEMM', 'Envío y aprobación de procedimiento de EEMM SUM', 10, '2023-12-26 12:00:00', 86, NULL, '3', '33', 57, 25, 22, 142, '2023-12-29 12:00:00', '2024-01-07 22:02:41', '0.00000', 1, '2023-12-25 23:56:50', NULL),
(420, 'Instalación de EEMM', 'Envío y aprobación de ETOS de EEMM LOSA DEPORTIVA', 10, '2024-01-01 12:00:00', 114, NULL, '3', '33', 57, 25, 22, 142, NULL, '2024-02-12 17:01:04', '1.00000', 1, '2023-12-26 00:00:00', 302),
(421, 'Instalación de EEMM', 'Envío y aprobación de ETOS de EEMM PORTON DE INGRESO', 10, '2024-01-01 12:00:00', 80, NULL, '3', '33', 57, 25, 22, 142, NULL, '2024-02-12 17:01:11', '3.00000', 1, '2023-12-26 00:01:32', 303),
(422, 'Instalación de EEMM', 'Llegada de EEMM SUM', 5, '2023-12-26 12:00:00', 114, NULL, '3', '33', 57, 25, 22, 142, NULL, '2024-01-22 22:46:53', '2.00000', 1, '2023-12-26 00:02:10', NULL),
(423, 'Instalación de acero', 'Llegada de acero de muro de cárcamo para su instalación', 5, '2023-12-28 12:00:00', 80, NULL, '3', '33', 56, 25, 22, 142, '2024-01-02 12:00:00', '2024-02-12 17:05:35', '0.00000', 1, '2023-12-26 00:04:20', 304),
(424, 'Instalación de encofrado de techo', 'Descencofrado del activo 417-416 para usar el material para el encofrado de techo del activo 471', 5, '2024-01-05 12:00:00', 82, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-01-07 11:00:47', '1.00000', 1, '2023-12-26 00:04:49', NULL),
(425, 'Instalación de ladrillo de techo', 'Llegada de ladrillo para la instalación en el activo 471', 5, '2024-01-05 12:00:00', 80, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-02-12 17:05:42', '2.00000', 1, '2023-12-26 00:06:05', 305),
(426, 'Instalación de acero', 'Enviar personal a instalar el acero del activo 471', 4, '2023-12-27 12:00:00', 80, NULL, '3', '33', 56, 25, 22, 142, '2023-12-25 12:00:00', '2024-01-07 22:01:54', '3.00000', 1, '2023-12-26 00:06:49', NULL),
(427, 'Instalación de acero', 'Enviar personal a instalar el acero de cimentación del activo de Cárcamo', 4, '2023-12-26 12:00:00', 80, NULL, '3', '33', 56, 25, 22, 142, '2024-01-13 12:00:00', '2024-02-12 17:05:53', '4.00000', 1, '2023-12-26 00:09:03', 306),
(428, 'RELLENO ACTIVO 469', 'MANO DE OBRA DEL SUBCONTRATA', 4, '2024-01-08 12:00:00', 80, NULL, '3', '69', 62, 27, 22, 142, NULL, '2024-01-22 22:50:32', '0.00000', 1, '2024-01-03 16:03:23', NULL),
(429, 'RELLENO ACTIVO 469', 'EQUIPOS Y HERRAMIENTAS DEL SUBCONTRATA', 6, '2024-01-08 12:00:00', 80, NULL, '3', '69', 62, 27, 22, 142, NULL, '2024-01-22 22:50:37', '1.00000', 1, '2024-01-03 16:05:36', NULL),
(430, 'Desencofrado, albañilería', 'Suministro e instalación de chute de eliminación.', 1, '2023-12-11 12:00:00', 80, NULL, '3', '67', 60, 26, 22, 142, '2024-01-05 12:00:00', '2024-02-06 03:47:59', '0.00000', 1, '2024-01-03 23:36:22', 115),
(432, 'VACIADO DE ELEMENTOS VERTICALES (RAMPA)', 'Mapeo y reparación de cimentaciones fisuradas', 9, '2024-01-08 12:00:00', 120, NULL, '3', '71', 63, 18, 22, 142, '2024-01-08 12:00:00', '2024-01-15 12:21:28', '0.00000', 1, '2024-01-07 10:18:16', NULL),
(433, 'INICIO DE REPARACIÓN DE ELEMENTOS ESTRUCTURALES', 'Ingreso de MO para reparación de elementos observados en el post vaciado', 4, '2024-01-10 12:00:00', 113, NULL, '3', '71', 63, 18, 22, 142, '2024-01-10 12:00:00', '2024-03-11 17:40:03', '1.00000', 1, '2024-01-07 10:20:25', 900),
(435, 'Nivelación de terreno sitio', 'Se necesita el los planos exportados del modelo BIM para niveles de terreno', 3, '2023-12-15 12:00:00', 123, NULL, '1', '67', 59, 26, 22, 142, '2024-01-22 12:00:00', NULL, '1.00000', 1, '2024-01-07 10:22:18', NULL),
(436, 'ENCOFRADO DE ELEMENTOS VERTICALES (RAMPA)', 'Aprobación de encofrado a utilizar para columnas circulares', 3, '2024-01-08 12:00:00', 80, NULL, '3', '71', 63, 18, 22, 142, '2024-01-08 12:00:00', '2024-01-15 12:21:49', '2.00000', 1, '2024-01-07 10:22:41', NULL),
(437, 'LOSA CONTRA TERRENO', 'Ingreso de personal y equipos para relleno y compactación', 4, '2024-01-09 12:00:00', 113, NULL, '3', '71', 63, 18, 22, 142, '2024-01-09 12:00:00', '2024-01-15 12:21:58', '3.00000', 1, '2024-01-07 10:24:19', NULL),
(438, 'Corte y relleno de terreno en exteriores.', 'Revisión de incompatibilidades en los exteriores', 3, '2023-12-15 12:00:00', 123, NULL, '1', '67', 59, 26, 22, 142, '2024-01-22 12:00:00', NULL, '2.00000', 1, '2024-01-07 10:24:40', 899),
(439, 'PUENTE METALICO', 'Visita a planta con calidad del consorcio para VB de los elementos fabricados', 9, '2024-01-09 12:00:00', 120, NULL, '3', '71', 58, 18, 22, 142, '2024-01-09 12:00:00', '2024-01-22 22:40:25', '0.00000', 1, '2024-01-07 10:28:05', NULL),
(440, 'ENTREGA POST VACIADO', 'Conciliación de criterios para la entrega de elementos post vaciado', 9, '2024-01-08 12:00:00', 120, NULL, '3', '71', 63, 18, 22, 142, '2024-01-08 12:00:00', '2024-01-15 12:22:29', '4.00000', 1, '2024-01-07 10:29:09', NULL),
(441, 'Demolición, excavación de cimentación', 'Confirmación de retiro del cerco perimétrico en zona de vecinos. ( retiro para excavación)', 3, '2024-01-08 12:00:00', 77, NULL, '3', '67', 59, 26, 22, 142, '2024-01-08 12:00:00', '2024-01-22 22:47:25', '4.00000', 1, '2024-01-07 10:32:03', NULL),
(442, 'LIBERACION DE PISOS (416 Y 417)', 'Inicio de trabajos de asentado y anclaje', 8, '2024-01-08 12:00:00', 112, NULL, '3', '71', 64, 18, 22, 142, '2024-01-08 12:00:00', '2024-01-09 13:02:47', '0.00000', 1, '2024-01-07 10:37:01', NULL),
(443, 'Nivelación de terreno', 'Se necesita devolver todo el encofrado de Los activos', 2, '2023-12-26 12:00:00', 80, NULL, '3', '67', 59, 26, 22, 142, '2024-01-09 12:00:00', '2024-02-06 03:48:06', '0.00000', 1, '2024-01-07 10:43:47', 116),
(444, 'Entrega de planos,', 'compatibilización de planos de estructura en exteriores.', 5, '2024-01-15 12:00:00', 123, NULL, '2', '67', 60, 26, 22, 142, '2024-01-16 12:00:00', NULL, '1.00000', 1, '2024-01-07 10:44:56', NULL),
(445, 'Relleno y compactación Cárcamo', 'No se tiene los equipos y personal para realizar la actividad', 7, '2024-01-08 12:00:00', 113, NULL, '3', '33', 54, 25, 22, 142, NULL, '2024-02-19 19:13:38', '3.00000', 1, '2024-01-07 21:56:32', 563),
(446, 'Relleno y compactación Activo 470', 'No se tiene los equipos y personal para realizar la actividad', 7, '2024-01-08 12:00:00', 113, NULL, '3', '33', 54, 25, 22, 142, '2024-01-13 12:00:00', '2024-01-13 00:05:19', '4.00000', 1, '2024-01-07 21:56:52', NULL),
(447, 'Relleno y compactación Activo 474-476', 'No se tiene los equipos y personal para realizar la actividad', 7, '2024-01-10 12:00:00', 113, NULL, '3', '33', 54, 25, 22, 142, '2024-01-13 12:00:00', '2024-01-13 00:05:36', '5.00000', 1, '2024-01-07 21:58:46', NULL),
(448, 'Instalación de acero', 'Llegada de acero de cerco perimétrico al costado del 455-470', 5, '2024-01-08 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, '2024-01-17 12:00:00', '2024-01-18 16:09:51', '5.00000', 1, '2024-01-07 22:03:41', NULL),
(449, 'Realización de falsa zapatas en cárcamo', 'Aprobación de adicional para la realización de la falsa zapata', 11, '2024-01-08 12:00:00', 80, NULL, '3', '33', 56, 25, 22, 142, '2024-01-16 12:00:00', '2024-01-18 16:10:05', '6.00000', 1, '2024-01-07 23:29:16', NULL),
(450, 'Asentado ladrillo', 'Pendiente adjudicación sc sardineles', 7, '2024-01-11 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-10 12:00:00', '2024-02-13 12:22:09', '0.00000', 1, '2024-01-08 10:47:14', 384),
(451, 'Vaciado contrapisos', 'Pendiente adjudicación sc vaciado', 7, '2024-01-11 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-11 12:00:00', '2024-01-23 09:55:04', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(452, 'Revoque/Asentado', 'Llegada andamios para sc', 7, '2024-01-09 12:00:00', 104, NULL, '3', '51', 65, 23, 14, 140, '2024-01-08 12:00:00', '2024-01-16 14:36:42', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(453, 'Revoque - Sotano 2', 'Destensado anclajes', 7, '2024-01-24 12:00:00', 48, NULL, '3', '51', 65, 23, 14, 140, '2024-01-24 12:00:00', '2024-01-23 09:55:19', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(454, 'Corte en losas de piso', 'Pendiente adjudicación sc de corte juntas', 7, '2024-01-08 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-01-10 12:00:00', '2024-01-23 09:54:59', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(455, 'Vaciado losa contraterreno', 'Pendiente adjudicación sc de vaciado losa contraterreno', 7, '2024-01-10 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-10 12:00:00', '2024-01-16 14:36:57', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(456, 'Impermeabilización cisternas', 'Pendiente adjudicación sc', 7, '2024-01-10 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-12 12:00:00', '2024-01-23 09:55:13', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(457, 'Ejecución escalera', 'Pendiente respuesta RFI N°238 viga', 11, '2024-01-09 12:00:00', 50, NULL, '3', '51', 67, 23, 14, 140, '2024-01-09 12:00:00', '2024-01-23 09:55:39', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(458, 'Acero viga piso 5', 'Pendiente respuesta RFI N°238 detalle viga', 11, '2024-01-08 12:00:00', 50, NULL, '3', '51', 67, 23, 14, 140, '2024-01-08 12:00:00', '2024-02-13 12:21:54', '0.00000', 1, '2024-01-08 10:47:14', 382),
(459, 'Revoque - sotano 1', 'Llegada de extractores adicionales', 6, '2024-01-09 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-09 12:00:00', '2024-01-23 09:55:16', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(460, 'Encofrado doble altura', 'Llegada de fenólico', 5, '2024-01-09 12:00:00', 53, NULL, '3', '51', 67, 23, 14, 140, '2024-01-09 12:00:00', '2024-01-16 14:36:53', '0.00000', 1, '2024-01-08 10:47:14', NULL),
(461, 'Muebles de melamina', 'Ingreso de SC de instalación de muebles.', 4, '2024-02-24 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-02-24 12:00:00', '2024-02-23 13:48:31', '6.00000', 1, '2024-01-09 08:00:10', 700),
(464, 'Inicio de escarchado', 'Liberación de acabados para inicio de esarchado', 9, '2024-02-19 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-02-19 12:00:00', '2024-02-20 10:03:11', '7.00000', 1, '2024-01-09 08:09:20', 580),
(465, 'EEMM Piso 17', 'Definición de tipo de Vigas enviado en RFI 65', 3, '2024-01-15 12:00:00', 9, NULL, '3', '57', 42, 22, 4, 132, '2024-01-15 12:00:00', '2024-01-16 18:09:54', '19.00000', 1, '2024-01-09 08:13:10', NULL),
(466, 'Pozo sumidero 1', 'Definir cota de fondo de pozo sumidero RFI 65', 3, '2024-01-15 12:00:00', 9, NULL, '3', '57', 38, 21, 4, 132, '2024-01-15 12:00:00', '2024-01-16 18:07:19', '3.00000', 1, '2024-01-09 08:15:12', NULL),
(468, 'Devolución de encofrado', 'corte y nivelación de vigas de cimentación activo 469', 1, '2024-01-11 12:00:00', 80, NULL, '3', '69', 69, 27, 22, 142, NULL, '2024-02-12 17:09:36', '0.00000', 1, '2024-01-09 10:46:49', 311),
(469, 'Devolución de encofrado', 'excavación localizada rampa de acceso 2', 1, '2024-01-11 12:00:00', 80, NULL, '3', '69', 69, 27, 22, 142, NULL, '2024-02-12 17:09:42', '1.00000', 1, '2024-01-09 10:50:16', 312),
(470, 'CERCO METALICO CERCO TIPO VI', 'adjudicación cerco tipo VI', 7, '2024-01-12 12:00:00', 113, NULL, '1', '69', 70, 27, 22, 142, NULL, NULL, '0.00000', 1, '2024-01-09 11:01:50', NULL),
(471, 'Etos patios de juegos', 'Etos no aprobados', 7, '2024-01-12 12:00:00', 113, NULL, '1', '69', 70, 27, 22, 142, NULL, NULL, '1.00000', 1, '2024-01-09 11:04:10', NULL),
(474, 'Armado de escalera de acceso de 1 vía', 'Llegada de escalera de acceso de 1 vía (H=3.7 m + baranda)', 12, '2024-02-07 12:00:00', 139, NULL, '3', '73', 73, 30, 28, 148, '2024-02-07 12:00:00', '2024-01-20 12:04:16', '13.00000', 1, '2024-01-12 16:35:11', NULL),
(475, 'Vaciado de muros', 'Envío de detalles de muros en zona de cocina activo 471', 3, '2024-01-13 12:00:00', 125, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-12 16:58:40', '6.00000', 1, '2024-01-13 00:06:42', 299),
(476, 'Vaciado de techo', 'Llegada de ladrillo de techo para zona de cocina y depósito', 5, '2024-01-17 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-12 16:58:44', '7.00000', 1, '2024-01-13 00:07:54', 300),
(477, 'Vaciado de dinteles', 'Llegada de acero para la colocación de los dinteles', 5, '2024-01-17 12:00:00', 82, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-12 16:58:50', '8.00000', 1, '2024-01-13 00:08:49', 301),
(478, 'Asentado de ladrillo', 'Colocación de IIEE-ISS en los muros para poder asentar los ladrillos activo 474-476', 4, '2024-01-16 12:00:00', 83, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-01-23 12:14:06', '9.00000', 1, '2024-01-13 00:09:28', NULL),
(479, 'Asentado de ladrillo', 'Incremento de personal para asegurar el avance requerido', 7, '2024-01-15 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-03-11 17:42:50', '10.00000', 1, '2024-01-13 00:11:25', 904),
(480, 'Asentado de ladrillo', 'Detalle de muebles fijos de la zona de cocina 471', 3, '2024-01-15 12:00:00', 118, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-03-11 17:42:33', '11.00000', 1, '2024-01-13 00:12:13', 903),
(481, 'Cobertura de techo pastelero', 'Adjudicación de la partida para comenzar coordinaciones', 7, '2024-01-18 12:00:00', 80, NULL, '1', '33', 55, 25, 22, 142, NULL, NULL, '12.00000', 1, '2024-01-13 00:14:56', NULL),
(482, 'Cobertura de SUM', 'Adjudicación de la partida para comenzar coordinaciones', 7, '2024-01-18 12:00:00', 115, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-03-11 17:43:18', '13.00000', 1, '2024-01-13 00:15:40', 905),
(483, 'Cobertura de SUM', 'Envío y aprobación de procedimiento de colocación de cobertura', 10, '2024-01-19 12:00:00', 86, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-03-11 17:43:22', '14.00000', 1, '2024-01-13 00:16:17', 906),
(484, 'Cobertura de techo pastelero', 'Envío y aprobación de procedimiento de colocación de ladrillo pastelero', 10, '2024-01-19 12:00:00', 86, NULL, '1', '33', 55, 25, 22, 142, NULL, NULL, '15.00000', 1, '2024-01-13 00:16:59', NULL),
(485, 'Colocación de Mesones', 'Adjudicación de la partida para comenzar coordinaciones', 7, '2024-01-22 12:00:00', 115, NULL, '1', '33', 55, 25, 22, 142, NULL, NULL, '16.00000', 1, '2024-01-13 00:18:52', NULL),
(487, 'Colocación de Mesones', 'Envío y aprobación de procedimiento de colocación de ladrillo pastelero', 10, '2024-01-22 12:00:00', 86, NULL, '1', '33', 55, 25, 22, 142, NULL, NULL, '17.00000', 1, '2024-01-13 00:19:10', NULL),
(488, 'Losa contraterreno', 'Envio y aprobación de juntas para losa contraterreno', 3, '2024-01-16 12:00:00', 118, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-05-03 21:44:47', '18.00000', 0, '2024-01-13 00:19:44', 1836),
(489, 'Losa contraterreno', 'Llegada de tecnopor para los vaciados de losa', 5, '2024-01-16 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-19 19:14:20', '19.00000', 1, '2024-01-13 00:20:23', 565),
(490, 'Losa contraterreno', 'Llegada de alisadora para el semipulido y Cortadora de piso', 6, '2024-01-18 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-19 19:14:16', '20.00000', 1, '2024-01-13 00:21:07', 564),
(491, 'Losa contraterreno', 'Sin la cobertura instalada la colocación losa contraterreno quedaría desprotegida', 1, '2024-01-23 12:00:00', 115, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-02-19 19:14:23', '21.00000', 1, '2024-01-13 00:22:19', 566),
(492, 'Vaciado de losa contraterreno', 'Pendiente respuesta RFI N°252 Juntas losa contraterreno', 11, '2024-01-16 12:00:00', 50, NULL, '3', '51', 67, 23, 14, 140, '2024-01-16 12:00:00', '2024-01-23 09:55:45', '0.00000', 1, '2024-01-16 14:56:51', NULL),
(493, 'Ejecución poyos para transformador3es', 'Pendiente respuesta RFI N°247', 11, '2024-01-14 00:00:00', 50, NULL, '2', '51', 67, 23, 14, 140, '2024-01-14 00:00:00', NULL, '0.00000', 1, '2024-01-16 14:56:51', NULL),
(494, 'Inicio revoques piso 2', 'Incremento personal', 7, '2024-01-15 00:00:00', 48, NULL, '3', '51', 65, 23, 14, 140, '2024-01-15 00:00:00', NULL, '0.00000', 1, '2024-01-16 14:56:51', NULL),
(495, 'Asentado tabiquería piso 1', 'Envío y aprobación ancho de muros', 3, '2024-01-15 12:00:00', 104, NULL, '3', '51', 65, 23, 14, 140, '2024-01-15 12:00:00', '2024-01-23 09:55:08', '0.00000', 1, '2024-01-16 14:56:51', NULL),
(496, 'Sardineles para tabiques piso 1', 'Pendiente respuesta rfi N°248 sardineles', 11, '2024-01-16 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-16 12:00:00', '2024-01-23 09:55:31', '0.00000', 1, '2024-01-16 14:56:51', NULL),
(498, 'Solaqueo rampa sotano 1', 'Llegada de andamios', 12, '2024-01-20 12:00:00', 104, NULL, '3', '51', 65, 23, 14, 140, '2024-01-20 12:00:00', '2024-01-16 14:57:11', '0.00000', 1, '2024-01-16 14:56:51', NULL),
(499, 'Instalación de aparatos Sanitarios', 'Seguimiento a llegada de aparatos sanitarios', 5, '2024-02-12 12:00:00', 62, NULL, '3', '57', 43, 22, 4, 132, '2024-02-09 12:00:00', '2024-01-16 18:36:13', '8.00000', 1, '2024-01-16 18:21:54', NULL),
(500, 'Instalación de griferías', 'Seguimiento a llegada de griferías', 5, '2024-02-13 12:00:00', 62, NULL, '3', '57', 43, 22, 4, 132, '2024-02-09 12:00:00', '2024-01-16 18:36:23', '9.00000', 1, '2024-01-16 18:23:16', NULL),
(501, 'Tarrajeo de Fachada 2do tramo', 'Llegada de andamios colgantes', 6, '2024-02-19 12:00:00', 9, NULL, '3', '57', 44, 22, 4, 132, '2024-02-15 12:00:00', '2024-02-20 10:03:28', '3.00000', 1, '2024-01-16 18:24:22', 582),
(502, 'Tarrajeo de Fachada 2do tramo', 'Culminación de tabiques de Fachada', 1, '2024-02-19 12:00:00', 61, NULL, '3', '57', 44, 22, 4, 132, '2024-02-16 12:00:00', '2024-02-20 10:03:24', '2.00000', 1, '2024-01-16 18:25:39', 581),
(503, 'Instalación de piso laminado', 'Llegada de piso laminado a obra', 5, '2024-02-12 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2024-02-07 12:00:00', '2024-01-16 18:36:37', '10.00000', 1, '2024-01-16 18:27:57', NULL),
(505, 'Instalación de piso laminado', 'ingreso de personal para instalación de piso laminado', 4, '2024-03-26 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-03-26 12:00:00', '2024-03-27 10:18:48', '12.00000', 1, '2024-01-16 18:29:14', 1162),
(506, 'Ascensores', 'Liberar caja de ascensores para inicio de montaje', 1, '2024-04-15 12:00:00', 64, NULL, '3', '57', 42, 22, 4, 132, '2024-04-13 12:00:00', '2024-04-16 08:05:48', '21.00000', 1, '2024-01-16 18:32:05', 1530),
(507, 'Ascensores', 'Liberar zona asignada a almacén de ascensores', 1, '2024-01-24 12:00:00', 61, NULL, '3', '57', 40, 21, 4, 132, '2024-01-23 12:00:00', '2024-01-23 16:27:52', '0.00000', 1, '2024-01-16 18:33:47', NULL),
(508, 'Ascensores', 'Armando de Almacén de ascensores', 1, '2024-01-25 12:00:00', 64, NULL, '3', '57', 40, 21, 4, 132, '2024-01-25 12:00:00', '2024-01-26 13:51:22', '1.00000', 1, '2024-01-16 18:34:36', 76),
(509, 'Canaleta de instalaciones', 'Excavación por parte INGEDEMO', 4, '2024-01-17 12:00:00', 113, NULL, '3', '33', 54, 25, 22, 142, '2024-01-18 12:00:00', '2024-01-22 22:43:51', '6.00000', 1, '2024-01-18 12:03:59', NULL),
(510, 'Instalación de acero', 'Personal para instalación de las vigas soleras de los muros del SUM-471', 4, '2024-01-18 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-02-12 17:05:59', '7.00000', 1, '2024-01-18 12:33:51', 307),
(511, 'Instalación de encofrado', 'No se tiene personal de TSCOSIN para la partida de encofrado de las vigas soleras  471', 4, '2024-01-19 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-02-12 17:06:16', '8.00000', 1, '2024-01-18 12:38:25', 308),
(512, 'Instalación de encofrado', 'No se tiene personal necesario para el encofrado de vigas y losas', 4, '2024-01-19 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-03-11 17:41:05', '9.00000', 1, '2024-01-18 12:39:08', 901),
(513, 'Instalación de ladrillo de techo', 'Llegada de material para la instalación de ladrillo', 5, '2024-01-19 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-01-22 22:46:36', '10.00000', 1, '2024-01-18 12:40:43', NULL),
(514, 'Instalación de ladrillo de techo', 'Falta de personal del contratista TSCONSIN con el fin de poder realizar la instalación', 4, '2024-01-19 12:00:00', 113, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-02-12 17:09:18', '11.00000', 1, '2024-01-18 12:41:14', 309),
(515, 'Construcción de columnas de concreto en cerco', 'Falta suministro de planchas metállicas', 7, '2024-01-15 12:00:00', 80, NULL, '1', '67', 61, 26, 22, 142, '2024-02-21 12:00:00', NULL, '0.01000', 1, '2024-01-18 13:52:29', NULL),
(516, 'Demolición, excavación de cimentación', 'Confirmación de la constatación notarial', 2, '2024-01-08 12:00:00', 84, NULL, '3', '67', 59, 26, 22, 142, '2024-01-08 12:00:00', '2024-02-06 03:48:51', '5.00000', 1, '2024-01-18 13:53:14', 118),
(517, 'Relleno y compactación 417', 'Ingreso de MO y EQ', 4, '2024-01-19 12:00:00', 113, NULL, '3', '71', 28, 18, 22, 142, NULL, '2024-01-22 22:40:19', '0.01000', 1, '2024-01-18 15:26:43', NULL),
(518, 'ENCOFRADO DE ESCALERA, RAMPA #2, VC Y PARASOLES', 'Ingreso de MO', 4, '2024-01-22 12:00:00', 113, NULL, '3', '71', 63, 18, 22, 142, '2024-01-22 12:00:00', '2024-02-06 03:51:04', '5.00000', 1, '2024-01-18 15:28:36', 127),
(519, 'RUTAS DE ACCESOS', 'Devolución de material de encofrado', 8, '2024-01-22 12:00:00', 93, NULL, '3', '71', 63, 18, 22, 142, '2024-01-22 12:00:00', '2024-02-06 03:51:08', '6.00000', 1, '2024-01-18 15:31:44', 128),
(520, 'ASENTADO DE BLOQUETA NORDICA', 'NO SE TIENE PERSONAL PAR INICIAR LA ACTIVIDAD', 4, '2024-01-13 12:00:00', 113, NULL, '2', '69', 81, 27, 22, 142, '2024-01-17 12:00:00', NULL, '1.00000', 1, '2024-01-18 15:34:07', NULL),
(521, 'INSTALACION DE VIGAS METALICAS', 'Retiro de mallas anticaídas y reubicación de parantes', 1, '2024-01-19 12:00:00', 80, NULL, '1', '71', 58, 18, 22, 142, '2024-01-19 12:00:00', NULL, '1.00000', 1, '2024-01-18 15:35:21', NULL),
(522, 'ENCOFRADO RAMPA #2', '', NULL, NULL, NULL, NULL, '1', '71', 63, 18, 22, 142, NULL, NULL, '7.01000', 1, '2024-01-18 15:36:22', NULL),
(523, 'ENCOFRADO RAMPA #2', 'Retiro y reubicación de malla anticaída', 1, '2024-01-19 12:00:00', NULL, NULL, '3', '71', 63, 18, 22, 142, '2024-01-19 12:00:00', '2024-02-06 03:51:29', '7.00000', 1, '2024-01-18 15:36:27', 129),
(524, 'LOSA', '', NULL, NULL, NULL, NULL, '1', '71', 63, 18, 22, 142, NULL, NULL, '8.01000', 1, '2024-01-18 15:37:37', NULL),
(525, 'INSTALACION DE ACERO RAMPA #2, ESCALERA, PARASOLES Y SARDINELES', 'Ingreso de MO', 4, '2024-01-22 12:00:00', 82, NULL, '3', '71', 63, 18, 22, 142, '2024-01-22 12:00:00', '2024-02-06 03:51:38', '8.00000', 1, '2024-01-18 15:37:46', 130),
(526, 'MONTAJE DE VM PISO 3', 'Visita a planta con supervisión', 9, '2024-01-20 12:00:00', 120, NULL, '3', '71', 58, 18, 22, 142, '2024-01-20 12:00:00', '2024-01-22 22:40:56', '2.00000', 1, '2024-01-18 15:42:19', NULL),
(527, 'ASENTADO DE BLOQUETAS 416 Y 417', 'Incremento de personal debido a bajo rendimiento', 4, '2024-01-22 12:00:00', 113, NULL, '3', '71', 64, 18, 22, 142, '2024-01-22 12:00:00', '2024-03-11 17:35:43', '1.00000', 1, '2024-01-18 15:50:44', 894),
(528, 'ARMADO E INSTALACIÓN DE CHUTE DE ELIMINACION', 'Incremento de residuos en piso', 2, '2024-01-20 12:00:00', 116, NULL, '3', '71', 64, 18, 22, 142, '2024-01-20 12:00:00', '2024-03-11 17:36:00', '2.00000', 1, '2024-01-18 15:51:43', 895),
(529, 'Acarreo vertical', 'Operador de torre grúa está en descanso médico, lo cual imposibilita el transporte de material', 4, '2024-01-19 12:00:00', 80, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-01-23 12:15:15', '22.00000', 1, '2024-01-18 15:52:44', NULL),
(530, 'ASENTADO DE BLOQUETAS 416 Y 417', 'Llegada de andamios y andamieros para SC', 5, '2024-01-20 12:00:00', 112, NULL, '3', '71', 64, 18, 22, 142, '2024-01-20 12:00:00', '2024-02-12 17:12:23', '4.00000', 1, '2024-01-18 15:53:12', 315),
(531, 'ASENTADO DE BLOQUETAS 416 Y 417', 'Cambio de plataforma observada por seguridad', 6, '2024-01-20 12:00:00', 80, NULL, '3', '71', 64, 18, 22, 142, '2024-01-20 12:00:00', '2024-03-11 17:36:11', '3.00000', 1, '2024-01-18 15:54:02', 896),
(532, 'SOLAQUEO  Y TARRAJEO', 'Adjudicación de partidas', 4, '2024-01-22 12:00:00', 115, NULL, '3', '71', 64, 18, 22, 142, '2024-01-22 12:00:00', '2024-03-11 17:36:25', '5.00000', 1, '2024-01-18 15:55:30', 897),
(533, 'Solaqueo, tarrajeo y cieloraso', 'Adjudicación de la partida para comenzar actividades', 7, '2024-01-24 12:00:00', 115, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-03-11 17:41:59', '23.00000', 1, '2024-01-18 15:55:39', 902),
(534, 'Solaqueo, tarrajeo y cieloraso', 'Envío y aprobación de procedimiento de solaqueo, tarrajeo y cieloraso', 3, '2024-01-25 12:00:00', 86, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-05-03 21:44:53', '24.00000', 0, '2024-01-18 15:57:08', 1837),
(536, 'EXCAVACION LOCALIZADA', 'RETRO EXCAVADORA', 6, '2024-01-15 12:00:00', 113, NULL, '1', '69', 62, 27, 22, 142, NULL, NULL, '2.00000', 1, '2024-01-18 15:58:53', NULL),
(537, 'ACARREO VERTICAL', '', NULL, NULL, NULL, NULL, '1', '71', 64, 18, 22, 142, NULL, NULL, '7.00000', 1, '2024-01-18 15:59:07', NULL),
(538, 'ACARREO VERTICAL', 'Falta de riggers y operador de TG', 4, '2024-01-19 12:00:00', 122, NULL, '3', '71', 64, 18, 22, 142, '2024-01-19 12:00:00', '2024-03-11 17:36:33', '6.00000', 1, '2024-01-18 15:59:17', 898),
(539, 'ASENTADO DE BLOQUETAS 416 Y 417', 'Planos definitivos de arquitectura con detalles de muros, pisos y cielo raso', 3, '2024-01-22 12:00:00', 123, NULL, '1', '71', 64, 18, 22, 142, '2024-01-22 12:00:00', NULL, '8.00000', 1, '2024-01-18 16:01:07', NULL),
(540, 'ASENTADO DE BLOQUETA CABEZAS', 'NO INICIA POR FALTA DE PERSONAL (CISTERNA)', 4, '2024-01-17 12:00:00', 113, NULL, '3', '69', 81, 27, 22, 142, NULL, '2024-02-12 17:10:54', '0.00000', 1, '2024-01-18 16:01:21', 313),
(541, 'PLANO DEFENITIVOS DE ARQUITECTURA', 'COMPATIBALIZACION DE PLANOS DE ARQUITECTURA', 3, '2024-01-18 12:00:00', 123, NULL, '1', '69', 81, 27, 22, 142, NULL, NULL, '2.00000', 1, '2024-01-18 16:02:12', NULL),
(542, 'MONTAJE DE VM PISO 3', 'Coordinación con ETAC para realizar maniobras sábado y domingo', 4, '2024-01-19 12:00:00', 82, NULL, '3', '71', 58, 18, 22, 142, '2024-01-19 12:00:00', '2024-01-22 22:41:10', '3.00000', 1, '2024-01-18 16:03:50', NULL),
(543, 'Solaqueo, tarrajeo y cieloraso', 'Llegada de materiales para la partida', 5, '2024-01-26 12:00:00', 115, NULL, '3', '33', 55, 25, 22, 142, NULL, '2024-05-03 21:44:56', '25.00000', 0, '2024-01-18 16:04:07', 1838),
(544, 'POST VACEADO DE FACHADAS', 'POST VACEADO DE FACHADAS ACTIVO 469', 3, '2024-01-17 12:00:00', 120, NULL, '3', '69', 81, 27, 22, 142, NULL, '2024-02-12 17:11:18', '4.00000', 1, '2024-01-18 16:06:18', 314),
(545, 'DEFINII', '', NULL, NULL, NULL, NULL, '1', '69', 81, 27, 22, 142, NULL, NULL, '6.00000', 1, '2024-01-18 16:09:26', NULL),
(546, 'SC DE IMPERMEABILIZACION CISTERNA', 'ADJUDICAR LA SC DE IMPERMEABILIZACION', 3, '2024-01-17 12:00:00', 115, NULL, '1', '69', 81, 27, 22, 142, NULL, NULL, '3.00000', 1, '2024-01-18 16:11:12', NULL),
(547, 'ATRASO', '', NULL, NULL, NULL, NULL, '1', '69', 81, 27, 22, 142, NULL, NULL, '7.00000', 1, '2024-01-18 16:13:34', NULL),
(548, 'ASENTADO DE BLOQUETA', 'RETRASO DE INGRESO DE PERSONAL', 4, '2024-01-17 12:00:00', 113, NULL, '1', '69', 81, 27, 22, 142, NULL, NULL, '5.00000', 1, '2024-01-18 16:13:40', NULL),
(549, 'Perforación e Inyección de anclajes', 'Falta la documentación de SSOMA de Batalla de Junín', 7, '2024-01-24 12:00:00', 142, NULL, '3', '73', 74, 30, 28, 148, '2024-01-24 12:00:00', '2024-01-25 11:12:42', '9.00000', 1, '2024-01-20 09:21:45', 58),
(550, 'Encofrado de muros anclados', 'Adquisión de madera', 12, '2024-01-24 12:00:00', 145, NULL, '3', '73', 74, 30, 28, 148, '2024-01-29 12:00:00', '2024-01-26 14:05:46', '4.00000', 1, '2024-01-20 09:26:12', 77),
(551, 'Concreto de muros anclados', 'Cierre del proveedor de concreto', 12, '2024-01-29 12:00:00', 137, NULL, '3', '73', 74, 30, 28, 148, '2024-01-29 12:00:00', '2024-02-01 10:05:10', '6.00000', 1, '2024-01-20 09:32:52', 95),
(552, 'Picado de calzaduras', 'Alquiler de andamios para picado de calzadura', 12, '2024-01-29 12:00:00', 139, NULL, '3', '73', 74, 30, 28, 148, '2024-01-29 12:00:00', '2024-01-25 11:12:37', '8.00000', 1, '2024-01-20 09:32:52', 57),
(553, 'Encofrado de muros anclados', 'Diseño de encofrado', 3, '2024-01-26 12:00:00', 141, NULL, '3', '73', 74, 30, 28, 148, '2024-01-26 12:00:00', '2024-02-01 10:05:12', '7.00000', 1, '2024-01-20 09:32:52', 96),
(554, 'Demolición de cerco perimétrico', 'Reubicación de medidor eléctrico', 1, '2024-01-23 12:00:00', 141, NULL, '3', '73', 73, 30, 28, 148, '2024-01-23 12:00:00', '2024-01-24 10:16:29', '7.00000', 1, '2024-01-20 09:32:52', NULL),
(555, 'Revoque escaleras', 'Incremento de personal por parte de sc', 7, '2024-01-24 12:00:00', 48, NULL, '3', '51', 65, 23, 14, 140, '2024-01-24 12:00:00', '2024-01-25 13:43:32', '0.00000', 1, '2024-01-23 10:04:35', 63),
(556, 'Asentado tabiquería piso 1', 'Definición detalle de columnetas y vigas collarin', 11, '2024-01-24 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-24 12:00:00', '2024-02-21 21:11:04', '0.00000', 1, '2024-01-23 10:04:35', 602),
(557, 'Asentado tabiquería piso 1', 'Pendiente llegada de acero por bloqueo comercial', 5, '2024-01-24 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-24 12:00:00', '2024-02-21 21:11:25', '0.00000', 1, '2024-01-23 10:04:35', 604),
(558, 'Acero escalera N°4', 'Pendiente definir si procede cambio que implica adicional', 11, '2024-01-22 12:00:00', 104, NULL, '3', '51', 67, 23, 14, 140, '2024-01-22 12:00:00', '2024-02-06 13:31:14', '0.00000', 1, '2024-01-23 10:04:35', 134),
(559, 'Revoques doble altura, rampa', 'Llegada de andamios', 5, '2024-01-23 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-23 12:00:00', '2024-02-13 12:22:02', '0.00000', 1, '2024-01-23 10:04:35', 383),
(560, 'Perforación e Inyección de anclajes', 'Falta la documentación de ADM de Batalla de Junín', 7, '2024-01-25 12:00:00', 145, NULL, '3', '73', 74, 30, 28, 148, '2024-01-25 12:00:00', '2024-01-25 11:12:45', '10.00000', 1, '2024-01-23 15:04:32', 59),
(561, 'Instalación de acero', 'Llegada de acero  para activo 471', 4, NULL, NULL, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-02-12 17:09:25', '12.00000', 1, '2024-01-24 15:30:52', 310),
(562, 'actividad para cliente 1', 'actualizamos la actividad para el cliente', 11, '2023-10-25 12:00:00', 160, NULL, '3', '19', 23, 15, 15, 141, '2024-01-25 12:00:00', NULL, '5.00000', 1, '2024-01-25 07:14:46', 49),
(563, 'actividad para cliente 1', 'actualizamos la actividad para el cliente', 9, '2023-10-25 12:00:00', 160, NULL, '2', '19', 23, 15, 15, 141, '2024-01-23 12:00:00', NULL, '6.00000', 1, '2024-01-25 07:20:54', 1690),
(564, 'Escuadras en volado para obras provisionales', 'Cierre de proveedor', 12, '2024-02-02 12:00:00', 139, NULL, '3', '73', 73, 30, 28, 148, '2024-02-02 12:00:00', '2024-02-03 10:30:22', '1.00000', 1, '2024-01-27 11:44:29', 97),
(565, 'Armado de obras provisionales sobre escuadras', 'Layout actualizado', 3, '2024-02-05 12:00:00', 141, NULL, '3', '73', 73, 30, 28, 148, '2024-02-05 12:00:00', '2024-02-06 11:33:46', '11.00000', 1, '2024-01-27 11:44:29', 131),
(566, 'Pañeteo', 'Llegada de cemento', 12, '2024-01-31 12:00:00', 145, NULL, '3', '73', 74, 30, 28, 148, '2024-01-31 12:00:00', '2024-02-01 10:05:07', '5.00000', 1, '2024-01-27 11:44:29', 94),
(567, 'Eliminación desmonte', 'Pendiente instalación de chute', 12, '2024-01-27 12:00:00', 104, NULL, '3', '51', 65, 23, 14, 140, '2024-01-31 12:00:00', '2024-02-06 13:30:57', '0.00000', 1, '2024-01-31 11:09:57', 132),
(568, 'EJECUCIÓN TECHOS (PASES EN VIGAS)', 'PENDIENTE RESPUESTA RFI 272 UBICACIÓN DE PASES EN VIGA DE ACI EN P6 AL P8', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2024-01-27 12:00:00', '2024-02-21 21:11:56', '0.00000', 1, '2024-01-31 11:09:57', 606),
(569, 'Pendiente respuesa rfi 2770 ubicación de junta sismica', '', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2024-01-27 12:00:00', '2024-03-31 15:22:15', '0.00000', 1, '2024-01-31 11:09:57', 1199),
(570, 'EJECUCIÓN SARDINEL', 'PENDIENTE RESPUESTA RFI 269 FALTA DETALLE DE PUERTA DE DUCTO DE IIEE', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-01-27 12:00:00', '2024-02-13 12:22:16', '0.00000', 1, '2024-01-31 11:09:57', 385),
(571, 'ACERO DIMENSIONADO PLACA', 'PENDIENTE RESPUESTA RFI N° 262 DETALLE DE ACERO E INCOMPATIBILIDADES DE PLACA 2 EN AZOTEA', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2024-01-27 12:00:00', '2024-02-13 12:22:23', '0.00000', 1, '2024-01-31 11:09:57', 386),
(572, 'ACERO DIMENSIONADO PLACA', 'PENDIENTE RESPUESTA RFI N° 263 DETALLE DE ACERO E INCOMPATIBILIDADES DE PLACA 4 EN AZOTEA', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2024-01-27 12:00:00', '2024-02-13 12:22:33', '0.00000', 1, '2024-01-31 11:09:57', 388),
(573, 'ASENTADO TABIQUERÍA DUCTO', 'PENDIENTE RESPUESTA RFI N°260 REGISTRO PARA MONTANTE DE TUBERIAS DE AGUA HELADA EJE 11-N', 11, '2024-01-17 12:00:00', 50, NULL, '3', '51', 50, 23, 14, 140, '2024-01-22 12:00:00', '2024-02-13 12:22:27', '0.00000', 1, '2024-01-31 11:09:57', 387),
(574, 'REVOQUE EN ESCALERAS', 'INCREMENTO DE PERSONAL PARA REVOQUE DE ESCALERAS', 7, '2024-02-01 12:00:00', 48, NULL, '3', '51', 65, 23, 14, 140, '2024-02-02 12:00:00', '2024-02-06 13:31:03', '0.00000', 1, '2024-01-31 11:09:57', 133),
(575, 'EJECUCIÓN POYOS PARA TRANSFORMADORES', NULL, 11, '2024-01-09 00:00:00', 50, NULL, '1', '51', 65, 23, 14, 140, '2024-01-14 00:00:00', NULL, '0.00000', 1, '2024-01-31 11:09:57', NULL),
(576, 'Armado de obras provisionales sobre escuadras', 'Envío del pedido de materiales', 3, '2024-02-06 12:00:00', 141, NULL, '3', '73', 73, 30, 28, 148, '2024-02-06 12:00:00', '2024-02-09 15:06:43', '3.00000', 1, '2024-02-03 11:46:52', 152),
(577, 'Armado de obras provisionales sobre escuadras', 'Compra de materiales', 12, '2024-02-13 12:00:00', 145, NULL, '3', '73', 73, 30, 28, 148, '2024-02-13 12:00:00', '2024-02-09 15:06:58', '6.00000', 1, '2024-02-03 11:46:52', 154),
(578, 'Perforación y inyección de anclajes en el 2do anillo', 'Envío de plan de izaje a la MM', 8, '2024-02-09 12:00:00', 139, NULL, '3', '73', 73, 30, 28, 148, '2024-02-09 12:00:00', '2024-02-09 15:06:51', '12.00000', 1, '2024-02-03 11:46:52', 153),
(579, 'Acero de muros anclados', 'Falta de planos aprobados para el 2do anillo de muros anclados del eje 8', 11, '2024-02-12 12:00:00', 138, NULL, '3', '73', 74, 30, 28, 148, '2024-02-12 12:00:00', '2024-02-09 15:13:41', '2.00000', 1, '2024-02-03 11:46:52', 155),
(580, '', '', NULL, '2024-02-21 12:00:00', NULL, NULL, '2', '19', 23, 15, 15, 141, NULL, NULL, '7.00000', 1, '2024-02-04 23:46:41', 607),
(584, 'Concreto en pavimentos , veredas y rampas', 'Planos de cortes de pavimentos en exteriores', 3, '2024-02-06 12:00:00', 123, NULL, '1', '67', 59, 26, 22, 142, '2024-02-15 12:00:00', NULL, '3.00000', 1, '2024-02-06 03:49:18', 126),
(585, 'Preparación para contrapiso', 'Pendiente instalacion de chute', 7, '2024-01-26 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-02-01 12:00:00', '2024-02-13 12:22:58', '0.00000', 1, '2024-02-06 13:51:48', 393),
(586, 'Inicio revoques piso 4', 'Pendiente retiro de encofrado', 1, '2024-02-02 12:00:00', 48, NULL, '3', '51', 66, 13, 14, 140, '2024-02-06 12:00:00', '2024-02-13 12:22:55', '0.00000', 1, '2024-02-06 13:51:48', 392),
(587, 'Tarrajeo lobby', 'Pendiente término instalacion de andamio. Reforzar cuadrilla', 4, '2024-02-02 00:00:00', 48, NULL, '3', '51', 66, 13, 14, 140, '2024-02-05 00:00:00', NULL, '0.00000', 1, '2024-02-06 13:51:48', NULL),
(588, 'Techo caja ascensores', 'Pendiente respuesta rfi n°276 ganchos de izaje de ascensor', 11, '2024-01-30 12:00:00', 50, NULL, '3', '51', 82, 13, 14, 140, '2024-02-04 12:00:00', '2024-02-13 12:22:50', '0.00000', 1, '2024-02-06 13:51:48', 391),
(589, 'ACERO DIMENSIONADO PLACA 2', 'PENDIENTE RESPUESTA RFI N° 262 DETALLE DE ACERO E INCOMPATIBILIDADES DE PLACA 2 EN AZOTEA', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 82, 13, 14, 140, '2024-01-27 12:00:00', '2024-02-13 12:22:46', '0.00000', 1, '2024-02-06 13:51:48', 390),
(590, 'ACERO DIMENSIONADO PLACA 4', 'PENDIENTE RESPUESTA RFI N° 263 DETALLE DE ACERO E INCOMPATIBILIDADES DE PLACA 4 EN AZOTEA', 11, '2024-01-22 12:00:00', 50, NULL, '3', '51', 82, 13, 14, 140, '2024-01-27 12:00:00', '2024-02-13 12:22:46', '0.00000', 1, '2024-02-06 13:51:48', 389),
(591, 'prueba1', 'prueba1 modificamos', 11, '2024-02-06 12:00:00', 160, NULL, '3', '19', 23, 15, 15, 141, '2024-02-06 12:00:00', '2024-02-08 16:53:14', '8.00000', 1, '2024-02-08 16:48:14', 149),
(598, 'Montaje de TG', 'Elaboración de diseño de zapata de TG', 3, '2024-03-19 12:00:00', 138, NULL, '3', '73', 73, 30, 28, 148, '2024-03-19 12:00:00', '2024-03-23 09:16:59', '8.00000', 1, '2024-02-09 15:12:12', 1101),
(599, 'Montaje de TG', 'Aprobación de planos de cimentación', 11, '2024-03-29 12:00:00', 138, NULL, '3', '73', 73, 30, 28, 148, '2024-03-29 12:00:00', '2024-03-02 10:20:01', '5.00000', 1, '2024-02-09 15:12:12', 754),
(601, 'Acero de muros anclados', 'Aprobación municipal de planos del 2do anillo de muros anclados del eje 8', 2, '2024-02-29 12:00:00', 138, NULL, '3', '73', 74, 30, 28, 148, '2024-02-29 12:00:00', '2024-03-02 10:20:18', '3.00000', 1, '2024-02-10 11:15:13', 755),
(608, 'Prelosas', 'Llegada de equipo para torre grúa', 6, '2024-04-08 12:00:00', 152, NULL, '3', '87', 102, 36, 31, 151, '2024-04-12 12:00:00', '2024-04-17 16:16:23', '2.00000', 1, '2024-02-10 12:11:22', 1602),
(611, 'Demolición', 'Fin de demolición de Edificios', 1, '2024-02-16 12:00:00', 154, NULL, '3', '87', 102, 36, 31, 151, '2024-02-16 12:00:00', '2024-02-16 18:00:17', '3.00000', 1, '2024-02-10 12:17:00', 464),
(615, 'Sector 1: Grúa Torre', 'Llegada de equipos balde basculante y canastilla para izaje de materiales', 12, '2024-03-22 12:00:00', 152, NULL, '3', '87', 103, 32, 31, 151, '2024-04-16 12:00:00', '2024-04-17 16:17:53', '0.00000', 1, '2024-02-10 12:21:41', 1612),
(616, 'Torre Grúa', 'Envío de planos de diseño y aprobación por supervisión de zapata de GT para ejecución', 3, '2024-02-17 12:00:00', 152, NULL, '3', '87', 103, 32, 31, 151, '2024-02-19 12:00:00', '2024-02-20 14:09:35', '2.00000', 1, '2024-02-10 12:30:02', 588),
(617, 'Torre Grúa', 'Definir requerimientos electricos a ETAC para solicitar pedidos', 3, '2024-02-14 12:00:00', 152, NULL, '3', '87', 103, 32, 31, 151, '2024-02-15 12:00:00', '2024-02-15 08:12:37', '3.00000', 1, '2024-02-10 12:32:17', 429),
(618, 'Grúa Torre', 'Montaje de Grúa Torre para izaje de materiales y prelosa', 6, '2024-03-04 12:00:00', 154, NULL, '3', '87', 104, 32, 31, 151, '2024-03-04 12:00:00', '2024-03-04 16:00:13', '14.00000', 1, '2024-02-10 12:42:46', 794),
(619, 'Grúa Torre', 'Montaje de Grúa Torre para izaje de materiales y prelosas', 6, '2024-03-18 12:00:00', 154, NULL, '3', '87', 105, 36, 31, 151, '2024-03-25 12:00:00', '2024-03-30 14:15:49', '0.00000', 1, '2024-02-10 12:43:57', 1183),
(620, 'Prelosas', 'Ingreso para Aprobación Municipal de prelosas para inicio de fabricación', 10, '2024-03-07 12:00:00', 152, NULL, '3', '87', 105, 36, 31, 151, '2024-03-20 12:00:00', '2024-03-23 11:27:10', '24.00000', 1, '2024-02-10 12:45:09', 1124),
(621, 'Prelosas', 'Llegada de prelosas a obra', 5, '2024-03-21 12:00:00', 154, NULL, '3', '87', 105, 36, 31, 151, '2024-04-04 12:00:00', '2024-04-04 14:25:29', '25.00000', 1, '2024-02-10 12:46:21', 1236),
(622, 'Prelosas', 'Ingreso para Aprobación Municipal de prelosas para inicio de fabricación', 10, '2024-02-26 12:00:00', 152, NULL, '3', '87', 104, 32, 31, 151, '2024-03-20 12:00:00', '2024-03-23 11:26:21', '27.00000', 1, '2024-02-10 12:47:13', 1119),
(623, 'Prelosas', 'Llegada de prelosas a obra', 5, '2024-03-11 12:00:00', 154, NULL, '3', '87', 104, 32, 31, 151, '2024-03-27 12:00:00', '2024-03-30 14:20:22', '28.00000', 1, '2024-02-10 13:00:30', 1189),
(627, 'PETS para Supervisión', 'Envío de PET de Izaje con Grúa Torre (1 semana antes del montaje) a la supervisión', 3, '2024-02-26 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-26 12:00:00', '2024-02-21 19:29:12', '22.00000', 1, '2024-02-13 11:41:02', 598),
(628, 'PETS para Supervisión', 'Envío de PET de Armado de andamios (1 semana antes del inicio de acero vertical) a la supervisión', 3, '2024-02-16 12:00:00', 154, NULL, '3', '87', 104, 32, 31, 151, '2024-02-21 12:00:00', '2024-02-21 19:24:18', '23.00000', 1, '2024-02-13 11:42:44', 589),
(629, 'PETS para Supervisión', 'Envío de PET de Montaje de prelosas (1 semana antes del inicio de la actividad) a la supervisión', 3, '2024-03-01 12:00:00', 154, NULL, '3', '87', 104, 32, 31, 151, '2024-04-15 12:00:00', '2024-04-21 10:02:36', '0.00000', 1, '2024-02-13 11:44:16', 1643),
(630, 'PETS para Supervisión', 'Envío de PET de IISS e IIEE (1 semana antes del inicio de la actividad) a la supervisión', 3, '2024-02-19 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-19 12:00:00', '2024-02-19 15:09:41', '26.00000', 1, '2024-02-13 11:45:10', 562),
(631, 'Protección perimetral', 'Cierre de servicio de Protección con Mallas Anticaídas', 7, '2024-03-06 12:00:00', 152, NULL, '3', '87', 104, 32, 31, 151, '2024-04-15 12:00:00', '2024-04-17 16:18:55', '16.00000', 1, '2024-02-13 11:47:38', 1616),
(632, 'Grúa Torre', 'Envío de certificado de inspección de Grúas Torres', 8, '2024-03-06 12:00:00', 152, NULL, '3', '87', 104, 32, 31, 151, '2024-03-08 12:00:00', '2024-03-07 09:01:39', '21.00000', 1, '2024-02-13 11:49:57', 827),
(633, 'VACIADO TECHO PISO 7', 'TÉRMINO INSTALACION VIGA POSTENSADA, REFORZAR PERSONAL', 7, '2024-02-12 12:00:00', 48, NULL, '3', '51', 67, 23, 14, 140, '2024-02-12 12:00:00', '2024-02-14 11:24:31', '0.00000', 1, '2024-02-13 12:37:15', 425),
(634, 'ASENTADO TABIQUERIA', 'INGRESO OTRO SUBCONTRATISTA', 7, '2024-02-10 12:00:00', 47, NULL, '3', '51', 65, 23, 14, 140, '2024-02-14 12:00:00', '2024-02-21 21:11:18', '0.00000', 1, '2024-02-13 12:37:15', 603),
(635, 'TABIQUERÍA PISO 1', 'PENDIENTE RESPUESTA RFI TABIQUES CAMBIO A DRRYWALL', 11, '2024-02-09 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-13 12:00:00', '2024-02-21 21:11:02', '0.00000', 1, '2024-02-13 12:37:15', 601),
(636, 'IMPERMEABILIZACIÓN CISTERNAS', 'PENDIENTE INGRESO PERSONAL POR PAGO DEL ADELANTO', 7, '2024-02-09 00:00:00', 47, NULL, '1', '51', 65, 23, 14, 140, '2024-02-12 00:00:00', NULL, '0.00000', 1, '2024-02-13 12:37:15', NULL),
(637, 'INSTALACIÓN MONTACARGA', 'REUBICACIÓN OFICINAS, TABIQUES DE DRYWALL', 7, '2024-02-09 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-13 12:00:00', '2024-02-21 21:11:31', '0.00000', 1, '2024-02-13 12:37:15', 605),
(641, 'AASA', 'Llegada de 1er despacho de acero dimensionado', 5, '2024-02-20 12:00:00', 154, NULL, '3', '87', 103, 32, 31, 151, '2024-02-20 12:00:00', '2024-02-19 13:15:40', '4.00000', 1, '2024-02-17 11:10:02', 560),
(642, 'Equipos', 'Llegada de Trompo para preparación de concreto', 12, '2024-02-19 12:00:00', 157, NULL, '3', '87', 103, 32, 31, 151, '2024-02-19 12:00:00', '2024-02-19 13:15:44', '5.00000', 1, '2024-02-17 11:11:15', 561),
(643, 'PETS para Supervisión', 'Envío de PET de Colocación de acero de refuerzo con uso de andamios', 3, '2024-02-20 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-22 12:00:00', '2024-02-21 19:29:14', '29.00000', 1, '2024-02-17 11:12:52', 599),
(644, 'Concreto', 'Liberación de proveedor de concreto para suministro de material', 9, '2024-02-21 12:00:00', 153, NULL, '3', '87', 103, 32, 31, 151, '2024-02-21 12:00:00', '2024-02-21 19:29:01', '6.00000', 1, '2024-02-17 11:13:57', 597),
(645, 'PETS para Supervisión', 'Envío de PET de Colocación de encofrado', 3, '2024-02-21 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-23 12:00:00', '2024-02-21 19:29:17', '30.00000', 1, '2024-02-17 11:15:14', 600),
(647, 'Encofrados Ulma', 'Llegada de equipos de andamios para colocación de acero', 6, '2024-02-20 12:00:00', 157, NULL, '3', '87', 104, 32, 31, 151, '2024-02-20 12:00:00', '2024-02-20 09:59:26', '31.00000', 1, '2024-02-17 11:20:57', 569),
(648, 'Encofrados Ulma', 'Llegada de equipo de encofrado para verticales', 6, '2024-02-21 12:00:00', 157, NULL, '3', '87', 104, 32, 31, 151, '2024-02-21 12:00:00', '2024-02-22 10:58:24', '32.00000', 1, '2024-02-17 11:21:01', 608),
(649, 'Encofrados Ulma', 'Llegada de equipos de encofrado de cimentaciones', 6, '2024-03-02 12:00:00', 157, NULL, '3', '87', 113, 36, 31, 151, '2024-03-06 12:00:00', '2024-03-06 19:38:54', '0.00000', 1, '2024-02-17 11:23:44', 814),
(652, 'Encofrados Ulma', 'Llegada de equipos de andamios para colocación de acero en verticales', 6, '2024-02-27 12:00:00', 157, NULL, '3', '87', 105, 36, 31, 151, '2024-03-08 12:00:00', '2024-03-10 18:43:28', '26.00000', 1, '2024-02-17 11:24:51', 836),
(653, 'Encofrados Ulma', 'Llegada de equipo de encofrado para verticales', 6, '2024-02-28 12:00:00', 157, NULL, '3', '87', 105, 36, 31, 151, '2024-03-06 12:00:00', '2024-03-20 10:04:08', '27.00000', 1, '2024-02-17 11:24:53', 1036),
(654, 'SC Encofrado', 'Ingreso de subcontratista de encofrado', 4, '2024-02-26 12:00:00', 152, NULL, '3', '87', 113, 36, 31, 151, '2024-02-26 12:00:00', '2024-02-23 11:00:42', '1.00000', 1, '2024-02-17 11:26:11', 679),
(655, 'INICIO TRABAJOS DE DRYWALL', 'ADJUDICACIÓN SC DRYWALL', 11, '2024-02-17 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-24 12:00:00', '2024-03-06 06:57:31', '0.00000', 1, '2024-02-21 21:16:29', 797),
(656, 'INICIO CARPINTERÍA METÁLICA', 'ADJUDICACIÓN SC CARPINTERÍA Y EEMM', 11, '2024-02-17 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-02-24 00:00:00', NULL, '0.00000', 1, '2024-02-21 21:16:29', NULL),
(657, 'FIN ASENTADO TABIQUERÍA PISO 2', 'PENDIENTE RESPUESTA RFI N°287 ALINEAMIENTOS DE TABIQUES EN PISO 2', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-06 06:57:43', '0.00000', 1, '2024-02-21 21:16:29', 798),
(658, 'ENTREGA TABIQUERÍA', 'PENDIENTE RESPUESTA RFI N°288 POR INCOMPATIBILIDADES EN VENTANAS S1, S2 Y P1', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-31 15:22:32', '0.00000', 1, '2024-02-21 21:16:29', 1200),
(659, 'TABIQUERÍA SOTANOS', 'PENDIENTE RESPUESTA RFI N°289 TIPO DE TABIQUE DEBIDO A ABERTURAS DE UMAS', 11, '2024-02-16 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-02-21 00:00:00', NULL, '0.00000', 1, '2024-02-21 21:16:29', NULL),
(660, 'FIN ASENTADO TABIQUERÍA PISO 2, COLUMNETAS PISO 1, TABIQUERÍA PISO 1 Y 6', 'PENDIENTE RESPUESTA RFI N°291 TABIQUE DESALIEADO ENTRE VIGA Y LOSA EN P1 Y P6', 11, '2024-02-16 12:00:00', 50, NULL, '3', '51', 65, 23, 14, 140, '2024-02-21 12:00:00', '2024-03-06 06:57:49', '0.00000', 1, '2024-02-21 21:16:29', 799),
(663, 'Cerco Perimetral', 'Revisar la arquitectura del cerco perimetral, evaluar la demolición y ejecución de un muro nuevo.', 1, '2024-02-27 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-27 12:00:00', '2024-02-23 19:15:04', '39.00000', 1, '2024-02-23 09:41:24', 701),
(664, 'Grua Torre', 'Llegada de insumos electricos para ETAC', 12, '2024-02-27 12:00:00', 157, NULL, '3', '87', 104, 32, 31, 151, '2024-02-28 12:00:00', '2024-02-28 21:46:42', '33.00000', 1, '2024-02-23 09:42:27', 725),
(665, 'Subcontratista', 'Adjudicación de SCs de IISS e IIEE', 4, '2024-02-27 12:00:00', 152, NULL, '3', '87', 104, 32, 31, 151, '2024-03-18 12:00:00', '2024-03-20 10:02:49', '34.00000', 1, '2024-02-23 09:43:09', 1033),
(666, 'Llegada de contenedores', 'Llegada de contenedores para establecer zonas de trabajo y de bienestar social', 12, '2024-03-01 12:00:00', 157, NULL, '3', '87', 114, 46, 31, 151, '2024-03-01 12:00:00', '2024-03-10 18:43:41', '0.00000', 1, '2024-02-23 09:48:06', 837),
(667, 'Grúa Torre', 'Envío de diseño de zapatas de grúas torre a la supervisión de manera informativa', 3, '2024-02-24 12:00:00', 151, NULL, '3', '87', 104, 32, 31, 151, '2024-02-24 12:00:00', '2024-02-24 09:45:10', '17.00000', 1, '2024-02-23 09:54:20', 705),
(668, 'PETS para Supervisión', 'Envío de PET de armado de andamios', 3, '2024-02-27 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-27 12:00:00', '2024-02-23 19:15:22', '24.00000', 1, '2024-02-23 09:56:36', 703),
(669, 'PETS para Supervisión', 'Envío de PET de izaje de materiales con torre grúa', 3, '2024-02-27 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-02-27 12:00:00', '2024-02-23 19:15:14', '25.00000', 1, '2024-02-23 09:56:49', 702),
(672, 'Mano de Obra', 'Ingreso de cuadrillas de solado y perfilado', 4, '2024-02-28 12:00:00', 154, NULL, '3', '87', 113, 36, 31, 151, '2024-03-04 12:00:00', '2024-03-04 16:00:31', '2.00000', 1, '2024-02-23 11:00:51', 795),
(673, 'Mano de Obra', 'Ingreso de cuadrillas de encofrado', 4, '2024-03-01 12:00:00', 154, NULL, '3', '87', 113, 36, 31, 151, '2024-03-05 12:00:00', '2024-03-04 16:00:44', '3.00000', 1, '2024-02-23 11:01:27', 796),
(674, 'IIEE', 'Ingreso de capataz de IIEE', 4, '2024-03-22 12:00:00', 157, NULL, '3', '87', 104, 32, 31, 151, '2024-03-25 12:00:00', '2024-03-23 11:26:28', '35.00000', 1, '2024-02-29 07:31:11', 1120),
(675, 'IIEE', 'Enviar requerimiento de materiales', 5, '2024-03-08 12:00:00', 258, NULL, '3', '87', 104, 32, 31, 151, '2024-03-18 12:00:00', '2024-03-18 09:59:47', '36.00000', 1, '2024-02-29 07:31:25', 975);
INSERT INTO `anares_actividad` (`codAnaResActividad`, `desActividad`, `desRestriccion`, `codTipoRestriccion`, `dayFechaRequerida`, `idUsuarioResponsable`, `desAreaResponsable`, `codEstadoActividad`, `codUsuarioSolicitante`, `codAnaResFase`, `codAnaResFrente`, `codProyecto`, `codAnaRes`, `dayFechaConciliada`, `dayFechaLevantamiento`, `numOrden`, `flgNoti`, `dayFechaCreacion`, `codAnaResActividadTrackLast`) VALUES
(676, 'IIEE', 'Establecer cuadro de alturas por tipo de ambiente para tods los puntos eléctricos', 3, '2024-03-08 12:00:00', 153, NULL, '3', '87', 104, 32, 31, 151, '2024-03-08 12:00:00', '2024-03-09 12:03:58', '37.00000', 1, '2024-02-29 07:31:34', 835),
(677, 'Izaje de excavadora', 'Subcontratación de izaje de excavadora', 12, '2024-03-08 12:00:00', 139, NULL, '3', '73', 73, 30, 28, 148, '2024-03-08 12:00:00', '2024-03-09 10:13:04', '10.00000', 1, '2024-03-02 10:52:57', 828),
(678, 'Izaje de excavadora', 'Obtención de permiso de cierre de vías para izaje de excavadora', 10, '2024-05-03 12:00:00', 145, NULL, '3', '73', 73, 30, 28, 148, '2024-05-03 12:00:00', '2024-04-27 09:45:04', '4.00000', 1, '2024-03-02 10:52:57', 1760),
(679, 'Uso de vías', 'Renovación de permiso de uso de vías (vence 2/4/24)', 10, '2024-03-15 12:00:00', 145, NULL, '3', '73', 73, 30, 28, 148, '2024-03-15 12:00:00', '2024-03-16 09:57:40', '9.00000', 1, '2024-03-02 10:52:57', 927),
(680, 'Montaje de TG', 'Elaboración de Expediente de cierre de vía para montaje de TG', 12, '2024-03-25 12:00:00', 139, NULL, '3', '73', 73, 30, 28, 148, '2024-03-25 12:00:00', '2024-03-23 09:16:42', '2.00000', 1, '2024-03-02 10:52:57', 1100),
(681, 'Vaciado de piso de cisterna', 'Definición de pendiente de losa de piso', 3, '2024-04-30 12:00:00', 143, NULL, '3', '73', 73, 30, 28, 148, '2024-04-30 12:00:00', '2024-05-02 07:33:01', '0.00000', 1, '2024-03-02 10:52:57', 1785),
(682, 'Excavación Masiva', 'Punto de agua dentro del área de excavación', 2, '2024-03-08 12:00:00', 172, NULL, '3', '39', 119, 48, 32, 152, NULL, '2024-03-19 14:58:35', '0.00000', 1, '2024-03-04 10:23:03', 1022),
(683, 'Muro anclado', 'Reparación de quipo de compresora', 6, '2024-03-05 12:00:00', 172, NULL, '3', '39', 120, 48, 32, 152, NULL, '2024-03-18 09:16:49', '0.00000', 1, '2024-03-04 10:29:19', 958),
(684, 'Concreto proyectado', 'Traslado de equipos y personal a obra', 4, '2024-03-06 12:00:00', 176, NULL, '3', '39', 120, 48, 32, 152, NULL, '2024-03-18 09:16:42', '1.00000', 1, '2024-03-04 10:32:28', 957),
(685, 'Drywall', 'PENDIENTE RESPUESTA RFI N°298 DEFINICIÓN REFUERZOS EN DRYWALL', 11, '2024-02-24 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-02-29 12:00:00', '2024-03-27 10:55:27', '0.00000', 1, '2024-03-06 07:02:54', 1169),
(686, 'Solaqueo escaleras', 'PENDEINTE RESPUESTA RFI N°304 UBICACIÓN PASE DE MANGUERA DE ESCALERA 1', 11, '2024-02-24 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-02-29 12:00:00', '2024-03-16 10:10:48', '0.00000', 1, '2024-03-06 07:02:54', 937),
(687, 'Prelosas', 'Enviar planos de prelosas con IIEE e IISS', 3, '2024-03-11 12:00:00', 258, NULL, '3', '87', 104, 32, 31, 151, '2024-03-11 12:00:00', '2024-03-16 13:21:40', '38.00000', 1, '2024-03-07 07:24:48', 942),
(688, 'Tableros de Granito', 'Ingreso de personal de SC para instalación de tableros', 4, '2024-03-13 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-03-13 12:00:00', '2024-03-22 10:58:40', '13.00000', 1, '2024-03-11 10:41:41', 1089),
(689, 'Instalación de aparatos sanitarios', 'Llegada de nuevos inodoros', 5, '2024-03-26 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2024-03-26 12:00:00', '2024-03-27 10:18:53', '14.00000', 1, '2024-03-11 10:43:19', 1163),
(690, 'Instalación de papel', 'Ingreso de personal para instalación de papel', 4, '2024-03-26 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-03-28 12:00:00', '2024-04-01 13:25:12', '15.00000', 1, '2024-03-11 10:44:54', 1216),
(691, 'Limpieza fina', 'Adjudicar SC para limpieza fina', 7, '2024-03-21 12:00:00', 9, NULL, '3', '57', 43, 22, 4, 132, '2024-03-25 12:00:00', '2024-03-11 11:16:14', '11.00000', 1, '2024-03-11 10:48:38', 893),
(692, 'Limpieza fina de departamentos', 'Ingreso de personal para limpieza fina', 4, '2024-04-10 12:00:00', 132, NULL, '3', '57', 43, 22, 4, 132, '2024-04-10 12:00:00', '2024-04-16 08:05:58', '16.00000', 1, '2024-03-11 10:48:44', 1531),
(693, 'Tarrajeo de fachada tramo central', 'Desmontaje de elevador', 7, '2024-03-25 12:00:00', 9, NULL, '3', '57', 44, 22, 4, 132, '2024-03-25 12:00:00', '2024-03-27 10:21:03', '4.00000', 1, '2024-03-11 11:01:34', 1166),
(694, 'Pintura de fachada', 'Definir proceso y color de pintura', 3, '2024-03-25 12:00:00', 9, NULL, '3', '57', 44, 22, 4, 132, '2024-03-21 12:00:00', '2024-03-20 10:23:51', '5.00000', 1, '2024-03-11 11:01:48', 1070),
(695, 'Pintura de fachada', 'Ingreso de personal para pintura de fachada', 4, '2024-03-25 12:00:00', 132, NULL, '3', '57', 44, 22, 4, 132, '2024-03-23 12:00:00', '2024-03-20 10:24:05', '6.00000', 1, '2024-03-11 11:09:36', 1071),
(696, 'Instalación de acero', 'Llegada de acero  para activo 471', 4, NULL, NULL, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-03-11 17:57:28', '12.00100', 1, '2024-03-11 17:57:28', 310),
(697, 'Instalación de acero', 'Llegada de acero  para activo 471', 4, NULL, NULL, NULL, '3', '33', 56, 25, 22, 142, NULL, '2024-03-11 17:58:35', '12.00200', 1, '2024-03-11 17:58:35', 310),
(698, 'Impermeabilización cisterna', 'Charla de inducción personal', 7, '2024-03-11 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-03-16 12:00:00', '2024-03-16 10:10:35', '0.00000', 1, '2024-03-12 09:37:49', 936),
(699, 'Enchape', 'Enviar PET', 7, '2024-03-14 12:00:00', 48, NULL, '3', '51', 66, 13, 14, 140, '2024-03-13 12:00:00', '2024-04-26 11:58:29', '0.00000', 1, '2024-03-12 09:37:49', 1719),
(700, 'Pintura', 'Enviar PET', 7, '2024-03-14 12:00:00', 48, NULL, '3', '51', 66, 13, 14, 140, '2024-03-13 12:00:00', '2024-03-31 15:21:07', '0.00000', 1, '2024-03-12 09:37:49', 1190),
(701, 'Enchape', 'Charla de inducción personal', 7, '2024-03-16 12:00:00', 51, NULL, '3', '51', 66, 13, 14, 140, '2024-03-16 12:00:00', '2024-03-31 15:21:32', '0.00000', 1, '2024-03-12 09:37:49', 1196),
(702, 'Pintura', 'Charla de inducción personal', 7, '2024-03-16 12:00:00', 51, NULL, '3', '51', 66, 13, 14, 140, '2024-03-16 12:00:00', '2024-04-26 11:58:31', '0.00000', 1, '2024-03-12 09:37:49', 1720),
(703, 'Carpintería cto bombas', 'Cierre sc carpintería', 7, '2024-03-12 12:00:00', 47, NULL, '2', '51', 66, 13, 14, 140, '2024-03-16 12:00:00', NULL, '0.00000', 1, '2024-03-12 09:37:49', 1191),
(704, 'Carpintería escaleras', 'Cierre sc carpintería', 7, '2024-03-12 00:00:00', 47, NULL, '1', '51', 66, 13, 14, 140, '2024-03-16 00:00:00', NULL, '0.00000', 1, '2024-03-12 09:37:49', NULL),
(705, 'Asentado tabiquería piso 5', 'Ingreso 4ta cuadrilla', 7, '2024-03-10 12:00:00', 47, NULL, '3', '51', 66, 13, 14, 140, '2024-03-12 12:00:00', '2024-04-26 11:58:39', '0.00000', 1, '2024-03-12 09:37:49', 1722),
(706, 'Encofrado de cimentación perimetral', 'Pedido de encofrado', 3, '2024-03-25 12:00:00', 141, NULL, '3', '73', 74, 30, 28, 148, '2024-03-25 12:00:00', '2024-03-20 11:58:00', '1.00000', 1, '2024-03-16 10:15:07', 1081),
(707, 'Colocación de bridas en cisterna', 'Fabricación de bridas', 3, '2024-04-29 12:00:00', 143, NULL, '3', '73', 74, 30, 28, 148, '2024-04-29 12:00:00', '2024-04-18 07:39:26', '0.00000', 1, '2024-03-16 10:15:07', 1620),
(708, 'Encofrado de cimentación perimetral', 'Pedido de encofrado', 3, '2024-03-25 12:00:00', 141, NULL, '3', '73', 121, 30, 28, 148, '2024-03-25 12:00:00', '2024-03-23 09:16:08', '0.00000', 1, '2024-03-16 10:15:07', 1099),
(709, 'Ingreso 2da cuadrilla pintura', 'Envío documentacion personal para charla', 7, '2024-04-04 12:00:00', 48, NULL, '3', '51', 122, 49, 14, 140, '2024-04-04 12:00:00', '2024-05-05 00:15:28', '0.00000', 1, '2024-03-17 12:09:40', 1848),
(710, 'Habilitado de acero Anillo N°02', 'Stock de acero', 5, '2024-03-18 12:00:00', 176, NULL, '1', '39', 120, 48, 32, 152, NULL, NULL, '2.00000', 1, '2024-03-18 09:20:17', 964),
(711, 'Tensado de paños', 'Rotura de probetas antes de las 8am', 7, '2024-03-23 12:00:00', 171, NULL, '1', '39', 120, 48, 32, 152, NULL, NULL, '3.00000', 1, '2024-03-18 09:21:42', 972),
(712, 'Sector 1 y 2: Protecciones Colectivas', 'Realizar el requerimiento y coordinar la llegada de materiales para protecciones colectivas para Techos', 5, '2024-03-22 12:00:00', 156, NULL, '3', '87', 104, 32, 31, 151, '2024-03-22 12:00:00', '2024-03-23 11:26:45', '40.00000', 1, '2024-03-18 10:29:21', 1122),
(713, 'Sector 1 y 2: Andamios Escaleras de Ulma', 'Realizar el requerimiento y coordinar la llegada de andamios escaleras de ULMA (4 UNIDADES)', 5, '2024-03-22 12:00:00', 158, NULL, '3', '87', 104, 32, 31, 151, '2024-03-22 12:00:00', '2024-03-23 11:26:42', '41.00000', 1, '2024-03-18 10:32:47', 1121),
(714, 'Sector 1: Mallas Anticaidas', 'Ingreso de cuadrilla de mallas anticaídas', 7, '2024-04-08 12:00:00', 154, NULL, '3', '87', 104, 32, 31, 151, '2024-05-03 12:00:00', '2024-05-04 10:34:30', '18.00000', 1, '2024-03-18 10:34:08', 1843),
(715, 'Sector 1: Grúa Torre', 'Llegada de equipos balde basculante y canastilla para izaje de materiales', 12, '2024-03-22 12:00:00', 152, NULL, '3', '87', 104, 32, 31, 151, '2024-04-23 12:00:00', '2024-04-30 19:19:51', '19.00000', 1, '2024-03-18 10:34:48', 1778),
(716, 'Sector 1 y 2: Baños portátiles', 'Realizar requerimiento y hacer seguimiento para la llegada de baños portátiles (2und) con canastilla', 12, '2024-04-03 12:00:00', 156, NULL, '3', '87', 104, 32, 31, 151, '2024-04-04 12:00:00', '2024-04-06 20:52:00', '42.00000', 1, '2024-03-18 10:36:12', 1247),
(717, 'Sector 1 y 2: Caja Ecológica', 'Realizar requerimiento y hacer seguimiento para la llegada de 1 caja ecológica', 12, '2024-03-22 12:00:00', 156, NULL, '3', '87', 104, 32, 31, 151, '2024-04-15 12:00:00', '2024-04-17 16:19:09', '20.00000', 1, '2024-03-18 10:36:18', 1618),
(718, 'Control de acero y concreto', 'Adaptación del equipo de control', 3, '2024-03-20 12:00:00', 168, NULL, '1', '39', 120, 48, 32, 152, NULL, NULL, '4.00000', 1, '2024-03-19 15:05:37', 1027),
(719, 'Prueba', 'Prueba', 5, '2024-03-20 12:00:00', 168, NULL, '1', '98', 120, 48, 32, 152, NULL, NULL, '5.00000', 1, '2024-03-19 15:51:33', 1032),
(720, 'Desbaste de pisos', 'Nivelación de pisos', 10, '2024-03-23 12:00:00', 11, NULL, '3', '66', 42, 22, 4, 132, '2024-03-22 12:00:00', '2024-03-22 10:57:58', '22.00000', 1, '2024-03-20 10:12:29', 1085),
(721, 'Colocación de pastelero', 'Llegada de impermeabilizante sikatop 107', 5, '2024-04-01 12:00:00', 11, NULL, '3', '57', 42, 22, 4, 132, '2024-03-30 12:00:00', '2024-03-22 10:58:12', '22.00000', 1, '2024-03-20 10:12:29', 1086),
(722, 'Enchape de terrazas', 'Pintura fachada', 5, '2024-03-18 12:00:00', 9, NULL, '3', '66', 43, 22, 4, 132, '2024-03-28 12:00:00', '2024-04-01 13:26:14', '17.00000', 1, '2024-03-20 10:17:55', 1218),
(723, 'Instalación de ventanas F4', 'Tarrajeo de fachada F4', 1, '2024-03-27 12:00:00', 64, NULL, '3', '66', 44, 22, 4, 132, '2024-03-27 12:00:00', '2024-04-01 13:25:27', '7.00000', 1, '2024-03-20 10:24:36', 1217),
(724, 'Encofrado de muros anclados', 'Modulación de encofrado de muros de contención con puntales', 6, '2024-04-10 12:00:00', 141, NULL, '3', '73', 74, 30, 28, 148, '2024-04-10 12:00:00', '2024-04-13 10:03:12', '11.00000', 1, '2024-03-23 09:21:41', 1495),
(725, 'Acero de muros anclados', 'Envío de panelado del 4to anillo de muros de contención', 3, '2024-04-01 12:00:00', 138, NULL, '3', '73', 74, 30, 28, 148, '2024-04-01 12:00:00', '2024-03-27 14:17:49', '12.00000', 1, '2024-03-23 09:25:45', 1177),
(727, 'Tabiquería de drywall', 'Paralización por cambio de alcance a tabiques acústicos', 11, '2024-03-22 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-03-25 12:00:00', '2024-03-27 10:56:08', '0.00000', 1, '2024-03-24 13:43:57', 1172),
(728, 'Abastecimiento materiales acabados', 'Montaje alevador', 7, '2024-03-25 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-03-25 12:00:00', '2024-03-27 10:55:51', '0.00000', 1, '2024-03-24 13:43:57', 1171),
(729, 'Desmontaje torre grúa', 'Aprobación documentación', 7, '2024-04-01 12:00:00', 51, NULL, '3', '51', 66, 13, 14, 140, '2024-04-01 12:00:00', '2024-03-31 15:21:38', '0.00000', 1, '2024-03-24 13:43:57', 1197),
(730, 'Tabiquería ladrillo sílico calcáreo', 'Ingreso 5ta cuadrilla asentadores', 7, '2024-03-25 12:00:00', 47, NULL, '3', '51', 66, 13, 14, 140, '2024-03-25 12:00:00', '2024-04-26 11:58:39', '0.00000', 1, '2024-03-24 13:43:57', 1723),
(731, 'Solaqueo escalera N°4', 'Incremento personal sc Loayza', 7, '2024-03-26 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-03-26 12:00:00', '2024-03-31 15:21:16', '0.00000', 1, '2024-03-24 13:43:57', 1192),
(732, 'Revoques fachada', 'Incremento de personal', 7, '2024-04-01 00:00:00', 48, NULL, '1', '51', 66, 13, 14, 140, '2024-04-01 00:00:00', NULL, '0.00000', 1, '2024-03-24 13:43:57', NULL),
(733, 'Revoques fachada', 'Montaje de andamios colgantes', 7, '2024-04-02 12:00:00', 50, NULL, '3', '51', 66, 13, 14, 140, '2024-04-02 12:00:00', '2024-03-27 10:55:40', '0.00000', 1, '2024-03-24 13:43:57', 1170),
(734, 'Revoques fachada', 'Protección vecinos', 7, '2024-04-02 12:00:00', 48, NULL, '2', '51', 66, 13, 14, 140, '2024-04-02 12:00:00', NULL, '0.00000', 1, '2024-03-24 13:43:57', 1193),
(735, 'Enchape pisos pares', 'Ingreso sc', 7, '2024-03-27 12:00:00', 48, NULL, '2', '51', 66, 13, 14, 140, '2024-03-27 12:00:00', NULL, '0.00000', 1, '2024-03-24 13:43:57', 1198),
(736, 'Pintura pisos impares', 'Ingreso sc', 7, '2024-04-01 00:00:00', 48, NULL, '1', '51', 66, 13, 14, 140, '2024-04-01 00:00:00', NULL, '0.00000', 1, '2024-03-24 13:43:57', NULL),
(737, 'Apertura y resane de pases en tabiques', 'Plano de pases', 7, '2024-03-25 12:00:00', 55, NULL, '3', '51', 66, 13, 14, 140, '2024-03-25 12:00:00', '2024-03-31 15:21:23', '0.00000', 1, '2024-03-24 13:43:57', 1194),
(738, 'Tabiquería drywall pisos 4 y 5', 'Aprobación del adicional de tabiques acústicos', 11, '2024-04-01 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-01 12:00:00', '2024-04-02 10:11:17', '0.00000', 1, '2024-03-31 15:35:16', 1227),
(739, 'Tabiquería drywall doble altura', 'Enviar adicional de sello de tabiques acústicos', 3, '2024-04-02 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-02 12:00:00', '2024-04-22 07:31:29', '0.00000', 1, '2024-03-31 15:35:16', 1672),
(740, 'Ingreso 2da cuadrilla pintura', 'Envío documentacion personal para charla', 7, '2024-04-04 12:00:00', 48, NULL, '2', '51', 123, 50, 14, 140, '2024-04-04 12:00:00', NULL, '0.00000', 0, '2024-03-31 15:35:16', 2366),
(741, 'Plano pases tabiqueria piso 4 y 5', 'Compatibilización sc instalaciones', 3, '2024-04-02 00:00:00', 55, NULL, '1', '51', 123, 50, 14, 140, '2024-04-02 00:00:00', NULL, '0.00000', 1, '2024-03-31 15:35:16', NULL),
(742, 'Vaciado contrapisos bloque II', 'Verificar posibilidad de vaciado con bomba pluma', 7, '2024-04-03 00:00:00', 48, NULL, '2', '51', 123, 50, 14, 140, '2024-04-03 00:00:00', NULL, '0.00000', 1, '2024-03-31 15:35:16', NULL),
(743, '', '', NULL, '2024-04-12 12:00:00', NULL, NULL, '1', '33', 59, 26, 22, 142, NULL, NULL, '6.00000', 0, '2024-04-04 15:04:19', 1238),
(744, '', '', NULL, '2024-04-05 12:00:00', NULL, NULL, '1', '33', 59, 26, 22, 142, NULL, NULL, '7.00000', 0, '2024-04-04 15:04:29', 1239),
(747, 'Encofrado Techo', 'Realizar requerimiento y hacer seguimiento para de fenólico, maderas y cables', 12, '2024-04-08 12:00:00', 154, NULL, '3', '103', 104, 32, 31, 151, '2024-04-09 12:00:00', '2024-04-10 13:24:57', '12.00000', 1, '2024-04-08 09:20:50', 1473),
(748, 'Encofrado Horizontal', 'Solicitar información sobre la modulación a ULMA (Piso 2 Vert. y piso 2 Hor.)', 3, '2024-04-08 12:00:00', 158, NULL, '3', '103', 104, 32, 31, 151, '2024-04-09 12:00:00', '2024-04-17 16:18:49', '15.00000', 1, '2024-04-08 09:34:57', 1615),
(749, 'Encofrado Horizontal', 'Definir procedimiento de reapuntalamiento de vigas y losas', 9, '2024-04-10 12:00:00', 153, NULL, '3', '103', 104, 32, 31, 151, '2024-04-18 12:00:00', '2024-04-21 10:02:45', '13.00000', 1, '2024-04-08 09:39:38', 1644),
(750, 'Encofrado Vigas', 'Solicitar mano de obra INARCO (6 personas)', 10, '2024-04-08 12:00:00', 157, NULL, '3', '103', 104, 32, 31, 151, '2024-04-09 12:00:00', '2024-04-10 13:24:41', '2.00000', 1, '2024-04-08 09:43:49', 1471),
(751, 'Acero', 'Solicitar mano de obra FEVEL (8 personas)', 10, '2024-04-11 12:00:00', 157, NULL, '3', '103', 104, 32, 31, 151, '2024-04-11 12:00:00', '2024-04-10 13:24:51', '4.00000', 1, '2024-04-08 09:45:57', 1472),
(752, 'Prelosas', 'Llegada e instalación de malla anticaida', 8, '2024-04-17 12:00:00', 156, NULL, '3', '103', 105, 36, 31, 151, '2024-05-03 12:00:00', '2024-05-04 10:34:08', '14.00000', 1, '2024-04-08 09:55:34', 1841),
(753, 'Cisterna', 'Información sobre el proceso constructivo y materiales a utilizar en la junta fría entre muro y losa', 3, '2024-04-15 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-04-18 12:00:00', '2024-04-21 10:02:11', '23.00000', 1, '2024-04-08 10:04:54', 1641),
(754, 'Cisterna', 'Asegurar una adecuada colocación de bridas', 7, '2024-04-25 12:00:00', 258, NULL, '3', '103', 105, 36, 31, 151, '2024-04-25 12:00:00', '2024-04-27 08:32:49', '22.00000', 1, '2024-04-08 10:08:14', 1734),
(755, 'Cisterna', 'Definir ubicación de ventana de ingreso de bomba.', 7, '2024-04-15 12:00:00', 258, NULL, '3', '103', 105, 36, 31, 151, '2024-04-18 12:00:00', '2024-04-20 10:27:03', '21.00000', 1, '2024-04-08 10:14:02', 1629),
(756, 'Preslosas', 'Asegurar el punto de agua en obra', 6, '2024-04-09 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-04-11 12:00:00', '2024-04-17 16:17:10', '20.00000', 1, '2024-04-08 10:18:04', 1608),
(757, 'Cisterna', 'Modulación de planos ACEDIN', 3, '2024-04-09 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-04-09 12:00:00', '2024-04-13 13:59:06', '16.00000', 1, '2024-04-08 10:32:43', 1499),
(758, 'Cisterna', 'Pedido de consumibles', 12, '2024-04-08 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-04-11 12:00:00', '2024-04-17 16:17:07', '19.00000', 1, '2024-04-08 10:34:13', 1607),
(759, 'Cisterna', 'Modulación (cimentación verticales y horizontales)', 3, '2024-04-10 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-04-10 12:00:00', '2024-04-17 16:16:58', '17.00000', 1, '2024-04-08 10:36:02', 1605),
(760, 'Prelosas', 'Llegada de equipo para torre grúa', 6, '2024-04-08 12:00:00', 152, NULL, '3', '103', 105, 36, 31, 151, '2024-04-12 12:00:00', '2024-04-17 16:17:04', '18.00000', 1, '2024-04-08 10:37:19', 1606),
(761, 'Prelosas', 'Ingreso de caja ecológica', 8, '2024-04-15 12:00:00', 156, NULL, '3', '103', 105, 36, 31, 151, '2024-04-15 12:00:00', '2024-04-17 16:16:46', '15.00000', 1, '2024-04-08 10:38:26', 1604),
(767, 'S.E. Avenida Fernandini', 'Cierre para ingreso de SC para ejecución de trabajos', 4, '2024-04-19 12:00:00', 9, NULL, '3', '57', 41, 22, 4, 132, '2024-04-19 12:00:00', '2024-04-16 08:16:53', '12.00000', 1, '2024-04-11 17:00:20', 1562),
(768, 'Se. Avenida Fernandini', 'Solicitud de consumibles para ejecución de trabajos', 5, '2024-04-19 12:00:00', 64, NULL, '3', '57', 41, 22, 4, 132, '2024-04-17 12:00:00', '2024-04-18 17:49:49', '13.00000', 1, '2024-04-11 17:00:23', 1627),
(769, 'Acero de verticales (MC, placas y columnas)', 'Envío de criterios de dimensionamiento', 3, '2024-04-19 12:00:00', 141, NULL, '3', '73', 127, 30, 28, 148, '2024-04-19 12:00:00', '2024-04-18 07:40:23', '0.00000', 1, '2024-04-13 11:41:35', 1622),
(770, 'Acero de losa de piso de cisterna', 'Envío de criterios de dimensionamiento', 3, '2024-04-19 12:00:00', 141, NULL, '3', '73', 127, 30, 28, 148, '2024-04-19 12:00:00', '2024-04-18 11:31:19', '0.00000', 1, '2024-04-13 11:41:35', 1625),
(771, 'Acero de techo de cisterna', 'Envío de criterios de dimensionamiento', 3, '2024-04-25 12:00:00', 141, NULL, '3', '73', 127, 30, 28, 148, '2024-04-25 12:00:00', '2024-04-18 07:40:16', '0.00000', 1, '2024-04-13 11:41:35', 1621),
(772, 'Colocación de bridas en cisterna', 'Definición de ubicación y dimensiones de bridas', 3, '2024-04-22 12:00:00', 143, NULL, '3', '73', 127, 30, 28, 148, '2024-04-22 12:00:00', '2024-04-18 11:31:08', '0.00000', 1, '2024-04-13 11:41:35', 1623),
(773, 'Colocación de bridas en cisterna', 'Fabricación de bridas', 3, '2024-04-29 12:00:00', 143, NULL, '3', '73', 127, 30, 28, 148, '2024-04-29 12:00:00', '2024-04-27 09:45:17', '0.00000', 1, '2024-04-13 11:41:35', 1761),
(774, 'IISS / IIEE en cisterna', 'Ingreso de personal', 7, '2024-05-07 12:00:00', 143, NULL, '3', '73', 127, 30, 28, 148, '2024-05-07 12:00:00', '2024-05-03 09:01:50', '0.00000', 1, '2024-04-13 11:41:35', 1826),
(775, 'Vaciado de piso de cisterna', 'Definición de pendiente de losa de piso', 3, '2024-04-30 12:00:00', 143, NULL, '3', '73', 127, 30, 28, 148, '2024-04-30 12:00:00', '2024-05-02 07:36:28', '0.00000', 1, '2024-04-13 11:41:35', 1786),
(776, 'Encofrado de cisterna', 'Sectorización de encofrado de cisterna / piso, muros y techo', 3, '2024-04-22 12:00:00', 141, NULL, '3', '73', 127, 30, 28, 148, '2024-04-22 12:00:00', '2024-04-18 11:31:12', '0.00000', 1, '2024-04-13 11:41:35', 1624),
(777, 'Encofrado de cisterna', 'Diseño de encofrado', 6, '2024-04-29 12:00:00', 138, NULL, '3', '73', 127, 30, 28, 148, '2024-04-29 12:00:00', '2024-05-03 09:01:46', '0.00000', 1, '2024-04-13 11:41:35', 1825),
(778, 'Encofrado de cisterna', 'Recojo de encofrado', 10, '2024-05-08 12:00:00', 145, NULL, '3', '73', 127, 30, 28, 148, '2024-05-08 12:00:00', '2024-05-11 12:12:22', '0.00000', 1, '2024-04-13 11:41:35', 2369),
(779, 'Vaciado contrapisos bloque II', 'Verificar posibilidad de vaciado con bomba pluma', 7, '2024-04-03 12:00:00', 48, NULL, '3', '51', 45, 23, 14, 140, '2024-04-03 12:00:00', '2024-05-05 00:16:01', '0.00000', 1, '2024-04-14 11:04:08', 1850),
(780, 'Tarrajeo fachadas', 'Andamio colgante', 7, '2024-04-15 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-04-15 00:00:00', NULL, '0.00000', 1, '2024-04-14 11:04:08', NULL),
(781, 'Tarrajeo fachadas', 'Encapsulado', 7, '2024-04-15 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-04-15 00:00:00', NULL, '0.00000', 1, '2024-04-14 11:04:08', NULL),
(782, 'Tarrajeo fachadas', 'Grua para izaje', 7, '2024-04-15 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-04-15 00:00:00', NULL, '0.00000', 1, '2024-04-14 11:04:08', NULL),
(783, 'Instalacion aparatos sanitarios', 'Llegada de aparatos', 5, '2024-04-16 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-04-16 00:00:00', NULL, '0.00000', 1, '2024-04-14 11:04:08', NULL),
(784, 'Instalacion puertas', 'Llegada de puertas', 5, '2024-04-16 00:00:00', 50, NULL, '2', '51', 65, 23, 14, 140, '2024-04-20 00:00:00', NULL, '0.00000', 1, '2024-04-14 11:04:08', NULL),
(785, 'Se. Av Fernandini', 'Llegada de marcos de tapas embebidas en losa', 5, '2024-05-13 12:00:00', 64, NULL, '2', '57', 41, 22, 4, 132, '2024-05-13 12:00:00', NULL, '14.00000', 0, '2024-04-16 08:18:04', 2415),
(786, 'Rejillas', 'Llegada de rejillas a obra', 5, '2024-05-16 12:00:00', 64, NULL, '3', '57', 37, 21, 4, 132, '2024-05-17 12:00:00', '2024-05-09 09:40:49', '5.00000', 0, '2024-04-16 08:19:35', 2233),
(787, 'Colocación de topellantas', 'Llegada de saldo a obra', 5, '2024-05-11 12:00:00', 9, NULL, '2', '57', 39, 21, 4, 132, '2024-05-13 12:00:00', NULL, '3.00000', 0, '2024-04-16 08:21:23', 2235),
(791, 'Limpieza fina de sótano', 'Ingreso de personal para limpieza fina', 7, '2024-06-03 12:00:00', 9, NULL, '2', '57', 40, 21, 4, 132, '2024-05-31 12:00:00', NULL, '4.00000', 0, '2024-04-16 08:25:25', 2260),
(792, '', '', NULL, '2024-04-17 12:00:00', NULL, NULL, '1', '34', 128, 53, 36, 156, NULL, NULL, '0.00000', 1, '2024-04-18 15:51:15', 1626),
(793, 'Inicio de perfilado de muros', 'PETS de instalación de acero', 3, '2024-04-25 12:00:00', 275, NULL, '1', '104', 131, 54, 37, 157, '2024-05-06 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2355),
(794, 'Colocación de Acero', 'Orden de Compra de subcontrato de acero', 7, '2024-04-27 12:00:00', 274, NULL, '3', '104', 129, 54, 37, 157, '2024-04-27 12:00:00', '2024-05-02 16:56:17', '0.00000', 1, '2024-04-19 19:09:46', 1792),
(795, 'Pruebas de Calidad del Concreto', 'Adjudicación de subcontratista para pruebas de concreto', 7, '2024-05-02 12:00:00', 274, NULL, '2', '104', 132, 54, 37, 157, '2024-05-10 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2284),
(796, 'Actividades de obra', 'Instalación de desagüe de salida UPCH', 2, '2024-05-08 12:00:00', 283, NULL, '2', '104', 133, 54, 37, 157, '2024-05-08 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2204),
(797, 'Instalación de Cámaras PTZ', 'Documentos administrativos de instalador de cámara', 10, '2024-04-25 12:00:00', 279, NULL, '3', '104', 133, 54, 37, 157, '2024-04-30 12:00:00', '2024-05-09 17:35:10', '0.00000', 1, '2024-04-19 19:09:46', 2344),
(798, 'Instalación de estructura en volado', 'Documentos de Seguridad de subcontratista', 8, '2024-05-08 00:00:00', 276, NULL, '1', '104', 133, 54, 37, 157, '2024-05-08 00:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', NULL),
(799, 'Obras Provisionales', 'Planos de Sedapal, instalaciones de servicios', 3, '2024-05-09 12:00:00', 273, NULL, '3', '104', 131, 54, 37, 157, '2024-05-09 12:00:00', '2024-05-03 16:03:46', '0.00000', 1, '2024-04-19 19:09:46', 1834),
(800, 'Limpieza en Obra', 'Orden de Compra subcontrato de limpieza', 7, '2024-04-22 12:00:00', 274, NULL, '3', '104', 134, 54, 37, 157, '2024-04-22 12:00:00', '2024-05-02 16:57:02', '0.00000', 1, '2024-04-19 19:09:46', 1796),
(801, 'Instalación de Cámaras PTZ', 'Orden de Compra de PTZ', 7, '2024-04-24 12:00:00', 274, NULL, '3', '104', 134, 54, 37, 157, '2024-04-24 12:00:00', '2024-05-02 17:40:45', '0.00000', 1, '2024-04-19 19:09:46', 1820),
(802, 'Instalación de Cámaras PTZ', 'Documentos administrativos de instalador de cámara', 10, '2024-04-25 12:00:00', 279, NULL, '1', '104', 134, 54, 37, 157, '2024-04-30 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1776),
(803, 'Instalación de Cerco Provisional con Colegio Lincoln', 'Orden de Compra de Instalación de Cerco Provisional', 7, '2024-04-22 12:00:00', 274, NULL, '3', '104', 134, 54, 37, 157, '2024-04-22 12:00:00', '2024-05-02 16:56:53', '0.00000', 1, '2024-04-19 19:09:46', 1795),
(804, 'Instalación de Cerco Provisional Exterior', 'Orden de Compra de Instalación de Cerco Provisional', 7, '2024-04-25 12:00:00', 274, NULL, '3', '104', 134, 54, 37, 157, '2024-04-25 12:00:00', '2024-05-02 16:57:10', '0.00000', 1, '2024-04-19 19:09:46', 1797),
(805, 'Actividades de obra', 'Solución de desagüe', 10, '2024-04-22 12:00:00', 279, NULL, '1', '104', 134, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1799),
(806, 'Actividades de obra', 'Solicitud de ampliación de suministro de agua', 10, '2024-04-25 12:00:00', 279, NULL, '1', '104', 134, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1801),
(807, 'Anclajes postensados', 'Adjudicación de Flesan', 7, '2024-04-22 12:00:00', 274, NULL, '3', '104', 132, 54, 37, 157, '2024-04-22 12:00:00', '2024-04-19 19:11:44', '0.00000', 1, '2024-04-19 19:09:46', 1628),
(808, 'Anclajes postensados', 'Documentación administrativa de Flesan', 7, '2024-04-23 12:00:00', 279, NULL, '1', '104', 132, 54, 37, 157, '2024-05-11 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2343),
(809, 'Colocación de Acero', 'Orden de Compra de suministro de acero', 7, '2024-04-25 12:00:00', 274, NULL, '3', '104', 132, 54, 37, 157, '2024-04-25 12:00:00', '2024-05-02 17:14:06', '0.00000', 1, '2024-04-19 19:09:46', 1806),
(810, 'Colocación de Acero', 'Orden de Compra de subcontrato de acero', 7, '2024-04-27 12:00:00', 274, NULL, '3', '104', 132, 54, 37, 157, '2024-04-27 12:00:00', '2024-05-02 17:14:19', '0.00000', 1, '2024-04-19 19:09:46', 1807),
(811, 'Instalación de Cámaras', 'Colocación de 2 puntos de energía en garita', 2, '2024-05-03 12:00:00', 273, NULL, '2', '104', 132, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2201),
(812, 'Actividades con andamios', 'Envío de solicitud de andamios', 6, '2024-05-26 12:00:00', 272, NULL, '1', '104', 132, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1809),
(813, 'Actividades con andamios', 'Orden de Compra de andamios', 6, '2024-04-26 00:00:00', 274, NULL, '2', '104', 132, 54, 37, 157, '2024-04-26 00:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1865),
(814, 'Modelado 3D', 'Orden de Compra de modelamiento', 7, '2024-04-27 12:00:00', 274, NULL, '1', '104', 134, 54, 37, 157, '2024-05-09 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1872),
(815, 'Vaciado de muros', 'Definición de uso de unianclado', 7, '2024-04-22 12:00:00', 271, NULL, '3', '104', 132, 54, 37, 157, '2024-04-22 12:00:00', '2024-05-02 17:24:03', '0.00000', 1, '2024-04-19 19:09:46', 1810),
(816, 'Constatación Notarial', 'Entrega de informe de constatación notarial a Supervisión incluyendo pistas y veredas', 11, '2024-04-30 12:00:00', 279, NULL, '1', '104', 134, 54, 37, 157, '2024-05-13 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2352),
(817, 'Obras Provisionales', 'Planos de Sedapal, instalaciones de servicios', 3, '2024-05-09 12:00:00', 282, NULL, '2', '104', 132, 54, 37, 157, '2024-05-09 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 2208),
(818, 'Inicio de perfilado de muros', 'PETS de perfilado', 3, '2024-04-25 12:00:00', 280, NULL, '3', '104', 132, 54, 37, 157, '2024-04-25 12:00:00', '2024-05-02 17:27:56', '0.00000', 1, '2024-04-19 19:09:46', 1813),
(819, 'Inicio de perfilado de muros', 'PETS de instalación de acero', 3, '2024-04-25 12:00:00', 280, NULL, '1', '104', 132, 54, 37, 157, '2024-05-06 12:00:00', NULL, '0.00000', 1, '2024-04-19 19:09:46', 1814),
(820, 'Inicio de perfilado de muros', 'PETS de perforación de anclajes', 3, '2024-04-25 12:00:00', 280, NULL, '3', '104', 132, 54, 37, 157, '2024-04-25 12:00:00', '2024-05-02 17:29:42', '0.00000', 1, '2024-04-19 19:09:46', 1815),
(821, 'Aprobación de Planos Ascensores', 'No hay fecha de entrega de equipamiento y cronograma de ascensores', 3, '2024-04-26 12:00:00', 152, NULL, '3', '97', 103, 32, 31, 151, '2024-05-06 12:00:00', '2024-05-07 15:22:26', '1.00000', 1, '2024-04-20 19:56:42', 1906),
(822, 'Llenado de cisternas', 'Tapones en válvulas', 1, '2024-04-22 00:00:00', 55, NULL, '1', '51', 66, 13, 14, 140, '2024-04-22 00:00:00', NULL, '0.00000', 1, '2024-04-21 15:55:30', NULL),
(823, 'Mov. Tierras sala grupos electrogenos', 'Definición cimentacion grupos', 11, '2024-04-12 00:00:00', 50, NULL, '1', '51', 65, 23, 14, 140, '2024-04-17 00:00:00', NULL, '0.00000', 1, '2024-04-21 15:55:30', NULL),
(824, 'estoy escribiewn  asas', 'sds', 3, '2024-04-25 12:00:00', 57, NULL, '1', '19', 23, 15, 15, 141, NULL, NULL, '9.00000', 1, '2024-04-24 11:08:25', 1689),
(825, 'ACTIVIDAD 1', 'ESTRICCION 1', 4, '2024-04-17 12:00:00', NULL, NULL, '1', '19', 137, 57, 9, 136, NULL, NULL, '0.00000', 1, '2024-04-24 12:26:46', 1693),
(826, 'ACTIVIDAD 2 sd sd', 'RESTRICCION 2', NULL, '2024-04-25 12:00:00', NULL, NULL, '1', '19', 137, 57, 9, 136, NULL, NULL, '1.00000', 1, '2024-04-24 12:27:00', 1697),
(827, 'actividad', 'veremossd', 9, '2024-04-30 12:00:00', NULL, NULL, '1', '19', 137, 57, 9, 136, NULL, NULL, '2.00000', 1, '2024-04-26 11:10:05', 1700),
(828, 'Encofrados ULMA', 'Llegada de andamios Brio', 6, '2024-04-26 12:00:00', 154, NULL, '3', '103', 105, 36, 31, 151, '2024-05-03 12:00:00', '2024-05-04 10:34:03', '1.00000', 1, '2024-04-27 08:45:13', 1840),
(829, 'Prelosas', 'Consultar dimensión de alero', 3, '2024-04-26 12:00:00', 154, NULL, '3', '103', 105, 36, 31, 151, '2024-04-29 12:00:00', '2024-04-30 19:15:00', '2.00000', 1, '2024-04-27 08:47:02', 1777),
(830, 'Prelosas', 'Coordinar el desencofrado del frente 2 para que no interrumpa vaciado del frente 1', 1, '2024-04-26 12:00:00', 259, NULL, '3', '103', 105, 36, 31, 151, '2024-05-02 12:00:00', '2024-05-02 07:22:39', '3.00000', 1, '2024-04-27 08:47:49', 1780),
(831, 'Excavación sala grupos electrógenos', 'Corrección observacion retro', 6, '2024-04-27 00:00:00', 50, NULL, '2', '51', 138, 49, 14, 140, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(832, 'Forjado escaleras', 'Ingreso cuadrilla', 7, '2024-04-22 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', '2024-05-07 14:00:38', '0.00000', 1, '2024-04-28 12:47:01', 1889),
(833, 'Forjado escaleras', 'Instalación montante ACI', 7, '2024-04-26 00:00:00', 55, NULL, '1', '51', 123, 50, 14, 140, '2024-04-30 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(834, 'Solaqueo fachada vecino morales', 'Protección techo', 4, '2024-04-26 00:00:00', 48, NULL, '1', '51', 123, 50, 14, 140, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(835, 'Solaqueo fachada vecino morales', 'Encapsulado andamios, incremento personal sc', 7, '2024-04-26 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', '2024-05-07 14:00:25', '0.00000', 1, '2024-04-28 12:47:01', 1887),
(836, 'Tarrajeo fachada montero rosas', 'Retiro de malla anticaída, incremento personal sc', 7, '2024-04-24 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', '2024-05-07 14:00:41', '0.00000', 1, '2024-04-28 12:47:01', 1890),
(837, 'Trazo planchas estructura pasarela', 'Armado de andamio para trazo topografía', 4, '2024-04-26 00:00:00', 105, NULL, '1', '51', 123, 50, 14, 140, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(838, 'Cierre tabique triple altura', 'Izaje de material EEMM pasarela', 7, '2024-04-26 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-05-02 12:00:00', '2024-05-10 11:34:46', '0.00000', 0, '2024-04-28 12:47:01', 2362),
(839, 'Enchape baños piso 5', 'Incremento personal sc', 7, '2024-04-26 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-05-02 12:00:00', '2024-05-07 14:00:29', '0.00000', 1, '2024-04-28 12:47:01', 1888),
(840, 'Pintura escaleras', 'Incremento personal sc', 7, '2024-04-26 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-05-02 12:00:00', '2024-05-07 14:00:45', '0.00000', 1, '2024-04-28 12:47:01', 1891),
(841, 'Vaciado contrapisos', 'Levantamiento topográfico niveles', 4, '2024-04-26 00:00:00', 105, NULL, '1', '51', 123, 50, 14, 140, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(842, 'Vaciado contrapisos', 'Visita coordinador bombas Pumpmix', 7, '2024-04-26 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', '2024-05-07 14:00:11', '0.00000', 1, '2024-04-28 12:47:01', 1885),
(843, 'Fabricación EEMM estudios 1 y 2', 'Definir altura de la eemm', 11, '2024-04-22 12:00:00', 50, NULL, '1', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', 1893),
(844, 'Anclaje EEMM estudio 3', 'Definir anclaje en vigas postensadas', 11, '2024-04-22 12:00:00', 50, NULL, '3', '51', 123, 50, 14, 140, '2024-04-29 12:00:00', '2024-05-07 14:00:18', '0.00000', 1, '2024-04-28 12:47:01', 1886),
(845, 'Anclaje EEMM estudio 3', 'Resolver incompatibilidad anclajes que caen en ducto', 11, '2024-04-16 00:00:00', 50, NULL, '1', '51', 123, 50, 14, 140, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-28 12:47:01', NULL),
(846, 'Inicio de perfilado de muros', 'PETS de instalación de acero', 3, '2024-04-26 12:00:00', 275, NULL, '1', '104', 129, 54, 37, 157, '2024-05-06 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 2356),
(847, 'Pedido de EPPs', 'Histograma de personal de casco', 3, '2024-05-02 12:00:00', 272, NULL, '1', '104', 134, 54, 37, 157, '2024-05-06 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 1805),
(848, 'Inicio de movimiento de tierras', 'Documentación de seguridad de subcontrata de movimiento de tierras', 7, '2024-05-03 12:00:00', 276, NULL, '3', '104', 129, 54, 37, 157, '2024-05-03 12:00:00', '2024-05-08 15:21:51', '0.00000', 1, '2024-04-29 19:09:10', 2199),
(849, 'Obras Provisionales', 'Nuevo Layout de Plataformas', 3, '2024-05-03 12:00:00', 272, NULL, '3', '104', 134, 54, 37, 157, '2024-05-03 12:00:00', '2024-05-02 17:10:23', '0.00000', 1, '2024-04-29 19:09:10', 1800),
(850, 'Actividades de obra', 'Subcontrato de Vigías', 7, '2024-05-02 12:00:00', 274, NULL, '2', '104', 134, 54, 37, 157, '2024-05-10 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 1873),
(851, 'Inicio de actividades de eliminación', 'Permiso de uso de vías', 10, '2024-05-10 00:00:00', 279, NULL, '2', '104', 129, 54, 37, 157, '2024-05-10 00:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', NULL),
(852, 'Obras Provisionales', 'Llegada de parantes de madera para señalización y pintura', 5, '2024-05-02 12:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-05-02 12:00:00', '2024-05-02 17:08:19', '0.00000', 1, '2024-04-29 19:09:10', 1798),
(853, 'Inicio de trabajos', 'Aprobación del estructural', 3, '2024-05-02 12:00:00', 272, NULL, '3', '104', 132, 54, 37, 157, '2024-05-02 12:00:00', '2024-05-02 17:14:39', '0.00000', 1, '2024-04-29 19:09:10', 1808),
(854, 'Instalación de Cámaras', 'Colocación de 2 puntos de energía en garita', 2, '2024-05-03 12:00:00', 283, NULL, '2', '104', 132, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 2206),
(855, 'Actividades de obra', 'Llegada de Cartel de obra', 5, '2024-04-29 00:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', NULL),
(856, 'Actividades de obra', 'Constatación notarial de pistas y veredas para enviar a Municipalidad', 10, '2024-05-02 12:00:00', 279, NULL, '2', '104', 134, 54, 37, 157, '2024-05-13 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 2345),
(857, 'Actividades de obra', 'Reunión con junta vecinal', 10, '2024-04-30 00:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-04-30 00:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', NULL),
(858, 'Actividades de obra', 'Capacitación de tareo de personal con BILDIN', 10, '2024-04-30 12:00:00', 279, NULL, '1', '104', 134, 54, 37, 157, '2024-05-03 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 2354),
(859, 'Inicio de actividades', 'Informe de estatus de grúas propias', 3, '2024-04-30 12:00:00', 279, NULL, '3', '104', 139, 54, 37, 157, '2024-04-30 12:00:00', '2024-05-02 17:33:48', '0.00000', 1, '2024-04-29 19:09:10', 1817),
(860, 'Actividades de obra', 'Informe de stock de material', 3, '2024-04-30 12:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-04-30 12:00:00', '2024-05-02 17:36:20', '0.00000', 1, '2024-04-29 19:09:10', 1818),
(861, 'Actividades de obra', 'Consulta de traspaso de duchas propias y otros', 3, '2024-04-30 12:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-05-03 12:00:00', '2024-05-09 17:36:29', '0.00000', 1, '2024-04-29 19:09:10', 2347),
(862, 'Inicio de actividades', 'Adjudiación de Torre Gúa', 7, '2024-04-30 12:00:00', 274, NULL, '2', '104', 139, 54, 37, 157, '2024-05-13 12:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', 1875),
(863, 'Actividades de obra', 'Implementación de nueva concesionaria de comida', 10, '2024-05-02 12:00:00', 279, NULL, '3', '104', 134, 54, 37, 157, '2024-05-06 12:00:00', '2024-05-09 17:36:02', '0.00000', 1, '2024-04-29 19:09:10', 2346),
(864, 'Actividades de obra', 'Construcción del nuevo comedor', 2, '2024-04-30 12:00:00', 272, NULL, '3', '104', 134, 54, 37, 157, '2024-04-30 12:00:00', '2024-05-02 17:44:19', '0.00000', 1, '2024-04-29 19:09:10', 1823),
(865, 'Inicio de vaciado de cimentaciones', 'Envío de información para la cotización de placing - Unicon', 3, '2024-04-29 00:00:00', 272, NULL, '3', '104', 139, 54, 37, 157, '2024-04-29 00:00:00', NULL, '0.00000', 1, '2024-04-29 19:09:10', NULL),
(866, 'Actividades de obra', 'Construcción del nuevo comedor', 2, '2024-05-06 00:00:00', 272, NULL, '2', '104', 134, 54, 37, 157, '2024-05-06 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(867, 'Instalación de Cámaras', 'Colocación de 2 puntos de energía en garita', 2, '2024-05-03 00:00:00', 273, NULL, '2', '104', 134, 54, 37, 157, '2024-05-03 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(868, 'Instalación de Cámaras', 'Colocación de punto de internet en garita', 2, '2024-05-04 00:00:00', 273, NULL, '2', '104', 134, 54, 37, 157, '2024-05-04 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(869, 'Actividades de obra', 'Instalación de desagüe de salida UPCH', 2, '2024-05-08 00:00:00', 273, NULL, '2', '104', 134, 54, 37, 157, '2024-05-08 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(870, 'Actividades de obra', 'Solución de desagüe', 10, '2024-04-22 12:00:00', 283, NULL, '3', '104', 132, 54, 37, 157, '2024-05-03 12:00:00', '2024-05-09 17:41:28', '0.00000', 1, '2024-05-02 18:37:23', 2358),
(871, 'Instalación de Acero', 'Documentos administrativos de mano de obra de JCHE', 7, '2024-05-06 12:00:00', 279, NULL, '3', '104', 132, 54, 37, 157, '2024-05-06 12:00:00', '2024-05-09 17:34:14', '0.00000', 1, '2024-05-02 18:37:23', 2342),
(872, 'Instalación de Acero', 'Documentos de seguridad de mano de obra de JCHE', 7, '2024-05-07 00:00:00', 276, NULL, '2', '104', 132, 54, 37, 157, '2024-05-07 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(873, 'Obras Provisionales', 'Planos de Sedapal, instalaciones de servicios', 3, '2024-05-09 00:00:00', 273, NULL, '2', '104', 134, 54, 37, 157, '2024-05-09 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(874, 'Colocación de cerco perimétrico', 'Evaluación de reubicación de árboles menores en exteriores', 3, '2024-05-07 00:00:00', 274, NULL, '2', '104', 134, 54, 37, 157, '2024-05-07 00:00:00', NULL, '0.00000', 1, '2024-05-02 18:37:23', NULL),
(875, 'Excavación', 'Evaluación de reforzamiento de canal en frontis del proyecto', 3, '2024-05-06 12:00:00', 274, NULL, '3', '104', 129, 54, 37, 157, '2024-05-06 12:00:00', '2024-05-06 15:52:03', '0.00000', 1, '2024-05-02 18:37:23', 1866),
(876, 'Inicio de casco', 'Definición de uso de prelosas', 3, '2024-05-08 12:00:00', 274, NULL, '2', '104', 139, 54, 37, 157, '2024-05-27 12:00:00', NULL, '0.00000', 1, '2024-05-03 15:47:18', 1874),
(895, 'Tabiquería', 'Planos de arquitectura aulas inicial', 3, '2024-05-07 12:00:00', 284, NULL, '1', '103', 144, 32, 31, 151, '2024-05-15 12:00:00', NULL, '0.00000', 1, '2024-05-07 16:24:24', 2423),
(896, 'Tabiquería', 'Compra de materiales tabiquería', 5, '2024-05-07 12:00:00', 152, NULL, '1', '103', 144, 32, 31, 151, '2024-05-16 12:00:00', NULL, '1.00000', 1, '2024-05-07 16:25:33', 2424),
(897, 'Tabiquería', 'Adjudicación de subcontratista de mano de obra para tabiquería', 7, '2024-05-07 12:00:00', 152, NULL, '1', '103', 144, 32, 31, 151, '2024-05-16 12:00:00', NULL, '2.00000', 1, '2024-05-07 16:26:10', 2425),
(898, 'Tabiquería', 'PETS para tarrajeo interiores', 8, '2024-05-07 12:00:00', 153, NULL, '1', '103', 144, 32, 31, 151, '2024-05-17 12:00:00', NULL, '3.00000', 1, '2024-05-07 16:27:15', 2428),
(899, 'Tabiquería', 'PETS para solaqueo', 8, '2024-05-07 12:00:00', 153, NULL, '1', '103', 144, 32, 31, 151, '2024-05-17 12:00:00', NULL, '4.00000', 1, '2024-05-07 16:27:20', 2430),
(900, 'Tabiquería', 'Compra materiales tarrajeo interior', 5, '2024-05-07 12:00:00', 154, NULL, '1', '103', 144, 32, 31, 151, '2024-05-20 12:00:00', NULL, '6.00000', 1, '2024-05-07 16:27:22', 2433),
(901, 'Tabiquería', 'Compra materiales solaqueo', 5, '2024-05-07 12:00:00', 154, NULL, '1', '103', 144, 32, 31, 151, '2024-05-20 12:00:00', NULL, '7.00000', 1, '2024-05-07 16:31:33', 2434),
(902, 'Tabiquería', 'Ingreso personal tarrajeo interior', 4, '2024-05-07 12:00:00', 154, NULL, '1', '103', 144, 32, 31, 151, '2024-05-20 12:00:00', NULL, '8.00000', 1, '2024-05-07 16:33:28', 2436),
(903, 'Tabiquería', 'Ingreso personal solaqueo', 4, '2024-05-07 12:00:00', 154, NULL, '1', '103', 144, 32, 31, 151, '2024-05-20 12:00:00', NULL, '9.00000', 1, '2024-05-07 16:34:07', 2437),
(904, 'Tabiquería', 'Planos de arquitectura aulas secundaria', 3, '2024-05-07 12:00:00', 284, NULL, '1', '103', 145, 36, 31, 151, '2024-05-15 12:00:00', NULL, '0.00000', 1, '2024-05-07 16:38:48', 2064),
(905, 'Tabiquería', 'Adjudicación de subcontratista de mano de obra para tabiquería', 7, '2024-05-07 12:00:00', 152, NULL, '1', '103', 145, 36, 31, 151, '2024-05-16 12:00:00', NULL, '2.00000', 1, '2024-05-07 16:38:53', 2457),
(906, 'Tabiquería', 'PETS para tarrajeo', 8, '2024-05-07 12:00:00', 259, NULL, '1', '103', 145, 36, 31, 151, '2024-05-15 12:00:00', NULL, '3.00000', 1, '2024-05-07 16:38:55', 2097),
(907, 'Tabiquería', 'PETS para solaqueo', 8, '2024-05-07 12:00:00', 259, NULL, '1', '103', 145, 36, 31, 151, '2024-05-15 12:00:00', NULL, '4.00000', 1, '2024-05-07 16:38:57', 2098),
(908, 'Tabiquería', 'Compra materiales tarrajeo interior', 5, '2024-05-07 12:00:00', 154, NULL, '1', '103', 145, 36, 31, 151, '2024-05-20 12:00:00', NULL, '6.00000', 1, '2024-05-07 16:39:00', 2462),
(909, 'Tabiquería', 'Compra materiales solaqueo', 5, '2024-05-07 12:00:00', 154, NULL, '1', '103', 145, 36, 31, 151, '2024-05-20 12:00:00', NULL, '7.00000', 1, '2024-05-07 16:39:03', 2463),
(910, 'Tabiquería', 'Ingreso personal solaqueo', 4, '2024-05-07 12:00:00', 154, NULL, '1', '103', 145, 36, 31, 151, '2024-05-20 12:00:00', NULL, '9.00000', 1, '2024-05-07 16:39:07', 2464),
(911, 'Tabiquería', 'Compra de materiales tabiquería', 5, '2024-05-07 12:00:00', 152, NULL, '1', '103', 145, 36, 31, 151, '2024-05-16 12:00:00', NULL, '1.00000', 1, '2024-05-07 16:39:55', 2455),
(912, 'Tabiquería', 'Ingreso personal tarrajeo interior', 4, '2024-05-07 12:00:00', 154, NULL, '1', '103', 145, 36, 31, 151, '2024-05-20 12:00:00', NULL, '8.00000', 1, '2024-05-07 16:40:33', 2472),
(913, 'IIEE', 'Adjudicación de subcontrata para sistema de pozo a tierra', 7, '2024-05-07 12:00:00', 152, NULL, '1', '103', 146, 32, 31, 151, '2024-05-20 12:00:00', NULL, '0.00000', 1, '2024-05-07 17:00:26', 2438),
(914, 'Losa CT', 'Pedidos materiales losa contra terreno', 5, '2024-05-07 12:00:00', 285, NULL, '1', '103', 146, 32, 31, 151, '2024-05-22 12:00:00', NULL, '1.00000', 1, '2024-05-07 17:04:40', 2441),
(915, 'Losa CT', 'Planos de juntas para construcción losa CT', 3, '2024-05-07 12:00:00', 285, NULL, '1', '103', 146, 32, 31, 151, '2024-05-22 12:00:00', NULL, '2.00000', 1, '2024-05-07 17:04:44', 2442),
(916, 'Losa CT', 'Definir espesores de pisos', 3, '2024-05-07 12:00:00', 284, NULL, '1', '103', 146, 32, 31, 151, '2024-05-20 12:00:00', NULL, '3.00000', 1, '2024-05-07 17:05:12', 2137),
(917, 'Losa CT', 'PETS losa contra terreno', 8, '2024-05-07 12:00:00', 285, NULL, '1', '103', 146, 32, 31, 151, '2024-05-23 12:00:00', NULL, '4.00000', 1, '2024-05-07 17:05:18', 2443),
(919, 'Tabiquería', 'Diseño de tabiquería', 3, '2024-05-07 12:00:00', 152, NULL, '1', '103', 144, 32, 31, 151, '2024-05-20 12:00:00', NULL, '5.00000', 1, '2024-05-07 17:12:17', 2431),
(920, 'Tabiquería', 'Diseño tabiquería', 3, '2024-05-07 12:00:00', 152, NULL, '1', '103', 145, 36, 31, 151, '2024-05-20 12:00:00', NULL, '5.00000', 1, '2024-05-07 17:13:19', 2458),
(921, 'IIEE', 'Adjudicación de subcontrata para sistema de pozo a tierra', 7, '2024-05-07 12:00:00', 152, NULL, '1', '103', 147, 36, 31, 151, '2024-05-20 12:00:00', NULL, '0.00000', 1, '2024-05-07 17:15:44', 2469),
(922, 'Losa CT', 'Pedidos materiales losa contra terreno', 5, '2024-05-07 12:00:00', 259, NULL, '1', '103', 147, 36, 31, 151, '2024-05-22 12:00:00', NULL, '1.00000', 1, '2024-05-07 17:15:47', 2466),
(923, 'Losa CT', 'Planos de juntas para construcción losa CT', 3, '2024-05-07 12:00:00', 259, NULL, '1', '103', 147, 36, 31, 151, '2024-05-22 12:00:00', NULL, '2.00000', 1, '2024-05-07 17:15:50', 2467),
(924, 'Losa CT', 'Definir espesores de pisos', 3, '2024-05-07 12:00:00', 284, NULL, '1', '103', 147, 36, 31, 151, '2024-05-20 12:00:00', NULL, '3.00000', 1, '2024-05-07 17:15:53', 2179),
(925, 'Losa CT', 'PETS losa contra terreno', 8, '2024-05-07 12:00:00', 262, NULL, '1', '103', 147, 36, 31, 151, '2024-05-23 12:00:00', NULL, '4.00000', 1, '2024-05-07 17:16:15', 2468),
(926, 'Falso Cielo Raso', 'Confirmación falso cielo raso - baldosas', 3, '2024-05-07 12:00:00', 152, NULL, '1', '103', 148, 32, 31, 151, '2024-05-30 12:00:00', NULL, '0.00000', 1, '2024-05-07 17:19:54', 2445),
(927, 'Falso Cielo Raso', 'Confirmación de falso cielo raso', 3, '2024-05-07 12:00:00', 152, NULL, '1', '103', 149, 36, 31, 151, '2024-05-17 12:00:00', NULL, '0.00000', 1, '2024-05-07 17:23:08', 2195),
(928, 'Se. Av Fernandini', 'Llegada de reja metálica para puerta', 5, '2024-05-20 12:00:00', 9, NULL, '2', '57', 41, 22, 4, 132, '2024-05-17 12:00:00', NULL, '14.00100', 0, '2024-05-09 09:34:22', 2220),
(929, 'Pintura de fachadas', 'Llegada e instalación de barandas de fachada para culminación de pintura', 1, '2024-05-17 12:00:00', 132, NULL, '2', '57', 44, 22, 4, 132, '2024-05-17 12:00:00', NULL, '8.00000', 0, '2024-05-09 09:36:08', 2230),
(930, 'Baranda piso  12', 'Definir diseño de baranda', 3, '2024-05-15 12:00:00', 9, NULL, '2', '57', 43, 22, 4, 132, '2024-05-14 12:00:00', NULL, '18.00000', 0, '2024-05-09 09:58:17', 2246),
(931, 'Cerco perimétrico', 'Definir detalle de cerco perimétrico', 3, '2024-05-16 12:00:00', 9, NULL, '2', '57', 150, 22, 4, 132, '2024-05-15 12:00:00', NULL, '0.00000', 0, '2024-05-09 10:03:07', 2276),
(932, 'Puerta batiente en ingreso', 'ingreso de materiales y personal', 7, '2024-05-16 12:00:00', 64, NULL, '2', '57', 150, 22, 4, 132, '2024-05-16 12:00:00', NULL, '1.00000', 0, '2024-05-09 10:03:14', 2279),
(933, '', '', NULL, '2024-05-16 12:00:00', NULL, NULL, '1', '57', 150, 22, 4, 132, NULL, NULL, '2.00000', 0, '2024-05-09 10:03:17', 2249),
(934, '', '', NULL, '2024-05-16 12:00:00', NULL, NULL, '1', '57', 150, 22, 4, 132, NULL, NULL, '3.00000', 0, '2024-05-09 10:03:19', 2250),
(935, '', '', NULL, '2024-05-16 12:00:00', NULL, NULL, '1', '57', 150, 22, 4, 132, NULL, NULL, '4.00000', 0, '2024-05-09 10:03:23', 2251),
(936, '', '', NULL, '2024-05-16 12:00:00', NULL, NULL, '1', '57', 150, 22, 4, 132, NULL, NULL, '5.00000', 0, '2024-05-09 10:03:26', 2252),
(937, 'Pintura de tráfico en sótanos', 'Definir SC para pintura de tráfico', 7, '2024-05-20 12:00:00', 9, NULL, '2', '57', 40, 21, 4, 132, '2024-05-20 12:00:00', NULL, '3.00000', 0, '2024-05-09 10:06:06', 2266);
INSERT INTO `anares_actividad` (`codAnaResActividad`, `desActividad`, `desRestriccion`, `codTipoRestriccion`, `dayFechaRequerida`, `idUsuarioResponsable`, `desAreaResponsable`, `codEstadoActividad`, `codUsuarioSolicitante`, `codAnaResFase`, `codAnaResFrente`, `codProyecto`, `codAnaRes`, `dayFechaConciliada`, `dayFechaLevantamiento`, `numOrden`, `flgNoti`, `dayFechaCreacion`, `codAnaResActividadTrackLast`) VALUES
(938, 'Pintura de puertas en depósitos', 'Definir si se pintarán los depósitos', 3, '2024-05-14 12:00:00', 59, NULL, '2', '57', 40, 21, 4, 132, '2024-05-14 12:00:00', NULL, '2.00000', 0, '2024-05-09 10:08:09', 2272),
(939, 'Encofrado ', 'Llegada de equipos techo sotano 3', 6, '2024-05-24 00:00:00', 141, NULL, '2', '75', 151, 30, 28, 148, '2024-05-24 00:00:00', NULL, '0.00000', 1, '2024-05-11 11:35:34', NULL),
(940, 'Actividades de Obra', 'Solicitud a Luz del Sur de conexión de energía adicional para segunda grúa', 3, '2024-05-14 00:00:00', 283, NULL, '2', '104', 134, 54, 37, 157, '2024-05-14 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(941, 'Actividades de Obra', 'Tramitar Suministro definitivo de energía para el proyecto', 3, '2024-05-17 00:00:00', 283, NULL, '2', '104', 134, 54, 37, 157, '2024-05-17 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(942, 'Actividades de Obra', 'Inicio de trámite de obras complementarias', 3, '2024-05-15 00:00:00', 283, NULL, '2', '104', 134, 54, 37, 157, '2024-05-15 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(943, 'Actividades de Obra', 'Acordar con Supervsión reforzamiento de cerco con Lincoln', 3, '2024-05-13 00:00:00', 274, NULL, '2', '104', 134, 54, 37, 157, '2024-05-13 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(944, 'Actividades de Obra', 'Presentar propuesta de solución a supervisión para reforzar canal que pasa por calle Jose Antonio', 3, '2024-05-13 00:00:00', 274, NULL, '2', '104', 134, 54, 37, 157, '2024-05-13 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(945, 'Actividades de Obra', 'Propuesta para mejoramiento de puente de Matazango', 3, '2024-05-16 00:00:00', 274, NULL, '2', '104', 134, 54, 37, 157, '2024-05-16 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(946, 'Pedido de Materiales', 'Cronograma de Adquisiciones', 3, '2024-05-14 00:00:00', 274, NULL, '2', '104', 139, 54, 37, 157, '2024-05-14 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(947, 'Inicio de Casco', 'Master Plan de estructuras', 3, '2024-05-18 00:00:00', 272, NULL, '2', '104', 139, 54, 37, 157, '2024-05-18 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(948, 'Inicio de Acabados', 'Master Plan de obras grises', 3, '2024-05-31 00:00:00', 272, NULL, '2', '104', 152, 54, 37, 157, '2024-05-31 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(949, 'Inicio de Casco', 'Master Plan total', 3, '2024-06-15 00:00:00', 272, NULL, '2', '104', 139, 54, 37, 157, '2024-06-15 00:00:00', NULL, '0.00000', 1, '2024-05-11 12:01:07', NULL),
(950, 'Relleno y Compactación', 'Procedimiento de relleno de unisuelo', 3, '2024-05-10 12:00:00', 259, NULL, '3', '103', 153, 36, 31, 151, '2024-05-14 12:00:00', '2024-05-14 17:54:12', '0.00000', 1, '2024-05-11 13:00:18', 2470),
(951, 'Techo Cisterna', 'Plano ULMA', 7, '2024-05-10 12:00:00', 259, NULL, '3', '103', 153, 36, 31, 151, '2024-05-14 12:00:00', '2024-05-14 12:34:02', '1.00000', 1, '2024-05-11 13:00:21', 2446),
(952, 'Techo Cisterna', 'Inspección de filtraciones de cisterna', 9, '2024-05-10 12:00:00', 259, NULL, '3', '103', 153, 36, 31, 151, '2024-05-14 12:00:00', '2024-05-14 12:34:07', '2.00000', 1, '2024-05-11 13:00:23', 2447),
(953, 'Techo Cisterna', 'Procedimiento de techo de cisterna', 3, '2024-05-10 12:00:00', 259, NULL, '3', '103', 153, 36, 31, 151, '2024-05-14 12:00:00', '2024-05-14 12:35:08', '3.00000', 1, '2024-05-11 13:00:28', 2448),
(954, 'Techo Cisterna', 'Recolecta cimbra brío para el techo', 12, '2024-05-10 12:00:00', 259, NULL, '3', '103', 153, 36, 31, 151, '2024-05-14 12:00:00', '2024-05-14 12:35:26', '4.00000', 1, '2024-05-11 13:00:32', 2449),
(955, 'Techo Cuarto de Bombas', 'Revisión de espesor de techo de cuarto de bombas', 3, '2024-05-10 12:00:00', 259, NULL, '1', '103', 153, 36, 31, 151, '2024-05-21 12:00:00', NULL, '5.00000', 1, '2024-05-11 13:01:04', 2452);

-- --------------------------------------------------------

--
-- Table structure for table `anares_actividad_tracking`
--

CREATE TABLE `anares_actividad_tracking` (
  `codAnaResActividadTrack` bigint(20) NOT NULL,
  `codAnaResActividad` bigint(20) DEFAULT NULL,
  `codProyecto` bigint(20) DEFAULT NULL,
  `codEstadoActividadInicial` char(18) DEFAULT NULL,
  `codEstadoActividadFinal` char(18) DEFAULT NULL,
  `codRetrasoMotivo` bigint(20) DEFAULT NULL,
  `desRetrasoComentario` text DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(100) DEFAULT NULL,
  `codUsuarioCreacion` bigint(20) NOT NULL,
  `flagRetrasoAprobacion` int(11) DEFAULT NULL,
  `codEstadoAprobacion` int(11) DEFAULT NULL,
  `codUsuarioAprobacion` int(11) DEFAULT NULL,
  `dayFechaAprobacion` datetime DEFAULT NULL,
  `desComentarioFinal` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `anares_actividad_tracking`
--

INSERT INTO `anares_actividad_tracking` (`codAnaResActividadTrack`, `codAnaResActividad`, `codProyecto`, `codEstadoActividadInicial`, `codEstadoActividadFinal`, `codRetrasoMotivo`, `desRetrasoComentario`, `dayFechaCreacion`, `desUsuarioCreacion`, `codUsuarioCreacion`, `flagRetrasoAprobacion`, `codEstadoAprobacion`, `codUsuarioAprobacion`, `dayFechaAprobacion`, `desComentarioFinal`) VALUES
(32, 280, 15, '1', '2', -1, '', '2024-01-24 14:17:55', '', 19, -1, -1, -1, NULL, NULL),
(2472, 912, 31, '1', '1', -1, '', '2024-05-14 17:54:46', '', 84, -1, -1, -1, NULL, NULL),
(2473, 118, 6, '1', '1', -1, '', '2024-05-14 18:32:38', '', 19, -1, -1, -1, NULL, NULL),
(2474, 118, 6, '1', '1', -1, '', '2024-05-15 00:18:50', '', 19, -1, -1, -1, NULL, NULL),
(2475, 118, 6, '1', '1', -1, '', '2024-05-15 00:19:01', '', 19, -1, -1, -1, NULL, NULL),
(2476, 118, 6, '1', '1', -1, '', '2024-05-15 00:19:47', '', 19, -1, -1, -1, NULL, NULL),
(2477, 118, 6, '1', '1', -1, '', '2024-05-15 00:43:29', '', 19, -1, -1, -1, NULL, NULL),
(2478, 118, 6, '1', '1', -1, '', '2024-05-15 00:57:02', '', 19, -1, -1, -1, NULL, NULL),
(2479, 118, 6, '1', '1', -1, '', '2024-05-15 08:31:55', '', 19, -1, -1, -1, NULL, NULL),
(2480, 118, 6, '1', '1', -1, '', '2024-05-15 08:40:04', '', 19, -1, -1, -1, NULL, NULL),
(2481, 118, 6, '1', '1', -1, '', '2024-05-15 09:02:43', '', 19, -1, -1, -1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `anares_analisisrestricciones`
--

CREATE TABLE `anares_analisisrestricciones` (
  `codProyecto` bigint(20) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `indNoRetrasados` int(11) DEFAULT NULL,
  `indRetrasados` int(11) DEFAULT NULL,
  `codAnaRes` bigint(20) NOT NULL,
  `desColOcultas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `anares_analisisrestricciones`
--

INSERT INTO `anares_analisisrestricciones` (`codProyecto`, `codEstado`, `dayFechaCreacion`, `desUsuarioCreacion`, `indNoRetrasados`, `indRetrasados`, `codAnaRes`, `desColOcultas`) VALUES
(1, 0, '2023-03-22 04:07:05', 'diego@gmail.com', 0, 0, 129, ' '),
(2, 0, '2023-03-23 03:58:44', 'armando@remasa.com.pe', 0, 0, 130, NULL),
(3, 0, '2023-03-23 10:58:14', 'armando@remasa.com.pe', 0, 0, 131, NULL),
(4, 0, '2023-03-23 11:34:54', 'vjimenez@inarco.com.pe', 0, 0, 132, ' '),
(5, 1, '2023-03-24 10:39:28', 'vjimenez@inarco.com.pe', 0, 0, 133, NULL),
(6, 0, '2023-06-25 01:10:59', 'diego@gmail.com', 0, 0, 134, NULL),
(7, 0, '2023-07-01 16:05:25', 'diegowarthonwh@gmail.com', 0, 0, 135, NULL),
(9, 0, '2023-08-23 17:05:52', 'diego@gmail.com', 0, 0, 136, NULL),
(10, 0, '2023-08-23 17:11:14', 'diego@gmail.com', 0, 0, 137, NULL),
(11, 0, '2023-08-23 21:47:10', 'diego@gmail.com', 0, 0, 138, NULL),
(14, 0, '2023-08-29 12:37:21', 'bduelles@inarco.com.pe', 0, 0, 140, NULL),
(15, 0, '2023-09-20 09:57:30', 'diego@gmail.com', 0, 0, 141, NULL),
(22, 0, '2023-10-05 11:53:25', 'jmasias@inarco.com.pe', 0, 0, 142, NULL),
(23, 1, '2023-10-05 11:57:40', 'jmasias@inarco.com.pe', 0, 0, 143, NULL),
(28, 0, '2023-12-07 13:43:28', 'bduelles@inarco.com.pe', 0, 0, 148, NULL),
(29, 0, '2023-12-13 17:13:04', 'diego@gmail.com', 0, 0, 149, NULL),
(30, 0, '2023-12-14 00:35:36', 'diego@gmail.com', 0, 0, 150, NULL),
(31, 0, '2024-01-22 10:46:04', 'bduelles@inarco.com.pe', 0, 0, 151, NULL),
(32, 0, '2024-02-12 09:48:26', 'bduelles@inarco.com.pe', 0, 0, 152, NULL),
(33, 0, '2024-02-16 11:22:49', 'bduelles@inarco.com.pe', 0, 0, 153, NULL),
(34, 0, '2024-02-16 11:44:55', 'bduelles@inarco.com.pe', 0, 0, 154, NULL),
(35, 0, '2024-02-16 12:12:44', 'bduelles@inarco.com.pe', 0, 0, 155, NULL),
(37, 0, '2024-04-19 10:52:25', 'bduelles@inarco.com.pe', 0, 0, 157, NULL),
(38, 0, '2024-05-17 13:38:47', 'darien.vr.98@gmail.com', 0, 0, 158, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `anares_analisis_tiporestricciones`
--

CREATE TABLE `anares_analisis_tiporestricciones` (
  `codAnalisisTipoRestricciones` bigint(20) NOT NULL,
  `codAnaRes` bigint(20) NOT NULL,
  `desTipoRestricciones` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `anares_fase`
--

CREATE TABLE `anares_fase` (
  `codAnaResFase` bigint(20) NOT NULL,
  `desAnaResFase` varchar(255) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `codAnaResFrente` bigint(20) DEFAULT NULL,
  `codProyecto` bigint(20) DEFAULT NULL,
  `codAnaRes` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `anares_fase`
--

INSERT INTO `anares_fase` (`codAnaResFase`, `desAnaResFase`, `dayFechaCreacion`, `desUsuarioCreacion`, `codAnaResFrente`, `codProyecto`, `codAnaRes`) VALUES
(1, 'PINTURA', NULL, NULL, 1, 1, 129),
(2, 'OBRAS PROVISIONALES', '2023-03-23 11:38:03', '', 2, 4, 132),
(4, 'MURO ANCLADO', '2023-03-24 10:45:55', '', 5, 5, 133),
(7, 'CERCO PERIMETRICO', '2023-03-28 14:09:18', '', 6, 5, 133),
(8, 'MUROS ANCLADOS', '2023-04-02 14:04:14', '', 3, 4, 132),
(9, 'SÓTANOS', '2023-04-03 08:22:46', '', 3, 4, 132),
(10, 'SECTION 1', '2023-05-24 03:33:57', '', 7, 1, 129),
(11, 'FASE OO91', '2023-05-24 03:34:28', '', 8, 1, 129),
(13, 'FASE-BT001', '2023-06-25 02:07:45', '', 9, 6, 134),
(14, 'FARID', '2023-07-01 16:06:18', '', 10, 7, 135),
(15, 'CIMENTACION', '2023-07-02 08:15:41', '', 11, 7, 135),
(16, 'CISTERNA', '2023-08-04 10:42:24', '', 3, 4, 132),
(17, 'TORRE GRÚA', NULL, NULL, 3, 4, 132),
(18, 'Cisterna', '2023-08-31 14:40:47', '', 13, 14, 140),
(19, 'Provisionales', NULL, NULL, 13, 14, 140),
(20, 'Cimentaciones', NULL, NULL, 13, 14, 140),
(21, 'Cimentaciones', NULL, NULL, 14, 14, 140),
(22, 'Cisterna', NULL, NULL, 14, 14, 140),
(23, 'F002', '2023-09-20 10:03:30', '', 15, 15, 141),
(24, 'FASE002', '2023-09-22 09:43:39', '', 16, 15, 141),
(28, 'Movimiento de tierras', '2023-10-05 15:03:59', '', 18, 22, 142),
(36, 'ESTRUCTURAS', '2023-10-08 18:12:18', '', 21, 4, 132),
(37, 'CISTERNA Y CB', '2023-10-08 18:13:20', '', 21, 4, 132),
(38, 'LOSA SOBRE TERRENO', '2023-10-08 18:13:30', '', 21, 4, 132),
(39, 'ACABADOS HÚMEDOS', '2023-10-08 18:13:48', '', 21, 4, 132),
(40, 'ACABADOS SECOS', '2023-10-08 18:14:01', '', 21, 4, 132),
(41, 'ESTRUCTURAS', '2023-10-08 18:14:28', '', 22, 4, 132),
(42, 'ACABADOS HÚMEDOS', '2023-10-08 18:15:14', '', 22, 4, 132),
(43, 'ACABADOS SECOS', '2023-10-08 18:15:27', '', 22, 4, 132),
(44, 'FACHADA', '2023-10-08 18:15:37', '', 22, 4, 132),
(45, 'Cimentaciones', '2023-10-11 11:38:45', '', 23, 14, 140),
(46, 'Sotano 2', '2023-10-11 11:38:57', '', 23, 14, 140),
(47, 'Sotano 2', NULL, NULL, 13, 14, 140),
(48, 'Cisterna', NULL, NULL, 23, 14, 140),
(49, 'Estructuras', '2023-10-26 15:26:35', '', 24, 4, 132),
(50, 'Casco', '2023-11-24 13:36:52', '', 23, 14, 140),
(51, 'Casco - Sótano', '2023-11-24 13:37:18', '', 23, 14, 140),
(52, 'Acabados - Sótanos', '2023-12-05 06:59:54', '', 23, 14, 140),
(53, 'Acabados - Sótano', NULL, NULL, 23, 14, 140),
(54, 'Movimiento de Tierra', '2023-12-06 11:13:14', '', 25, 22, 142),
(55, 'Abañilería', '2023-12-06 11:26:24', '', 25, 22, 142),
(56, 'Obra Civil', '2023-12-07 09:45:00', '', 25, 22, 142),
(57, 'Estructura Metálica', '2023-12-07 09:45:15', '', 25, 22, 142),
(58, 'EEMM', '2023-12-10 21:42:09', '', 18, 22, 142),
(59, 'Movimiento de Tierras', '2024-01-02 15:53:53', '', 26, 22, 142),
(60, 'Estructura', '2024-01-02 15:54:39', '', 26, 22, 142),
(61, 'EEMM', '2024-01-02 15:55:16', '', 26, 22, 142),
(62, 'MOV. TIERRAS', '2024-01-03 16:02:49', '', 27, 22, 142),
(63, 'Estructura', '2024-01-07 10:17:52', '', 18, 22, 142),
(64, 'Albañilería', '2024-01-07 10:34:49', '', 18, 22, 142),
(65, 'Acabados', NULL, NULL, 23, 14, 140),
(66, 'Acabados', NULL, NULL, 13, 14, 140),
(67, 'Torre', NULL, NULL, 23, 14, 140),
(69, 'Encofrado', '2024-01-09 10:46:35', '', 27, 22, 142),
(70, 'EEMM', '2024-01-09 11:01:11', '', 27, 22, 142),
(73, 'Obras Provisionales / Preliminares', '2024-01-12 16:24:35', '', 30, 28, 148),
(74, 'Muros Anclados', '2024-01-12 16:24:48', '', 30, 28, 148),
(75, 'Cimentación / Cisterna', '2024-01-12 16:25:01', '', 30, 28, 148),
(76, 'Casco - Subestructura', '2024-01-12 16:25:16', '', 30, 28, 148),
(77, 'Casco - Superestructura', '2024-01-12 16:25:31', '', 30, 28, 148),
(79, 'Torre', '2024-01-16 14:50:05', '', 23, 14, 140),
(80, 'Acabados', '2024-01-16 14:50:14', '', 23, 14, 140),
(81, 'TABIQUERIA', '2024-01-18 15:33:39', '', 27, 22, 142),
(82, 'Torre', NULL, NULL, 13, 14, 140),
(84, 'Demolicion y desmontajes', '2024-02-09 14:02:14', '', 31, 31, 151),
(85, 'Movimiento de Tierras', '2024-02-09 14:02:28', '', 31, 31, 151),
(86, 'Cimentaciones', '2024-02-09 14:02:47', '', 31, 31, 151),
(87, 'Estructuras', '2024-02-09 14:03:06', '', 31, 31, 151),
(89, 'Demolición y Desmontaje', '2024-02-09 14:06:56', '', 33, 31, 151),
(90, 'Movimiento de Tierras', '2024-02-09 14:07:19', '', 33, 31, 151),
(91, 'Cimentaciones', '2024-02-09 14:07:32', '', 33, 31, 151),
(92, 'Demolición y Desmonte', '2024-02-09 14:08:19', '', 34, 31, 151),
(93, 'Demolición y Desmontaje', '2024-02-09 14:15:19', '', 35, 31, 151),
(94, 'Movimientos de Tierras', '2024-02-09 14:16:41', '', 35, 31, 151),
(95, 'Cimentaciones', '2024-02-09 14:16:57', '', 35, 31, 151),
(96, 'Movimientos de Tierra', '2024-02-09 14:20:19', '', 32, 31, 151),
(101, 'Movimiento de Tierras', '2024-02-10 12:03:24', '', 32, 31, 151),
(102, 'Movimiento de Tierras', '2024-02-10 12:09:18', '', 36, 31, 151),
(103, 'Cimentación', '2024-02-10 12:12:28', '', 32, 31, 151),
(104, 'Superestructura', '2024-02-10 12:40:54', '', 32, 31, 151),
(105, 'Superestructura2', '2024-02-10 12:43:34', '', 36, 31, 151),
(109, 'Movimientos de Tierra', '2024-02-16 11:05:28', '', 42, 32, 152),
(113, 'Cimentaciones', '2024-02-17 11:23:17', '', 36, 31, 151),
(114, 'OFICINAS', '2024-02-23 09:47:51', '', 46, 31, 151),
(117, 'Movimiento de Tierras', '2024-03-04 10:18:56', '', 47, 32, 152),
(118, 'Muro Anclado', '2024-03-04 10:20:02', '', 47, 32, 152),
(119, 'Movimiento de Tierras', '2024-03-04 10:22:20', '', 48, 32, 152),
(120, 'Muro Anclado', '2024-03-04 10:22:40', '', 48, 32, 152),
(121, 'Cimentación perimetral', NULL, NULL, 30, 28, 148),
(122, 'Acabados', NULL, NULL, 49, 14, 140),
(123, 'Acabados', NULL, NULL, 50, 14, 140),
(126, 'Cisterna', '2024-04-13 11:24:36', '', 30, 28, 148),
(127, 'Cisterna y cimentación', '2024-04-13 11:28:54', '', 30, 28, 148),
(128, 'Mov. Tierra', '2024-04-18 15:51:04', '', 53, 36, 156),
(129, 'Movimiento de Tierras', '2024-04-19 11:51:07', '', 54, 37, 157),
(130, 'Movimiento de Tierras', '2024-04-19 11:56:59', '', 55, 37, 157),
(131, 'Demolición', NULL, NULL, 54, 37, 157),
(132, 'Muro Anclado', NULL, NULL, 54, 37, 157),
(133, 'Estructuras Metálicas', NULL, NULL, 54, 37, 157),
(134, 'Obras Provisionales', NULL, NULL, 54, 37, 157),
(135, 'cimentación', '2024-04-20 19:52:39', '', 32, 31, 151),
(136, 'FASE 90', '2024-04-24 11:00:09', '', 56, 15, 141),
(137, 'FASE 002', '2024-04-24 12:26:34', '', 57, 9, 136),
(138, 'Cimentaciones', NULL, NULL, 49, 14, 140),
(139, 'Casco', NULL, NULL, 54, 37, 157),
(140, 'Cercos', '2024-05-03 21:46:06', '', 25, 22, 142),
(141, 'Acabados Húmedos', '2024-05-07 15:49:12', '', 32, 31, 151),
(142, 'Acabados Húmedos', '2024-05-07 15:55:08', '', 32, 31, 151),
(143, 'Acabados Húmedos', '2024-05-07 15:55:44', '', 32, 31, 151),
(144, 'Acabados Húmedos', '2024-05-07 16:23:31', '', 32, 31, 151),
(145, 'Acabados Húmedos', '2024-05-07 16:36:24', '', 36, 31, 151),
(146, 'Losa Contra Terreno', '2024-05-07 16:44:49', '', 32, 31, 151),
(147, 'Losa Contra Terreno', '2024-05-07 17:15:29', '', 36, 31, 151),
(148, 'Acabados Secos', '2024-05-07 17:19:34', '', 32, 31, 151),
(149, 'Acabados Secos', '2024-05-07 17:22:48', '', 36, 31, 151),
(150, 'EXTERIORES', '2024-05-09 10:02:49', '', 22, 4, 132),
(151, 'Sub estructra ', NULL, NULL, 30, 28, 148),
(152, 'Acabados', NULL, NULL, 54, 37, 157),
(153, 'Cisterna', '2024-05-11 12:59:58', '', 36, 31, 151);

-- --------------------------------------------------------

--
-- Table structure for table `anares_frente`
--

CREATE TABLE `anares_frente` (
  `codAnaResFrente` bigint(20) NOT NULL,
  `desAnaResFrente` varchar(255) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `codProyecto` bigint(20) DEFAULT NULL,
  `codAnaRes` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `anares_frente`
--

INSERT INTO `anares_frente` (`codAnaResFrente`, `desAnaResFrente`, `dayFechaCreacion`, `desUsuarioCreacion`, `codProyecto`, `codAnaRes`) VALUES
(1, 'CONSTRUCCION', NULL, NULL, 1, 129),
(2, 'OBRAS PROVISIONALES', '2023-03-23 11:37:29', '', 4, 132),
(3, 'TORRE', '2023-03-23 11:37:48', '', 4, 132),
(5, 'MURO ANCLADO', '2023-03-24 10:45:33', '', 5, 133),
(6, 'OBRAS PROVISIONALES', '2023-03-28 13:55:42', '', 5, 133),
(7, 'PLATING', '2023-05-24 03:33:45', '', 1, 129),
(8, 'FINISHES', '2023-05-24 03:34:16', '', 1, 129),
(9, 'FRENTE-BT001', '2023-06-25 01:59:43', '', 6, 134),
(10, 'AVICOLA', '2023-07-01 16:06:03', '', 7, 135),
(11, 'CONSTRUCCION', '2023-07-02 08:08:53', '', 7, 135),
(13, 'Frente 01', '2023-08-31 14:40:18', '', 14, 140),
(14, NULL, NULL, NULL, 14, 140),
(15, 'F001', '2023-09-20 10:03:14', '', 15, 141),
(16, 'F002', '2023-09-22 09:43:21', '', 15, 141),
(18, 'Frente 1', '2023-10-05 15:03:47', '', 22, 142),
(21, 'SÓTANOS', '2023-10-08 18:11:04', '', 4, 132),
(22, 'TORRE A', '2023-10-08 18:11:14', '', 4, 132),
(23, 'Frente 02', '2023-10-11 11:38:29', '', 14, 140),
(24, 'TORRE B', '2023-10-26 15:26:19', '', 4, 132),
(25, 'Frente 3', '2023-12-06 11:12:22', '', 22, 142),
(26, 'Exteriores', '2024-01-02 15:53:18', '', 22, 142),
(27, 'FRENTE 2', '2024-01-03 13:25:08', '', 22, 142),
(30, 'Frente 1 - Casco', '2024-01-12 16:24:20', '', 28, 148),
(31, 'SECTOR 1', '2024-02-09 14:00:34', '', 31, 151),
(32, 'SECTOR 01', '2024-02-09 14:05:10', '', 31, 151),
(33, 'Sector 01', '2024-02-09 14:06:41', '', 31, 151),
(34, 'Sector 01', '2024-02-09 14:07:56', '', 31, 151),
(35, 'Sector 01', '2024-02-09 14:14:47', '', 31, 151),
(36, 'SECTOR 2', NULL, NULL, 31, 151),
(37, 'Frente 01', '2024-02-13 10:36:19', '', 32, 152),
(38, 'Frente 02', NULL, NULL, 32, 152),
(40, 'Movimiento de tierras', '2024-02-15 17:24:08', '', 32, 152),
(41, 'Movimiento de tierras', '2024-02-15 17:25:11', '', 32, 152),
(42, 'Frente 01', '2024-02-16 11:05:16', '', 32, 152),
(45, 'Frente 02', '2024-02-16 11:55:53', '', 32, 152),
(46, 'PROVISIONALES', '2024-02-23 09:47:30', '', 31, 151),
(47, 'Frente N°01', '2024-03-04 10:16:56', '', 32, 152),
(48, 'Frente N°01', '2024-03-04 10:22:01', '', 32, 152),
(49, 'Frente 2', NULL, NULL, 14, 140),
(50, 'Frente 1', NULL, NULL, 14, 140),
(53, 'FRente 01', '2024-04-18 15:50:55', '', 36, 156),
(54, 'Frente 1', '2024-04-19 11:47:26', '', 37, 157),
(55, 'Frente 1', '2024-04-19 11:56:49', '', 37, 157),
(56, 'frent 55', '2024-04-24 10:59:47', '', 15, 141),
(57, 'FRENTE 001', '2024-04-24 12:26:18', '', 9, 136),
(59, 'sub estructura', '2024-05-11 11:20:43', '', 28, 148);

-- --------------------------------------------------------

--
-- Table structure for table `anares_tiporestricciones`
--

CREATE TABLE `anares_tiporestricciones` (
  `codTipoRestricciones` bigint(20) NOT NULL,
  `desTipoRestricciones` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `anares_tiporestricciones`
--

INSERT INTO `anares_tiporestricciones` (`codTipoRestricciones`, `desTipoRestricciones`) VALUES
(1, 'Proceso Constructivo'),
(2, 'Entorno'),
(3, 'Información'),
(4, 'Mano de Obra'),
(5, 'Materiales'),
(6, 'Equipos y Herramientas'),
(7, 'SubContratos'),
(8, 'Seguridad'),
(9, 'Calidad'),
(10, 'Administración'),
(11, 'Cliente y Supervisión'),
(12, 'Logistica');

-- --------------------------------------------------------

--
-- Table structure for table `ana_integrantes`
--

CREATE TABLE `ana_integrantes` (
  `codProyecto` bigint(20) NOT NULL,
  `codAnaRes` bigint(20) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `codProyIntegrante` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `ana_integrantes`
--

INSERT INTO `ana_integrantes` (`codProyecto`, `codAnaRes`, `codEstado`, `dayFechaCreacion`, `desUsuarioCreacion`, `codProyIntegrante`) VALUES
(5, 133, 1, '2023-03-24 16:02:40', '', 13),
(5, 133, 1, '2023-03-24 16:02:40', '', 14),
(5, 133, 1, '2023-03-24 16:02:40', '', 15),
(5, 133, 1, '2023-03-24 16:02:40', '', 16),
(5, 133, 1, '2023-03-24 16:02:40', '', 17),
(5, 133, 1, '2023-03-24 16:02:40', '', 18),
(5, 133, 1, '2023-03-24 16:02:40', '', 19),
(5, 133, 1, '2023-03-24 16:02:40', '', 20),
(5, 133, 1, '2023-03-24 16:02:40', '', 22),
(1, 129, 1, '2023-06-25 00:48:42', '', 1),
(1, 129, 1, '2023-06-25 00:48:42', '', 2),
(6, 134, 1, '2023-06-25 01:11:11', '', 25),
(7, 135, 1, '2023-07-01 23:31:46', '', 26),
(7, 135, 1, '2023-07-01 23:31:46', '', 28),
(7, 135, 1, '2023-07-01 23:31:46', '', 29),
(23, 143, 1, '2023-10-09 18:18:10', '', 78),
(23, 143, 1, '2023-10-09 18:18:10', '', 99),
(23, 143, 1, '2023-10-09 18:18:10', '', 100),
(23, 143, 1, '2023-10-09 18:18:10', '', 101),
(23, 143, 1, '2023-10-09 18:18:10', '', 102),
(29, 149, 1, '2023-12-13 17:13:04', '', NULL),
(30, 150, 1, '2023-12-14 00:35:36', '', NULL),
(15, 141, 1, '2024-01-25 07:13:11', '', 57),
(15, 141, 1, '2024-01-25 07:13:11', '', 160),
(32, 152, 1, '2024-02-12 09:51:35', '', 164),
(32, 152, 1, '2024-02-12 09:51:35', '', 165),
(32, 152, 1, '2024-02-12 09:51:35', '', 166),
(32, 152, 1, '2024-02-12 09:51:35', '', 167),
(32, 152, 1, '2024-02-12 09:51:35', '', 168),
(32, 152, 1, '2024-02-12 09:51:35', '', 169),
(32, 152, 1, '2024-02-12 09:51:35', '', 170),
(32, 152, 1, '2024-02-12 09:51:35', '', 171),
(32, 152, 1, '2024-02-12 09:51:35', '', 172),
(32, 152, 1, '2024-02-12 09:51:35', '', 173),
(32, 152, 1, '2024-02-12 09:51:35', '', 174),
(32, 152, 1, '2024-02-12 09:51:35', '', 175),
(32, 152, 1, '2024-02-12 09:51:35', '', 176),
(32, 152, 1, '2024-02-12 09:51:35', '', 177),
(32, 152, 1, '2024-02-12 09:51:35', '', 178),
(32, 152, 1, '2024-02-12 09:51:35', '', 179),
(4, 132, 1, '2024-04-04 14:38:59', '', 6),
(4, 132, 1, '2024-04-04 14:38:59', '', 7),
(4, 132, 1, '2024-04-04 14:38:59', '', 9),
(4, 132, 1, '2024-04-04 14:38:59', '', 11),
(4, 132, 1, '2024-04-04 14:38:59', '', 21),
(4, 132, 1, '2024-04-04 14:38:59', '', 59),
(4, 132, 1, '2024-04-04 14:38:59', '', 61),
(4, 132, 1, '2024-04-04 14:38:59', '', 62),
(4, 132, 1, '2024-04-04 14:38:59', '', 64),
(4, 132, 1, '2024-04-04 14:38:59', '', 65),
(4, 132, 1, '2024-04-04 14:38:59', '', 132),
(4, 132, 1, '2024-04-04 14:38:59', '', 135),
(4, 132, 1, '2024-04-04 14:38:59', '', 136),
(4, 132, 1, '2024-04-04 14:38:59', '', 162),
(4, 132, 1, '2024-04-04 14:38:59', '', 260),
(14, 140, 1, '2024-04-04 14:39:03', '', 46),
(14, 140, 1, '2024-04-04 14:39:03', '', 47),
(14, 140, 1, '2024-04-04 14:39:03', '', 48),
(14, 140, 1, '2024-04-04 14:39:03', '', 49),
(14, 140, 1, '2024-04-04 14:39:03', '', 50),
(14, 140, 1, '2024-04-04 14:39:03', '', 51),
(14, 140, 1, '2024-04-04 14:39:03', '', 53),
(14, 140, 1, '2024-04-04 14:39:03', '', 54),
(14, 140, 1, '2024-04-04 14:39:03', '', 55),
(14, 140, 1, '2024-04-04 14:39:03', '', 56),
(14, 140, 1, '2024-04-04 14:39:03', '', 58),
(14, 140, 1, '2024-04-04 14:39:03', '', 66),
(14, 140, 1, '2024-04-04 14:39:03', '', 98),
(14, 140, 1, '2024-04-04 14:39:03', '', 104),
(14, 140, 1, '2024-04-04 14:39:03', '', 105),
(14, 140, 1, '2024-04-04 14:39:03', '', 111),
(14, 140, 1, '2024-04-04 14:39:03', '', 134),
(22, 142, 1, '2024-04-04 14:39:06', '', 77),
(22, 142, 1, '2024-04-04 14:39:06', '', 80),
(22, 142, 1, '2024-04-04 14:39:06', '', 82),
(22, 142, 1, '2024-04-04 14:39:06', '', 83),
(22, 142, 1, '2024-04-04 14:39:06', '', 84),
(22, 142, 1, '2024-04-04 14:39:06', '', 86),
(22, 142, 1, '2024-04-04 14:39:06', '', 87),
(22, 142, 1, '2024-04-04 14:39:06', '', 88),
(22, 142, 1, '2024-04-04 14:39:06', '', 89),
(22, 142, 1, '2024-04-04 14:39:06', '', 90),
(22, 142, 1, '2024-04-04 14:39:06', '', 91),
(22, 142, 1, '2024-04-04 14:39:06', '', 92),
(22, 142, 1, '2024-04-04 14:39:06', '', 93),
(22, 142, 1, '2024-04-04 14:39:06', '', 106),
(22, 142, 1, '2024-04-04 14:39:06', '', 107),
(22, 142, 1, '2024-04-04 14:39:06', '', 112),
(22, 142, 1, '2024-04-04 14:39:06', '', 113),
(22, 142, 1, '2024-04-04 14:39:06', '', 114),
(22, 142, 1, '2024-04-04 14:39:06', '', 115),
(22, 142, 1, '2024-04-04 14:39:06', '', 116),
(22, 142, 1, '2024-04-04 14:39:06', '', 117),
(22, 142, 1, '2024-04-04 14:39:06', '', 118),
(22, 142, 1, '2024-04-04 14:39:06', '', 119),
(22, 142, 1, '2024-04-04 14:39:06', '', 120),
(22, 142, 1, '2024-04-04 14:39:06', '', 121),
(22, 142, 1, '2024-04-04 14:39:06', '', 122),
(22, 142, 1, '2024-04-04 14:39:06', '', 123),
(22, 142, 1, '2024-04-04 14:39:06', '', 124),
(22, 142, 1, '2024-04-04 14:39:06', '', 125),
(22, 142, 1, '2024-04-04 14:39:06', '', 126),
(22, 142, 1, '2024-04-04 14:39:06', '', 127),
(22, 142, 1, '2024-04-04 14:39:06', '', 128),
(22, 142, 1, '2024-04-04 14:39:06', '', 129),
(22, 142, 1, '2024-04-04 14:39:06', '', 133),
(22, 142, 1, '2024-04-04 14:39:06', '', 161),
(22, 142, 1, '2024-04-04 14:39:06', '', 261),
(33, 153, 1, '2024-04-04 14:39:18', '', 180),
(33, 153, 1, '2024-04-04 14:39:18', '', 181),
(33, 153, 1, '2024-04-04 14:39:18', '', 182),
(33, 153, 1, '2024-04-04 14:39:18', '', 183),
(33, 153, 1, '2024-04-04 14:39:18', '', 184),
(33, 153, 1, '2024-04-04 14:39:18', '', 185),
(33, 153, 1, '2024-04-04 14:39:18', '', 186),
(33, 153, 1, '2024-04-04 14:39:18', '', 187),
(33, 153, 1, '2024-04-04 14:39:18', '', 188),
(33, 153, 1, '2024-04-04 14:39:18', '', 189),
(33, 153, 1, '2024-04-04 14:39:18', '', 190),
(33, 153, 1, '2024-04-04 14:39:18', '', 191),
(33, 153, 1, '2024-04-04 14:39:18', '', 192),
(33, 153, 1, '2024-04-04 14:39:18', '', 193),
(33, 153, 1, '2024-04-04 14:39:18', '', 194),
(33, 153, 1, '2024-04-04 14:39:18', '', 195),
(33, 153, 1, '2024-04-04 14:39:18', '', 196),
(33, 153, 1, '2024-04-04 14:39:18', '', 197),
(33, 153, 1, '2024-04-04 14:39:18', '', 198),
(33, 153, 1, '2024-04-04 14:39:18', '', 199),
(33, 153, 1, '2024-04-04 14:39:18', '', 200),
(33, 153, 1, '2024-04-04 14:39:18', '', 201),
(33, 153, 1, '2024-04-04 14:39:18', '', 202),
(33, 153, 1, '2024-04-04 14:39:18', '', 203),
(33, 153, 1, '2024-04-04 14:39:18', '', 204),
(33, 153, 1, '2024-04-04 14:39:18', '', 205),
(33, 153, 1, '2024-04-04 14:39:18', '', 206),
(33, 153, 1, '2024-04-04 14:39:18', '', 207),
(33, 153, 1, '2024-04-04 14:39:18', '', 208),
(33, 153, 1, '2024-04-04 14:39:18', '', 209),
(34, 154, 1, '2024-04-04 14:39:22', '', 210),
(34, 154, 1, '2024-04-04 14:39:22', '', 211),
(34, 154, 1, '2024-04-04 14:39:22', '', 212),
(34, 154, 1, '2024-04-04 14:39:22', '', 213),
(34, 154, 1, '2024-04-04 14:39:22', '', 214),
(34, 154, 1, '2024-04-04 14:39:22', '', 215),
(34, 154, 1, '2024-04-04 14:39:22', '', 216),
(34, 154, 1, '2024-04-04 14:39:22', '', 217),
(34, 154, 1, '2024-04-04 14:39:22', '', 218),
(34, 154, 1, '2024-04-04 14:39:22', '', 219),
(34, 154, 1, '2024-04-04 14:39:22', '', 220),
(34, 154, 1, '2024-04-04 14:39:22', '', 221),
(34, 154, 1, '2024-04-04 14:39:22', '', 222),
(34, 154, 1, '2024-04-04 14:39:22', '', 223),
(34, 154, 1, '2024-04-04 14:39:22', '', 224),
(34, 154, 1, '2024-04-04 14:39:22', '', 225),
(34, 154, 1, '2024-04-04 14:39:22', '', 226),
(34, 154, 1, '2024-04-04 14:39:22', '', 227),
(34, 154, 1, '2024-04-04 14:39:22', '', 228),
(34, 154, 1, '2024-04-04 14:39:22', '', 229),
(34, 154, 1, '2024-04-04 14:39:22', '', 230),
(34, 154, 1, '2024-04-04 14:39:22', '', 231),
(34, 154, 1, '2024-04-04 14:39:22', '', 232),
(34, 154, 1, '2024-04-04 14:39:22', '', 233),
(34, 154, 1, '2024-04-04 14:39:22', '', 234),
(35, 155, 1, '2024-04-04 14:39:33', '', 235),
(35, 155, 1, '2024-04-04 14:39:33', '', 236),
(35, 155, 1, '2024-04-04 14:39:33', '', 237),
(35, 155, 1, '2024-04-04 14:39:33', '', 238),
(35, 155, 1, '2024-04-04 14:39:33', '', 239),
(35, 155, 1, '2024-04-04 14:39:33', '', 240),
(35, 155, 1, '2024-04-04 14:39:33', '', 241),
(35, 155, 1, '2024-04-04 14:39:33', '', 242),
(35, 155, 1, '2024-04-04 14:39:33', '', 243),
(35, 155, 1, '2024-04-04 14:39:33', '', 244),
(35, 155, 1, '2024-04-04 14:39:33', '', 245),
(35, 155, 1, '2024-04-04 14:39:33', '', 246),
(35, 155, 1, '2024-04-04 14:39:33', '', 247),
(35, 155, 1, '2024-04-04 14:39:33', '', 248),
(35, 155, 1, '2024-04-04 14:39:33', '', 249),
(35, 155, 1, '2024-04-04 14:39:33', '', 250),
(35, 155, 1, '2024-04-04 14:39:33', '', 251),
(35, 155, 1, '2024-04-04 14:39:33', '', 252),
(35, 155, 1, '2024-04-04 14:39:33', '', 253),
(35, 155, 1, '2024-04-04 14:39:33', '', 254),
(35, 155, 1, '2024-04-04 14:39:33', '', 255),
(35, 155, 1, '2024-04-04 14:39:33', '', 256),
(35, 155, 1, '2024-04-04 14:39:33', '', 257),
(28, 148, 1, '2024-04-09 11:21:36', '', 108),
(28, 148, 1, '2024-04-09 11:21:36', '', 109),
(28, 148, 1, '2024-04-09 11:21:36', '', 110),
(28, 148, 1, '2024-04-09 11:21:36', '', 137),
(28, 148, 1, '2024-04-09 11:21:36', '', 138),
(28, 148, 1, '2024-04-09 11:21:36', '', 139),
(28, 148, 1, '2024-04-09 11:21:36', '', 140),
(28, 148, 1, '2024-04-09 11:21:36', '', 141),
(28, 148, 1, '2024-04-09 11:21:36', '', 142),
(28, 148, 1, '2024-04-09 11:21:36', '', 143),
(28, 148, 1, '2024-04-09 11:21:36', '', 144),
(28, 148, 1, '2024-04-09 11:21:36', '', 145),
(28, 148, 1, '2024-04-09 11:21:36', '', 146),
(28, 148, 1, '2024-04-09 11:21:36', '', 147),
(28, 148, 1, '2024-04-09 11:21:36', '', 263),
(28, 148, 1, '2024-04-09 11:21:36', '', 267),
(37, 157, 1, '2024-05-03 15:53:52', '', 270),
(37, 157, 1, '2024-05-03 15:53:52', '', 271),
(37, 157, 1, '2024-05-03 15:53:52', '', 272),
(37, 157, 1, '2024-05-03 15:53:52', '', 273),
(37, 157, 1, '2024-05-03 15:53:52', '', 274),
(37, 157, 1, '2024-05-03 15:53:52', '', 275),
(37, 157, 1, '2024-05-03 15:53:52', '', 276),
(37, 157, 1, '2024-05-03 15:53:52', '', 277),
(37, 157, 1, '2024-05-03 15:53:52', '', 278),
(37, 157, 1, '2024-05-03 15:53:52', '', 279),
(37, 157, 1, '2024-05-03 15:53:52', '', 280),
(37, 157, 1, '2024-05-03 15:53:52', '', 281),
(37, 157, 1, '2024-05-03 15:53:52', '', 282),
(37, 157, 1, '2024-05-03 15:53:52', '', 283),
(31, 151, 1, '2024-05-07 16:29:39', '', 148),
(31, 151, 1, '2024-05-07 16:29:39', '', 149),
(31, 151, 1, '2024-05-07 16:29:39', '', 150),
(31, 151, 1, '2024-05-07 16:29:39', '', 151),
(31, 151, 1, '2024-05-07 16:29:39', '', 152),
(31, 151, 1, '2024-05-07 16:29:39', '', 153),
(31, 151, 1, '2024-05-07 16:29:39', '', 154),
(31, 151, 1, '2024-05-07 16:29:39', '', 156),
(31, 151, 1, '2024-05-07 16:29:39', '', 157),
(31, 151, 1, '2024-05-07 16:29:39', '', 158),
(31, 151, 1, '2024-05-07 16:29:39', '', 163),
(31, 151, 1, '2024-05-07 16:29:39', '', 258),
(31, 151, 1, '2024-05-07 16:29:39', '', 259),
(31, 151, 1, '2024-05-07 16:29:39', '', 262),
(31, 151, 1, '2024-05-07 16:29:39', '', 264),
(31, 151, 1, '2024-05-07 16:29:39', '', 265),
(31, 151, 1, '2024-05-07 16:29:39', '', 284),
(31, 151, 1, '2024-05-07 16:29:39', '', 285),
(38, 158, 1, '2024-05-17 13:38:47', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `conf_colacorreos`
--

CREATE TABLE `conf_colacorreos` (
  `codColaCorreo` int(10) UNSIGNED NOT NULL,
  `desMensaje` longtext DEFAULT NULL,
  `dayFechaRegistro` datetime DEFAULT NULL,
  `dayFechaEnvio` datetime DEFAULT NULL,
  `numEstado` int(11) NOT NULL DEFAULT 0,
  `codUsuarioRegistro` int(11) DEFAULT NULL,
  `desCorreoEnvio` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `desMotivo` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `conf_estado`
--

CREATE TABLE `conf_estado` (
  `codEstado` int(11) NOT NULL,
  `desEstado` varchar(100) NOT NULL,
  `desModulo` varchar(100) NOT NULL,
  `desDescripcion` varchar(250) DEFAULT NULL,
  `iconColor` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conf_estado`
--

INSERT INTO `conf_estado` (`codEstado`, `desEstado`, `desModulo`, `desDescripcion`, `iconColor`) VALUES
(1, 'Pendiente', 'ANARES', 'Estado de las actividad es o restricciones, este estado es el estao inicial con el cual se crea.', 'red'),
(2, 'Proceso', 'ANARES', 'Estado de las actividad es o restricciones, este estado  indica que se esta completando la actividad', 'yellow'),
(3, 'Completado', 'ANARES', 'Estado de las actividad es o restricciones, este estado indica que fue cerrado la actividad', 'green'),
(0, 'Abierto', 'ANAPROY', 'Estado perteneciente al proyecto de analisis de restricciones , indica que es un proyecto trabajandose.', NULL),
(1, 'Cerrado', 'ANAPROY', 'Estado perteneciente al proyecto de analisis de restricciones , indica que es un proyecto finalizado', NULL),
(4, 'Por Aprobar', 'ANARES', 'Estado de pendiente  de aprobacion', 'blue');

-- --------------------------------------------------------

--
-- Table structure for table `conf_maestro_empresas`
--

CREATE TABLE `conf_maestro_empresas` (
  `cod_Empresa` bigint(20) NOT NULL,
  `des_Empresa` varchar(250) DEFAULT NULL,
  `num_Ruc` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conf_maestro_empresas`
--

INSERT INTO `conf_maestro_empresas` (`cod_Empresa`, `des_Empresa`, `num_Ruc`) VALUES
(1, 'SODIMAC', 7845451121),
(2, 'CANTABRIA', 788415151),
(3, 'NUEVAEMPRESA', 787984141),
(4, 'CORNELIA', 8494151),
(5, 'SOLGAS', 984545451),
(6, 'GLORIA', 978545),
(7, 'SAMAS', 98471545),
(8, 'CONSTRUCTORAX', 9784515),
(9, 'ENTEL', 5545454),
(10, 'AVIANCA', 2121545),
(11, 'NADAAAAAA', 1545454),
(12, 'PRUEBA001', 45454),
(13, 'CORTINA', 45454),
(14, 'COSMICOS', 87845),
(15, 'EMPRESA JULIAN', 20212100),
(16, 'PROMART', 82202121),
(17, 'CRISTINASTORE', 5454121),
(18, 'EMPRESA UNO', 200515154445),
(19, 'KAYSER', 21415454),
(20, 'JARAMILLOS SAC', 8454545),
(21, 'MOLITALIA', 54812122),
(22, 'CONSTRUCTORA INARCO PERÚ', 20519219922),
(23, 'REMASA', 22041545),
(24, 'Test01', 123456);

-- --------------------------------------------------------

--
-- Table structure for table `conf_moneda`
--

CREATE TABLE `conf_moneda` (
  `codMoneda` bigint(20) NOT NULL,
  `desMoneda` varchar(100) DEFAULT NULL,
  `desSimbolo` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conf_moneda`
--

INSERT INTO `conf_moneda` (`codMoneda`, `desMoneda`, `desSimbolo`) VALUES
(1, 'Soles', 'S/'),
(2, 'Dolares', '$'),
(3, 'Euros', '€');

-- --------------------------------------------------------

--
-- Table structure for table `conf_motivosretraso`
--

CREATE TABLE `conf_motivosretraso` (
  `codRetrasoMotivo` bigint(20) NOT NULL,
  `desRetrasoMotivo` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conf_motivosretraso`
--

INSERT INTO `conf_motivosretraso` (`codRetrasoMotivo`, `desRetrasoMotivo`) VALUES
(1, 'Llegada a obra'),
(2, 'Hora Fuera de Motivo'),
(3, 'No tenemos nada');

-- --------------------------------------------------------

--
-- Table structure for table `conf_tipodiaprogramacion`
--

CREATE TABLE `conf_tipodiaprogramacion` (
  `codTipoDiaProgramacion` bigint(20) NOT NULL,
  `desTipoDiaProgramacion` varchar(250) DEFAULT NULL,
  `desNombreCorto` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conf_tipodiaprogramacion`
--

INSERT INTO `conf_tipodiaprogramacion` (`codTipoDiaProgramacion`, `desTipoDiaProgramacion`, `desNombreCorto`) VALUES
(1, 'Lunea a Viernes', 'LV'),
(2, 'Lunes a Sabado', 'LS'),
(3, 'Lunes a Domingo', 'D');

-- --------------------------------------------------------

--
-- Table structure for table `conf_ubigeo`
--

CREATE TABLE `conf_ubigeo` (
  `codUbigeo` int(11) UNSIGNED NOT NULL,
  `desUbigeo` varchar(255) DEFAULT NULL,
  `Departamento` varchar(255) DEFAULT NULL,
  `Provincia` varchar(255) DEFAULT NULL,
  `Distrito` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `conf_ubigeo`
--

INSERT INTO `conf_ubigeo` (`codUbigeo`, `desUbigeo`, `Departamento`, `Provincia`, `Distrito`) VALUES
(1, 'Chachapoyas , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Chachapoyas'),
(2, 'Asuncion , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Asuncion'),
(3, 'Balsas , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Balsas'),
(4, 'Cheto , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Cheto'),
(5, 'Chiliquin , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Chiliquin'),
(6, 'Chuquibamba , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Chuquibamba'),
(7, 'Granada , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Granada'),
(8, 'Huancas , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Huancas'),
(9, 'La Jalca , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'La Jalca'),
(10, 'Leimebamba , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Leimebamba'),
(11, 'Levanto , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Levanto'),
(12, 'Magdalena , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Magdalena'),
(13, 'Mariscal Castilla , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Mariscal Castilla'),
(14, 'Molinopampa , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Molinopampa'),
(15, 'Montevideo , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Montevideo'),
(16, 'Olleros , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Olleros'),
(17, 'Quinjalca , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Quinjalca'),
(18, 'San Francisco de Daguas , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'San Francisco de Daguas'),
(19, 'San Isidro de Maino , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'San Isidro de Maino'),
(20, 'Soloco , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Soloco'),
(21, 'Sonche , Chachapoyas , Amazonas', 'Amazonas', 'Chachapoyas', 'Sonche'),
(22, 'Bagua , Bagua , Amazonas', 'Amazonas', 'Bagua', 'Bagua'),
(23, 'Aramango , Bagua , Amazonas', 'Amazonas', 'Bagua', 'Aramango'),
(24, 'Copallin , Bagua , Amazonas', 'Amazonas', 'Bagua', 'Copallin'),
(25, 'El Parco , Bagua , Amazonas', 'Amazonas', 'Bagua', 'El Parco'),
(26, 'Imaza , Bagua , Amazonas', 'Amazonas', 'Bagua', 'Imaza'),
(27, 'La Peca , Bagua , Amazonas', 'Amazonas', 'Bagua', 'La Peca'),
(28, 'Jumbilla , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Jumbilla'),
(29, 'Chisquilla , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Chisquilla'),
(30, 'Churuja , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Churuja'),
(31, 'Corosha , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Corosha'),
(32, 'Cuispes , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Cuispes'),
(33, 'Florida , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Florida'),
(34, 'Jazan , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Jazan'),
(35, 'Recta , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Recta'),
(36, 'San Carlos , Bongara , Amazonas', 'Amazonas', 'Bongara', 'San Carlos'),
(37, 'Shipasbamba , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Shipasbamba'),
(38, 'Valera , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Valera'),
(39, 'Yambrasbamba , Bongara , Amazonas', 'Amazonas', 'Bongara', 'Yambrasbamba'),
(40, 'Nieva , Condorcanqui , Amazonas', 'Amazonas', 'Condorcanqui', 'Nieva'),
(41, 'El Cenepa , Condorcanqui , Amazonas', 'Amazonas', 'Condorcanqui', 'El Cenepa'),
(42, 'Rio Santiago , Condorcanqui , Amazonas', 'Amazonas', 'Condorcanqui', 'Rio Santiago'),
(43, 'Lamud , Luya , Amazonas', 'Amazonas', 'Luya', 'Lamud'),
(44, 'Camporredondo , Luya , Amazonas', 'Amazonas', 'Luya', 'Camporredondo'),
(45, 'Cocabamba , Luya , Amazonas', 'Amazonas', 'Luya', 'Cocabamba'),
(46, 'Colcamar , Luya , Amazonas', 'Amazonas', 'Luya', 'Colcamar'),
(47, 'Conila , Luya , Amazonas', 'Amazonas', 'Luya', 'Conila'),
(48, 'Inguilpata , Luya , Amazonas', 'Amazonas', 'Luya', 'Inguilpata'),
(49, 'Longuita , Luya , Amazonas', 'Amazonas', 'Luya', 'Longuita'),
(50, 'Lonya Chico , Luya , Amazonas', 'Amazonas', 'Luya', 'Lonya Chico'),
(51, 'Luya , Luya , Amazonas', 'Amazonas', 'Luya', 'Luya'),
(52, 'Luya Viejo , Luya , Amazonas', 'Amazonas', 'Luya', 'Luya Viejo'),
(53, 'Maria , Luya , Amazonas', 'Amazonas', 'Luya', 'Maria'),
(54, 'Ocalli , Luya , Amazonas', 'Amazonas', 'Luya', 'Ocalli'),
(55, 'Ocumal , Luya , Amazonas', 'Amazonas', 'Luya', 'Ocumal'),
(56, 'Pisuquia , Luya , Amazonas', 'Amazonas', 'Luya', 'Pisuquia'),
(57, 'Providencia , Luya , Amazonas', 'Amazonas', 'Luya', 'Providencia'),
(58, 'San Cristobal , Luya , Amazonas', 'Amazonas', 'Luya', 'San Cristobal'),
(59, 'San Francisco del Yeso , Luya , Amazonas', 'Amazonas', 'Luya', 'San Francisco del Yeso'),
(60, 'San Jeronimo , Luya , Amazonas', 'Amazonas', 'Luya', 'San Jeronimo'),
(61, 'San Juan de Lopecancha , Luya , Amazonas', 'Amazonas', 'Luya', 'San Juan de Lopecancha'),
(62, 'Santa Catalina , Luya , Amazonas', 'Amazonas', 'Luya', 'Santa Catalina'),
(63, 'Santo Tomas , Luya , Amazonas', 'Amazonas', 'Luya', 'Santo Tomas'),
(64, 'Tingo , Luya , Amazonas', 'Amazonas', 'Luya', 'Tingo'),
(65, 'Trita , Luya , Amazonas', 'Amazonas', 'Luya', 'Trita'),
(66, 'San Nicolas , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'San Nicolas'),
(67, 'Chirimoto , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Chirimoto'),
(68, 'Cochamal , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Cochamal'),
(69, 'Huambo , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Huambo'),
(70, 'Limabamba , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Limabamba'),
(71, 'Longar , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Longar'),
(72, 'Mariscal Benavides , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Mariscal Benavides'),
(73, 'Milpuc , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Milpuc'),
(74, 'Omia , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Omia'),
(75, 'Santa Rosa , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Santa Rosa'),
(76, 'Totora , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Totora'),
(77, 'Vista Alegre , Rodriguez de Mendoza , Amazonas', 'Amazonas', 'Rodriguez de Mendoza', 'Vista Alegre'),
(78, 'Bagua Grande , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Bagua Grande'),
(79, 'Cajaruro , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Cajaruro'),
(80, 'Cumba , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Cumba'),
(81, 'El Milagro , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'El Milagro'),
(82, 'Jamalca , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Jamalca'),
(83, 'Lonya Grande , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Lonya Grande'),
(84, 'Yamon , Utcubamba , Amazonas', 'Amazonas', 'Utcubamba', 'Yamon'),
(85, 'Huaraz , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Huaraz'),
(86, 'Cochabamba , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Cochabamba'),
(87, 'Colcabamba , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Colcabamba'),
(88, 'Huanchay , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Huanchay'),
(89, 'Independencia , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Independencia'),
(90, 'Jangas , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Jangas'),
(91, 'La Libertad , Huaraz , Ancash', 'Ancash', 'Huaraz', 'La Libertad'),
(92, 'Olleros , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Olleros'),
(93, 'Pampas , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Pampas'),
(94, 'Pariacoto , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Pariacoto'),
(95, 'Pira , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Pira'),
(96, 'Tarica , Huaraz , Ancash', 'Ancash', 'Huaraz', 'Tarica'),
(97, 'Aija , Aija , Ancash', 'Ancash', 'Aija', 'Aija'),
(98, 'Coris , Aija , Ancash', 'Ancash', 'Aija', 'Coris'),
(99, 'Huacllan , Aija , Ancash', 'Ancash', 'Aija', 'Huacllan'),
(100, 'La Merced , Aija , Ancash', 'Ancash', 'Aija', 'La Merced'),
(101, 'Succha , Aija , Ancash', 'Ancash', 'Aija', 'Succha'),
(102, 'Llamellin , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'Llamellin'),
(103, 'Aczo , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'Aczo'),
(104, 'Chaccho , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'Chaccho'),
(105, 'Chingas , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'Chingas'),
(106, 'Mirgas , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'Mirgas'),
(107, 'San Juan de Rontoy , Antonio Raymondi , Ancash', 'Ancash', 'Antonio Raymondi', 'San Juan de Rontoy'),
(108, 'Chacas , Asuncion , Ancash', 'Ancash', 'Asuncion', 'Chacas'),
(109, 'Acochaca , Asuncion , Ancash', 'Ancash', 'Asuncion', 'Acochaca'),
(110, 'Chiquian , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Chiquian'),
(111, 'Abelardo Pardo Lezameta , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Abelardo Pardo Lezameta'),
(112, 'Antonio Raymondi , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Antonio Raymondi'),
(113, 'Aquia , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Aquia'),
(114, 'Cajacay , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Cajacay'),
(115, 'Canis , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Canis'),
(116, 'Colquioc , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Colquioc'),
(117, 'Huallanca , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Huallanca'),
(118, 'Huasta , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Huasta'),
(119, 'Huayllacayan , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Huayllacayan'),
(120, 'La Primavera , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'La Primavera'),
(121, 'Mangas , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Mangas'),
(122, 'Pacllon , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Pacllon'),
(123, 'San Miguel de Corpanqui , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'San Miguel de Corpanqui'),
(124, 'Ticllos , Bolognesi , Ancash', 'Ancash', 'Bolognesi', 'Ticllos'),
(125, 'Carhuaz , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Carhuaz'),
(126, 'Acopampa , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Acopampa'),
(127, 'Amashca , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Amashca'),
(128, 'Anta , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Anta'),
(129, 'Ataquero , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Ataquero'),
(130, 'Marcara , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Marcara'),
(131, 'Pariahuanca , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Pariahuanca'),
(132, 'San Miguel de Aco , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'San Miguel de Aco'),
(133, 'Shilla , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Shilla'),
(134, 'Tinco , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Tinco'),
(135, 'Yungar , Carhuaz , Ancash', 'Ancash', 'Carhuaz', 'Yungar'),
(136, 'San Luis , Carlos Fermin Fitzca , Ancash', 'Ancash', 'Carlos Fermin Fitzca', 'San Luis'),
(137, 'San Nicolas , Carlos Fermin Fitzca , Ancash', 'Ancash', 'Carlos Fermin Fitzca', 'San Nicolas'),
(138, 'Yauya , Carlos Fermin Fitzca , Ancash', 'Ancash', 'Carlos Fermin Fitzca', 'Yauya'),
(139, 'Casma , Casma , Ancash', 'Ancash', 'Casma', 'Casma'),
(140, 'Buena Vista Alta , Casma , Ancash', 'Ancash', 'Casma', 'Buena Vista Alta'),
(141, 'Comandante Noel , Casma , Ancash', 'Ancash', 'Casma', 'Comandante Noel'),
(142, 'Yautan , Casma , Ancash', 'Ancash', 'Casma', 'Yautan'),
(143, 'Corongo , Corongo , Ancash', 'Ancash', 'Corongo', 'Corongo'),
(144, 'Aco , Corongo , Ancash', 'Ancash', 'Corongo', 'Aco'),
(145, 'Bambas , Corongo , Ancash', 'Ancash', 'Corongo', 'Bambas'),
(146, 'Cusca , Corongo , Ancash', 'Ancash', 'Corongo', 'Cusca'),
(147, 'La Pampa , Corongo , Ancash', 'Ancash', 'Corongo', 'La Pampa'),
(148, 'Yanac , Corongo , Ancash', 'Ancash', 'Corongo', 'Yanac'),
(149, 'Yupan , Corongo , Ancash', 'Ancash', 'Corongo', 'Yupan'),
(150, 'Huari , Huari , Ancash', 'Ancash', 'Huari', 'Huari'),
(151, 'Anra , Huari , Ancash', 'Ancash', 'Huari', 'Anra'),
(152, 'Cajay , Huari , Ancash', 'Ancash', 'Huari', 'Cajay'),
(153, 'Chavin de Huantar , Huari , Ancash', 'Ancash', 'Huari', 'Chavin de Huantar'),
(154, 'Huacachi , Huari , Ancash', 'Ancash', 'Huari', 'Huacachi'),
(155, 'Huacchis , Huari , Ancash', 'Ancash', 'Huari', 'Huacchis'),
(156, 'Huachis , Huari , Ancash', 'Ancash', 'Huari', 'Huachis'),
(157, 'Huantar , Huari , Ancash', 'Ancash', 'Huari', 'Huantar'),
(158, 'Masin , Huari , Ancash', 'Ancash', 'Huari', 'Masin'),
(159, 'Paucas , Huari , Ancash', 'Ancash', 'Huari', 'Paucas'),
(160, 'Ponto , Huari , Ancash', 'Ancash', 'Huari', 'Ponto'),
(161, 'Rahuapampa , Huari , Ancash', 'Ancash', 'Huari', 'Rahuapampa'),
(162, 'Rapayan , Huari , Ancash', 'Ancash', 'Huari', 'Rapayan'),
(163, 'San Marcos , Huari , Ancash', 'Ancash', 'Huari', 'San Marcos'),
(164, 'San Pedro de Chana , Huari , Ancash', 'Ancash', 'Huari', 'San Pedro de Chana'),
(165, 'Uco , Huari , Ancash', 'Ancash', 'Huari', 'Uco'),
(166, 'Huarmey , Huarmey , Ancash', 'Ancash', 'Huarmey', 'Huarmey'),
(167, 'Cochapeti , Huarmey , Ancash', 'Ancash', 'Huarmey', 'Cochapeti'),
(168, 'Culebras , Huarmey , Ancash', 'Ancash', 'Huarmey', 'Culebras'),
(169, 'Huayan , Huarmey , Ancash', 'Ancash', 'Huarmey', 'Huayan'),
(170, 'Malvas , Huarmey , Ancash', 'Ancash', 'Huarmey', 'Malvas'),
(171, 'Caraz , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Caraz'),
(172, 'Huallanca , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Huallanca'),
(173, 'Huata , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Huata'),
(174, 'Huaylas , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Huaylas'),
(175, 'Mato , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Mato'),
(176, 'Pamparomas , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Pamparomas'),
(177, 'Pueblo Libre , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Pueblo Libre'),
(178, 'Santa Cruz , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Santa Cruz'),
(179, 'Santo Toribio , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Santo Toribio'),
(180, 'Yuracmarca , Huaylas , Ancash', 'Ancash', 'Huaylas', 'Yuracmarca'),
(181, 'Piscobamba , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Piscobamba'),
(182, 'Casca , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Casca'),
(183, 'Eleazar Guzman Barron , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Eleazar Guzman Barron'),
(184, 'Fidel Olivas Escudero , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Fidel Olivas Escudero'),
(185, 'Llama , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Llama'),
(186, 'Llumpa , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Llumpa'),
(187, 'Lucma , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Lucma'),
(188, 'Musga , Mariscal Luzuriaga , Ancash', 'Ancash', 'Mariscal Luzuriaga', 'Musga'),
(189, 'Ocros , Ocros , Ancash', 'Ancash', 'Ocros', 'Ocros'),
(190, 'Acas , Ocros , Ancash', 'Ancash', 'Ocros', 'Acas'),
(191, 'Cajamarquilla , Ocros , Ancash', 'Ancash', 'Ocros', 'Cajamarquilla'),
(192, 'Carhuapampa , Ocros , Ancash', 'Ancash', 'Ocros', 'Carhuapampa'),
(193, 'Cochas , Ocros , Ancash', 'Ancash', 'Ocros', 'Cochas'),
(194, 'Congas , Ocros , Ancash', 'Ancash', 'Ocros', 'Congas'),
(195, 'Llipa , Ocros , Ancash', 'Ancash', 'Ocros', 'Llipa'),
(196, 'San Cristobal de Rajan , Ocros , Ancash', 'Ancash', 'Ocros', 'San Cristobal de Rajan'),
(197, 'San Pedro , Ocros , Ancash', 'Ancash', 'Ocros', 'San Pedro'),
(198, 'Santiago de Chilcas , Ocros , Ancash', 'Ancash', 'Ocros', 'Santiago de Chilcas'),
(199, 'Cabana , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Cabana'),
(200, 'Bolognesi , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Bolognesi'),
(201, 'Conchucos , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Conchucos'),
(202, 'Huacaschuque , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Huacaschuque'),
(203, 'Huandoval , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Huandoval'),
(204, 'Lacabamba , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Lacabamba'),
(205, 'Llapo , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Llapo'),
(206, 'Pallasca , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Pallasca'),
(207, 'Pampas , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Pampas'),
(208, 'Santa Rosa , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Santa Rosa'),
(209, 'Tauca , Pallasca , Ancash', 'Ancash', 'Pallasca', 'Tauca'),
(210, 'Pomabamba , Pomabamba , Ancash', 'Ancash', 'Pomabamba', 'Pomabamba'),
(211, 'Huayllan , Pomabamba , Ancash', 'Ancash', 'Pomabamba', 'Huayllan'),
(212, 'Parobamba , Pomabamba , Ancash', 'Ancash', 'Pomabamba', 'Parobamba'),
(213, 'Quinuabamba , Pomabamba , Ancash', 'Ancash', 'Pomabamba', 'Quinuabamba'),
(214, 'Recuay , Recuay , Ancash', 'Ancash', 'Recuay', 'Recuay'),
(215, 'Catac , Recuay , Ancash', 'Ancash', 'Recuay', 'Catac'),
(216, 'Cotaparaco , Recuay , Ancash', 'Ancash', 'Recuay', 'Cotaparaco'),
(217, 'Huayllapampa , Recuay , Ancash', 'Ancash', 'Recuay', 'Huayllapampa'),
(218, 'Llacllin , Recuay , Ancash', 'Ancash', 'Recuay', 'Llacllin'),
(219, 'Marca , Recuay , Ancash', 'Ancash', 'Recuay', 'Marca'),
(220, 'Pampas Chico , Recuay , Ancash', 'Ancash', 'Recuay', 'Pampas Chico'),
(221, 'Pararin , Recuay , Ancash', 'Ancash', 'Recuay', 'Pararin'),
(222, 'Tapacocha , Recuay , Ancash', 'Ancash', 'Recuay', 'Tapacocha'),
(223, 'Ticapampa , Recuay , Ancash', 'Ancash', 'Recuay', 'Ticapampa'),
(224, 'Chimbote , Santa , Ancash', 'Ancash', 'Santa', 'Chimbote'),
(225, 'Caceres del Peru , Santa , Ancash', 'Ancash', 'Santa', 'Caceres del Peru'),
(226, 'Coishco , Santa , Ancash', 'Ancash', 'Santa', 'Coishco'),
(227, 'Macate , Santa , Ancash', 'Ancash', 'Santa', 'Macate'),
(228, 'Moro , Santa , Ancash', 'Ancash', 'Santa', 'Moro'),
(229, 'Nepeña , Santa , Ancash', 'Ancash', 'Santa', 'Nepeña'),
(230, 'Samanco , Santa , Ancash', 'Ancash', 'Santa', 'Samanco'),
(231, 'Santa , Santa , Ancash', 'Ancash', 'Santa', 'Santa'),
(232, 'Nuevo Chimbote , Santa , Ancash', 'Ancash', 'Santa', 'Nuevo Chimbote'),
(233, 'Sihuas , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Sihuas'),
(234, 'Acobamba , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Acobamba'),
(235, 'Alfonso Ugarte , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Alfonso Ugarte'),
(236, 'Cashapampa , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Cashapampa'),
(237, 'Chingalpo , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Chingalpo'),
(238, 'Huayllabamba , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Huayllabamba'),
(239, 'Quiches , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Quiches'),
(240, 'Ragash , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Ragash'),
(241, 'San Juan , Sihuas , Ancash', 'Ancash', 'Sihuas', 'San Juan'),
(242, 'Sicsibamba , Sihuas , Ancash', 'Ancash', 'Sihuas', 'Sicsibamba'),
(243, 'Yungay , Yungay , Ancash', 'Ancash', 'Yungay', 'Yungay'),
(244, 'Cascapara , Yungay , Ancash', 'Ancash', 'Yungay', 'Cascapara'),
(245, 'Mancos , Yungay , Ancash', 'Ancash', 'Yungay', 'Mancos'),
(246, 'Matacoto , Yungay , Ancash', 'Ancash', 'Yungay', 'Matacoto'),
(247, 'Quillo , Yungay , Ancash', 'Ancash', 'Yungay', 'Quillo'),
(248, 'Ranrahirca , Yungay , Ancash', 'Ancash', 'Yungay', 'Ranrahirca'),
(249, 'Shupluy , Yungay , Ancash', 'Ancash', 'Yungay', 'Shupluy'),
(250, 'Yanama , Yungay , Ancash', 'Ancash', 'Yungay', 'Yanama'),
(251, 'Abancay , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Abancay'),
(252, 'Chacoche , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Chacoche'),
(253, 'Circa , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Circa'),
(254, 'Curahuasi , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Curahuasi'),
(255, 'Huanipaca , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Huanipaca'),
(256, 'Lambrama , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Lambrama'),
(257, 'Pichirhua , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Pichirhua'),
(258, 'San Pedro de Cachora , Abancay , Apurimac', 'Apurimac', 'Abancay', 'San Pedro de Cachora'),
(259, 'Tamburco , Abancay , Apurimac', 'Apurimac', 'Abancay', 'Tamburco'),
(260, 'Andahuaylas , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Andahuaylas'),
(261, 'Andarapa , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Andarapa'),
(262, 'Chiara , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Chiara'),
(263, 'Huancarama , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Huancarama'),
(264, 'Huancaray , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Huancaray'),
(265, 'Huayana , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Huayana'),
(266, 'Kishuara , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Kishuara'),
(267, 'Pacobamba , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Pacobamba'),
(268, 'Pacucha , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Pacucha'),
(269, 'Pampachiri , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Pampachiri'),
(270, 'Pomacocha , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Pomacocha'),
(271, 'San Antonio de Cachi , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'San Antonio de Cachi'),
(272, 'San Jeronimo , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'San Jeronimo'),
(273, 'San Miguel de Chaccrampa , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'San Miguel de Chaccrampa'),
(274, 'Santa Maria de Chicmo , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Santa Maria de Chicmo'),
(275, 'Talavera , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Talavera'),
(276, 'Tumay Huaraca , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Tumay Huaraca'),
(277, 'Turpo , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Turpo'),
(278, 'Kaquiabamba , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Kaquiabamba'),
(279, 'Jose Maria Arguedas , Andahuaylas , Apurimac', 'Apurimac', 'Andahuaylas', 'Jose Maria Arguedas'),
(280, 'Antabamba , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Antabamba'),
(281, 'El Oro , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'El Oro'),
(282, 'Huaquirca , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Huaquirca'),
(283, 'Juan Espinoza Medrano , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Juan Espinoza Medrano'),
(284, 'Oropesa , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Oropesa'),
(285, 'Pachaconas , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Pachaconas'),
(286, 'Sabaino , Antabamba , Apurimac', 'Apurimac', 'Antabamba', 'Sabaino'),
(287, 'Chalhuanca , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Chalhuanca'),
(288, 'Capaya , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Capaya'),
(289, 'Caraybamba , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Caraybamba'),
(290, 'Chapimarca , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Chapimarca'),
(291, 'Colcabamba , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Colcabamba'),
(292, 'Cotaruse , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Cotaruse'),
(293, 'Huayllo , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Huayllo'),
(294, 'Justo Apu Sahuaraura , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Justo Apu Sahuaraura'),
(295, 'Lucre , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Lucre'),
(296, 'Pocohuanca , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Pocohuanca'),
(297, 'San Juan de Chacña , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'San Juan de Chacña'),
(298, 'Sañayca , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Sañayca'),
(299, 'Soraya , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Soraya'),
(300, 'Tapairihua , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Tapairihua'),
(301, 'Tintay , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Tintay'),
(302, 'Toraya , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Toraya'),
(303, 'Yanaca , Aymaraes , Apurimac', 'Apurimac', 'Aymaraes', 'Yanaca'),
(304, 'Tambobamba , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Tambobamba'),
(305, 'Cotabambas , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Cotabambas'),
(306, 'Coyllurqui , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Coyllurqui'),
(307, 'Haquira , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Haquira'),
(308, 'Mara , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Mara'),
(309, 'Challhuahuacho , Cotabambas , Apurimac', 'Apurimac', 'Cotabambas', 'Challhuahuacho'),
(310, 'Chincheros , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Chincheros'),
(311, 'Anco_Huallo , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Anco_Huallo'),
(312, 'Cocharcas , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Cocharcas'),
(313, 'Huaccana , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Huaccana'),
(314, 'Ocobamba , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Ocobamba'),
(315, 'Ongoy , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Ongoy'),
(316, 'Uranmarca , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Uranmarca'),
(317, 'Ranracancha , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Ranracancha'),
(318, 'Rocchacc , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Rocchacc'),
(319, 'El Porvenir , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'El Porvenir'),
(320, 'Los Chankas , Chincheros , Apurimac', 'Apurimac', 'Chincheros', 'Los Chankas'),
(321, 'Chuquibambilla , Grau , Apurimac', 'Apurimac', 'Grau', 'Chuquibambilla'),
(322, 'Curpahuasi , Grau , Apurimac', 'Apurimac', 'Grau', 'Curpahuasi'),
(323, 'Gamarra , Grau , Apurimac', 'Apurimac', 'Grau', 'Gamarra'),
(324, 'Huayllati , Grau , Apurimac', 'Apurimac', 'Grau', 'Huayllati'),
(325, 'Mamara , Grau , Apurimac', 'Apurimac', 'Grau', 'Mamara'),
(326, 'Micaela Bastidas , Grau , Apurimac', 'Apurimac', 'Grau', 'Micaela Bastidas'),
(327, 'Pataypampa , Grau , Apurimac', 'Apurimac', 'Grau', 'Pataypampa'),
(328, 'Progreso , Grau , Apurimac', 'Apurimac', 'Grau', 'Progreso'),
(329, 'San Antonio , Grau , Apurimac', 'Apurimac', 'Grau', 'San Antonio'),
(330, 'Santa Rosa , Grau , Apurimac', 'Apurimac', 'Grau', 'Santa Rosa'),
(331, 'Turpay , Grau , Apurimac', 'Apurimac', 'Grau', 'Turpay'),
(332, 'Vilcabamba , Grau , Apurimac', 'Apurimac', 'Grau', 'Vilcabamba'),
(333, 'Virundo , Grau , Apurimac', 'Apurimac', 'Grau', 'Virundo'),
(334, 'Curasco , Grau , Apurimac', 'Apurimac', 'Grau', 'Curasco'),
(335, 'Arequipa , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Arequipa'),
(336, 'Alto Selva Alegre , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Alto Selva Alegre'),
(337, 'Cayma , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Cayma'),
(338, 'Cerro Colorado , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Cerro Colorado'),
(339, 'Characato , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Characato'),
(340, 'Chiguata , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Chiguata'),
(341, 'Jacobo Hunter , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Jacobo Hunter'),
(342, 'La Joya , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'La Joya'),
(343, 'Mariano Melgar , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Mariano Melgar'),
(344, 'Miraflores , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Miraflores'),
(345, 'Mollebaya , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Mollebaya'),
(346, 'Paucarpata , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Paucarpata'),
(347, 'Pocsi , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Pocsi'),
(348, 'Polobaya , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Polobaya'),
(349, 'Quequeña , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Quequeña'),
(350, 'Sabandia , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Sabandia'),
(351, 'Sachaca , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Sachaca'),
(352, 'San Juan de Siguas , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'San Juan de Siguas'),
(353, 'San Juan de Tarucani , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'San Juan de Tarucani'),
(354, 'Santa Isabel de Siguas , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Santa Isabel de Siguas'),
(355, 'Santa Rita de Siguas , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Santa Rita de Siguas'),
(356, 'Socabaya , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Socabaya'),
(357, 'Tiabaya , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Tiabaya'),
(358, 'Uchumayo , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Uchumayo'),
(359, 'Vitor , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Vitor'),
(360, 'Yanahuara , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Yanahuara'),
(361, 'Yarabamba , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Yarabamba'),
(362, 'Yura , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Yura'),
(363, 'Jose Luis Bustamante y Rivero , Arequipa , Arequipa', 'Arequipa', 'Arequipa', 'Jose Luis Bustamante y Rivero'),
(364, 'Camana , Camana , Arequipa', 'Arequipa', 'Camana', 'Camana'),
(365, 'Jose Maria Quimper , Camana , Arequipa', 'Arequipa', 'Camana', 'Jose Maria Quimper'),
(366, 'Mariano Nicolas Valcarcel , Camana , Arequipa', 'Arequipa', 'Camana', 'Mariano Nicolas Valcarcel'),
(367, 'Mariscal Caceres , Camana , Arequipa', 'Arequipa', 'Camana', 'Mariscal Caceres'),
(368, 'Nicolas de Pierola , Camana , Arequipa', 'Arequipa', 'Camana', 'Nicolas de Pierola'),
(369, 'Ocoña , Camana , Arequipa', 'Arequipa', 'Camana', 'Ocoña'),
(370, 'Quilca , Camana , Arequipa', 'Arequipa', 'Camana', 'Quilca'),
(371, 'Samuel Pastor , Camana , Arequipa', 'Arequipa', 'Camana', 'Samuel Pastor'),
(372, 'Caraveli , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Caraveli'),
(373, 'Acari , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Acari'),
(374, 'Atico , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Atico'),
(375, 'Atiquipa , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Atiquipa'),
(376, 'Bella Union , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Bella Union'),
(377, 'Cahuacho , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Cahuacho'),
(378, 'Chala , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Chala'),
(379, 'Chaparra , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Chaparra'),
(380, 'Huanuhuanu , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Huanuhuanu'),
(381, 'Jaqui , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Jaqui'),
(382, 'Lomas , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Lomas'),
(383, 'Quicacha , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Quicacha'),
(384, 'Yauca , Caraveli , Arequipa', 'Arequipa', 'Caraveli', 'Yauca'),
(385, 'Aplao , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Aplao'),
(386, 'Andagua , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Andagua'),
(387, 'Ayo , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Ayo'),
(388, 'Chachas , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Chachas'),
(389, 'Chilcaymarca , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Chilcaymarca'),
(390, 'Choco , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Choco'),
(391, 'Huancarqui , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Huancarqui'),
(392, 'Machaguay , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Machaguay'),
(393, 'Orcopampa , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Orcopampa'),
(394, 'Pampacolca , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Pampacolca'),
(395, 'Tipan , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Tipan'),
(396, 'Uñon , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Uñon'),
(397, 'Uraca , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Uraca'),
(398, 'Viraco , Castilla , Arequipa', 'Arequipa', 'Castilla', 'Viraco'),
(399, 'Chivay , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Chivay'),
(400, 'Achoma , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Achoma'),
(401, 'Cabanaconde , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Cabanaconde'),
(402, 'Callalli , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Callalli'),
(403, 'Caylloma , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Caylloma'),
(404, 'Coporaque , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Coporaque'),
(405, 'Huambo , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Huambo'),
(406, 'Huanca , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Huanca'),
(407, 'Ichupampa , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Ichupampa'),
(408, 'Lari , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Lari'),
(409, 'Lluta , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Lluta'),
(410, 'Maca , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Maca'),
(411, 'Madrigal , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Madrigal'),
(412, 'San Antonio de Chuca , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'San Antonio de Chuca'),
(413, 'Sibayo , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Sibayo'),
(414, 'Tapay , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Tapay'),
(415, 'Tisco , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Tisco'),
(416, 'Tuti , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Tuti'),
(417, 'Yanque , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Yanque'),
(418, 'Majes , Caylloma , Arequipa', 'Arequipa', 'Caylloma', 'Majes'),
(419, 'Chuquibamba , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Chuquibamba'),
(420, 'Andaray , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Andaray'),
(421, 'Cayarani , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Cayarani'),
(422, 'Chichas , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Chichas'),
(423, 'Iray , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Iray'),
(424, 'Rio Grande , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Rio Grande'),
(425, 'Salamanca , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Salamanca'),
(426, 'Yanaquihua , Condesuyos , Arequipa', 'Arequipa', 'Condesuyos', 'Yanaquihua'),
(427, 'Mollendo , Islay , Arequipa', 'Arequipa', 'Islay', 'Mollendo'),
(428, 'Cocachacra , Islay , Arequipa', 'Arequipa', 'Islay', 'Cocachacra'),
(429, 'Dean Valdivia , Islay , Arequipa', 'Arequipa', 'Islay', 'Dean Valdivia'),
(430, 'Islay , Islay , Arequipa', 'Arequipa', 'Islay', 'Islay'),
(431, 'Mejia , Islay , Arequipa', 'Arequipa', 'Islay', 'Mejia'),
(432, 'Punta de Bombon , Islay , Arequipa', 'Arequipa', 'Islay', 'Punta de Bombon'),
(433, 'Cotahuasi , La Union , Arequipa', 'Arequipa', 'La Union', 'Cotahuasi'),
(434, 'Alca , La Union , Arequipa', 'Arequipa', 'La Union', 'Alca'),
(435, 'Charcana , La Union , Arequipa', 'Arequipa', 'La Union', 'Charcana'),
(436, 'Huaynacotas , La Union , Arequipa', 'Arequipa', 'La Union', 'Huaynacotas'),
(437, 'Pampamarca , La Union , Arequipa', 'Arequipa', 'La Union', 'Pampamarca'),
(438, 'Puyca , La Union , Arequipa', 'Arequipa', 'La Union', 'Puyca'),
(439, 'Quechualla , La Union , Arequipa', 'Arequipa', 'La Union', 'Quechualla'),
(440, 'Sayla , La Union , Arequipa', 'Arequipa', 'La Union', 'Sayla'),
(441, 'Tauria , La Union , Arequipa', 'Arequipa', 'La Union', 'Tauria'),
(442, 'Tomepampa , La Union , Arequipa', 'Arequipa', 'La Union', 'Tomepampa'),
(443, 'Toro , La Union , Arequipa', 'Arequipa', 'La Union', 'Toro'),
(444, 'Ayacucho , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Ayacucho'),
(445, 'Acocro , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Acocro'),
(446, 'Acos Vinchos , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Acos Vinchos'),
(447, 'Carmen Alto , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Carmen Alto'),
(448, 'Chiara , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Chiara'),
(449, 'Ocros , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Ocros'),
(450, 'Pacaycasa , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Pacaycasa'),
(451, 'Quinua , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Quinua'),
(452, 'San Jose de Ticllas , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'San Jose de Ticllas'),
(453, 'San Juan Bautista , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'San Juan Bautista'),
(454, 'Santiago de Pischa , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Santiago de Pischa'),
(455, 'Socos , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Socos'),
(456, 'Tambillo , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Tambillo'),
(457, 'Vinchos , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Vinchos'),
(458, 'Jesus Nazareno , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Jesus Nazareno'),
(459, 'Andres Avelino Caceres Dorregaray , Huamanga , Ayacucho', 'Ayacucho', 'Huamanga', 'Andres Avelino Caceres Dorregaray'),
(460, 'Cangallo , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Cangallo'),
(461, 'Chuschi , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Chuschi'),
(462, 'Los Morochucos , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Los Morochucos'),
(463, 'Maria Parado de Bellido , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Maria Parado de Bellido'),
(464, 'Paras , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Paras'),
(465, 'Totos , Cangallo , Ayacucho', 'Ayacucho', 'Cangallo', 'Totos'),
(466, 'Sancos , Huanca Sancos , Ayacucho', 'Ayacucho', 'Huanca Sancos', 'Sancos'),
(467, 'Carapo , Huanca Sancos , Ayacucho', 'Ayacucho', 'Huanca Sancos', 'Carapo'),
(468, 'Sacsamarca , Huanca Sancos , Ayacucho', 'Ayacucho', 'Huanca Sancos', 'Sacsamarca'),
(469, 'Santiago de Lucanamarca , Huanca Sancos , Ayacucho', 'Ayacucho', 'Huanca Sancos', 'Santiago de Lucanamarca'),
(470, 'Huanta , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Huanta'),
(471, 'Ayahuanco , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Ayahuanco'),
(472, 'Huamanguilla , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Huamanguilla'),
(473, 'Iguain , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Iguain'),
(474, 'Luricocha , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Luricocha'),
(475, 'Santillana , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Santillana'),
(476, 'Sivia , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Sivia'),
(477, 'Llochegua , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Llochegua'),
(478, 'Canayre , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Canayre'),
(479, 'Uchuraccay , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Uchuraccay'),
(480, 'Pucacolpa , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Pucacolpa'),
(481, 'Chaca , Huanta , Ayacucho', 'Ayacucho', 'Huanta', 'Chaca'),
(482, 'San Miguel , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'San Miguel'),
(483, 'Anco , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Anco'),
(484, 'Ayna , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Ayna'),
(485, 'Chilcas , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Chilcas'),
(486, 'Chungui , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Chungui'),
(487, 'Luis Carranza , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Luis Carranza'),
(488, 'Santa Rosa , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Santa Rosa'),
(489, 'Tambo , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Tambo'),
(490, 'Samugari , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Samugari'),
(491, 'Anchihuay , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Anchihuay'),
(492, 'Oronccoy , La Mar , Ayacucho', 'Ayacucho', 'La Mar', 'Oronccoy'),
(493, 'Puquio , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Puquio'),
(494, 'Aucara , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Aucara'),
(495, 'Cabana , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Cabana'),
(496, 'Carmen Salcedo , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Carmen Salcedo'),
(497, 'Chaviña , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Chaviña'),
(498, 'Chipao , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Chipao'),
(499, 'Huac-Huas , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Huac-Huas'),
(500, 'Laramate , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Laramate'),
(501, 'Leoncio Prado , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Leoncio Prado'),
(502, 'Llauta , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Llauta'),
(503, 'Lucanas , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Lucanas'),
(504, 'Ocaña , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Ocaña'),
(505, 'Otoca , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Otoca'),
(506, 'Saisa , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Saisa'),
(507, 'San Cristobal , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'San Cristobal'),
(508, 'San Juan , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'San Juan'),
(509, 'San Pedro , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'San Pedro'),
(510, 'San Pedro de Palco , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'San Pedro de Palco'),
(511, 'Sancos , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Sancos'),
(512, 'Santa Ana de Huaycahuacho , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Santa Ana de Huaycahuacho'),
(513, 'Santa Lucia , Lucanas , Ayacucho', 'Ayacucho', 'Lucanas', 'Santa Lucia'),
(514, 'Coracora , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Coracora'),
(515, 'Chumpi , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Chumpi'),
(516, 'Coronel Castañeda , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Coronel Castañeda'),
(517, 'Pacapausa , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Pacapausa'),
(518, 'Pullo , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Pullo'),
(519, 'Puyusca , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Puyusca'),
(520, 'San Francisco de Ravacayco , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'San Francisco de Ravacayco'),
(521, 'Upahuacho , Parinacochas , Ayacucho', 'Ayacucho', 'Parinacochas', 'Upahuacho'),
(522, 'Pausa , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Pausa'),
(523, 'Colta , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Colta'),
(524, 'Corculla , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Corculla'),
(525, 'Lampa , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Lampa'),
(526, 'Marcabamba , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Marcabamba'),
(527, 'Oyolo , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Oyolo'),
(528, 'Pararca , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Pararca'),
(529, 'San Javier de Alpabamba , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'San Javier de Alpabamba'),
(530, 'San Jose de Ushua , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'San Jose de Ushua'),
(531, 'Sara Sara , Paucar del Sara Sara , Ayacucho', 'Ayacucho', 'Paucar del Sara Sara', 'Sara Sara'),
(532, 'Querobamba , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Querobamba'),
(533, 'Belen , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Belen'),
(534, 'Chalcos , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Chalcos'),
(535, 'Chilcayoc , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Chilcayoc'),
(536, 'Huacaña , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Huacaña'),
(537, 'Morcolla , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Morcolla'),
(538, 'Paico , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Paico'),
(539, 'San Pedro de Larcay , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'San Pedro de Larcay'),
(540, 'San Salvador de Quije , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'San Salvador de Quije'),
(541, 'Santiago de Paucaray , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Santiago de Paucaray'),
(542, 'Soras , Sucre , Ayacucho', 'Ayacucho', 'Sucre', 'Soras'),
(543, 'Huancapi , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Huancapi'),
(544, 'Alcamenca , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Alcamenca'),
(545, 'Apongo , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Apongo'),
(546, 'Asquipata , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Asquipata'),
(547, 'Canaria , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Canaria'),
(548, 'Cayara , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Cayara'),
(549, 'Colca , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Colca'),
(550, 'Huamanquiquia , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Huamanquiquia'),
(551, 'Huancaraylla , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Huancaraylla'),
(552, 'Huaya , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Huaya'),
(553, 'Sarhua , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Sarhua'),
(554, 'Vilcanchos , Victor Fajardo , Ayacucho', 'Ayacucho', 'Victor Fajardo', 'Vilcanchos'),
(555, 'Vilcas Huaman , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Vilcas Huaman'),
(556, 'Accomarca , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Accomarca'),
(557, 'Carhuanca , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Carhuanca'),
(558, 'Concepcion , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Concepcion'),
(559, 'Huambalpa , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Huambalpa'),
(560, 'Independencia , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Independencia'),
(561, 'Saurama , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Saurama'),
(562, 'Vischongo , Vilcas Huaman , Ayacucho', 'Ayacucho', 'Vilcas Huaman', 'Vischongo'),
(563, 'Cajamarca , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Cajamarca'),
(564, 'Asuncion , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Asuncion'),
(565, 'Chetilla , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Chetilla'),
(566, 'Cospan , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Cospan'),
(567, 'Encañada , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Encañada'),
(568, 'Jesus , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Jesus'),
(569, 'Llacanora , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Llacanora'),
(570, 'Los Baños del Inca , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Los Baños del Inca'),
(571, 'Magdalena , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Magdalena'),
(572, 'Matara , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Matara'),
(573, 'Namora , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'Namora'),
(574, 'San Juan , Cajamarca , Cajamarca', 'Cajamarca', 'Cajamarca', 'San Juan'),
(575, 'Cajabamba , Cajabamba , Cajamarca', 'Cajamarca', 'Cajabamba', 'Cajabamba'),
(576, 'Cachachi , Cajabamba , Cajamarca', 'Cajamarca', 'Cajabamba', 'Cachachi'),
(577, 'Condebamba , Cajabamba , Cajamarca', 'Cajamarca', 'Cajabamba', 'Condebamba'),
(578, 'Sitacocha , Cajabamba , Cajamarca', 'Cajamarca', 'Cajabamba', 'Sitacocha'),
(579, 'Celendin , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Celendin'),
(580, 'Chumuch , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Chumuch'),
(581, 'Cortegana , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Cortegana'),
(582, 'Huasmin , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Huasmin'),
(583, 'Jorge Chavez , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Jorge Chavez'),
(584, 'Jose Galvez , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Jose Galvez'),
(585, 'Miguel Iglesias , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Miguel Iglesias'),
(586, 'Oxamarca , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Oxamarca'),
(587, 'Sorochuco , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Sorochuco'),
(588, 'Sucre , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Sucre'),
(589, 'Utco , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'Utco'),
(590, 'La Libertad de Pallan , Celendin , Cajamarca', 'Cajamarca', 'Celendin', 'La Libertad de Pallan'),
(591, 'Chota , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Chota'),
(592, 'Anguia , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Anguia'),
(593, 'Chadin , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Chadin'),
(594, 'Chiguirip , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Chiguirip'),
(595, 'Chimban , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Chimban'),
(596, 'Choropampa , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Choropampa'),
(597, 'Cochabamba , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Cochabamba'),
(598, 'Conchan , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Conchan'),
(599, 'Huambos , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Huambos'),
(600, 'Lajas , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Lajas'),
(601, 'Llama , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Llama'),
(602, 'Miracosta , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Miracosta'),
(603, 'Paccha , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Paccha'),
(604, 'Pion , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Pion'),
(605, 'Querocoto , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Querocoto'),
(606, 'San Juan de Licupis , Chota , Cajamarca', 'Cajamarca', 'Chota', 'San Juan de Licupis'),
(607, 'Tacabamba , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Tacabamba'),
(608, 'Tocmoche , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Tocmoche'),
(609, 'Chalamarca , Chota , Cajamarca', 'Cajamarca', 'Chota', 'Chalamarca'),
(610, 'Contumaza , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Contumaza'),
(611, 'Chilete , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Chilete'),
(612, 'Cupisnique , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Cupisnique'),
(613, 'Guzmango , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Guzmango'),
(614, 'San Benito , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'San Benito'),
(615, 'Santa Cruz de Toled , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Santa Cruz de Toled'),
(616, 'Tantarica , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Tantarica'),
(617, 'Yonan , Contumaza , Cajamarca', 'Cajamarca', 'Contumaza', 'Yonan'),
(618, 'Cutervo , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Cutervo'),
(619, 'Callayuc , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Callayuc'),
(620, 'Choros , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Choros'),
(621, 'Cujillo , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Cujillo'),
(622, 'La Ramada , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'La Ramada'),
(623, 'Pimpingos , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Pimpingos'),
(624, 'Querocotillo , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Querocotillo'),
(625, 'San Andres de Cutervo , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'San Andres de Cutervo'),
(626, 'San Juan de Cutervo , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'San Juan de Cutervo'),
(627, 'San Luis de Lucma , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'San Luis de Lucma'),
(628, 'Santa Cruz , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Santa Cruz'),
(629, 'Santo Domingo de La Capilla , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Santo Domingo de La Capilla'),
(630, 'Santo Tomas , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Santo Tomas'),
(631, 'Socota , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Socota'),
(632, 'Toribio Casanova , Cutervo , Cajamarca', 'Cajamarca', 'Cutervo', 'Toribio Casanova'),
(633, 'Bambamarca , Hualgayoc , Cajamarca', 'Cajamarca', 'Hualgayoc', 'Bambamarca'),
(634, 'Chugur , Hualgayoc , Cajamarca', 'Cajamarca', 'Hualgayoc', 'Chugur'),
(635, 'Hualgayoc , Hualgayoc , Cajamarca', 'Cajamarca', 'Hualgayoc', 'Hualgayoc'),
(636, 'Jaen , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Jaen'),
(637, 'Bellavista , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Bellavista'),
(638, 'Chontali , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Chontali'),
(639, 'Colasay , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Colasay'),
(640, 'Huabal , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Huabal'),
(641, 'Las Pirias , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Las Pirias'),
(642, 'Pomahuaca , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Pomahuaca'),
(643, 'Pucara , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Pucara'),
(644, 'Sallique , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Sallique'),
(645, 'San Felipe , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'San Felipe'),
(646, 'San Jose del Alto , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'San Jose del Alto'),
(647, 'Santa Rosa , Jaen , Cajamarca', 'Cajamarca', 'Jaen', 'Santa Rosa'),
(648, 'San Ignacio , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'San Ignacio'),
(649, 'Chirinos , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'Chirinos'),
(650, 'Huarango , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'Huarango');
INSERT INTO `conf_ubigeo` (`codUbigeo`, `desUbigeo`, `Departamento`, `Provincia`, `Distrito`) VALUES
(651, 'La Coipa , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'La Coipa'),
(652, 'Namballe , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'Namballe'),
(653, 'San Jose de Lourdes , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'San Jose de Lourdes'),
(654, 'Tabaconas , San Ignacio , Cajamarca', 'Cajamarca', 'San Ignacio', 'Tabaconas'),
(655, 'Pedro Galvez , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Pedro Galvez'),
(656, 'Chancay , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Chancay'),
(657, 'Eduardo Villanueva , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Eduardo Villanueva'),
(658, 'Gregorio Pita , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Gregorio Pita'),
(659, 'Ichocan , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Ichocan'),
(660, 'Jose Manuel Quiroz , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Jose Manuel Quiroz'),
(661, 'Jose Sabogal , San Marcos , Cajamarca', 'Cajamarca', 'San Marcos', 'Jose Sabogal'),
(662, 'San Miguel , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'San Miguel'),
(663, 'Bolivar , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Bolivar'),
(664, 'Calquis , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Calquis'),
(665, 'Catilluc , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Catilluc'),
(666, 'El Prado , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'El Prado'),
(667, 'La Florida , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'La Florida'),
(668, 'Llapa , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Llapa'),
(669, 'Nanchoc , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Nanchoc'),
(670, 'Niepos , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Niepos'),
(671, 'San Gregorio , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'San Gregorio'),
(672, 'San Silvestre de Cochan , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'San Silvestre de Cochan'),
(673, 'Tongod , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Tongod'),
(674, 'Union Agua Blanca , San Miguel , Cajamarca', 'Cajamarca', 'San Miguel', 'Union Agua Blanca'),
(675, 'San Pablo , San Pablo , Cajamarca', 'Cajamarca', 'San Pablo', 'San Pablo'),
(676, 'San Bernardino , San Pablo , Cajamarca', 'Cajamarca', 'San Pablo', 'San Bernardino'),
(677, 'San Luis , San Pablo , Cajamarca', 'Cajamarca', 'San Pablo', 'San Luis'),
(678, 'Tumbaden , San Pablo , Cajamarca', 'Cajamarca', 'San Pablo', 'Tumbaden'),
(679, 'Santa Cruz , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Santa Cruz'),
(680, 'Andabamba , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Andabamba'),
(681, 'Catache , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Catache'),
(682, 'Chancaybaños , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Chancaybaños'),
(683, 'La Esperanza , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'La Esperanza'),
(684, 'Ninabamba , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Ninabamba'),
(685, 'Pulan , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Pulan'),
(686, 'Saucepampa , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Saucepampa'),
(687, 'Sexi , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Sexi'),
(688, 'Uticyacu , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Uticyacu'),
(689, 'Yauyucan , Santa Cruz , Cajamarca', 'Cajamarca', 'Santa Cruz', 'Yauyucan'),
(690, 'Callao , Callao , Callao', 'Callao', 'Callao', 'Callao'),
(691, 'Bellavista , Callao , Callao', 'Callao', 'Callao', 'Bellavista'),
(692, 'Carmen de La Legua , Callao , Callao', 'Callao', 'Callao', 'Carmen de La Legua'),
(693, 'La Perla , Callao , Callao', 'Callao', 'Callao', 'La Perla'),
(694, 'La Punta , Callao , Callao', 'Callao', 'Callao', 'La Punta'),
(695, 'Ventanilla , Callao , Callao', 'Callao', 'Callao', 'Ventanilla'),
(696, 'Mi Peru , Callao , Callao', 'Callao', 'Callao', 'Mi Peru'),
(697, 'Cusco , Cusco , Cusco', 'Cusco', 'Cusco', 'Cusco'),
(698, 'Ccorca , Cusco , Cusco', 'Cusco', 'Cusco', 'Ccorca'),
(699, 'Poroy , Cusco , Cusco', 'Cusco', 'Cusco', 'Poroy'),
(700, 'San Jeronimo , Cusco , Cusco', 'Cusco', 'Cusco', 'San Jeronimo'),
(701, 'San Sebastian , Cusco , Cusco', 'Cusco', 'Cusco', 'San Sebastian'),
(702, 'Santiago , Cusco , Cusco', 'Cusco', 'Cusco', 'Santiago'),
(703, 'Saylla , Cusco , Cusco', 'Cusco', 'Cusco', 'Saylla'),
(704, 'Wanchaq , Cusco , Cusco', 'Cusco', 'Cusco', 'Wanchaq'),
(705, 'Acomayo , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Acomayo'),
(706, 'Acopia , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Acopia'),
(707, 'Acos , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Acos'),
(708, 'Mosoc Llacta , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Mosoc Llacta'),
(709, 'Pomacanchi , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Pomacanchi'),
(710, 'Rondocan , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Rondocan'),
(711, 'Sangarara , Acomayo , Cusco', 'Cusco', 'Acomayo', 'Sangarara'),
(712, 'Anta , Anta , Cusco', 'Cusco', 'Anta', 'Anta'),
(713, 'Ancahuasi , Anta , Cusco', 'Cusco', 'Anta', 'Ancahuasi'),
(714, 'Cachimayo , Anta , Cusco', 'Cusco', 'Anta', 'Cachimayo'),
(715, 'Chinchaypujio , Anta , Cusco', 'Cusco', 'Anta', 'Chinchaypujio'),
(716, 'Huarocondo , Anta , Cusco', 'Cusco', 'Anta', 'Huarocondo'),
(717, 'Limatambo , Anta , Cusco', 'Cusco', 'Anta', 'Limatambo'),
(718, 'Mollepata , Anta , Cusco', 'Cusco', 'Anta', 'Mollepata'),
(719, 'Pucyura , Anta , Cusco', 'Cusco', 'Anta', 'Pucyura'),
(720, 'Zurite , Anta , Cusco', 'Cusco', 'Anta', 'Zurite'),
(721, 'Calca , Calca , Cusco', 'Cusco', 'Calca', 'Calca'),
(722, 'Coya , Calca , Cusco', 'Cusco', 'Calca', 'Coya'),
(723, 'Lamay , Calca , Cusco', 'Cusco', 'Calca', 'Lamay'),
(724, 'Lares , Calca , Cusco', 'Cusco', 'Calca', 'Lares'),
(725, 'Pisac , Calca , Cusco', 'Cusco', 'Calca', 'Pisac'),
(726, 'San Salvador , Calca , Cusco', 'Cusco', 'Calca', 'San Salvador'),
(727, 'Taray , Calca , Cusco', 'Cusco', 'Calca', 'Taray'),
(728, 'Yanatile , Calca , Cusco', 'Cusco', 'Calca', 'Yanatile'),
(729, 'Yanaoca , Canas , Cusco', 'Cusco', 'Canas', 'Yanaoca'),
(730, 'Checca , Canas , Cusco', 'Cusco', 'Canas', 'Checca'),
(731, 'Kunturkanki , Canas , Cusco', 'Cusco', 'Canas', 'Kunturkanki'),
(732, 'Langui , Canas , Cusco', 'Cusco', 'Canas', 'Langui'),
(733, 'Layo , Canas , Cusco', 'Cusco', 'Canas', 'Layo'),
(734, 'Pampamarca , Canas , Cusco', 'Cusco', 'Canas', 'Pampamarca'),
(735, 'Quehue , Canas , Cusco', 'Cusco', 'Canas', 'Quehue'),
(736, 'Tupac Amaru , Canas , Cusco', 'Cusco', 'Canas', 'Tupac Amaru'),
(737, 'Sicuani , Canchis , Cusco', 'Cusco', 'Canchis', 'Sicuani'),
(738, 'Checacupe , Canchis , Cusco', 'Cusco', 'Canchis', 'Checacupe'),
(739, 'Combapata , Canchis , Cusco', 'Cusco', 'Canchis', 'Combapata'),
(740, 'Marangani , Canchis , Cusco', 'Cusco', 'Canchis', 'Marangani'),
(741, 'Pitumarca , Canchis , Cusco', 'Cusco', 'Canchis', 'Pitumarca'),
(742, 'San Pablo , Canchis , Cusco', 'Cusco', 'Canchis', 'San Pablo'),
(743, 'San Pedro , Canchis , Cusco', 'Cusco', 'Canchis', 'San Pedro'),
(744, 'Tinta , Canchis , Cusco', 'Cusco', 'Canchis', 'Tinta'),
(745, 'Santo Tomas , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Santo Tomas'),
(746, 'Capacmarca , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Capacmarca'),
(747, 'Chamaca , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Chamaca'),
(748, 'Colquemarca , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Colquemarca'),
(749, 'Livitaca , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Livitaca'),
(750, 'Llusco , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Llusco'),
(751, 'Quiñota , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Quiñota'),
(752, 'Velille , Chumbivilcas , Cusco', 'Cusco', 'Chumbivilcas', 'Velille'),
(753, 'Espinar , Espinar , Cusco', 'Cusco', 'Espinar', 'Espinar'),
(754, 'Condoroma , Espinar , Cusco', 'Cusco', 'Espinar', 'Condoroma'),
(755, 'Coporaque , Espinar , Cusco', 'Cusco', 'Espinar', 'Coporaque'),
(756, 'Ocoruro , Espinar , Cusco', 'Cusco', 'Espinar', 'Ocoruro'),
(757, 'Pallpata , Espinar , Cusco', 'Cusco', 'Espinar', 'Pallpata'),
(758, 'Pichigua , Espinar , Cusco', 'Cusco', 'Espinar', 'Pichigua'),
(759, 'Suyckutambo , Espinar , Cusco', 'Cusco', 'Espinar', 'Suyckutambo'),
(760, 'Alto Pichigua , Espinar , Cusco', 'Cusco', 'Espinar', 'Alto Pichigua'),
(761, 'Santa Ana , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Santa Ana'),
(762, 'Echarate , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Echarate'),
(763, 'Huayopata , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Huayopata'),
(764, 'Maranura , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Maranura'),
(765, 'Ocobamba , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Ocobamba'),
(766, 'Quellouno , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Quellouno'),
(767, 'Kimbiri , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Kimbiri'),
(768, 'Santa Teresa , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Santa Teresa'),
(769, 'Vilcabamba , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Vilcabamba'),
(770, 'Pichari , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Pichari'),
(771, 'Inkawasi , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Inkawasi'),
(772, 'Villa Virgen , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Villa Virgen'),
(773, 'Villa Kintiarina , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Villa Kintiarina'),
(774, 'Megantoni , La Convencion , Cusco', 'Cusco', 'La Convencion', 'Megantoni'),
(775, 'Paruro , Paruro , Cusco', 'Cusco', 'Paruro', 'Paruro'),
(776, 'Accha , Paruro , Cusco', 'Cusco', 'Paruro', 'Accha'),
(777, 'Ccapi , Paruro , Cusco', 'Cusco', 'Paruro', 'Ccapi'),
(778, 'Colcha , Paruro , Cusco', 'Cusco', 'Paruro', 'Colcha'),
(779, 'Huanoquite , Paruro , Cusco', 'Cusco', 'Paruro', 'Huanoquite'),
(780, 'Omacha , Paruro , Cusco', 'Cusco', 'Paruro', 'Omacha'),
(781, 'Paccaritambo , Paruro , Cusco', 'Cusco', 'Paruro', 'Paccaritambo'),
(782, 'Pillpinto , Paruro , Cusco', 'Cusco', 'Paruro', 'Pillpinto'),
(783, 'Yaurisque , Paruro , Cusco', 'Cusco', 'Paruro', 'Yaurisque'),
(784, 'Paucartambo , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Paucartambo'),
(785, 'Caicay , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Caicay'),
(786, 'Challabamba , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Challabamba'),
(787, 'Colquepata , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Colquepata'),
(788, 'Huancarani , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Huancarani'),
(789, 'Kosñipata , Paucartambo , Cusco', 'Cusco', 'Paucartambo', 'Kosñipata'),
(790, 'Urcos , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Urcos'),
(791, 'Andahuaylillas , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Andahuaylillas'),
(792, 'Camanti , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Camanti'),
(793, 'Ccarhuayo , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Ccarhuayo'),
(794, 'Ccatca , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Ccatca'),
(795, 'Cusipata , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Cusipata'),
(796, 'Huaro , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Huaro'),
(797, 'Lucre , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Lucre'),
(798, 'Marcapata , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Marcapata'),
(799, 'Ocongate , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Ocongate'),
(800, 'Oropesa , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Oropesa'),
(801, 'Quiquijana , Quispicanchi , Cusco', 'Cusco', 'Quispicanchi', 'Quiquijana'),
(802, 'Urubamba , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Urubamba'),
(803, 'Chinchero , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Chinchero'),
(804, 'Huayllabamba , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Huayllabamba'),
(805, 'Machupicchu , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Machupicchu'),
(806, 'Maras , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Maras'),
(807, 'Ollantaytambo , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Ollantaytambo'),
(808, 'Yucay , Urubamba , Cusco', 'Cusco', 'Urubamba', 'Yucay'),
(809, 'Huancavelica , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Huancavelica'),
(810, 'Acobambilla , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Acobambilla'),
(811, 'Acoria , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Acoria'),
(812, 'Conayca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Conayca'),
(813, 'Cuenca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Cuenca'),
(814, 'Huachocolpa , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Huachocolpa'),
(815, 'Huayllahuara , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Huayllahuara'),
(816, 'Izcuchaca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Izcuchaca'),
(817, 'Laria , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Laria'),
(818, 'Manta , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Manta'),
(819, 'Mariscal Caceres , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Mariscal Caceres'),
(820, 'Moya , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Moya'),
(821, 'Nuevo Occoro , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Nuevo Occoro'),
(822, 'Palca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Palca'),
(823, 'Pilchaca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Pilchaca'),
(824, 'Vilca , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Vilca'),
(825, 'Yauli , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Yauli'),
(826, 'Ascension , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Ascension'),
(827, 'Huando , Huancavelica , Huancavelica', 'Huancavelica', 'Huancavelica', 'Huando'),
(828, 'Acobamba , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Acobamba'),
(829, 'Andabamba , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Andabamba'),
(830, 'Anta , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Anta'),
(831, 'Caja , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Caja'),
(832, 'Marcas , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Marcas'),
(833, 'Paucara , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Paucara'),
(834, 'Pomacocha , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Pomacocha'),
(835, 'Rosario , Acobamba , Huancavelica', 'Huancavelica', 'Acobamba', 'Rosario'),
(836, 'Lircay , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Lircay'),
(837, 'Anchonga , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Anchonga'),
(838, 'Callanmarca , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Callanmarca'),
(839, 'Ccochaccasa , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Ccochaccasa'),
(840, 'Chincho , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Chincho'),
(841, 'Congalla , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Congalla'),
(842, 'Huanca-Huanca , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Huanca-Huanca'),
(843, 'Huayllay Grande , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Huayllay Grande'),
(844, 'Julcamarca , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Julcamarca'),
(845, 'San Antonio de Antaparco , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'San Antonio de Antaparco'),
(846, 'Santo Tomas de Pata , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Santo Tomas de Pata'),
(847, 'Secclla , Angaraes , Huancavelica', 'Huancavelica', 'Angaraes', 'Secclla'),
(848, 'Castrovirreyna , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Castrovirreyna'),
(849, 'Arma , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Arma'),
(850, 'Aurahua , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Aurahua'),
(851, 'Capillas , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Capillas'),
(852, 'Chupamarca , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Chupamarca'),
(853, 'Cocas , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Cocas'),
(854, 'Huachos , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Huachos'),
(855, 'Huamatambo , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Huamatambo'),
(856, 'Mollepampa , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Mollepampa'),
(857, 'San Juan , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'San Juan'),
(858, 'Santa Ana , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Santa Ana'),
(859, 'Tantara , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Tantara'),
(860, 'Ticrapo , Castrovirreyna , Huancavelica', 'Huancavelica', 'Castrovirreyna', 'Ticrapo'),
(861, 'Churcampa , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Churcampa'),
(862, 'Anco , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Anco'),
(863, 'Chinchihuasi , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Chinchihuasi'),
(864, 'El Carmen , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'El Carmen'),
(865, 'La Merced , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'La Merced'),
(866, 'Locroja , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Locroja'),
(867, 'Paucarbamba , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Paucarbamba'),
(868, 'San Miguel de Mayocc , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'San Miguel de Mayocc'),
(869, 'San Pedro de Coris , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'San Pedro de Coris'),
(870, 'Pachamarca , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Pachamarca'),
(871, 'Cosme , Churcampa , Huancavelica', 'Huancavelica', 'Churcampa', 'Cosme'),
(872, 'Huaytara , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Huaytara'),
(873, 'Ayavi , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Ayavi'),
(874, 'Cordova , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Cordova'),
(875, 'Huayacundo Arma , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Huayacundo Arma'),
(876, 'Laramarca , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Laramarca'),
(877, 'Ocoyo , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Ocoyo'),
(878, 'Pilpichaca , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Pilpichaca'),
(879, 'Querco , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Querco'),
(880, 'Quito-Arma , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Quito-Arma'),
(881, 'San Antonio de Cusicancha , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'San Antonio de Cusicancha'),
(882, 'San Francisco de Sangayaico , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'San Francisco de Sangayaico'),
(883, 'San Isidro , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'San Isidro'),
(884, 'Santiago de Chocorvos , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Santiago de Chocorvos'),
(885, 'Santiago de Quirahuara , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Santiago de Quirahuara'),
(886, 'Santo Domingo de Capillas , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Santo Domingo de Capillas'),
(887, 'Tambo , Huaytara , Huancavelica', 'Huancavelica', 'Huaytara', 'Tambo'),
(888, 'Pampas , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Pampas'),
(889, 'Acostambo , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Acostambo'),
(890, 'Acraquia , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Acraquia'),
(891, 'Ahuaycha , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Ahuaycha'),
(892, 'Colcabamba , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Colcabamba'),
(893, 'Daniel Hernandez , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Daniel Hernandez'),
(894, 'Huachocolpa , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Huachocolpa'),
(895, 'Huaribamba , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Huaribamba'),
(896, 'Ñahuimpuquio , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Ñahuimpuquio'),
(897, 'Pazos , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Pazos'),
(898, 'Quishuar , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Quishuar'),
(899, 'Salcabamba , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Salcabamba'),
(900, 'Salcahuasi , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Salcahuasi'),
(901, 'San Marcos de Rocchac , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'San Marcos de Rocchac'),
(902, 'Surcubamba , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Surcubamba'),
(903, 'Tintay Puncu , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Tintay Puncu'),
(904, 'Quichuas , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Quichuas'),
(905, 'Andaymarca , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Andaymarca'),
(906, 'Roble , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Roble'),
(907, 'Pichos , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Pichos'),
(908, 'Santiago de Tucuma , Tayacaja , Huancavelica', 'Huancavelica', 'Tayacaja', 'Santiago de Tucuma'),
(909, 'Huanuco , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Huanuco'),
(910, 'Amarilis , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Amarilis'),
(911, 'Chinchao , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Chinchao'),
(912, 'Churubamba , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Churubamba'),
(913, 'Margos , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Margos'),
(914, 'Quisqui , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Quisqui'),
(915, 'San Francisco de Cayran , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'San Francisco de Cayran'),
(916, 'San Pedro de Chaulan , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'San Pedro de Chaulan'),
(917, 'Santa Maria del Valle , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Santa Maria del Valle'),
(918, 'Yarumayo , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Yarumayo'),
(919, 'Pillco Marca , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Pillco Marca'),
(920, 'Yacus , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'Yacus'),
(921, 'San Pablo de Pillao , Huanuco , Huanuco', 'Huanuco', 'Huanuco', 'San Pablo de Pillao'),
(922, 'Ambo , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Ambo'),
(923, 'Cayna , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Cayna'),
(924, 'Colpas , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Colpas'),
(925, 'Conchamarca , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Conchamarca'),
(926, 'Huacar , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Huacar'),
(927, 'San Francisco , Ambo , Huanuco', 'Huanuco', 'Ambo', 'San Francisco'),
(928, 'San Rafael , Ambo , Huanuco', 'Huanuco', 'Ambo', 'San Rafael'),
(929, 'Tomay Kichwa , Ambo , Huanuco', 'Huanuco', 'Ambo', 'Tomay Kichwa'),
(930, 'La Union , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'La Union'),
(931, 'Chuquis , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Chuquis'),
(932, 'Marias , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Marias'),
(933, 'Pachas , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Pachas'),
(934, 'Quivilla , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Quivilla'),
(935, 'Ripan , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Ripan'),
(936, 'Shunqui , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Shunqui'),
(937, 'Sillapata , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Sillapata'),
(938, 'Yanas , Dos de Mayo , Huanuco', 'Huanuco', 'Dos de Mayo', 'Yanas'),
(939, 'Huacaybamba , Huacaybamba , Huanuco', 'Huanuco', 'Huacaybamba', 'Huacaybamba'),
(940, 'Canchabamba , Huacaybamba , Huanuco', 'Huanuco', 'Huacaybamba', 'Canchabamba'),
(941, 'Cochabamba , Huacaybamba , Huanuco', 'Huanuco', 'Huacaybamba', 'Cochabamba'),
(942, 'Pinra , Huacaybamba , Huanuco', 'Huanuco', 'Huacaybamba', 'Pinra'),
(943, 'Llata , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Llata'),
(944, 'Arancay , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Arancay'),
(945, 'Chavin de Pariarca , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Chavin de Pariarca'),
(946, 'Jacas Grande , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Jacas Grande'),
(947, 'Jircan , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Jircan'),
(948, 'Miraflores , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Miraflores'),
(949, 'Monzon , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Monzon'),
(950, 'Punchao , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Punchao'),
(951, 'Puños , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Puños'),
(952, 'Singa , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Singa'),
(953, 'Tantamayo , Huamalies , Huanuco', 'Huanuco', 'Huamalies', 'Tantamayo'),
(954, 'Rupa-Rupa , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Rupa-Rupa'),
(955, 'Daniel Alomias Robles , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Daniel Alomias Robles'),
(956, 'Hermilio Valdizan , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Hermilio Valdizan'),
(957, 'Jose Crespo y Castillo , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Jose Crespo y Castillo'),
(958, 'Luyando , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Luyando'),
(959, 'Mariano Damaso Beraun , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Mariano Damaso Beraun'),
(960, 'Pucayacu , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Pucayacu'),
(961, 'Castillo Grande , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Castillo Grande'),
(962, 'Pueblo Nuevo , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Pueblo Nuevo'),
(963, 'Santo Domingo de Anda , Leoncio Prado , Huanuco', 'Huanuco', 'Leoncio Prado', 'Santo Domingo de Anda'),
(964, 'Huacrachuco , Marañon , Huanuco', 'Huanuco', 'Marañon', 'Huacrachuco'),
(965, 'Cholon , Marañon , Huanuco', 'Huanuco', 'Marañon', 'Cholon'),
(966, 'San Buenaventura , Marañon , Huanuco', 'Huanuco', 'Marañon', 'San Buenaventura'),
(967, 'La Morada , Marañon , Huanuco', 'Huanuco', 'Marañon', 'La Morada'),
(968, 'Santa Rosa de Alto Yanajanca , Marañon , Huanuco', 'Huanuco', 'Marañon', 'Santa Rosa de Alto Yanajanca'),
(969, 'Panao , Pachitea , Huanuco', 'Huanuco', 'Pachitea', 'Panao'),
(970, 'Chaglla , Pachitea , Huanuco', 'Huanuco', 'Pachitea', 'Chaglla'),
(971, 'Molino , Pachitea , Huanuco', 'Huanuco', 'Pachitea', 'Molino'),
(972, 'Umari , Pachitea , Huanuco', 'Huanuco', 'Pachitea', 'Umari'),
(973, 'Puerto Inca , Puerto Inca , Huanuco', 'Huanuco', 'Puerto Inca', 'Puerto Inca'),
(974, 'Codo del Pozuzo , Puerto Inca , Huanuco', 'Huanuco', 'Puerto Inca', 'Codo del Pozuzo'),
(975, 'Honoria , Puerto Inca , Huanuco', 'Huanuco', 'Puerto Inca', 'Honoria'),
(976, 'Tournavista , Puerto Inca , Huanuco', 'Huanuco', 'Puerto Inca', 'Tournavista'),
(977, 'Yuyapichis , Puerto Inca , Huanuco', 'Huanuco', 'Puerto Inca', 'Yuyapichis'),
(978, 'Jesus , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'Jesus'),
(979, 'Baños , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'Baños'),
(980, 'Jivia , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'Jivia'),
(981, 'Queropalca , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'Queropalca'),
(982, 'Rondos , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'Rondos'),
(983, 'San Francisco de Asis , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'San Francisco de Asis'),
(984, 'San Miguel de Cauri , Lauricocha , Huanuco', 'Huanuco', 'Lauricocha', 'San Miguel de Cauri'),
(985, 'Chavinillo , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Chavinillo'),
(986, 'Cahuac , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Cahuac'),
(987, 'Chacabamba , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Chacabamba'),
(988, 'Aparicio Pomares , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Aparicio Pomares'),
(989, 'Jacas Chico , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Jacas Chico'),
(990, 'Obas , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Obas'),
(991, 'Pampamarca , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Pampamarca'),
(992, 'Choras , Yarowilca , Huanuco', 'Huanuco', 'Yarowilca', 'Choras'),
(993, 'Ica , Ica , Ica', 'Ica', 'Ica', 'Ica'),
(994, 'La Tinguiña , Ica , Ica', 'Ica', 'Ica', 'La Tinguiña'),
(995, 'Los Aquijes , Ica , Ica', 'Ica', 'Ica', 'Los Aquijes'),
(996, 'Ocucaje , Ica , Ica', 'Ica', 'Ica', 'Ocucaje'),
(997, 'Pachacutec , Ica , Ica', 'Ica', 'Ica', 'Pachacutec'),
(998, 'Parcona , Ica , Ica', 'Ica', 'Ica', 'Parcona'),
(999, 'Pueblo Nuevo , Ica , Ica', 'Ica', 'Ica', 'Pueblo Nuevo'),
(1000, 'Salas , Ica , Ica', 'Ica', 'Ica', 'Salas'),
(1001, 'San Jose de los Molinos , Ica , Ica', 'Ica', 'Ica', 'San Jose de los Molinos'),
(1002, 'San Juan Bautista , Ica , Ica', 'Ica', 'Ica', 'San Juan Bautista'),
(1003, 'Santiago , Ica , Ica', 'Ica', 'Ica', 'Santiago'),
(1004, 'Subtanjalla , Ica , Ica', 'Ica', 'Ica', 'Subtanjalla'),
(1005, 'Tate , Ica , Ica', 'Ica', 'Ica', 'Tate'),
(1006, 'Yauca del Rosario , Ica , Ica', 'Ica', 'Ica', 'Yauca del Rosario'),
(1007, 'Chincha Alta , Chincha , Ica', 'Ica', 'Chincha', 'Chincha Alta'),
(1008, 'Alto Laran , Chincha , Ica', 'Ica', 'Chincha', 'Alto Laran'),
(1009, 'Chavin , Chincha , Ica', 'Ica', 'Chincha', 'Chavin'),
(1010, 'Chincha Baja , Chincha , Ica', 'Ica', 'Chincha', 'Chincha Baja'),
(1011, 'El Carmen , Chincha , Ica', 'Ica', 'Chincha', 'El Carmen'),
(1012, 'Grocio Prado , Chincha , Ica', 'Ica', 'Chincha', 'Grocio Prado'),
(1013, 'Pueblo Nuevo , Chincha , Ica', 'Ica', 'Chincha', 'Pueblo Nuevo'),
(1014, 'San Juan de Yanac , Chincha , Ica', 'Ica', 'Chincha', 'San Juan de Yanac'),
(1015, 'San Pedro de Huacarpana , Chincha , Ica', 'Ica', 'Chincha', 'San Pedro de Huacarpana'),
(1016, 'Sunampe , Chincha , Ica', 'Ica', 'Chincha', 'Sunampe'),
(1017, 'Tambo de Mora , Chincha , Ica', 'Ica', 'Chincha', 'Tambo de Mora'),
(1018, 'Nazca , Nazca , Ica', 'Ica', 'Nazca', 'Nazca'),
(1019, 'Changuillo , Nazca , Ica', 'Ica', 'Nazca', 'Changuillo'),
(1020, 'El Ingenio , Nazca , Ica', 'Ica', 'Nazca', 'El Ingenio'),
(1021, 'Marcona , Nazca , Ica', 'Ica', 'Nazca', 'Marcona'),
(1022, 'Vista Alegre , Nazca , Ica', 'Ica', 'Nazca', 'Vista Alegre'),
(1023, 'Palpa , Palpa , Ica', 'Ica', 'Palpa', 'Palpa'),
(1024, 'Llipata , Palpa , Ica', 'Ica', 'Palpa', 'Llipata'),
(1025, 'Rio Grande , Palpa , Ica', 'Ica', 'Palpa', 'Rio Grande'),
(1026, 'Santa Cruz , Palpa , Ica', 'Ica', 'Palpa', 'Santa Cruz'),
(1027, 'Tibillo , Palpa , Ica', 'Ica', 'Palpa', 'Tibillo'),
(1028, 'Pisco , Pisco , Ica', 'Ica', 'Pisco', 'Pisco'),
(1029, 'Huancano , Pisco , Ica', 'Ica', 'Pisco', 'Huancano'),
(1030, 'Humay , Pisco , Ica', 'Ica', 'Pisco', 'Humay'),
(1031, 'Independencia , Pisco , Ica', 'Ica', 'Pisco', 'Independencia'),
(1032, 'Paracas , Pisco , Ica', 'Ica', 'Pisco', 'Paracas'),
(1033, 'San Andres , Pisco , Ica', 'Ica', 'Pisco', 'San Andres'),
(1034, 'San Clemente , Pisco , Ica', 'Ica', 'Pisco', 'San Clemente'),
(1035, 'Tupac Amaru Inca , Pisco , Ica', 'Ica', 'Pisco', 'Tupac Amaru Inca'),
(1036, 'Huancayo , Huancayo , Junin', 'Junin', 'Huancayo', 'Huancayo'),
(1037, 'Carhuacallanga , Huancayo , Junin', 'Junin', 'Huancayo', 'Carhuacallanga'),
(1038, 'Chacapampa , Huancayo , Junin', 'Junin', 'Huancayo', 'Chacapampa'),
(1039, 'Chicche , Huancayo , Junin', 'Junin', 'Huancayo', 'Chicche'),
(1040, 'Chilca , Huancayo , Junin', 'Junin', 'Huancayo', 'Chilca'),
(1041, 'Chongos Alto , Huancayo , Junin', 'Junin', 'Huancayo', 'Chongos Alto'),
(1042, 'Chupuro , Huancayo , Junin', 'Junin', 'Huancayo', 'Chupuro'),
(1043, 'Colca , Huancayo , Junin', 'Junin', 'Huancayo', 'Colca'),
(1044, 'Cullhuas , Huancayo , Junin', 'Junin', 'Huancayo', 'Cullhuas'),
(1045, 'El Tambo , Huancayo , Junin', 'Junin', 'Huancayo', 'El Tambo'),
(1046, 'Huacrapuquio , Huancayo , Junin', 'Junin', 'Huancayo', 'Huacrapuquio'),
(1047, 'Hualhuas , Huancayo , Junin', 'Junin', 'Huancayo', 'Hualhuas'),
(1048, 'Huancan , Huancayo , Junin', 'Junin', 'Huancayo', 'Huancan'),
(1049, 'Huasicancha , Huancayo , Junin', 'Junin', 'Huancayo', 'Huasicancha'),
(1050, 'Huayucachi , Huancayo , Junin', 'Junin', 'Huancayo', 'Huayucachi'),
(1051, 'Ingenio , Huancayo , Junin', 'Junin', 'Huancayo', 'Ingenio'),
(1052, 'Pariahuanca , Huancayo , Junin', 'Junin', 'Huancayo', 'Pariahuanca'),
(1053, 'Pilcomayo , Huancayo , Junin', 'Junin', 'Huancayo', 'Pilcomayo'),
(1054, 'Pucara , Huancayo , Junin', 'Junin', 'Huancayo', 'Pucara'),
(1055, 'Quichuay , Huancayo , Junin', 'Junin', 'Huancayo', 'Quichuay'),
(1056, 'Quilcas , Huancayo , Junin', 'Junin', 'Huancayo', 'Quilcas'),
(1057, 'San Agustin , Huancayo , Junin', 'Junin', 'Huancayo', 'San Agustin'),
(1058, 'San Jeronimo de Tunan , Huancayo , Junin', 'Junin', 'Huancayo', 'San Jeronimo de Tunan'),
(1059, 'Saño , Huancayo , Junin', 'Junin', 'Huancayo', 'Saño'),
(1060, 'Sapallanga , Huancayo , Junin', 'Junin', 'Huancayo', 'Sapallanga'),
(1061, 'Sicaya , Huancayo , Junin', 'Junin', 'Huancayo', 'Sicaya'),
(1062, 'Santo Domingo de Acobamba , Huancayo , Junin', 'Junin', 'Huancayo', 'Santo Domingo de Acobamba'),
(1063, 'Viques , Huancayo , Junin', 'Junin', 'Huancayo', 'Viques'),
(1064, 'Concepcion , Concepcion , Junin', 'Junin', 'Concepcion', 'Concepcion'),
(1065, 'Aco , Concepcion , Junin', 'Junin', 'Concepcion', 'Aco'),
(1066, 'Andamarca , Concepcion , Junin', 'Junin', 'Concepcion', 'Andamarca'),
(1067, 'Chambara , Concepcion , Junin', 'Junin', 'Concepcion', 'Chambara'),
(1068, 'Cochas , Concepcion , Junin', 'Junin', 'Concepcion', 'Cochas'),
(1069, 'Comas , Concepcion , Junin', 'Junin', 'Concepcion', 'Comas'),
(1070, 'Heroinas Toledo , Concepcion , Junin', 'Junin', 'Concepcion', 'Heroinas Toledo'),
(1071, 'Manzanares , Concepcion , Junin', 'Junin', 'Concepcion', 'Manzanares'),
(1072, 'Mariscal Castilla , Concepcion , Junin', 'Junin', 'Concepcion', 'Mariscal Castilla'),
(1073, 'Matahuasi , Concepcion , Junin', 'Junin', 'Concepcion', 'Matahuasi'),
(1074, 'Mito , Concepcion , Junin', 'Junin', 'Concepcion', 'Mito'),
(1075, 'Nueve de Julio , Concepcion , Junin', 'Junin', 'Concepcion', 'Nueve de Julio'),
(1076, 'Orcotuna , Concepcion , Junin', 'Junin', 'Concepcion', 'Orcotuna'),
(1077, 'San Jose de Quero , Concepcion , Junin', 'Junin', 'Concepcion', 'San Jose de Quero'),
(1078, 'Santa Rosa de Ocopa , Concepcion , Junin', 'Junin', 'Concepcion', 'Santa Rosa de Ocopa'),
(1079, 'Chanchamayo , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'Chanchamayo'),
(1080, 'Perene , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'Perene'),
(1081, 'Pichanaqui , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'Pichanaqui'),
(1082, 'San Luis de Shuaro , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'San Luis de Shuaro'),
(1083, 'San Ramon , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'San Ramon'),
(1084, 'Vitoc , Chanchamayo , Junin', 'Junin', 'Chanchamayo', 'Vitoc'),
(1085, 'Jauja , Jauja , Junin', 'Junin', 'Jauja', 'Jauja'),
(1086, 'Acolla , Jauja , Junin', 'Junin', 'Jauja', 'Acolla'),
(1087, 'Apata , Jauja , Junin', 'Junin', 'Jauja', 'Apata'),
(1088, 'Ataura , Jauja , Junin', 'Junin', 'Jauja', 'Ataura'),
(1089, 'Canchayllo , Jauja , Junin', 'Junin', 'Jauja', 'Canchayllo'),
(1090, 'Curicaca , Jauja , Junin', 'Junin', 'Jauja', 'Curicaca'),
(1091, 'El Mantaro , Jauja , Junin', 'Junin', 'Jauja', 'El Mantaro'),
(1092, 'Huamali , Jauja , Junin', 'Junin', 'Jauja', 'Huamali'),
(1093, 'Huaripampa , Jauja , Junin', 'Junin', 'Jauja', 'Huaripampa'),
(1094, 'Huertas , Jauja , Junin', 'Junin', 'Jauja', 'Huertas'),
(1095, 'Janjaillo , Jauja , Junin', 'Junin', 'Jauja', 'Janjaillo'),
(1096, 'Julcan , Jauja , Junin', 'Junin', 'Jauja', 'Julcan'),
(1097, 'Leonor Ordoñez , Jauja , Junin', 'Junin', 'Jauja', 'Leonor Ordoñez'),
(1098, 'Llocllapampa , Jauja , Junin', 'Junin', 'Jauja', 'Llocllapampa'),
(1099, 'Marco , Jauja , Junin', 'Junin', 'Jauja', 'Marco'),
(1100, 'Masma , Jauja , Junin', 'Junin', 'Jauja', 'Masma'),
(1101, 'Masma Chicche , Jauja , Junin', 'Junin', 'Jauja', 'Masma Chicche'),
(1102, 'Molinos , Jauja , Junin', 'Junin', 'Jauja', 'Molinos'),
(1103, 'Monobamba , Jauja , Junin', 'Junin', 'Jauja', 'Monobamba'),
(1104, 'Muqui , Jauja , Junin', 'Junin', 'Jauja', 'Muqui'),
(1105, 'Muquiyauyo , Jauja , Junin', 'Junin', 'Jauja', 'Muquiyauyo'),
(1106, 'Paca , Jauja , Junin', 'Junin', 'Jauja', 'Paca'),
(1107, 'Paccha , Jauja , Junin', 'Junin', 'Jauja', 'Paccha'),
(1108, 'Pancan , Jauja , Junin', 'Junin', 'Jauja', 'Pancan'),
(1109, 'Parco , Jauja , Junin', 'Junin', 'Jauja', 'Parco'),
(1110, 'Pomacancha , Jauja , Junin', 'Junin', 'Jauja', 'Pomacancha'),
(1111, 'Ricran , Jauja , Junin', 'Junin', 'Jauja', 'Ricran'),
(1112, 'San Lorenzo , Jauja , Junin', 'Junin', 'Jauja', 'San Lorenzo'),
(1113, 'San Pedro de Chunan , Jauja , Junin', 'Junin', 'Jauja', 'San Pedro de Chunan'),
(1114, 'Sausa , Jauja , Junin', 'Junin', 'Jauja', 'Sausa'),
(1115, 'Sincos , Jauja , Junin', 'Junin', 'Jauja', 'Sincos'),
(1116, 'Tunan Marca , Jauja , Junin', 'Junin', 'Jauja', 'Tunan Marca'),
(1117, 'Yauli , Jauja , Junin', 'Junin', 'Jauja', 'Yauli'),
(1118, 'Yauyos , Jauja , Junin', 'Junin', 'Jauja', 'Yauyos'),
(1119, 'Junin , Junin , Junin', 'Junin', 'Junin', 'Junin'),
(1120, 'Carhuamayo , Junin , Junin', 'Junin', 'Junin', 'Carhuamayo'),
(1121, 'Ondores , Junin , Junin', 'Junin', 'Junin', 'Ondores'),
(1122, 'Ulcumayo , Junin , Junin', 'Junin', 'Junin', 'Ulcumayo'),
(1123, 'Satipo , Satipo , Junin', 'Junin', 'Satipo', 'Satipo'),
(1124, 'Coviriali , Satipo , Junin', 'Junin', 'Satipo', 'Coviriali'),
(1125, 'Llaylla , Satipo , Junin', 'Junin', 'Satipo', 'Llaylla'),
(1126, 'Mazamari , Satipo , Junin', 'Junin', 'Satipo', 'Mazamari'),
(1127, 'Pampa Hermosa , Satipo , Junin', 'Junin', 'Satipo', 'Pampa Hermosa'),
(1128, 'Pangoa , Satipo , Junin', 'Junin', 'Satipo', 'Pangoa'),
(1129, 'Rio Negro , Satipo , Junin', 'Junin', 'Satipo', 'Rio Negro'),
(1130, 'Rio Tambo , Satipo , Junin', 'Junin', 'Satipo', 'Rio Tambo'),
(1131, 'Vizcatan del Ene , Satipo , Junin', 'Junin', 'Satipo', 'Vizcatan del Ene'),
(1132, 'Tarma , Tarma , Junin', 'Junin', 'Tarma', 'Tarma'),
(1133, 'Acobamba , Tarma , Junin', 'Junin', 'Tarma', 'Acobamba'),
(1134, 'Huaricolca , Tarma , Junin', 'Junin', 'Tarma', 'Huaricolca'),
(1135, 'Huasahuasi , Tarma , Junin', 'Junin', 'Tarma', 'Huasahuasi'),
(1136, 'La Union , Tarma , Junin', 'Junin', 'Tarma', 'La Union'),
(1137, 'Palca , Tarma , Junin', 'Junin', 'Tarma', 'Palca'),
(1138, 'Palcamayo , Tarma , Junin', 'Junin', 'Tarma', 'Palcamayo'),
(1139, 'San Pedro de Cajas , Tarma , Junin', 'Junin', 'Tarma', 'San Pedro de Cajas'),
(1140, 'Tapo , Tarma , Junin', 'Junin', 'Tarma', 'Tapo'),
(1141, 'La Oroya , Yauli , Junin', 'Junin', 'Yauli', 'La Oroya'),
(1142, 'Chacapalpa , Yauli , Junin', 'Junin', 'Yauli', 'Chacapalpa'),
(1143, 'Huay-Huay , Yauli , Junin', 'Junin', 'Yauli', 'Huay-Huay'),
(1144, 'Marcapomacocha , Yauli , Junin', 'Junin', 'Yauli', 'Marcapomacocha'),
(1145, 'Morococha , Yauli , Junin', 'Junin', 'Yauli', 'Morococha'),
(1146, 'Paccha , Yauli , Junin', 'Junin', 'Yauli', 'Paccha'),
(1147, 'Santa Barbara de Carhuacayan , Yauli , Junin', 'Junin', 'Yauli', 'Santa Barbara de Carhuacayan'),
(1148, 'Santa Rosa de Sacco , Yauli , Junin', 'Junin', 'Yauli', 'Santa Rosa de Sacco'),
(1149, 'Suitucancha , Yauli , Junin', 'Junin', 'Yauli', 'Suitucancha'),
(1150, 'Yauli , Yauli , Junin', 'Junin', 'Yauli', 'Yauli'),
(1151, 'Chupaca , Chupaca , Junin', 'Junin', 'Chupaca', 'Chupaca'),
(1152, 'Ahuac , Chupaca , Junin', 'Junin', 'Chupaca', 'Ahuac'),
(1153, 'Chongos Bajo , Chupaca , Junin', 'Junin', 'Chupaca', 'Chongos Bajo'),
(1154, 'Huachac , Chupaca , Junin', 'Junin', 'Chupaca', 'Huachac'),
(1155, 'Huamancaca Chico , Chupaca , Junin', 'Junin', 'Chupaca', 'Huamancaca Chico'),
(1156, 'San Juan de Yscos , Chupaca , Junin', 'Junin', 'Chupaca', 'San Juan de Yscos'),
(1157, 'San Juan de Jarpa , Chupaca , Junin', 'Junin', 'Chupaca', 'San Juan de Jarpa'),
(1158, 'Tres de Diciembre , Chupaca , Junin', 'Junin', 'Chupaca', 'Tres de Diciembre'),
(1159, 'Yanacancha , Chupaca , Junin', 'Junin', 'Chupaca', 'Yanacancha'),
(1160, 'Trujillo , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Trujillo'),
(1161, 'El Porvenir , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'El Porvenir'),
(1162, 'Florencia de Mora , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Florencia de Mora'),
(1163, 'Huanchaco , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Huanchaco'),
(1164, 'La Esperanza , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'La Esperanza'),
(1165, 'Laredo , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Laredo'),
(1166, 'Moche , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Moche'),
(1167, 'Poroto , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Poroto'),
(1168, 'Salaverry , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Salaverry'),
(1169, 'Simbal , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Simbal'),
(1170, 'Victor Larco Herrera , Trujillo , La Libertad', 'La Libertad', 'Trujillo', 'Victor Larco Herrera'),
(1171, 'Ascope , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Ascope'),
(1172, 'Chicama , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Chicama'),
(1173, 'Chocope , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Chocope'),
(1174, 'Magdalena de Cao , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Magdalena de Cao'),
(1175, 'Paijan , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Paijan'),
(1176, 'Razuri , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Razuri'),
(1177, 'Santiago de Cao , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Santiago de Cao'),
(1178, 'Casa Grande , Ascope , La Libertad', 'La Libertad', 'Ascope', 'Casa Grande'),
(1179, 'Bolivar , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Bolivar'),
(1180, 'Bambamarca , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Bambamarca'),
(1181, 'Condormarca , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Condormarca'),
(1182, 'Longotea , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Longotea'),
(1183, 'Uchumarca , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Uchumarca'),
(1184, 'Ucuncha , Bolivar , La Libertad', 'La Libertad', 'Bolivar', 'Ucuncha'),
(1185, 'Chepen , Chepen , La Libertad', 'La Libertad', 'Chepen', 'Chepen'),
(1186, 'Pacanga , Chepen , La Libertad', 'La Libertad', 'Chepen', 'Pacanga'),
(1187, 'Pueblo Nuevo , Chepen , La Libertad', 'La Libertad', 'Chepen', 'Pueblo Nuevo'),
(1188, 'Julcan , Julcan , La Libertad', 'La Libertad', 'Julcan', 'Julcan'),
(1189, 'Calamarca , Julcan , La Libertad', 'La Libertad', 'Julcan', 'Calamarca'),
(1190, 'Carabamba , Julcan , La Libertad', 'La Libertad', 'Julcan', 'Carabamba'),
(1191, 'Huaso , Julcan , La Libertad', 'La Libertad', 'Julcan', 'Huaso'),
(1192, 'Otuzco , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Otuzco'),
(1193, 'Agallpampa , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Agallpampa'),
(1194, 'Charat , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Charat'),
(1195, 'Huaranchal , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Huaranchal'),
(1196, 'La Cuesta , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'La Cuesta'),
(1197, 'Mache , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Mache'),
(1198, 'Paranday , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Paranday'),
(1199, 'Salpo , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Salpo'),
(1200, 'Sinsicap , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Sinsicap'),
(1201, 'Usquil , Otuzco , La Libertad', 'La Libertad', 'Otuzco', 'Usquil'),
(1202, 'San Pedro de Lloc , Pacasmayo , La Libertad', 'La Libertad', 'Pacasmayo', 'San Pedro de Lloc'),
(1203, 'Guadalupe , Pacasmayo , La Libertad', 'La Libertad', 'Pacasmayo', 'Guadalupe'),
(1204, 'Jequetepeque , Pacasmayo , La Libertad', 'La Libertad', 'Pacasmayo', 'Jequetepeque'),
(1205, 'Pacasmayo , Pacasmayo , La Libertad', 'La Libertad', 'Pacasmayo', 'Pacasmayo'),
(1206, 'San Jose , Pacasmayo , La Libertad', 'La Libertad', 'Pacasmayo', 'San Jose'),
(1207, 'Tayabamba , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Tayabamba'),
(1208, 'Buldibuyo , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Buldibuyo'),
(1209, 'Chillia , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Chillia'),
(1210, 'Huancaspata , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Huancaspata'),
(1211, 'Huaylillas , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Huaylillas'),
(1212, 'Huayo , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Huayo'),
(1213, 'Ongon , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Ongon'),
(1214, 'Parcoy , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Parcoy'),
(1215, 'Pataz , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Pataz'),
(1216, 'Pias , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Pias'),
(1217, 'Santiago de Challas , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Santiago de Challas'),
(1218, 'Taurija , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Taurija'),
(1219, 'Urpay , Pataz , La Libertad', 'La Libertad', 'Pataz', 'Urpay'),
(1220, 'Huamachuco , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Huamachuco'),
(1221, 'Chugay , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Chugay'),
(1222, 'Cochorco , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Cochorco'),
(1223, 'Curgos , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Curgos'),
(1224, 'Marcabal , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Marcabal'),
(1225, 'Sanagoran , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Sanagoran'),
(1226, 'Sarin , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Sarin'),
(1227, 'Sartimbamba , Sanchez Carrion , La Libertad', 'La Libertad', 'Sanchez Carrion', 'Sartimbamba'),
(1228, 'Santiago de Chuco , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Santiago de Chuco'),
(1229, 'Angasmarca , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Angasmarca'),
(1230, 'Cachicadan , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Cachicadan'),
(1231, 'Mollebamba , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Mollebamba'),
(1232, 'Mollepata , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Mollepata'),
(1233, 'Quiruvilca , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Quiruvilca'),
(1234, 'Santa Cruz de Chuca , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Santa Cruz de Chuca'),
(1235, 'Sitabamba , Santiago de Chuco , La Libertad', 'La Libertad', 'Santiago de Chuco', 'Sitabamba'),
(1236, 'Cascas , Gran Chimu , La Libertad', 'La Libertad', 'Gran Chimu', 'Cascas'),
(1237, 'Lucma , Gran Chimu , La Libertad', 'La Libertad', 'Gran Chimu', 'Lucma'),
(1238, 'Marmot , Gran Chimu , La Libertad', 'La Libertad', 'Gran Chimu', 'Marmot'),
(1239, 'Sayapullo , Gran Chimu , La Libertad', 'La Libertad', 'Gran Chimu', 'Sayapullo'),
(1240, 'Viru , Viru , La Libertad', 'La Libertad', 'Viru', 'Viru'),
(1241, 'Chao , Viru , La Libertad', 'La Libertad', 'Viru', 'Chao'),
(1242, 'Guadalupito , Viru , La Libertad', 'La Libertad', 'Viru', 'Guadalupito'),
(1243, 'Chiclayo , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Chiclayo'),
(1244, 'Chongoyape , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Chongoyape'),
(1245, 'Eten , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Eten'),
(1246, 'Eten Puerto , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Eten Puerto'),
(1247, 'Jose Leonardo Ortiz , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Jose Leonardo Ortiz'),
(1248, 'La Victoria , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'La Victoria'),
(1249, 'Lagunas , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Lagunas'),
(1250, 'Monsefu , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Monsefu'),
(1251, 'Nueva Arica , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Nueva Arica'),
(1252, 'Oyotun , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Oyotun'),
(1253, 'Picsi , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Picsi'),
(1254, 'Pimentel , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Pimentel'),
(1255, 'Reque , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Reque'),
(1256, 'Santa Rosa , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Santa Rosa'),
(1257, 'Saña , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Saña'),
(1258, 'Cayalti , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Cayalti'),
(1259, 'Patapo , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Patapo'),
(1260, 'Pomalca , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Pomalca'),
(1261, 'Pucala , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Pucala'),
(1262, 'Tuman , Chiclayo , Lambayeque', 'Lambayeque', 'Chiclayo', 'Tuman'),
(1263, 'Ferreñafe , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Ferreñafe'),
(1264, 'Cañaris , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Cañaris'),
(1265, 'Incahuasi , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Incahuasi'),
(1266, 'Manuel Antonio Mesones Muro , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Manuel Antonio Mesones Muro'),
(1267, 'Pitipo , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Pitipo'),
(1268, 'Pueblo Nuevo , Ferreñafe , Lambayeque', 'Lambayeque', 'Ferreñafe', 'Pueblo Nuevo'),
(1269, 'Lambayeque , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Lambayeque'),
(1270, 'Chochope , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Chochope'),
(1271, 'Illimo , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Illimo'),
(1272, 'Jayanca , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Jayanca'),
(1273, 'Mochumi , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Mochumi'),
(1274, 'Morrope , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Morrope'),
(1275, 'Motupe , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Motupe'),
(1276, 'Olmos , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Olmos'),
(1277, 'Pacora , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Pacora'),
(1278, 'Salas , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Salas'),
(1279, 'San Jose , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'San Jose'),
(1280, 'Tucume , Lambayeque , Lambayeque', 'Lambayeque', 'Lambayeque', 'Tucume'),
(1281, 'Lima , Lima , Lima', 'Lima', 'Lima', 'Lima'),
(1282, 'Ancon , Lima , Lima', 'Lima', 'Lima', 'Ancon'),
(1283, 'Ate , Lima , Lima', 'Lima', 'Lima', 'Ate'),
(1284, 'Barranco , Lima , Lima', 'Lima', 'Lima', 'Barranco'),
(1285, 'Breña , Lima , Lima', 'Lima', 'Lima', 'Breña'),
(1286, 'Carabayllo , Lima , Lima', 'Lima', 'Lima', 'Carabayllo'),
(1287, 'Chaclacayo , Lima , Lima', 'Lima', 'Lima', 'Chaclacayo'),
(1288, 'Chorrillos , Lima , Lima', 'Lima', 'Lima', 'Chorrillos'),
(1289, 'Cieneguilla , Lima , Lima', 'Lima', 'Lima', 'Cieneguilla'),
(1290, 'Comas , Lima , Lima', 'Lima', 'Lima', 'Comas'),
(1291, 'El Agustino , Lima , Lima', 'Lima', 'Lima', 'El Agustino'),
(1292, 'Independencia , Lima , Lima', 'Lima', 'Lima', 'Independencia'),
(1293, 'Jesus Maria , Lima , Lima', 'Lima', 'Lima', 'Jesus Maria'),
(1294, 'La Molina , Lima , Lima', 'Lima', 'Lima', 'La Molina'),
(1295, 'La Victoria , Lima , Lima', 'Lima', 'Lima', 'La Victoria'),
(1296, 'Lince , Lima , Lima', 'Lima', 'Lima', 'Lince'),
(1297, 'Los Olivos , Lima , Lima', 'Lima', 'Lima', 'Los Olivos');
INSERT INTO `conf_ubigeo` (`codUbigeo`, `desUbigeo`, `Departamento`, `Provincia`, `Distrito`) VALUES
(1298, 'Lurigancho , Lima , Lima', 'Lima', 'Lima', 'Lurigancho'),
(1299, 'Lurin , Lima , Lima', 'Lima', 'Lima', 'Lurin'),
(1300, 'Magdalena del Mar , Lima , Lima', 'Lima', 'Lima', 'Magdalena del Mar'),
(1301, 'Pueblo Libre , Lima , Lima', 'Lima', 'Lima', 'Pueblo Libre'),
(1302, 'Miraflores , Lima , Lima', 'Lima', 'Lima', 'Miraflores'),
(1303, 'Pachacamac , Lima , Lima', 'Lima', 'Lima', 'Pachacamac'),
(1304, 'Pucusana , Lima , Lima', 'Lima', 'Lima', 'Pucusana'),
(1305, 'Puente Piedra , Lima , Lima', 'Lima', 'Lima', 'Puente Piedra'),
(1306, 'Punta Hermosa , Lima , Lima', 'Lima', 'Lima', 'Punta Hermosa'),
(1307, 'Punta Negra , Lima , Lima', 'Lima', 'Lima', 'Punta Negra'),
(1308, 'Rimac , Lima , Lima', 'Lima', 'Lima', 'Rimac'),
(1309, 'San Bartolo , Lima , Lima', 'Lima', 'Lima', 'San Bartolo'),
(1310, 'San Borja , Lima , Lima', 'Lima', 'Lima', 'San Borja'),
(1311, 'San Isidro , Lima , Lima', 'Lima', 'Lima', 'San Isidro'),
(1312, 'San Juan de Lurigancho , Lima , Lima', 'Lima', 'Lima', 'San Juan de Lurigancho'),
(1313, 'San Juan de Miraflores , Lima , Lima', 'Lima', 'Lima', 'San Juan de Miraflores'),
(1314, 'San Luis , Lima , Lima', 'Lima', 'Lima', 'San Luis'),
(1315, 'San Martin de Porres , Lima , Lima', 'Lima', 'Lima', 'San Martin de Porres'),
(1316, 'San Miguel , Lima , Lima', 'Lima', 'Lima', 'San Miguel'),
(1317, 'Santa Anita , Lima , Lima', 'Lima', 'Lima', 'Santa Anita'),
(1318, 'Santa Maria del Mar , Lima , Lima', 'Lima', 'Lima', 'Santa Maria del Mar'),
(1319, 'Santa Rosa , Lima , Lima', 'Lima', 'Lima', 'Santa Rosa'),
(1320, 'Santiago de Surco , Lima , Lima', 'Lima', 'Lima', 'Santiago de Surco'),
(1321, 'Surquillo , Lima , Lima', 'Lima', 'Lima', 'Surquillo'),
(1322, 'Villa El Salvador , Lima , Lima', 'Lima', 'Lima', 'Villa El Salvador'),
(1323, 'Villa Maria del Triunfo , Lima , Lima', 'Lima', 'Lima', 'Villa Maria del Triunfo'),
(1324, 'Barranca , Barranca , Lima', 'Lima', 'Barranca', 'Barranca'),
(1325, 'Paramonga , Barranca , Lima', 'Lima', 'Barranca', 'Paramonga'),
(1326, 'Pativilca , Barranca , Lima', 'Lima', 'Barranca', 'Pativilca'),
(1327, 'Supe , Barranca , Lima', 'Lima', 'Barranca', 'Supe'),
(1328, 'Supe Puerto , Barranca , Lima', 'Lima', 'Barranca', 'Supe Puerto'),
(1329, 'Cajatambo , Cajatambo , Lima', 'Lima', 'Cajatambo', 'Cajatambo'),
(1330, 'Copa , Cajatambo , Lima', 'Lima', 'Cajatambo', 'Copa'),
(1331, 'Gorgor , Cajatambo , Lima', 'Lima', 'Cajatambo', 'Gorgor'),
(1332, 'Huancapon , Cajatambo , Lima', 'Lima', 'Cajatambo', 'Huancapon'),
(1333, 'Manas , Cajatambo , Lima', 'Lima', 'Cajatambo', 'Manas'),
(1334, 'Canta , Canta , Lima', 'Lima', 'Canta', 'Canta'),
(1335, 'Arahuay , Canta , Lima', 'Lima', 'Canta', 'Arahuay'),
(1336, 'Huamantanga , Canta , Lima', 'Lima', 'Canta', 'Huamantanga'),
(1337, 'Huaros , Canta , Lima', 'Lima', 'Canta', 'Huaros'),
(1338, 'Lachaqui , Canta , Lima', 'Lima', 'Canta', 'Lachaqui'),
(1339, 'San Buenaventura , Canta , Lima', 'Lima', 'Canta', 'San Buenaventura'),
(1340, 'Santa Rosa de Quives , Canta , Lima', 'Lima', 'Canta', 'Santa Rosa de Quives'),
(1341, 'San Vicente de Cañete , Cañete , Lima', 'Lima', 'Cañete', 'San Vicente de Cañete'),
(1342, 'Asia , Cañete , Lima', 'Lima', 'Cañete', 'Asia'),
(1343, 'Calango , Cañete , Lima', 'Lima', 'Cañete', 'Calango'),
(1344, 'Cerro Azul , Cañete , Lima', 'Lima', 'Cañete', 'Cerro Azul'),
(1345, 'Chilca , Cañete , Lima', 'Lima', 'Cañete', 'Chilca'),
(1346, 'Coayllo , Cañete , Lima', 'Lima', 'Cañete', 'Coayllo'),
(1347, 'Imperial , Cañete , Lima', 'Lima', 'Cañete', 'Imperial'),
(1348, 'Lunahuana , Cañete , Lima', 'Lima', 'Cañete', 'Lunahuana'),
(1349, 'Mala , Cañete , Lima', 'Lima', 'Cañete', 'Mala'),
(1350, 'Nuevo Imperial , Cañete , Lima', 'Lima', 'Cañete', 'Nuevo Imperial'),
(1351, 'Pacaran , Cañete , Lima', 'Lima', 'Cañete', 'Pacaran'),
(1352, 'Quilmana , Cañete , Lima', 'Lima', 'Cañete', 'Quilmana'),
(1353, 'San Antonio , Cañete , Lima', 'Lima', 'Cañete', 'San Antonio'),
(1354, 'San Luis , Cañete , Lima', 'Lima', 'Cañete', 'San Luis'),
(1355, 'Santa Cruz de Flores , Cañete , Lima', 'Lima', 'Cañete', 'Santa Cruz de Flores'),
(1356, 'Zuñiga , Cañete , Lima', 'Lima', 'Cañete', 'Zuñiga'),
(1357, 'Huaral , Huaral , Lima', 'Lima', 'Huaral', 'Huaral'),
(1358, 'Atavillos Alto , Huaral , Lima', 'Lima', 'Huaral', 'Atavillos Alto'),
(1359, 'Atavillos Bajo , Huaral , Lima', 'Lima', 'Huaral', 'Atavillos Bajo'),
(1360, 'Aucallama , Huaral , Lima', 'Lima', 'Huaral', 'Aucallama'),
(1361, 'Chancay , Huaral , Lima', 'Lima', 'Huaral', 'Chancay'),
(1362, 'Ihuari , Huaral , Lima', 'Lima', 'Huaral', 'Ihuari'),
(1363, 'Lampian , Huaral , Lima', 'Lima', 'Huaral', 'Lampian'),
(1364, 'Pacaraos , Huaral , Lima', 'Lima', 'Huaral', 'Pacaraos'),
(1365, 'San Miguel de Acos , Huaral , Lima', 'Lima', 'Huaral', 'San Miguel de Acos'),
(1366, 'Santa Cruz de Andamarca , Huaral , Lima', 'Lima', 'Huaral', 'Santa Cruz de Andamarca'),
(1367, 'Sumbilca , Huaral , Lima', 'Lima', 'Huaral', 'Sumbilca'),
(1368, 'Veintisiete de Noviembre , Huaral , Lima', 'Lima', 'Huaral', 'Veintisiete de Noviembre'),
(1369, 'Matucana , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Matucana'),
(1370, 'Antioquia , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Antioquia'),
(1371, 'Callahuanca , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Callahuanca'),
(1372, 'Carampoma , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Carampoma'),
(1373, 'Chicla , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Chicla'),
(1374, 'Cuenca , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Cuenca'),
(1375, 'Huachupampa , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Huachupampa'),
(1376, 'Huanza , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Huanza'),
(1377, 'Huarochiri , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Huarochiri'),
(1378, 'Lahuaytambo , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Lahuaytambo'),
(1379, 'Langa , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Langa'),
(1380, 'Laraos , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Laraos'),
(1381, 'Mariatana , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Mariatana'),
(1382, 'Ricardo Palma , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Ricardo Palma'),
(1383, 'San Andres de Tupicocha , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Andres de Tupicocha'),
(1384, 'San Antonio , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Antonio'),
(1385, 'San Bartolome , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Bartolome'),
(1386, 'San Damian , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Damian'),
(1387, 'San Juan de Iris , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Juan de Iris'),
(1388, 'San Juan de Tantaranche , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Juan de Tantaranche'),
(1389, 'San Lorenzo de Quinti , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Lorenzo de Quinti'),
(1390, 'San Mateo , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Mateo'),
(1391, 'San Mateo de Otao , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Mateo de Otao'),
(1392, 'San Pedro de Casta , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Pedro de Casta'),
(1393, 'San Pedro de Huancayre , Huarochiri , Lima', 'Lima', 'Huarochiri', 'San Pedro de Huancayre'),
(1394, 'Sangallaya , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Sangallaya'),
(1395, 'Santa Cruz de Cocachacra , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Santa Cruz de Cocachacra'),
(1396, 'Santa Eulalia , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Santa Eulalia'),
(1397, 'Santiago de Anchucaya , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Santiago de Anchucaya'),
(1398, 'Santiago de Tuna , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Santiago de Tuna'),
(1399, 'Santo Domingo de los Olleros , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Santo Domingo de los Olleros'),
(1400, 'Surco , Huarochiri , Lima', 'Lima', 'Huarochiri', 'Surco'),
(1401, 'Huacho , Huaura , Lima', 'Lima', 'Huaura', 'Huacho'),
(1402, 'Ambar , Huaura , Lima', 'Lima', 'Huaura', 'Ambar'),
(1403, 'Caleta de Carquin , Huaura , Lima', 'Lima', 'Huaura', 'Caleta de Carquin'),
(1404, 'Checras , Huaura , Lima', 'Lima', 'Huaura', 'Checras'),
(1405, 'Hualmay , Huaura , Lima', 'Lima', 'Huaura', 'Hualmay'),
(1406, 'Huaura , Huaura , Lima', 'Lima', 'Huaura', 'Huaura'),
(1407, 'Leoncio Prado , Huaura , Lima', 'Lima', 'Huaura', 'Leoncio Prado'),
(1408, 'Paccho , Huaura , Lima', 'Lima', 'Huaura', 'Paccho'),
(1409, 'Santa Leonor , Huaura , Lima', 'Lima', 'Huaura', 'Santa Leonor'),
(1410, 'Santa Maria , Huaura , Lima', 'Lima', 'Huaura', 'Santa Maria'),
(1411, 'Sayan , Huaura , Lima', 'Lima', 'Huaura', 'Sayan'),
(1412, 'Vegueta , Huaura , Lima', 'Lima', 'Huaura', 'Vegueta'),
(1413, 'Oyon , Oyon , Lima', 'Lima', 'Oyon', 'Oyon'),
(1414, 'Andajes , Oyon , Lima', 'Lima', 'Oyon', 'Andajes'),
(1415, 'Caujul , Oyon , Lima', 'Lima', 'Oyon', 'Caujul'),
(1416, 'Cochamarca , Oyon , Lima', 'Lima', 'Oyon', 'Cochamarca'),
(1417, 'Navan , Oyon , Lima', 'Lima', 'Oyon', 'Navan'),
(1418, 'Pachangara , Oyon , Lima', 'Lima', 'Oyon', 'Pachangara'),
(1419, 'Yauyos , Yauyos , Lima', 'Lima', 'Yauyos', 'Yauyos'),
(1420, 'Alis , Yauyos , Lima', 'Lima', 'Yauyos', 'Alis'),
(1421, 'Ayauca , Yauyos , Lima', 'Lima', 'Yauyos', 'Ayauca'),
(1422, 'Ayaviri , Yauyos , Lima', 'Lima', 'Yauyos', 'Ayaviri'),
(1423, 'Azangaro , Yauyos , Lima', 'Lima', 'Yauyos', 'Azangaro'),
(1424, 'Cacra , Yauyos , Lima', 'Lima', 'Yauyos', 'Cacra'),
(1425, 'Carania , Yauyos , Lima', 'Lima', 'Yauyos', 'Carania'),
(1426, 'Catahuasi , Yauyos , Lima', 'Lima', 'Yauyos', 'Catahuasi'),
(1427, 'Chocos , Yauyos , Lima', 'Lima', 'Yauyos', 'Chocos'),
(1428, 'Cochas , Yauyos , Lima', 'Lima', 'Yauyos', 'Cochas'),
(1429, 'Colonia , Yauyos , Lima', 'Lima', 'Yauyos', 'Colonia'),
(1430, 'Hongos , Yauyos , Lima', 'Lima', 'Yauyos', 'Hongos'),
(1431, 'Huampara , Yauyos , Lima', 'Lima', 'Yauyos', 'Huampara'),
(1432, 'Huancaya , Yauyos , Lima', 'Lima', 'Yauyos', 'Huancaya'),
(1433, 'Huangascar , Yauyos , Lima', 'Lima', 'Yauyos', 'Huangascar'),
(1434, 'Huantan , Yauyos , Lima', 'Lima', 'Yauyos', 'Huantan'),
(1435, 'Huañec , Yauyos , Lima', 'Lima', 'Yauyos', 'Huañec'),
(1436, 'Laraos , Yauyos , Lima', 'Lima', 'Yauyos', 'Laraos'),
(1437, 'Lincha , Yauyos , Lima', 'Lima', 'Yauyos', 'Lincha'),
(1438, 'Madean , Yauyos , Lima', 'Lima', 'Yauyos', 'Madean'),
(1439, 'Miraflores , Yauyos , Lima', 'Lima', 'Yauyos', 'Miraflores'),
(1440, 'Omas , Yauyos , Lima', 'Lima', 'Yauyos', 'Omas'),
(1441, 'Putinza , Yauyos , Lima', 'Lima', 'Yauyos', 'Putinza'),
(1442, 'Quinches , Yauyos , Lima', 'Lima', 'Yauyos', 'Quinches'),
(1443, 'Quinocay , Yauyos , Lima', 'Lima', 'Yauyos', 'Quinocay'),
(1444, 'San Joaquin , Yauyos , Lima', 'Lima', 'Yauyos', 'San Joaquin'),
(1445, 'San Pedro de Pilas , Yauyos , Lima', 'Lima', 'Yauyos', 'San Pedro de Pilas'),
(1446, 'Tanta , Yauyos , Lima', 'Lima', 'Yauyos', 'Tanta'),
(1447, 'Tauripampa , Yauyos , Lima', 'Lima', 'Yauyos', 'Tauripampa'),
(1448, 'Tomas , Yauyos , Lima', 'Lima', 'Yauyos', 'Tomas'),
(1449, 'Tupe , Yauyos , Lima', 'Lima', 'Yauyos', 'Tupe'),
(1450, 'Viñac , Yauyos , Lima', 'Lima', 'Yauyos', 'Viñac'),
(1451, 'Vitis , Yauyos , Lima', 'Lima', 'Yauyos', 'Vitis'),
(1452, 'Iquitos , Maynas , Loreto', 'Loreto', 'Maynas', 'Iquitos'),
(1453, 'Alto Nanay , Maynas , Loreto', 'Loreto', 'Maynas', 'Alto Nanay'),
(1454, 'Fernando Lores , Maynas , Loreto', 'Loreto', 'Maynas', 'Fernando Lores'),
(1455, 'Indiana , Maynas , Loreto', 'Loreto', 'Maynas', 'Indiana'),
(1456, 'Las Amazonas , Maynas , Loreto', 'Loreto', 'Maynas', 'Las Amazonas'),
(1457, 'Mazan , Maynas , Loreto', 'Loreto', 'Maynas', 'Mazan'),
(1458, 'Napo , Maynas , Loreto', 'Loreto', 'Maynas', 'Napo'),
(1459, 'Punchana , Maynas , Loreto', 'Loreto', 'Maynas', 'Punchana'),
(1460, 'Torres Causana , Maynas , Loreto', 'Loreto', 'Maynas', 'Torres Causana'),
(1461, 'Belen , Maynas , Loreto', 'Loreto', 'Maynas', 'Belen'),
(1462, 'San Juan Bautista , Maynas , Loreto', 'Loreto', 'Maynas', 'San Juan Bautista'),
(1463, 'Yurimaguas , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Yurimaguas'),
(1464, 'Balsapuerto , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Balsapuerto'),
(1465, 'Jeberos , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Jeberos'),
(1466, 'Lagunas , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Lagunas'),
(1467, 'Santa Cruz , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Santa Cruz'),
(1468, 'Teniente Cesar Lopez Rojas , Alto Amazonas , Loreto', 'Loreto', 'Alto Amazonas', 'Teniente Cesar Lopez Rojas'),
(1469, 'Nauta , Loreto , Loreto', 'Loreto', 'Loreto', 'Nauta'),
(1470, 'Parinari , Loreto , Loreto', 'Loreto', 'Loreto', 'Parinari'),
(1471, 'Tigre , Loreto , Loreto', 'Loreto', 'Loreto', 'Tigre'),
(1472, 'Trompeteros , Loreto , Loreto', 'Loreto', 'Loreto', 'Trompeteros'),
(1473, 'Urarinas , Loreto , Loreto', 'Loreto', 'Loreto', 'Urarinas'),
(1474, 'Ramon Castilla , Mariscal Ramon Castilla , Loreto', 'Loreto', 'Mariscal Ramon Castilla', 'Ramon Castilla'),
(1475, 'Pebas , Mariscal Ramon Castilla , Loreto', 'Loreto', 'Mariscal Ramon Castilla', 'Pebas'),
(1476, 'Yavari , Mariscal Ramon Castilla , Loreto', 'Loreto', 'Mariscal Ramon Castilla', 'Yavari'),
(1477, 'San Pablo , Mariscal Ramon Castilla , Loreto', 'Loreto', 'Mariscal Ramon Castilla', 'San Pablo'),
(1478, 'Requena , Requena , Loreto', 'Loreto', 'Requena', 'Requena'),
(1479, 'Alto Tapiche , Requena , Loreto', 'Loreto', 'Requena', 'Alto Tapiche'),
(1480, 'Capelo , Requena , Loreto', 'Loreto', 'Requena', 'Capelo'),
(1481, 'Emilio San Martin , Requena , Loreto', 'Loreto', 'Requena', 'Emilio San Martin'),
(1482, 'Maquia , Requena , Loreto', 'Loreto', 'Requena', 'Maquia'),
(1483, 'Puinahua , Requena , Loreto', 'Loreto', 'Requena', 'Puinahua'),
(1484, 'Saquena , Requena , Loreto', 'Loreto', 'Requena', 'Saquena'),
(1485, 'Soplin , Requena , Loreto', 'Loreto', 'Requena', 'Soplin'),
(1486, 'Tapiche , Requena , Loreto', 'Loreto', 'Requena', 'Tapiche'),
(1487, 'Jenaro Herrera , Requena , Loreto', 'Loreto', 'Requena', 'Jenaro Herrera'),
(1488, 'Yaquerana , Requena , Loreto', 'Loreto', 'Requena', 'Yaquerana'),
(1489, 'Contamana , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Contamana'),
(1490, 'Inahuaya , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Inahuaya'),
(1491, 'Padre Marquez , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Padre Marquez'),
(1492, 'Pampa Hermosa , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Pampa Hermosa'),
(1493, 'Sarayacu , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Sarayacu'),
(1494, 'Vargas Guerra , Ucayali , Loreto', 'Loreto', 'Ucayali', 'Vargas Guerra'),
(1495, 'Barranca , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Barranca'),
(1496, 'Cahuapanas , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Cahuapanas'),
(1497, 'Manseriche , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Manseriche'),
(1498, 'Morona , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Morona'),
(1499, 'Pastaza , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Pastaza'),
(1500, 'Andoas , Datem del Marañon , Loreto', 'Loreto', 'Datem del Marañon', 'Andoas'),
(1501, 'Putumayo , Maynas , Loreto', 'Loreto', 'Maynas', 'Putumayo'),
(1502, 'Rosa Panduro , Maynas , Loreto', 'Loreto', 'Maynas', 'Rosa Panduro'),
(1503, 'Teniente Manuel Clavero , Maynas , Loreto', 'Loreto', 'Maynas', 'Teniente Manuel Clavero'),
(1504, 'Yaguas , Maynas , Loreto', 'Loreto', 'Maynas', 'Yaguas'),
(1505, 'Tambopata , Tambopata , Madre de Dios', 'Madre de Dios', 'Tambopata', 'Tambopata'),
(1506, 'Inambari , Tambopata , Madre de Dios', 'Madre de Dios', 'Tambopata', 'Inambari'),
(1507, 'Las Piedras , Tambopata , Madre de Dios', 'Madre de Dios', 'Tambopata', 'Las Piedras'),
(1508, 'Laberinto , Tambopata , Madre de Dios', 'Madre de Dios', 'Tambopata', 'Laberinto'),
(1509, 'Manu , Manu , Madre de Dios', 'Madre de Dios', 'Manu', 'Manu'),
(1510, 'Fitzcarrald , Manu , Madre de Dios', 'Madre de Dios', 'Manu', 'Fitzcarrald'),
(1511, 'Madre de Dios , Manu , Madre de Dios', 'Madre de Dios', 'Manu', 'Madre de Dios'),
(1512, 'Huepetuhe , Manu , Madre de Dios', 'Madre de Dios', 'Manu', 'Huepetuhe'),
(1513, 'Iñapari , Tahuamanu , Madre de Dios', 'Madre de Dios', 'Tahuamanu', 'Iñapari'),
(1514, 'Iberia , Tahuamanu , Madre de Dios', 'Madre de Dios', 'Tahuamanu', 'Iberia'),
(1515, 'Tahuamanu , Tahuamanu , Madre de Dios', 'Madre de Dios', 'Tahuamanu', 'Tahuamanu'),
(1516, 'Moquegua , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'Moquegua'),
(1517, 'Carumas , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'Carumas'),
(1518, 'Cuchumbaya , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'Cuchumbaya'),
(1519, 'Samegua , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'Samegua'),
(1520, 'San Cristobal , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'San Cristobal'),
(1521, 'Torata , Mariscal Nieto , Moquegua', 'Moquegua', 'Mariscal Nieto', 'Torata'),
(1522, 'Omate , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Omate'),
(1523, 'Chojata , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Chojata'),
(1524, 'Coalaque , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Coalaque'),
(1525, 'Ichuña , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Ichuña'),
(1526, 'La Capilla , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'La Capilla'),
(1527, 'Lloque , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Lloque'),
(1528, 'Matalaque , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Matalaque'),
(1529, 'Puquina , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Puquina'),
(1530, 'Quinistaquillas , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Quinistaquillas'),
(1531, 'Ubinas , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Ubinas'),
(1532, 'Yunga , General Sanchez Cerro , Moquegua', 'Moquegua', 'General Sanchez Cerro', 'Yunga'),
(1533, 'Ilo , Ilo , Moquegua', 'Moquegua', 'Ilo', 'Ilo'),
(1534, 'El Algarrobal , Ilo , Moquegua', 'Moquegua', 'Ilo', 'El Algarrobal'),
(1535, 'Pacocha , Ilo , Moquegua', 'Moquegua', 'Ilo', 'Pacocha'),
(1536, 'Chaupimarca , Pasco , Pasco', 'Pasco', 'Pasco', 'Chaupimarca'),
(1537, 'Huachon , Pasco , Pasco', 'Pasco', 'Pasco', 'Huachon'),
(1538, 'Huariaca , Pasco , Pasco', 'Pasco', 'Pasco', 'Huariaca'),
(1539, 'Huayllay , Pasco , Pasco', 'Pasco', 'Pasco', 'Huayllay'),
(1540, 'Ninacaca , Pasco , Pasco', 'Pasco', 'Pasco', 'Ninacaca'),
(1541, 'Pallanchacra , Pasco , Pasco', 'Pasco', 'Pasco', 'Pallanchacra'),
(1542, 'Paucartambo , Pasco , Pasco', 'Pasco', 'Pasco', 'Paucartambo'),
(1543, 'San Francisco de Asis de Yarusyacan , Pasco , Pasco', 'Pasco', 'Pasco', 'San Francisco de Asis de Yarusyacan'),
(1544, 'Simon Bolivar , Pasco , Pasco', 'Pasco', 'Pasco', 'Simon Bolivar'),
(1545, 'Ticlacayan , Pasco , Pasco', 'Pasco', 'Pasco', 'Ticlacayan'),
(1546, 'Tinyahuarco , Pasco , Pasco', 'Pasco', 'Pasco', 'Tinyahuarco'),
(1547, 'Vicco , Pasco , Pasco', 'Pasco', 'Pasco', 'Vicco'),
(1548, 'Yanacancha , Pasco , Pasco', 'Pasco', 'Pasco', 'Yanacancha'),
(1549, 'Yanahuanca , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Yanahuanca'),
(1550, 'Chacayan , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Chacayan'),
(1551, 'Goyllarisquizga , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Goyllarisquizga'),
(1552, 'Paucar , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Paucar'),
(1553, 'San Pedro de Pillao , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'San Pedro de Pillao'),
(1554, 'Santa Ana de Tusi , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Santa Ana de Tusi'),
(1555, 'Tapuc , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Tapuc'),
(1556, 'Vilcabamba , Daniel Alcides Carrion , Pasco', 'Pasco', 'Daniel Alcides Carrion', 'Vilcabamba'),
(1557, 'Oxapampa , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Oxapampa'),
(1558, 'Chontabamba , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Chontabamba'),
(1559, 'Huancabamba , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Huancabamba'),
(1560, 'Palcazu , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Palcazu'),
(1561, 'Pozuzo , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Pozuzo'),
(1562, 'Puerto Bermudez , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Puerto Bermudez'),
(1563, 'Villa Rica , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Villa Rica'),
(1564, 'Constitucion , Oxapampa , Pasco', 'Pasco', 'Oxapampa', 'Constitucion'),
(1565, 'Piura , Piura , Piura', 'Piura', 'Piura', 'Piura'),
(1566, 'Castilla , Piura , Piura', 'Piura', 'Piura', 'Castilla'),
(1567, 'Catacaos , Piura , Piura', 'Piura', 'Piura', 'Catacaos'),
(1568, 'Cura Mori , Piura , Piura', 'Piura', 'Piura', 'Cura Mori'),
(1569, 'El Tallan , Piura , Piura', 'Piura', 'Piura', 'El Tallan'),
(1570, 'La Arena , Piura , Piura', 'Piura', 'Piura', 'La Arena'),
(1571, 'La Union , Piura , Piura', 'Piura', 'Piura', 'La Union'),
(1572, 'Las Lomas , Piura , Piura', 'Piura', 'Piura', 'Las Lomas'),
(1573, 'Tambo Grande , Piura , Piura', 'Piura', 'Piura', 'Tambo Grande'),
(1574, '26 de Octubre , Piura , Piura', 'Piura', 'Piura', '26 de Octubre'),
(1575, 'Ayabaca , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Ayabaca'),
(1576, 'Frias , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Frias'),
(1577, 'Jilili , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Jilili'),
(1578, 'Lagunas , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Lagunas'),
(1579, 'Montero , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Montero'),
(1580, 'Pacaipampa , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Pacaipampa'),
(1581, 'Paimas , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Paimas'),
(1582, 'Sapillica , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Sapillica'),
(1583, 'Sicchez , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Sicchez'),
(1584, 'Suyo , Ayabaca , Piura', 'Piura', 'Ayabaca', 'Suyo'),
(1585, 'Huancabamba , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Huancabamba'),
(1586, 'Canchaque , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Canchaque'),
(1587, 'El Carmen de La Frontera , Huancabamba , Piura', 'Piura', 'Huancabamba', 'El Carmen de La Frontera'),
(1588, 'Huarmaca , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Huarmaca'),
(1589, 'Lalaquiz , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Lalaquiz'),
(1590, 'San Miguel de El Faique , Huancabamba , Piura', 'Piura', 'Huancabamba', 'San Miguel de El Faique'),
(1591, 'Sondor , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Sondor'),
(1592, 'Sondorillo , Huancabamba , Piura', 'Piura', 'Huancabamba', 'Sondorillo'),
(1593, 'Chulucanas , Morropon , Piura', 'Piura', 'Morropon', 'Chulucanas'),
(1594, 'Buenos Aires , Morropon , Piura', 'Piura', 'Morropon', 'Buenos Aires'),
(1595, 'Chalaco , Morropon , Piura', 'Piura', 'Morropon', 'Chalaco'),
(1596, 'La Matanza , Morropon , Piura', 'Piura', 'Morropon', 'La Matanza'),
(1597, 'Morropon , Morropon , Piura', 'Piura', 'Morropon', 'Morropon'),
(1598, 'Salitral , Morropon , Piura', 'Piura', 'Morropon', 'Salitral'),
(1599, 'San Juan de Bigote , Morropon , Piura', 'Piura', 'Morropon', 'San Juan de Bigote'),
(1600, 'Santa Catalina de Mossa , Morropon , Piura', 'Piura', 'Morropon', 'Santa Catalina de Mossa'),
(1601, 'Santo Domingo , Morropon , Piura', 'Piura', 'Morropon', 'Santo Domingo'),
(1602, 'Yamango , Morropon , Piura', 'Piura', 'Morropon', 'Yamango'),
(1603, 'Paita , Paita , Piura', 'Piura', 'Paita', 'Paita'),
(1604, 'Amotape , Paita , Piura', 'Piura', 'Paita', 'Amotape'),
(1605, 'Arenal , Paita , Piura', 'Piura', 'Paita', 'Arenal'),
(1606, 'Colan , Paita , Piura', 'Piura', 'Paita', 'Colan'),
(1607, 'La Huaca , Paita , Piura', 'Piura', 'Paita', 'La Huaca'),
(1608, 'Tamarindo , Paita , Piura', 'Piura', 'Paita', 'Tamarindo'),
(1609, 'Vichayal , Paita , Piura', 'Piura', 'Paita', 'Vichayal'),
(1610, 'Sullana , Sullana , Piura', 'Piura', 'Sullana', 'Sullana'),
(1611, 'Bellavista , Sullana , Piura', 'Piura', 'Sullana', 'Bellavista'),
(1612, 'Ignacio Escudero , Sullana , Piura', 'Piura', 'Sullana', 'Ignacio Escudero'),
(1613, 'Lancones , Sullana , Piura', 'Piura', 'Sullana', 'Lancones'),
(1614, 'Marcavelica , Sullana , Piura', 'Piura', 'Sullana', 'Marcavelica'),
(1615, 'Miguel Checa , Sullana , Piura', 'Piura', 'Sullana', 'Miguel Checa'),
(1616, 'Querecotillo , Sullana , Piura', 'Piura', 'Sullana', 'Querecotillo'),
(1617, 'Salitral , Sullana , Piura', 'Piura', 'Sullana', 'Salitral'),
(1618, 'Pariñas , Talara , Piura', 'Piura', 'Talara', 'Pariñas'),
(1619, 'El Alto , Talara , Piura', 'Piura', 'Talara', 'El Alto'),
(1620, 'La Brea , Talara , Piura', 'Piura', 'Talara', 'La Brea'),
(1621, 'Lobitos , Talara , Piura', 'Piura', 'Talara', 'Lobitos'),
(1622, 'Los Organos , Talara , Piura', 'Piura', 'Talara', 'Los Organos'),
(1623, 'Mancora , Talara , Piura', 'Piura', 'Talara', 'Mancora'),
(1624, 'Sechura , Sechura , Piura', 'Piura', 'Sechura', 'Sechura'),
(1625, 'Bellavista de La Union , Sechura , Piura', 'Piura', 'Sechura', 'Bellavista de La Union'),
(1626, 'Bernal , Sechura , Piura', 'Piura', 'Sechura', 'Bernal'),
(1627, 'Cristo Nos Valga , Sechura , Piura', 'Piura', 'Sechura', 'Cristo Nos Valga'),
(1628, 'Vice , Sechura , Piura', 'Piura', 'Sechura', 'Vice'),
(1629, 'Rinconada Llicuar , Sechura , Piura', 'Piura', 'Sechura', 'Rinconada Llicuar'),
(1630, 'Puno , Puno , Puno', 'Puno', 'Puno', 'Puno'),
(1631, 'Acora , Puno , Puno', 'Puno', 'Puno', 'Acora'),
(1632, 'Amantani , Puno , Puno', 'Puno', 'Puno', 'Amantani'),
(1633, 'Atuncolla , Puno , Puno', 'Puno', 'Puno', 'Atuncolla'),
(1634, 'Capachica , Puno , Puno', 'Puno', 'Puno', 'Capachica'),
(1635, 'Chucuito , Puno , Puno', 'Puno', 'Puno', 'Chucuito'),
(1636, 'Coata , Puno , Puno', 'Puno', 'Puno', 'Coata'),
(1637, 'Huata , Puno , Puno', 'Puno', 'Puno', 'Huata'),
(1638, 'Mañazo , Puno , Puno', 'Puno', 'Puno', 'Mañazo'),
(1639, 'Paucarcolla , Puno , Puno', 'Puno', 'Puno', 'Paucarcolla'),
(1640, 'Pichacani , Puno , Puno', 'Puno', 'Puno', 'Pichacani'),
(1641, 'Plateria , Puno , Puno', 'Puno', 'Puno', 'Plateria'),
(1642, 'San Antonio , Puno , Puno', 'Puno', 'Puno', 'San Antonio'),
(1643, 'Tiquillaca , Puno , Puno', 'Puno', 'Puno', 'Tiquillaca'),
(1644, 'Vilque , Puno , Puno', 'Puno', 'Puno', 'Vilque'),
(1645, 'Azangaro , Azangaro , Puno', 'Puno', 'Azangaro', 'Azangaro'),
(1646, 'Achaya , Azangaro , Puno', 'Puno', 'Azangaro', 'Achaya'),
(1647, 'Arapa , Azangaro , Puno', 'Puno', 'Azangaro', 'Arapa'),
(1648, 'Asillo , Azangaro , Puno', 'Puno', 'Azangaro', 'Asillo'),
(1649, 'Caminaca , Azangaro , Puno', 'Puno', 'Azangaro', 'Caminaca'),
(1650, 'Chupa , Azangaro , Puno', 'Puno', 'Azangaro', 'Chupa'),
(1651, 'Jose Domingo Choquehuanca , Azangaro , Puno', 'Puno', 'Azangaro', 'Jose Domingo Choquehuanca'),
(1652, 'Muñani , Azangaro , Puno', 'Puno', 'Azangaro', 'Muñani'),
(1653, 'Potoni , Azangaro , Puno', 'Puno', 'Azangaro', 'Potoni'),
(1654, 'Saman , Azangaro , Puno', 'Puno', 'Azangaro', 'Saman'),
(1655, 'San Anton , Azangaro , Puno', 'Puno', 'Azangaro', 'San Anton'),
(1656, 'San Jose , Azangaro , Puno', 'Puno', 'Azangaro', 'San Jose'),
(1657, 'San Juan de Salinas , Azangaro , Puno', 'Puno', 'Azangaro', 'San Juan de Salinas'),
(1658, 'Santiago de Pupuja , Azangaro , Puno', 'Puno', 'Azangaro', 'Santiago de Pupuja'),
(1659, 'Tirapata , Azangaro , Puno', 'Puno', 'Azangaro', 'Tirapata'),
(1660, 'Macusani , Carabaya , Puno', 'Puno', 'Carabaya', 'Macusani'),
(1661, 'Ajoyani , Carabaya , Puno', 'Puno', 'Carabaya', 'Ajoyani'),
(1662, 'Ayapata , Carabaya , Puno', 'Puno', 'Carabaya', 'Ayapata'),
(1663, 'Coasa , Carabaya , Puno', 'Puno', 'Carabaya', 'Coasa'),
(1664, 'Corani , Carabaya , Puno', 'Puno', 'Carabaya', 'Corani'),
(1665, 'Crucero , Carabaya , Puno', 'Puno', 'Carabaya', 'Crucero'),
(1666, 'Ituata , Carabaya , Puno', 'Puno', 'Carabaya', 'Ituata'),
(1667, 'Ollachea , Carabaya , Puno', 'Puno', 'Carabaya', 'Ollachea'),
(1668, 'San Gaban , Carabaya , Puno', 'Puno', 'Carabaya', 'San Gaban'),
(1669, 'Usicayos , Carabaya , Puno', 'Puno', 'Carabaya', 'Usicayos'),
(1670, 'Juli , Chucuito , Puno', 'Puno', 'Chucuito', 'Juli'),
(1671, 'Desaguadero , Chucuito , Puno', 'Puno', 'Chucuito', 'Desaguadero'),
(1672, 'Huacullani , Chucuito , Puno', 'Puno', 'Chucuito', 'Huacullani'),
(1673, 'Kelluyo , Chucuito , Puno', 'Puno', 'Chucuito', 'Kelluyo'),
(1674, 'Pisacoma , Chucuito , Puno', 'Puno', 'Chucuito', 'Pisacoma'),
(1675, 'Pomata , Chucuito , Puno', 'Puno', 'Chucuito', 'Pomata'),
(1676, 'Zepita , Chucuito , Puno', 'Puno', 'Chucuito', 'Zepita'),
(1677, 'Ilave , El Collao , Puno', 'Puno', 'El Collao', 'Ilave'),
(1678, 'Capazo , El Collao , Puno', 'Puno', 'El Collao', 'Capazo'),
(1679, 'Pilcuyo , El Collao , Puno', 'Puno', 'El Collao', 'Pilcuyo'),
(1680, 'Santa Rosa , El Collao , Puno', 'Puno', 'El Collao', 'Santa Rosa'),
(1681, 'Conduriri , El Collao , Puno', 'Puno', 'El Collao', 'Conduriri'),
(1682, 'Huancane , Huancane , Puno', 'Puno', 'Huancane', 'Huancane'),
(1683, 'Cojata , Huancane , Puno', 'Puno', 'Huancane', 'Cojata'),
(1684, 'Huatasani , Huancane , Puno', 'Puno', 'Huancane', 'Huatasani'),
(1685, 'Inchupalla , Huancane , Puno', 'Puno', 'Huancane', 'Inchupalla'),
(1686, 'Pusi , Huancane , Puno', 'Puno', 'Huancane', 'Pusi'),
(1687, 'Rosaspata , Huancane , Puno', 'Puno', 'Huancane', 'Rosaspata'),
(1688, 'Taraco , Huancane , Puno', 'Puno', 'Huancane', 'Taraco'),
(1689, 'Vilque Chico , Huancane , Puno', 'Puno', 'Huancane', 'Vilque Chico'),
(1690, 'Lampa , Lampa , Puno', 'Puno', 'Lampa', 'Lampa'),
(1691, 'Cabanilla , Lampa , Puno', 'Puno', 'Lampa', 'Cabanilla'),
(1692, 'Calapuja , Lampa , Puno', 'Puno', 'Lampa', 'Calapuja'),
(1693, 'Nicasio , Lampa , Puno', 'Puno', 'Lampa', 'Nicasio'),
(1694, 'Ocuviri , Lampa , Puno', 'Puno', 'Lampa', 'Ocuviri'),
(1695, 'Palca , Lampa , Puno', 'Puno', 'Lampa', 'Palca'),
(1696, 'Paratia , Lampa , Puno', 'Puno', 'Lampa', 'Paratia'),
(1697, 'Pucara , Lampa , Puno', 'Puno', 'Lampa', 'Pucara'),
(1698, 'Santa Lucia , Lampa , Puno', 'Puno', 'Lampa', 'Santa Lucia'),
(1699, 'Vilavila , Lampa , Puno', 'Puno', 'Lampa', 'Vilavila'),
(1700, 'Ayaviri , Melgar , Puno', 'Puno', 'Melgar', 'Ayaviri'),
(1701, 'Antauta , Melgar , Puno', 'Puno', 'Melgar', 'Antauta'),
(1702, 'Cupi , Melgar , Puno', 'Puno', 'Melgar', 'Cupi'),
(1703, 'Llalli , Melgar , Puno', 'Puno', 'Melgar', 'Llalli'),
(1704, 'Macari , Melgar , Puno', 'Puno', 'Melgar', 'Macari'),
(1705, 'Nuñoa , Melgar , Puno', 'Puno', 'Melgar', 'Nuñoa'),
(1706, 'Orurillo , Melgar , Puno', 'Puno', 'Melgar', 'Orurillo'),
(1707, 'Santa Rosa , Melgar , Puno', 'Puno', 'Melgar', 'Santa Rosa'),
(1708, 'Umachiri , Melgar , Puno', 'Puno', 'Melgar', 'Umachiri'),
(1709, 'Moho , Moho , Puno', 'Puno', 'Moho', 'Moho'),
(1710, 'Conima , Moho , Puno', 'Puno', 'Moho', 'Conima'),
(1711, 'Huayrapata , Moho , Puno', 'Puno', 'Moho', 'Huayrapata'),
(1712, 'Tilali , Moho , Puno', 'Puno', 'Moho', 'Tilali'),
(1713, 'Putina , San Antonio de Putina , Puno', 'Puno', 'San Antonio de Putina', 'Putina'),
(1714, 'Ananea , San Antonio de Putina , Puno', 'Puno', 'San Antonio de Putina', 'Ananea'),
(1715, 'Pedro Vilca Apaza , San Antonio de Putina , Puno', 'Puno', 'San Antonio de Putina', 'Pedro Vilca Apaza'),
(1716, 'Quilcapuncu , San Antonio de Putina , Puno', 'Puno', 'San Antonio de Putina', 'Quilcapuncu'),
(1717, 'Sina , San Antonio de Putina , Puno', 'Puno', 'San Antonio de Putina', 'Sina'),
(1718, 'Juliaca , San Roman , Puno', 'Puno', 'San Roman', 'Juliaca'),
(1719, 'Cabana , San Roman , Puno', 'Puno', 'San Roman', 'Cabana'),
(1720, 'Cabanillas , San Roman , Puno', 'Puno', 'San Roman', 'Cabanillas'),
(1721, 'Caracoto , San Roman , Puno', 'Puno', 'San Roman', 'Caracoto'),
(1722, 'San Miguel , San Roman , Puno', 'Puno', 'San Roman', 'San Miguel'),
(1723, 'Sandia , Sandia , Puno', 'Puno', 'Sandia', 'Sandia'),
(1724, 'Cuyocuyo , Sandia , Puno', 'Puno', 'Sandia', 'Cuyocuyo'),
(1725, 'Limbani , Sandia , Puno', 'Puno', 'Sandia', 'Limbani'),
(1726, 'Patambuco , Sandia , Puno', 'Puno', 'Sandia', 'Patambuco'),
(1727, 'Phara , Sandia , Puno', 'Puno', 'Sandia', 'Phara'),
(1728, 'Quiaca , Sandia , Puno', 'Puno', 'Sandia', 'Quiaca'),
(1729, 'San Juan del Oro , Sandia , Puno', 'Puno', 'Sandia', 'San Juan del Oro'),
(1730, 'Yanahuaya , Sandia , Puno', 'Puno', 'Sandia', 'Yanahuaya'),
(1731, 'Alto Inambari , Sandia , Puno', 'Puno', 'Sandia', 'Alto Inambari'),
(1732, 'San Pedro de Putina Punco , Sandia , Puno', 'Puno', 'Sandia', 'San Pedro de Putina Punco'),
(1733, 'Yunguyo , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Yunguyo'),
(1734, 'Anapia , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Anapia'),
(1735, 'Copani , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Copani'),
(1736, 'Cuturapi , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Cuturapi'),
(1737, 'Ollaraya , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Ollaraya'),
(1738, 'Tinicachi , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Tinicachi'),
(1739, 'Unicachi , Yunguyo , Puno', 'Puno', 'Yunguyo', 'Unicachi'),
(1740, 'Moyobamba , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Moyobamba'),
(1741, 'Calzada , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Calzada'),
(1742, 'Habana , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Habana'),
(1743, 'Jepelacio , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Jepelacio'),
(1744, 'Soritor , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Soritor'),
(1745, 'Yantalo , Moyobamba , San Martin', 'San Martin', 'Moyobamba', 'Yantalo'),
(1746, 'Bellavista , Bellavista , San Martin', 'San Martin', 'Bellavista', 'Bellavista'),
(1747, 'Alto Biavo , Bellavista , San Martin', 'San Martin', 'Bellavista', 'Alto Biavo'),
(1748, 'Bajo Biavo , Bellavista , San Martin', 'San Martin', 'Bellavista', 'Bajo Biavo'),
(1749, 'Huallaga , Bellavista , San Martin', 'San Martin', 'Bellavista', 'Huallaga'),
(1750, 'San Pablo , Bellavista , San Martin', 'San Martin', 'Bellavista', 'San Pablo'),
(1751, 'San Rafael , Bellavista , San Martin', 'San Martin', 'Bellavista', 'San Rafael'),
(1752, 'San Jose de Sisa , El Dorado , San Martin', 'San Martin', 'El Dorado', 'San Jose de Sisa'),
(1753, 'Agua Blanca , El Dorado , San Martin', 'San Martin', 'El Dorado', 'Agua Blanca'),
(1754, 'San Martin , El Dorado , San Martin', 'San Martin', 'El Dorado', 'San Martin'),
(1755, 'Santa Rosa , El Dorado , San Martin', 'San Martin', 'El Dorado', 'Santa Rosa'),
(1756, 'Shatoja , El Dorado , San Martin', 'San Martin', 'El Dorado', 'Shatoja'),
(1757, 'Saposoa , Huallaga , San Martin', 'San Martin', 'Huallaga', 'Saposoa'),
(1758, 'Alto Saposoa , Huallaga , San Martin', 'San Martin', 'Huallaga', 'Alto Saposoa'),
(1759, 'El Eslabon , Huallaga , San Martin', 'San Martin', 'Huallaga', 'El Eslabon'),
(1760, 'Piscoyacu , Huallaga , San Martin', 'San Martin', 'Huallaga', 'Piscoyacu'),
(1761, 'Sacanche , Huallaga , San Martin', 'San Martin', 'Huallaga', 'Sacanche'),
(1762, 'Tingo de Saposoa , Huallaga , San Martin', 'San Martin', 'Huallaga', 'Tingo de Saposoa'),
(1763, 'Lamas , Lamas , San Martin', 'San Martin', 'Lamas', 'Lamas'),
(1764, 'Alonso de Alvarado , Lamas , San Martin', 'San Martin', 'Lamas', 'Alonso de Alvarado'),
(1765, 'Barranquita , Lamas , San Martin', 'San Martin', 'Lamas', 'Barranquita'),
(1766, 'Caynarachi , Lamas , San Martin', 'San Martin', 'Lamas', 'Caynarachi'),
(1767, 'Cuñumbuqui , Lamas , San Martin', 'San Martin', 'Lamas', 'Cuñumbuqui'),
(1768, 'Pinto Recodo , Lamas , San Martin', 'San Martin', 'Lamas', 'Pinto Recodo'),
(1769, 'Rumisapa , Lamas , San Martin', 'San Martin', 'Lamas', 'Rumisapa'),
(1770, 'San Roque de Cumbaza , Lamas , San Martin', 'San Martin', 'Lamas', 'San Roque de Cumbaza'),
(1771, 'Shanao , Lamas , San Martin', 'San Martin', 'Lamas', 'Shanao'),
(1772, 'Tabalosos , Lamas , San Martin', 'San Martin', 'Lamas', 'Tabalosos'),
(1773, 'Zapatero , Lamas , San Martin', 'San Martin', 'Lamas', 'Zapatero'),
(1774, 'Juanjui , Mariscal Caceres , San Martin', 'San Martin', 'Mariscal Caceres', 'Juanjui'),
(1775, 'Campanilla , Mariscal Caceres , San Martin', 'San Martin', 'Mariscal Caceres', 'Campanilla'),
(1776, 'Huicungo , Mariscal Caceres , San Martin', 'San Martin', 'Mariscal Caceres', 'Huicungo'),
(1777, 'Pachiza , Mariscal Caceres , San Martin', 'San Martin', 'Mariscal Caceres', 'Pachiza'),
(1778, 'Pajarillo , Mariscal Caceres , San Martin', 'San Martin', 'Mariscal Caceres', 'Pajarillo'),
(1779, 'Picota , Picota , San Martin', 'San Martin', 'Picota', 'Picota'),
(1780, 'Buenos Aires , Picota , San Martin', 'San Martin', 'Picota', 'Buenos Aires'),
(1781, 'Caspisapa , Picota , San Martin', 'San Martin', 'Picota', 'Caspisapa'),
(1782, 'Pilluana , Picota , San Martin', 'San Martin', 'Picota', 'Pilluana'),
(1783, 'Pucacaca , Picota , San Martin', 'San Martin', 'Picota', 'Pucacaca'),
(1784, 'San Cristobal , Picota , San Martin', 'San Martin', 'Picota', 'San Cristobal'),
(1785, 'San Hilarion , Picota , San Martin', 'San Martin', 'Picota', 'San Hilarion'),
(1786, 'Shamboyacu , Picota , San Martin', 'San Martin', 'Picota', 'Shamboyacu'),
(1787, 'Tingo de Ponasa , Picota , San Martin', 'San Martin', 'Picota', 'Tingo de Ponasa'),
(1788, 'Tres Unidos , Picota , San Martin', 'San Martin', 'Picota', 'Tres Unidos'),
(1789, 'Rioja , Rioja , San Martin', 'San Martin', 'Rioja', 'Rioja'),
(1790, 'Awajun , Rioja , San Martin', 'San Martin', 'Rioja', 'Awajun'),
(1791, 'Elias Soplin Vargas , Rioja , San Martin', 'San Martin', 'Rioja', 'Elias Soplin Vargas'),
(1792, 'Nueva Cajamarca , Rioja , San Martin', 'San Martin', 'Rioja', 'Nueva Cajamarca'),
(1793, 'Pardo Miguel , Rioja , San Martin', 'San Martin', 'Rioja', 'Pardo Miguel'),
(1794, 'Posic , Rioja , San Martin', 'San Martin', 'Rioja', 'Posic'),
(1795, 'San Fernando , Rioja , San Martin', 'San Martin', 'Rioja', 'San Fernando'),
(1796, 'Yorongos , Rioja , San Martin', 'San Martin', 'Rioja', 'Yorongos'),
(1797, 'Yuracyacu , Rioja , San Martin', 'San Martin', 'Rioja', 'Yuracyacu'),
(1798, 'Tarapoto , San Martin , San Martin', 'San Martin', 'San Martin', 'Tarapoto'),
(1799, 'Alberto Leveau , San Martin , San Martin', 'San Martin', 'San Martin', 'Alberto Leveau'),
(1800, 'Cacatachi , San Martin , San Martin', 'San Martin', 'San Martin', 'Cacatachi'),
(1801, 'Chazuta , San Martin , San Martin', 'San Martin', 'San Martin', 'Chazuta'),
(1802, 'Chipurana , San Martin , San Martin', 'San Martin', 'San Martin', 'Chipurana'),
(1803, 'El Porvenir , San Martin , San Martin', 'San Martin', 'San Martin', 'El Porvenir'),
(1804, 'Huimbayoc , San Martin , San Martin', 'San Martin', 'San Martin', 'Huimbayoc'),
(1805, 'Juan Guerra , San Martin , San Martin', 'San Martin', 'San Martin', 'Juan Guerra'),
(1806, 'La Banda de Shilcayo , San Martin , San Martin', 'San Martin', 'San Martin', 'La Banda de Shilcayo'),
(1807, 'Morales , San Martin , San Martin', 'San Martin', 'San Martin', 'Morales'),
(1808, 'Papaplaya , San Martin , San Martin', 'San Martin', 'San Martin', 'Papaplaya'),
(1809, 'San Antonio , San Martin , San Martin', 'San Martin', 'San Martin', 'San Antonio'),
(1810, 'Sauce , San Martin , San Martin', 'San Martin', 'San Martin', 'Sauce'),
(1811, 'Shapaja , San Martin , San Martin', 'San Martin', 'San Martin', 'Shapaja'),
(1812, 'Tocache , Tocache , San Martin', 'San Martin', 'Tocache', 'Tocache'),
(1813, 'Nuevo Progreso , Tocache , San Martin', 'San Martin', 'Tocache', 'Nuevo Progreso'),
(1814, 'Polvora , Tocache , San Martin', 'San Martin', 'Tocache', 'Polvora'),
(1815, 'Shunte , Tocache , San Martin', 'San Martin', 'Tocache', 'Shunte'),
(1816, 'Uchiza , Tocache , San Martin', 'San Martin', 'Tocache', 'Uchiza'),
(1817, 'Tacna , Tacna , Tacna', 'Tacna', 'Tacna', 'Tacna'),
(1818, 'Alto de La Alianza , Tacna , Tacna', 'Tacna', 'Tacna', 'Alto de La Alianza'),
(1819, 'Calana , Tacna , Tacna', 'Tacna', 'Tacna', 'Calana'),
(1820, 'Ciudad Nueva , Tacna , Tacna', 'Tacna', 'Tacna', 'Ciudad Nueva'),
(1821, 'Inclan , Tacna , Tacna', 'Tacna', 'Tacna', 'Inclan'),
(1822, 'Pachia , Tacna , Tacna', 'Tacna', 'Tacna', 'Pachia'),
(1823, 'Palca , Tacna , Tacna', 'Tacna', 'Tacna', 'Palca'),
(1824, 'Pocollay , Tacna , Tacna', 'Tacna', 'Tacna', 'Pocollay'),
(1825, 'Sama , Tacna , Tacna', 'Tacna', 'Tacna', 'Sama'),
(1826, 'Coronel Gregorio Albarracin Lanchipa , Tacna , Tacna', 'Tacna', 'Tacna', 'Coronel Gregorio Albarracin Lanchipa'),
(1827, 'La Yarada-Los Palos , Tacna , Tacna', 'Tacna', 'Tacna', 'La Yarada-Los Palos'),
(1828, 'Candarave , Candarave , Tacna', 'Tacna', 'Candarave', 'Candarave'),
(1829, 'Cairani , Candarave , Tacna', 'Tacna', 'Candarave', 'Cairani'),
(1830, 'Camilaca , Candarave , Tacna', 'Tacna', 'Candarave', 'Camilaca'),
(1831, 'Curibaya , Candarave , Tacna', 'Tacna', 'Candarave', 'Curibaya'),
(1832, 'Huanuara , Candarave , Tacna', 'Tacna', 'Candarave', 'Huanuara'),
(1833, 'Quilahuani , Candarave , Tacna', 'Tacna', 'Candarave', 'Quilahuani'),
(1834, 'Locumba , Jorge Basadre , Tacna', 'Tacna', 'Jorge Basadre', 'Locumba'),
(1835, 'Ilabaya , Jorge Basadre , Tacna', 'Tacna', 'Jorge Basadre', 'Ilabaya'),
(1836, 'Ite , Jorge Basadre , Tacna', 'Tacna', 'Jorge Basadre', 'Ite'),
(1837, 'Tarata , Tarata , Tacna', 'Tacna', 'Tarata', 'Tarata'),
(1838, 'Heroes Albarracin , Tarata , Tacna', 'Tacna', 'Tarata', 'Heroes Albarracin'),
(1839, 'Estique , Tarata , Tacna', 'Tacna', 'Tarata', 'Estique'),
(1840, 'Estique-Pampa , Tarata , Tacna', 'Tacna', 'Tarata', 'Estique-Pampa'),
(1841, 'Sitajara , Tarata , Tacna', 'Tacna', 'Tarata', 'Sitajara'),
(1842, 'Susapaya , Tarata , Tacna', 'Tacna', 'Tarata', 'Susapaya'),
(1843, 'Tarucachi , Tarata , Tacna', 'Tacna', 'Tarata', 'Tarucachi'),
(1844, 'Ticaco , Tarata , Tacna', 'Tacna', 'Tarata', 'Ticaco'),
(1845, 'Tumbes , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'Tumbes'),
(1846, 'Corrales , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'Corrales'),
(1847, 'La Cruz , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'La Cruz'),
(1848, 'Pampas de Hospital , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'Pampas de Hospital'),
(1849, 'San Jacinto , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'San Jacinto'),
(1850, 'San Juan de La Virgen , Tumbes , Tumbes', 'Tumbes', 'Tumbes', 'San Juan de La Virgen'),
(1851, 'Zorritos , Contralmirante Villar , Tumbes', 'Tumbes', 'Contralmirante Villar', 'Zorritos'),
(1852, 'Casitas , Contralmirante Villar , Tumbes', 'Tumbes', 'Contralmirante Villar', 'Casitas'),
(1853, 'Canoas de Punta Sal , Contralmirante Villar , Tumbes', 'Tumbes', 'Contralmirante Villar', 'Canoas de Punta Sal'),
(1854, 'Zarumilla , Zarumilla , Tumbes', 'Tumbes', 'Zarumilla', 'Zarumilla'),
(1855, 'Aguas Verdes , Zarumilla , Tumbes', 'Tumbes', 'Zarumilla', 'Aguas Verdes'),
(1856, 'Matapalo , Zarumilla , Tumbes', 'Tumbes', 'Zarumilla', 'Matapalo'),
(1857, 'Papayal , Zarumilla , Tumbes', 'Tumbes', 'Zarumilla', 'Papayal'),
(1858, 'Calleria , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Calleria'),
(1859, 'Campoverde , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Campoverde'),
(1860, 'Iparia , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Iparia'),
(1861, 'Masisea , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Masisea'),
(1862, 'Yarinacocha , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Yarinacocha'),
(1863, 'Nueva Requena , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Nueva Requena'),
(1864, 'Manantay , Coronel Portillo , Ucayali', 'Ucayali', 'Coronel Portillo', 'Manantay'),
(1865, 'Raymondi , Atalaya , Ucayali', 'Ucayali', 'Atalaya', 'Raymondi'),
(1866, 'Sepahua , Atalaya , Ucayali', 'Ucayali', 'Atalaya', 'Sepahua'),
(1867, 'Tahuania , Atalaya , Ucayali', 'Ucayali', 'Atalaya', 'Tahuania'),
(1868, 'Yurua , Atalaya , Ucayali', 'Ucayali', 'Atalaya', 'Yurua'),
(1869, 'Padre Abad , Padre Abad , Ucayali', 'Ucayali', 'Padre Abad', 'Padre Abad'),
(1870, 'Irazola , Padre Abad , Ucayali', 'Ucayali', 'Padre Abad', 'Irazola'),
(1871, 'Curimana , Padre Abad , Ucayali', 'Ucayali', 'Padre Abad', 'Curimana'),
(1872, 'Neshuya , Padre Abad , Ucayali', 'Ucayali', 'Padre Abad', 'Neshuya'),
(1873, 'Alexander von Humboldt , Padre Abad , Ucayali', 'Ucayali', 'Padre Abad', 'Alexander von Humboldt'),
(1874, 'Purus , Purus , Ucayali', 'Ucayali', 'Purus', 'Purus');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `failed_jobs`
--

INSERT INTO `failed_jobs` (`id`, `uuid`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES
(1, 'c21a153b-3855-4692-90b2-1d6969f09a51', 'database', 'default', '{\"uuid\":\"c21a153b-3855-4692-90b2-1d6969f09a51\",\"displayName\":\"App\\\\Jobs\\\\SendEmails\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendEmails\",\"command\":\"O:19:\\\"App\\\\Jobs\\\\SendEmails\\\":10:{s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}}\"}}', 'Swift_RfcComplianceException: Address in mailbox given [testing] does not comply with RFC 2822, 3.6.2. in D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\Headers\\MailboxHeader.php:355\nStack trace:\n#0 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\Headers\\MailboxHeader.php(272): Swift_Mime_Headers_MailboxHeader->assertValidAddress(\'testing\')\n#1 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\Headers\\MailboxHeader.php(117): Swift_Mime_Headers_MailboxHeader->normalizeMailboxes(Array)\n#2 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\Headers\\MailboxHeader.php(74): Swift_Mime_Headers_MailboxHeader->setNameAddresses(Array)\n#3 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\SimpleHeaderFactory.php(61): Swift_Mime_Headers_MailboxHeader->setFieldBodyModel(Array)\n#4 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\SimpleHeaderSet.php(71): Swift_Mime_SimpleHeaderFactory->createMailboxHeader(\'To\', Array)\n#5 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\SimpleMessage.php(323): Swift_Mime_SimpleHeaderSet->addMailboxHeader(\'To\', Array)\n#6 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\swiftmailer\\swiftmailer\\lib\\classes\\Swift\\Mime\\SimpleMessage.php(299): Swift_Mime_SimpleMessage->setTo(Array)\n#7 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Message.php(164): Swift_Mime_SimpleMessage->addTo(\'testing\', NULL)\n#8 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Message.php(98): Illuminate\\Mail\\Message->addAddresses(\'testing\', NULL, \'To\')\n#9 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailable.php(376): Illuminate\\Mail\\Message->to(\'testing\', NULL)\n#10 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailable.php(183): Illuminate\\Mail\\Mailable->buildRecipients(Object(Illuminate\\Mail\\Message))\n#11 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailer.php(271): Illuminate\\Mail\\Mailable->Illuminate\\Mail\\{closure}(Object(Illuminate\\Mail\\Message))\n#12 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailable.php(187): Illuminate\\Mail\\Mailer->send(Object(Illuminate\\Support\\HtmlString), Array, Object(Closure))\n#13 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\Traits\\Localizable.php(19): Illuminate\\Mail\\Mailable->Illuminate\\Mail\\{closure}()\n#14 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailable.php(188): Illuminate\\Mail\\Mailable->withLocale(NULL, Object(Closure))\n#15 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailer.php(304): Illuminate\\Mail\\Mailable->send(Object(Illuminate\\Mail\\Mailer))\n#16 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\Mailer.php(258): Illuminate\\Mail\\Mailer->sendMailable(Object(App\\Mail\\InvitationEmail))\n#17 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Mail\\PendingMail.php(124): Illuminate\\Mail\\Mailer->send(Object(App\\Mail\\InvitationEmail))\n#18 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\app\\Jobs\\SendEmails.php(27): Illuminate\\Mail\\PendingMail->send(Object(App\\Mail\\InvitationEmail))\n#19 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\SendEmails->handle()\n#20 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(40): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#21 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(93): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#22 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(37): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#23 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(653): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#24 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(128): Illuminate\\Container\\Container->call(Array)\n#25 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(128): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\SendEmails))\n#26 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\SendEmails))\n#27 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(132): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#28 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(120): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\SendEmails), false)\n#29 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(128): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\SendEmails))\n#30 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\SendEmails))\n#31 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(122): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#32 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\SendEmails))\n#33 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(98): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#34 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(428): Illuminate\\Queue\\Jobs\\Job->fire()\n#35 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(378): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#36 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(172): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#37 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(117): Illuminate\\Queue\\Worker->daemon(\'database\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#38 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(101): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'default\')\n#39 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#40 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(40): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#41 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(93): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#42 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(37): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#43 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(653): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#44 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(136): Illuminate\\Container\\Container->call(Array)\n#45 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Command\\Command.php(298): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#46 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(121): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#47 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(1040): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#48 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(301): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#49 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(171): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#50 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Application.php(94): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#51 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(129): Illuminate\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#52 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\artisan(37): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#53 {main}', '2023-03-08 13:44:18'),
(2, '9a39a8da-9ac2-48f1-8d59-118acdfb3a2a', 'database', 'default', '{\"uuid\":\"9a39a8da-9ac2-48f1-8d59-118acdfb3a2a\",\"displayName\":\"App\\\\Jobs\\\\SendEmails\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\SendEmails\",\"command\":\"O:19:\\\"App\\\\Jobs\\\\SendEmails\\\":10:{s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}}\"}}', 'Error: Call to undefined method Illuminate\\Mail\\PendingMail::subject() in D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\app\\Jobs\\SendEmails.php:27\nStack trace:\n#0 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\SendEmails->handle()\n#1 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(40): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#2 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(93): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#3 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(37): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#4 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(653): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#5 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(128): Illuminate\\Container\\Container->call(Array)\n#6 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(128): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\SendEmails))\n#7 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\SendEmails))\n#8 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(132): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#9 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(120): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\SendEmails), false)\n#10 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(128): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\SendEmails))\n#11 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(103): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\SendEmails))\n#12 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(122): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#13 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(70): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\SendEmails))\n#14 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(98): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#15 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(428): Illuminate\\Queue\\Jobs\\Job->fire()\n#16 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(378): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#17 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(172): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(117): Illuminate\\Queue\\Worker->daemon(\'database\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(101): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'default\')\n#20 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#21 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(40): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#22 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(93): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#23 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(37): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#24 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(653): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#25 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(136): Illuminate\\Container\\Container->call(Array)\n#26 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Command\\Command.php(298): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#27 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(121): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(1040): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#29 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(301): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\symfony\\console\\Application.php(171): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Application.php(94): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(129): Illuminate\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\xampp 7.4\\htdocs\\versiones programador\\DirektorAppFinal2\\DirektorAppFinal\\artisan(37): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 {main}', '2023-03-09 09:02:35');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `other_notificaciones`
--

CREATE TABLE `other_notificaciones` (
  `codNotificacion` int(11) NOT NULL,
  `desNombre` varchar(255) DEFAULT NULL,
  `desDescripción` varchar(255) DEFAULT NULL,
  `desPersonalizar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `other_notificaciones`
--

INSERT INTO `other_notificaciones` (`codNotificacion`, `desNombre`, `desDescripción`, `desPersonalizar`) VALUES
(1, 'CreacionProyecto', 'CreacionProyecto', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `other_notificaciones_usuario`
--

CREATE TABLE `other_notificaciones_usuario` (
  `id` bigint(20) NOT NULL,
  `codNotificacion` int(11) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreación` varchar(255) DEFAULT NULL,
  `codNotificacionUsuario` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `other_notificaciones_usuario2`
--

CREATE TABLE `other_notificaciones_usuario2` (
  `codNotificacionUsuario` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  `codNotificacion` int(11) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreación` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `other_notificaciones_usuario4`
--

CREATE TABLE `other_notificaciones_usuario4` (
  `codNotificacionUsuario` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  `codNotificacion` int(11) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreación` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('cbacalla@inarco.com.pe', 'ABhb59ekTGoP5KNP8mCIr8tWmSCX2kZAt2lMXX1I1zRDI3AvrxP5H6MbIKjPcESu', '2024-03-20 10:03:08');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(2, 'App\\Models\\User', 4, 'main', 'fad423794c19b2fcafa97ea7b3df90432ae38f84feb04d7876ae77e8c43749fd', '[\"*\"]', NULL, '2022-11-08 11:00:02', '2022-11-08 11:00:02'),
(3, 'App\\Models\\User', 4, 'main', '8b23b8515d0c16fa55307ada01558e8daa544f2cb148764486e7252fbcf40502', '[\"*\"]', NULL, '2022-11-08 11:00:25', '2022-11-08 11:00:25'),
(4, 'App\\Models\\User', 4, 'main', 'c7bf9c90bb85f93b443baf3ee8ead0f3da3de473fe798a3786ec450988c45b76', '[\"*\"]', NULL, '2022-11-08 21:38:39', '2022-11-08 21:38:39'),
(5, 'App\\Models\\User', 5, 'main', '0aa1e989c6969e6d10c6646cf74b3ab944df69d6152044c171a4d936288972a6', '[\"*\"]', NULL, '2022-11-11 00:18:15', '2022-11-11 00:18:15'),
(6, 'App\\Models\\User', 5, 'main', 'da842488d492df963f2820a0e4897de5a30e3d05b27d84150e4e1f83928e9133', '[\"*\"]', NULL, '2022-11-11 00:18:50', '2022-11-11 00:18:50'),
(7, 'App\\Models\\User', 5, 'main', '8e92ab3a7a4ad4da42c52fd6f1400095c016bfd9ec3bb302b18d363fda7bc889', '[\"*\"]', NULL, '2022-11-11 04:49:37', '2022-11-11 04:49:37'),
(8, 'App\\Models\\User', 5, 'main', '2a7a97c651cd5fb2fcf4d9c1dfd1d8d944a95193103303c141aac0982812dd91', '[\"*\"]', NULL, '2022-11-11 10:06:35', '2022-11-11 10:06:35'),
(9, 'App\\Models\\User', 5, 'main', 'c7d95e0a2148e561747b204d7154d1f40c44b17549aae17a8da6512c1903bdd9', '[\"*\"]', NULL, '2022-11-11 10:07:51', '2022-11-11 10:07:51'),
(10, 'App\\Models\\User', 5, 'main', '37d04b5f734555c1ac0da48ab605c44ed3a49aa5ec59c2cb18cf0087ec0dc768', '[\"*\"]', NULL, '2022-11-11 10:10:00', '2022-11-11 10:10:00'),
(11, 'App\\Models\\User', 5, 'main', '2f11262c47a6795de590094b52168449bf37ca353d13c68c5b3dbd70d2d8a671', '[\"*\"]', NULL, '2022-11-11 10:33:09', '2022-11-11 10:33:09'),
(12, 'App\\Models\\User', 5, 'main', '33f056e3e511f56ef8530326a2799d10b530b4273eaab0d593ea1a9e66bec7f4', '[\"*\"]', NULL, '2022-11-11 10:34:46', '2022-11-11 10:34:46'),
(13, 'App\\Models\\User', 5, 'main', '1d3e0128edeed25fe49c1b7f32234649909b225b54554749eb47e4c562bd5a9b', '[\"*\"]', NULL, '2022-11-11 10:39:32', '2022-11-11 10:39:32'),
(14, 'App\\Models\\User', 5, 'main', '4cab016e278c88a1e141cf1ad363d619f851475f4c1f2511c987bebc43970d41', '[\"*\"]', NULL, '2022-11-11 10:44:52', '2022-11-11 10:44:52'),
(15, 'App\\Models\\User', 5, 'main', 'a085b1189ee5434876835bc0e356830e26b446c54a442fec5b4f096b26f7756c', '[\"*\"]', NULL, '2022-11-11 18:20:13', '2022-11-11 18:20:13'),
(16, 'App\\Models\\User', 5, 'main', 'ec3da1d0dbbdfc1685ac78de7417e56226ba7f13df5cdd07b1de011d4f91fd58', '[\"*\"]', NULL, '2022-11-13 16:34:48', '2022-11-13 16:34:48'),
(17, 'App\\Models\\User', 6, 'main', 'c35d81587d6679cad0d462941e8b3d24f6057f4e7a1a539a0a2c664301d5a971', '[\"*\"]', NULL, '2022-11-15 09:22:22', '2022-11-15 09:22:22'),
(18, 'App\\Models\\User', 6, 'main', 'ce117f6577de5997021a35e2d05a8e9669bab2f744c97f435cec16968503bb04', '[\"*\"]', NULL, '2022-11-15 09:22:34', '2022-11-15 09:22:34'),
(19, 'App\\Models\\User', 7, 'main', '002d96e3164c3ace78cca5670d336dde247293a7771cd6c00c74256dcc84372e', '[\"*\"]', NULL, '2022-11-15 18:38:01', '2022-11-15 18:38:01'),
(20, 'App\\Models\\User', 7, 'main', 'c633a7156756adc12e54def5ddffdd27828e529de86e94b9b1806f575d386453', '[\"*\"]', NULL, '2022-11-15 18:38:16', '2022-11-15 18:38:16'),
(21, 'App\\Models\\User', 5, 'main', '066711ee3b2bc6ac0f388e03b56d3c8ce5e09ae6a81179bbce6afd86df179071', '[\"*\"]', NULL, '2022-11-17 05:03:26', '2022-11-17 05:03:26'),
(22, 'App\\Models\\User', 5, 'main', 'dbd3138ad438933d85d12b92d4afc21e95f30f04c2f97cfaba31e1f020b939e9', '[\"*\"]', NULL, '2022-11-17 21:40:30', '2022-11-17 21:40:30'),
(23, 'App\\Models\\User', 5, 'main', 'dc9f6f75376cdc7a6e887698f15c21ba08c5db28a52e327766b1e1273cc291c5', '[\"*\"]', NULL, '2022-11-18 06:49:24', '2022-11-18 06:49:24'),
(24, 'App\\Models\\User', 5, 'main', '4823fb622e5f1d691bac582faa0faf3043dd0a0554f4339d3010c18159a8deb6', '[\"*\"]', NULL, '2022-11-18 10:47:11', '2022-11-18 10:47:11'),
(25, 'App\\Models\\User', 6, 'main', 'f32a736b9f58fc341538407297f67141cf36bad581fcf9e19f45cef6676ec6bf', '[\"*\"]', NULL, '2022-11-18 10:47:49', '2022-11-18 10:47:49'),
(26, 'App\\Models\\User', 6, 'main', '5941cfbfc163e40db4a6b3f753aabad233ade3feaced5b2327bb6259c4773156', '[\"*\"]', NULL, '2022-11-18 10:49:06', '2022-11-18 10:49:06'),
(27, 'App\\Models\\User', 5, 'main', '355bcb5ced91a3e77b83b325968688a12fd7205dc70ddf62f969830417c0752a', '[\"*\"]', NULL, '2022-11-20 14:45:09', '2022-11-20 14:45:09'),
(28, 'App\\Models\\User', 6, 'main', '8193094a022a19d00c06774ec8ae0f089d5c0a57a2b5bd95fa62cc72764d5c36', '[\"*\"]', NULL, '2022-11-20 18:44:49', '2022-11-20 18:44:49'),
(29, 'App\\Models\\User', 6, 'main', 'def93eb74e74d92ea16f10fcaf0ebcc1496f753963fc17cdcd7442fee9323386', '[\"*\"]', NULL, '2022-11-21 20:25:03', '2022-11-21 20:25:03'),
(30, 'App\\Models\\User', 6, 'main', '93c913260bd3a10edefdd0d2cc3e1a8ba95f7bbccd8e868672013c4a8f12ccae', '[\"*\"]', NULL, '2022-11-22 14:16:17', '2022-11-22 14:16:17'),
(31, 'App\\Models\\User', 7, 'main', '1262a10de8a9ba54ff00c207791834275f013b4d05b5d9a1c46a789d87d142a3', '[\"*\"]', NULL, '2022-11-22 19:38:09', '2022-11-22 19:38:09'),
(32, 'App\\Models\\User', 5, 'main', '7b21d51c7031b2bcb03f59665900fc2b1c35f0b1a2103d152f684bf7bed4449c', '[\"*\"]', NULL, '2022-11-22 21:14:02', '2022-11-22 21:14:02'),
(33, 'App\\Models\\User', 6, 'main', '7c20ac3ce0b178133ac2666a10eacaa6a7bf0e35ea592e942abab05709eff183', '[\"*\"]', NULL, '2022-11-22 21:16:44', '2022-11-22 21:16:44'),
(34, 'App\\Models\\User', 6, 'main', '360f4e14c5fb61c24f3c017f8fd41ad4a2d460627b42feaf44fae3e9c470b5cc', '[\"*\"]', NULL, '2022-11-23 18:38:56', '2022-11-23 18:38:56'),
(35, 'App\\Models\\User', 8, 'main', 'b18722012bec8d32da5a01ed7599fec0c7bc2e63bd55e23d75c51c52b09a1d4f', '[\"*\"]', NULL, '2022-11-23 21:33:01', '2022-11-23 21:33:01'),
(36, 'App\\Models\\User', 8, 'main', 'b8deacf012d2afbea9729c6f42873d1af2e052e68172aa167a31a32314a22060', '[\"*\"]', NULL, '2022-11-23 21:33:19', '2022-11-23 21:33:19'),
(1703, 'App\\Models\\User', 88, 'main', '267e1f209c103969bfcb893250b3123080c2876599cf0bb07692c5df7ce80b41', '[\"*\"]', NULL, '2024-05-14 13:57:37', '2024-05-14 13:57:37'),
(1704, 'App\\Models\\User', 19, 'main', '85be77d9a5ad1ca3eac4dbb5dab3e8db191282c7a7ce3ad071dc70479a62b1d7', '[\"*\"]', '2024-05-15 08:31:31', '2024-05-14 18:32:21', '2024-05-15 08:31:31'),
(1705, 'App\\Models\\User', 19, 'main', '5a2e22ee834c53afc5f2646fb753abcfb97d23d08432f18bb092c46aeb6389dc', '[\"*\"]', '2024-05-17 00:51:51', '2024-05-17 00:49:03', '2024-05-17 00:51:51'),
(1706, 'App\\Models\\User', 34, 'main', '0aa7abd5de88e79764f46cf0cedb100a5b853dddabb074c6800312b7a3615c40', '[\"*\"]', NULL, '2024-05-17 00:54:07', '2024-05-17 00:54:07'),
(1707, 'App\\Models\\User', 112, 'main', '543871fe806dcecb715a3d2ec429ae02bfba88dc06bd5383affd8b7cb57889b8', '[\"*\"]', NULL, '2024-05-17 13:35:40', '2024-05-17 13:35:40'),
(1708, 'App\\Models\\User', 112, 'main', '65e1dcd979ea12dea2ff621ea1db8ff90d9d35ad5a9568d2b2043c6f44d7082b', '[\"*\"]', NULL, '2024-05-17 13:35:49', '2024-05-17 13:35:49'),
(1709, 'App\\Models\\User', 112, 'main', '619a6f4cd21a460f75c3351115ae50cc51885db408beab44dfa51be45fb4d05c', '[\"*\"]', '2024-05-17 13:55:35', '2024-05-17 13:51:15', '2024-05-17 13:55:35'),
(1710, 'App\\Models\\User', 112, 'main', 'b2f2593b479423ab11f3d76e3169d1288e22baee9821d2346dd2551c1fe54382', '[\"*\"]', '2024-05-17 14:18:22', '2024-05-17 14:02:56', '2024-05-17 14:18:22'),
(1711, 'App\\Models\\User', 112, 'main', '2f7044de1f5747215427423cfa961c357fecf747d3a070f2ebc44e08b3946713', '[\"*\"]', '2024-05-18 11:05:02', '2024-05-18 10:48:38', '2024-05-18 11:05:02');

-- --------------------------------------------------------

--
-- Table structure for table `proy_areaintegrante`
--

CREATE TABLE `proy_areaintegrante` (
  `codArea` bigint(20) NOT NULL,
  `desArea` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proy_areaintegrante`
--

INSERT INTO `proy_areaintegrante` (`codArea`, `desArea`) VALUES
(1, 'Residencia'),
(2, 'Of. Tecnica '),
(3, 'Campo'),
(4, 'SSOMA'),
(5, 'Administración'),
(6, 'Calidad'),
(7, 'Gerencia'),
(8, 'Cliente'),
(9, 'BIM'),
(10, 'CGP');

-- --------------------------------------------------------

--
-- Table structure for table `proy_integrantes`
--

CREATE TABLE `proy_integrantes` (
  `codProyIntegrante` bigint(20) NOT NULL,
  `codProyecto` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  `codEstadoInvitacion` varchar(255) DEFAULT NULL,
  `codArea` int(11) DEFAULT NULL,
  `dayFechaInvitacion` datetime DEFAULT NULL,
  `dayFechaInvitacionConfirmacion` datetime DEFAULT NULL,
  `codRolIntegrante` int(11) DEFAULT NULL,
  `desCorreo` varchar(255) DEFAULT NULL,
  `idIntegrante` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `proy_integrantes`
--

INSERT INTO `proy_integrantes` (`codProyIntegrante`, `codProyecto`, `id`, `codEstadoInvitacion`, `codArea`, `dayFechaInvitacion`, `dayFechaInvitacionConfirmacion`, `codRolIntegrante`, `desCorreo`, `idIntegrante`) VALUES
(1, 1, 19, '1', 2, '2023-03-22 04:07:05', '2023-03-26 19:24:14', 2, 'diegowarthon1190@gmail.com', 38),
(2, 1, 19, '-1', 2, '2023-03-22 07:53:08', '2023-07-01 15:57:39', 3, 'diegowarthonwh@gmail.com', 50),
(3, 2, 30, '1', 2, '2023-03-23 03:58:44', '2023-03-26 19:24:14', 2, 'diegowarthon1190@gmail.com', 38),
(4, 2, 30, '0', 2, '2023-03-23 03:58:44', NULL, 2, 'carlos@proyectoveremos.com', -999),
(5, 3, 30, '1', 1, '2023-03-23 10:58:14', '2023-03-26 19:24:14', 2, 'diegowarthon1190@gmail.com', 38),
(6, 4, 29, '1', 10, '2023-03-23 11:34:54', '2023-04-17 15:43:39', 3, 'bduelles@inarco.com.pe', 34),
(7, 4, 29, '1', 10, '2023-03-23 11:34:54', '2023-03-23 23:18:52', 3, 'jmasias@inarco.com.pe', 32),
(9, 4, 29, '1', 2, '2023-03-23 17:16:35', '2023-05-30 15:29:38', 2, 'mmiranda@inarco.com.pe', 48),
(11, 4, 29, '1', 5, '2023-03-23 17:16:35', '2023-06-06 11:01:25', 2, 'smalaver@inarco.com.pe', 49),
(13, 5, 29, '1', 2, '2023-03-24 10:39:28', '2023-04-17 15:43:39', 3, 'bduelles@inarco.com.pe', 34),
(14, 5, 29, '1', 2, '2023-03-24 10:39:28', '2023-10-02 09:30:07', 1, 'jmasias@inarco.com.pe', 32),
(15, 5, 29, '1', 1, '2023-03-24 10:39:28', '2023-03-24 16:44:19', 3, 'wibanez@inarco.com.pe', 35),
(16, 5, 29, '1', 3, '2023-03-24 10:39:28', '2023-03-24 16:10:49', 3, 'mlujan@inarco.com.pe', 33),
(17, 5, 29, '1', 3, '2023-03-24 10:39:28', '2023-04-17 13:57:20', 2, 'jfrancisco@inarco.com.pe', 39),
(18, 5, 29, '1', 5, '2023-03-24 10:39:28', '2023-04-24 20:40:08', 2, 'rreyes@inarco.com.pe', 44),
(19, 5, 29, '1', 6, '2023-03-24 10:39:28', '2023-05-04 17:59:06', 2, 'crobledo@inarco.com.pe', 45),
(20, 5, 29, '0', 4, '2023-03-24 10:39:28', NULL, 2, 'ecalderon@inarco.com.pe', -999),
(21, 4, 29, '1', 10, '2023-03-24 11:02:14', '2023-03-25 17:00:18', 3, 'vjimenez@inarco.com.pe', 29),
(22, 5, 29, '1', 1, '2023-03-24 11:02:30', '2023-03-25 17:00:18', 3, 'vjimenez@inarco.com.pe', 29),
(24, 1, 19, '-1', 2, '2023-06-23 15:42:22', '2023-06-23 16:20:12', 8, 'bduelles@inarco.com.pe', 34),
(25, 6, 19, '1', 3, '2023-06-25 01:10:59', '2023-06-25 01:11:35', 2, 'diegowarthon1190@gmail.com', 38),
(26, 7, 50, '1', 1, '2023-07-01 16:05:25', NULL, 3, 'diegowarthonwh@gmail.com', 50),
(28, 7, 50, '0', 4, '2023-07-01 20:52:14', NULL, 2, 'diegowarthon_wh@outlook.com', -999),
(29, 7, 50, '1', 4, '2023-07-01 23:25:41', '2023-07-01 23:30:31', 3, 'diegowarthon1190@gmail.com', 38),
(38, 9, 19, '', 1, '2023-08-23 17:05:52', '2024-01-26 20:20:22', 1, 'diegowarthon1190@gmail.com', 38),
(39, 10, 19, '', 2, '2023-08-23 17:11:14', '2024-01-26 20:20:22', 1, 'diegowarthon1190@gmail.com', 38),
(40, 10, 19, '', 2, '2023-08-23 17:11:14', '2023-09-20 10:21:27', 1, 'diegowarthonwh@gmail.com', 50),
(41, 11, 19, '', 2, '2023-08-23 21:47:10', '2024-01-26 20:20:22', 1, 'diegowarthon1190@gmail.com', 38),
(46, 14, 34, '1', 1, '2023-08-29 12:37:21', '2023-09-11 09:40:32', 3, 'vjimenez@inarco.com.pe', 29),
(47, 14, 34, '1', 1, '2023-08-29 12:38:49', '2023-08-31 14:27:22', 3, 'jasto@inarco.com.pe', 55),
(48, 14, 34, '1', 3, '2023-08-29 12:59:16', '2023-08-31 10:30:25', 3, 'dsanchez@inarco.com.pe', 51),
(49, 14, 34, '1', 2, '2023-08-29 12:59:16', '2023-08-31 14:17:54', 2, 'alarosa@inarco.com.pe', 52),
(50, 14, 34, '1', 2, '2023-08-29 12:59:16', '2023-08-31 14:20:50', 3, 'hdonayre@inarco.com.pe', 54),
(51, 14, 34, '1', 4, '2023-08-29 12:59:16', '2023-08-31 14:14:45', 2, 'csolis@inarco.com.pe', 53),
(53, 14, 34, '1', 5, '2023-08-29 12:59:16', '2023-08-31 14:19:39', 2, 'rreyes@inarco.com.pe', 44),
(54, 14, 34, '1', 1, '2023-08-31 14:06:11', '2023-08-31 14:29:42', 3, 'bduelles@inarco.com.pe', 34),
(55, 14, 34, '0', 3, '2023-08-31 14:32:03', NULL, 3, 'mescurra@inarco.com.pe', 37),
(56, 14, 34, '1', 3, '2023-08-31 14:32:03', '2023-09-01 17:02:38', 2, 'gcasiano@inarco.com.pe', 56),
(57, 15, 19, '1', 1, '2023-09-20 09:57:30', '2023-09-20 10:21:27', 3, 'diegowarthonwh@gmail.com', 50),
(58, 14, 34, '0', 3, '2023-09-22 12:04:12', NULL, 2, 'adiaz@inarco.com.pe', 31),
(59, 4, 34, '1', 1, '2023-09-22 14:52:07', '2023-10-06 10:35:07', 3, 'gcondezo@inarco.com.pe', 60),
(61, 4, 34, '1', 3, '2023-09-22 14:56:21', '2024-03-20 10:03:04', 3, 'lluyo@inarco.com.pe', 99),
(62, 4, 34, '1', 3, '2023-09-26 10:26:25', '2023-09-26 10:47:15', 2, 'lleon@inarco.com.pe', 58),
(64, 4, 34, '1', 3, '2023-09-29 11:27:18', '2023-09-29 11:27:49', 3, 'cmorales@inarco.com.pe', 57),
(65, 4, 29, '0', 7, '2023-10-03 15:49:47', NULL, 1, 'cvega@inarco.com.pe', -999),
(66, 14, 29, '0', 1, '2023-10-03 15:53:48', NULL, 1, 'cvega@inarco.com.pe', -999),
(73, 19, 32, '1', 10, '2023-10-04 14:36:28', '2023-10-04 14:39:19', 3, 'vjimenez@inarco.com.pe', 29),
(74, 19, 32, '1', 10, '2023-10-04 14:36:28', NULL, 3, 'jmasias@inarco.com.pe', 32),
(75, 19, 32, '1', 10, '2023-10-04 14:36:28', '2023-10-04 16:37:33', 3, 'bduelles@inarco.com.pe', 34),
(76, 19, 32, '0', 1, '2023-10-04 14:36:28', NULL, 3, 'wibanez@inarco.com.pe', 35),
(77, 22, 32, '1', 1, '2023-10-05 11:53:25', '2023-10-07 08:13:38', 3, 'gpino@inarco.com.pe', 61),
(78, 23, 32, '1', 10, '2023-10-05 11:57:40', '2023-11-03 09:13:59', 3, 'vjimenez@inarco.com.pe', 29),
(80, 22, 32, '1', 2, '2023-10-05 15:02:46', '2023-10-07 10:16:39', 1, 'bloayza@inarco.com.pe', 62),
(83, 22, 32, '0', 3, '2023-10-05 15:02:46', NULL, 3, 'eborda@inarco.com.pe', -999),
(84, 22, 32, '0', 5, '2023-10-05 15:02:46', NULL, 1, 'randrade@inarco.com.pe', -999),
(86, 22, 32, '0', 6, '2023-10-05 15:02:46', NULL, 1, 'kaliaga@inarco.com.pe', -999),
(87, 22, 32, '0', 6, '2023-10-05 15:02:46', NULL, 1, 'ranton@inarco.com.pe', -999),
(88, 22, 32, '0', 4, '2023-10-05 15:02:46', NULL, 1, 'mclavijo@inarco.com.pe', -999),
(89, 22, 32, '0', 5, '2023-10-05 15:02:46', NULL, 1, 'jleyva@inarco.com.pe', -999),
(90, 22, 32, '1', 10, '2023-10-05 15:02:46', '2023-11-03 09:13:59', 3, 'vjimenez@inarco.com.pe', 29),
(91, 22, 32, '1', 10, '2023-10-05 15:02:46', '2023-10-05 15:04:59', 3, 'jmasias@inarco.com.pe', 32),
(92, 22, 32, '1', 10, '2023-10-05 15:02:46', '2023-10-06 11:16:26', 3, 'bduelles@inarco.com.pe', 34),
(93, 22, 32, '1', 10, '2023-10-05 15:02:46', '2024-01-03 21:28:17', 1, 'lrobles@inarco.com.pe', 70),
(98, 14, 34, '0', 8, '2023-10-06 15:19:03', NULL, 1, 'cliente@gmail.com.pe', -999),
(99, 23, 32, '1', 10, '2023-10-09 18:17:10', '2023-10-10 16:38:36', 1, 'bduelles@inarco.com.pe', 34),
(100, 23, 32, '1', 10, '2023-10-09 18:17:10', '2023-10-10 12:18:12', 3, 'jmasias@inarco.com.pe', 32),
(101, 23, 32, '0', 1, '2023-10-09 18:17:10', NULL, 3, 'wibanez@inarco.com.pe', 35),
(102, 23, 32, '0', 2, '2023-10-09 18:17:10', NULL, 1, 'erojas@inarco.com.pe', -999),
(103, 23, 32, '0', 2, '2023-10-09 18:21:39', NULL, 1, 'aore@inarco.com.pe', -999),
(104, 14, 34, '1', 2, '2023-11-27 16:10:21', '2023-11-27 16:25:40', 2, 'kmejia@inarco.com.pe', 64),
(105, 14, 34, '0', 3, '2023-11-29 09:48:35', NULL, 2, 'jtello@inarco.com.pe', -999),
(106, 22, 34, '1', 3, '2023-12-06 11:04:50', '2023-12-06 11:06:05', 3, 'mlujan@inarco.com.pe', 33),
(107, 22, 34, '1', 10, '2023-12-07 13:38:50', '2023-12-07 13:39:16', 3, 'egomez@inarco.com.pe', 65),
(108, 28, 34, '1', 10, '2023-12-07 13:43:28', '2023-12-07 13:44:19', 3, 'egomez@inarco.com.pe', 65),
(109, 28, 34, '1', 10, '2023-12-07 13:43:28', NULL, 3, 'bduelles@inarco.com.pe', 34),
(110, 28, 34, '1', 10, '2023-12-07 13:43:28', '2024-01-18 13:18:16', 3, 'vjimenez@inarco.com.pe', 29),
(111, 14, 34, '1', 10, '2023-12-07 13:44:59', '2023-12-07 13:45:20', 3, 'egomez@inarco.com.pe', 65),
(112, 22, 65, '1', 4, '2023-12-07 13:49:35', '2024-04-22 14:53:50', 1, 'calvarez@inarco.com.pe', 106),
(113, 22, 65, '1', 2, '2023-12-07 16:10:00', '2024-01-02 15:16:18', 1, 'ebeltran@inarco.com.pe', 68),
(114, 22, 65, '0', 2, '2023-12-07 16:15:48', NULL, 1, 'mpoma@inarco.com.pe', -999),
(115, 22, 65, '0', 2, '2023-12-07 16:20:12', NULL, 1, 'gmurillo@inarco.com.pe', -999),
(116, 22, 65, '1', 3, '2023-12-07 16:21:47', '2024-01-07 10:16:20', 3, 'avidal@inarco.com.pe', 71),
(117, 22, 65, '1', 3, '2023-12-07 16:22:26', '2024-01-02 15:20:52', 3, 'mchacmana@inarco.com.pe', 69),
(118, 22, 65, '0', 3, '2023-12-07 16:23:29', NULL, 3, 'anavarro@inarco.com.pe', -999),
(119, 22, 65, '0', 3, '2023-12-07 16:25:27', NULL, 3, 'cquispe@inarco.com.pe', -999),
(120, 22, 65, '0', 6, '2023-12-07 16:26:30', NULL, 1, 'cdedekind@inarco.com.pe', -999),
(121, 22, 65, '0', 4, '2023-12-07 16:27:45', NULL, 1, 'pcuenca@inarco.com.pe', -999),
(122, 22, 65, '0', 4, '2023-12-07 16:29:00', NULL, 1, 'ncarrion@inarco.com.pe', -999),
(123, 22, 65, '0', 9, '2023-12-07 16:30:23', NULL, 1, 'mroque@inarco.com.pe', -999),
(124, 22, 65, '0', 9, '2023-12-07 16:32:12', NULL, 1, 'mcastillo@inarco.com.pe', -999),
(125, 22, 65, '0', 9, '2023-12-07 16:33:05', NULL, 1, 'csantibañez@inarco.com.pe', -999),
(126, 22, 65, '0', 9, '2023-12-07 16:34:23', NULL, 1, 'dmarin@inarco.com.pe', -999),
(127, 22, 65, '0', 5, '2023-12-07 16:35:02', NULL, 1, 'iarcata@inarco.com.pe', -999),
(128, 22, 65, '0', 5, '2023-12-07 16:35:43', NULL, 1, 'mcolonio@inarco.com.pe', -999),
(129, 22, 65, '0', 5, '2023-12-07 16:37:18', NULL, 1, 'gcardenas@inarco.com.pe', -999),
(130, 29, 19, '0', 2, '2023-12-13 17:13:04', NULL, 2, 'diegowarthonwh@gmail.com', 50),
(131, 30, 19, '0', 4, '2023-12-14 00:35:36', NULL, 2, 'diegowarthonwh@gmail.com', 50),
(132, 4, 34, '1', 3, '2023-12-14 12:52:34', '2024-03-20 10:04:45', 3, 'cbacalla@inarco.com.pe', 66),
(133, 22, 34, '1', 3, '2024-01-03 11:53:25', '2024-01-03 11:54:42', 3, 'mchacmana@inarco.com.pe', 69),
(134, 14, 34, '0', 3, '2024-01-08 10:47:41', NULL, 3, 'jtello@inarco.com.pe', -999),
(135, 4, 34, '0', 6, '2024-01-12 15:22:37', NULL, 2, 'Gsuarez@inarco.com.pe', -999),
(136, 4, 34, '1', 3, '2024-01-12 15:23:30', '2024-01-13 09:56:52', 3, 'afarfan@inarco.com.pe', 83),
(137, 28, 34, '0', 7, '2024-01-12 15:36:53', NULL, 3, 'cvega@inarco.com.pe', -999),
(138, 28, 34, '1', 1, '2024-01-12 15:36:53', '2024-01-12 16:13:02', 3, 'mpena@inarco.com.pe', 73),
(139, 28, 34, '1', 2, '2024-01-12 15:36:53', '2024-01-12 16:13:56', 2, 'pllanos@inarco.com.pe', 74),
(140, 28, 34, '1', 6, '2024-01-12 15:36:53', '2024-01-12 15:56:56', 2, 'jtrejo@inarco.com.pe', 78),
(141, 28, 34, '1', 3, '2024-01-12 15:36:53', '2024-01-12 15:51:15', 3, 'apaez@inarco.com.pe', 75),
(142, 28, 34, '1', 4, '2024-01-12 15:36:53', '2024-01-12 16:14:48', 2, 'lweill@inarco.com.pe', 81),
(143, 28, 34, '1', 3, '2024-01-12 15:36:53', '2024-01-12 16:14:39', 3, 'dcortez@inarco.com.pe', 76),
(144, 28, 34, '1', 3, '2024-01-12 15:36:53', '2024-01-12 15:47:06', 3, 'gpiscoya@inarco.com.pe', 80),
(145, 28, 34, '1', 5, '2024-01-12 15:36:53', '2024-01-12 15:45:19', 2, 'eanamaria@inarco.com.pe', 77),
(146, 28, 34, '1', 2, '2024-01-12 15:36:53', '2024-01-12 15:46:36', 2, 'aramirez@inarco.com.pe', 79),
(147, 28, 34, '1', 5, '2024-01-12 15:36:53', '2024-01-12 15:49:23', 2, 'phuayhua@inarco.com.pe', 82),
(148, 31, 34, '0', 7, '2024-01-22 10:46:04', NULL, 3, 'cvega@inarco.com.pe', -999),
(149, 31, 34, '1', 10, '2024-01-22 10:46:04', NULL, 3, 'bduelles@inarco.com.pe', 34),
(150, 31, 34, '1', 10, '2024-01-22 10:46:04', '2024-01-26 19:58:32', 3, 'vjimenez@inarco.com.pe', 29),
(151, 31, 34, '1', 1, '2024-01-22 10:46:04', '2024-01-22 15:12:45', 3, 'dperez@inarco.com.pe', 85),
(152, 31, 34, '1', 2, '2024-01-22 10:46:04', '2024-02-10 14:10:11', 2, 'ozagazeta@inarco.com.pe', 88),
(153, 31, 34, '1', 6, '2024-01-22 10:46:04', '2024-02-10 13:01:08', 2, 'dfigueroa@inarco.com.pe', 72),
(154, 31, 34, '1', 3, '2024-01-22 10:46:04', '2024-01-22 13:45:58', 3, 'rtincallpa@inarco.com.pe', 84),
(156, 31, 34, '1', 4, '2024-01-22 10:46:04', '2024-01-23 14:13:01', 2, 'lvilla@inarco.com.pe', 86),
(157, 31, 34, '1', 5, '2024-01-22 10:46:04', '2024-02-10 14:23:56', 2, 'fochoa@inarco.com.pe', 89),
(158, 31, 34, '1', 3, '2024-01-23 15:24:48', '2024-01-23 15:29:57', 3, 'flezama@inarco.com.pe', 87),
(160, 15, 19, '1', 8, '2024-01-25 06:57:27', '2024-01-25 07:11:50', 8, 'diegowarthon1190@gmail.com', 38),
(161, 22, 29, '1', 1, '2024-01-26 20:19:52', '2024-01-26 20:20:22', 3, 'diegowarthon1190@gmail.com', 38),
(162, 4, 34, '1', 8, '2024-02-02 16:33:10', '2024-02-05 12:06:57', 8, 'rmeneses@inarco.com.pe', 46),
(163, 31, 34, '1', 8, '2024-02-09 13:33:52', '2024-02-09 13:35:11', 8, 'rmeneses@inarco.com.pe', 46),
(164, 32, 34, '1', 10, '2024-02-12 09:48:26', '2024-04-04 13:07:10', 3, 'vjimenez@inarco.com.pe', 29),
(165, 32, 34, '1', 10, '2024-02-12 09:48:26', '2024-02-12 11:34:27', 3, 'jmasias@inarco.com.pe', 32),
(166, 32, 34, '1', 10, '2024-02-12 09:48:26', NULL, 3, 'bduelles@inarco.com.pe', 34),
(167, 32, 34, '0', 7, '2024-02-12 09:48:26', NULL, 3, 'mullauri@inarco.com.pe', -999),
(168, 32, 34, '1', 1, '2024-02-12 09:48:26', '2024-03-19 15:46:29', 3, 'mfelix@inarco.com.pe', 98),
(169, 32, 34, '0', 2, '2024-02-12 09:48:26', NULL, 1, 'jvelasquez@inarco.com.pe', -999),
(170, 32, 34, '0', 2, '2024-02-12 09:48:26', NULL, 1, 'mclavijo@inarco.com.pe', -999),
(171, 32, 34, '0', 6, '2024-02-12 09:48:26', NULL, 1, 'nmanrique@inarco.com.pe', 59),
(172, 32, 34, '0', 3, '2024-02-12 09:48:26', NULL, 2, 'smaldonado@inarco.com.pe', -999),
(173, 32, 34, '0', 5, '2024-02-12 09:48:26', NULL, 1, 'oportella@inarco.com.pe', -999),
(174, 32, 34, '0', 5, '2024-02-12 09:48:26', NULL, 1, 'erafael@inarco.com.pe', -999),
(175, 32, 34, '1', 2, '2024-02-12 09:48:26', '2024-02-13 10:53:02', 3, 'jfrancisco@inarco.com.pe', 39),
(176, 32, 34, '0', 2, '2024-02-12 09:48:26', NULL, 1, 'dquispe@inarco.com.pe', -999),
(177, 32, 34, '1', 2, '2024-02-12 09:48:26', '2024-02-12 09:53:20', 1, 'ahermoza@inarco.com.pe', 90),
(178, 32, 34, '0', 2, '2024-02-12 09:48:26', NULL, 1, 'jrufasto@inarco.com.pe', -999),
(179, 32, 34, '0', 2, '2024-02-12 09:48:26', NULL, 1, 'vquiroz@inarco.com.pe', -999),
(180, 33, 34, '1', 10, '2024-02-16 11:22:49', '2024-04-04 13:07:10', 3, 'vjimenez@inarco.com.pe', 29),
(181, 33, 34, '1', 10, '2024-02-16 11:22:49', '2024-02-16 11:32:33', 3, 'jmasias@inarco.com.pe', 32),
(182, 33, 34, '1', 10, '2024-02-16 11:22:49', NULL, 3, 'bduelles@inarco.com.pe', 34),
(183, 33, 34, '0', 7, '2024-02-16 11:22:49', NULL, 3, 'ejurado@inarco.com.pe', -999),
(184, 33, 34, '0', 2, '2024-02-16 11:22:49', NULL, 2, 'avilchez@inarco.com.pe', -999),
(185, 33, 34, '0', 1, '2024-02-16 11:22:49', NULL, 3, 'wsanchez@inarco.com.pe', -999),
(186, 33, 34, '0', 9, '2024-02-16 11:22:49', NULL, 2, 'cyarleque@inarco.com.pe', -999),
(187, 33, 34, '0', 2, '2024-02-16 11:22:49', NULL, 2, 'jsarmiento@inarco.com.pe', -999),
(188, 33, 34, '0', 2, '2024-02-16 11:22:49', NULL, 2, 'nrea@inarco.com.pe', -999),
(189, 33, 34, '0', 2, '2024-02-16 11:22:49', NULL, 2, 'rfernandez@inarco.com.pe', -999),
(190, 33, 34, '0', 2, '2024-02-16 11:22:49', NULL, 2, 'mtuesta@inarco.com.p', -999),
(191, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 2, 'hmendoza@inarco.com.pe', -999),
(192, 33, 34, '0', 5, '2024-02-16 11:22:49', NULL, 2, 'milton@inarco.com.pe', -999),
(193, 33, 34, '0', 5, '2024-02-16 11:22:49', NULL, 2, 'macosta@inarco.com.pe', -999),
(194, 33, 34, '0', 5, '2024-02-16 11:22:49', NULL, 2, 'Yyrigoin@inarco.com.pe', -999),
(195, 33, 34, '0', 5, '2024-02-16 11:22:49', NULL, 2, 'erivas@inarco.com.pe', -999),
(196, 33, 34, '0', 6, '2024-02-16 11:22:49', NULL, 2, 'dcamargo@inarco.com.pe', -999),
(197, 33, 34, '0', 6, '2024-02-16 11:22:49', NULL, 2, 'dhernandez@inarco.com.pe', -999),
(198, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'llopez@inarco.com.pe', -999),
(199, 33, 34, '1', 3, '2024-02-16 11:22:49', '2024-02-19 13:50:10', 3, 'ralva@inarco.com.pe', 96),
(200, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'avidal@inarco.com.pe', 71),
(201, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'jccolca@inarco.com.pe', -999),
(202, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'dcucho@inarco.com.pe', -999),
(203, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'jocana@inarco.com.pe', -999),
(204, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'gllamosas@inarco.com.pe', -999),
(205, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'mchacmana@inarco.com.pe', 69),
(206, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'lvivas@inarco.com.pe', -999),
(207, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'vrojas@inarco.com.pe', -999),
(208, 33, 34, '1', 3, '2024-02-16 11:22:49', '2024-02-16 12:20:08', 3, 'vlopez@inarco.com.pe', 92),
(209, 33, 34, '0', 3, '2024-02-16 11:22:49', NULL, 3, 'fguerrero@inarco.com.pe', -999),
(210, 34, 34, '1', 10, '2024-02-16 11:44:55', '2024-04-04 13:07:10', 3, 'vjimenez@inarco.com.pe', 29),
(211, 34, 34, '1', 10, '2024-02-16 11:44:55', '2024-02-21 10:49:13', 3, 'jmasias@inarco.com.pe', 32),
(212, 34, 34, '1', 10, '2024-02-16 11:44:55', NULL, 3, 'bduelles@inarco.com.pe', 34),
(213, 34, 34, '0', 1, '2024-02-16 11:44:55', NULL, 3, 'Jose.leyva@inarco.com.pe', -999),
(214, 34, 34, '0', 2, '2024-02-16 11:44:55', NULL, 2, 'enaupac@inarco.com.pe', -999),
(215, 34, 34, '0', 2, '2024-02-16 11:44:55', NULL, 2, 'aore@inarco.com.pe', -999),
(216, 34, 34, '0', 2, '2024-02-16 11:44:55', NULL, 2, 'bgutierrez@inarco.com.pe', -999),
(217, 34, 34, '1', 2, '2024-02-16 11:44:55', '2024-02-16 12:01:47', 2, 'paviles@inarco.com.pe', 91),
(218, 34, 34, '0', 2, '2024-02-16 11:44:55', NULL, 2, 'awilbet@inarco.com', -999),
(219, 34, 34, '0', 2, '2024-02-16 11:44:55', NULL, 2, 'bzapata@inarco.com.pe', -999),
(220, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'lbarzola@inarco.com.pe', -999),
(221, 34, 34, '0', 4, '2024-02-16 11:44:55', NULL, 2, 'jportocarrero@inarco.com.pe', -999),
(222, 34, 34, '0', 6, '2024-02-16 11:44:55', NULL, 2, 'agarcia@inarco.com.pe', -999),
(223, 34, 34, '0', 5, '2024-02-16 11:44:55', NULL, 2, 'agarcia@inarco.com.pe', -999),
(224, 34, 34, '0', 5, '2024-02-16 11:44:55', NULL, 2, 'gutierrezsamaluis@gmail.com', -999),
(225, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'adeltorre@inarco.com.pe', -999),
(226, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'mmejia@inarco.com.pe', -999),
(227, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'rtenorio@inarco.com.pe', -999),
(228, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'ing.arveyaldean@gmail.com', -999),
(229, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 2, 'jestrada@inarco.com.pe', -999),
(230, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 2, 'emogrovejo@inarco.com.pe', -999),
(231, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 2, 'jcastro@inarco.com.pe', -999),
(232, 34, 34, '0', 9, '2024-02-16 11:44:55', NULL, 2, 'dgarcia@inarco.com.pe', -999),
(233, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 3, 'dbustamante@inarco.com.pe', -999),
(234, 34, 34, '0', 3, '2024-02-16 11:44:55', NULL, 2, 'pmiranda@inarco.com.pe', -999),
(235, 35, 34, '1', 10, '2024-02-16 12:12:44', '2024-04-04 13:07:10', 3, 'vjimenez@inarco.com.pe', 29),
(236, 35, 34, '1', 10, '2024-02-16 12:12:44', '2024-02-21 10:49:13', 3, 'jmasias@inarco.com.pe', 32),
(237, 35, 34, '1', 10, '2024-02-16 12:12:44', NULL, 3, 'bduelles@inarco.com.pe', 34),
(238, 35, 34, '0', 7, '2024-02-16 12:12:44', NULL, 3, 'jcustodio@inarco.com.pe', -999),
(239, 35, 34, '0', 1, '2024-02-16 12:12:44', NULL, 3, 'jrojas@inarco.com.pe', -999),
(240, 35, 34, '0', 5, '2024-02-16 12:12:44', NULL, 2, 'joseperez@inarco.com.pe', -999),
(241, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'jcastillo@inarco.com.pe', -999),
(242, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'mttica@inarco.com.pe', -999),
(243, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'lasmat@inarco.com.pe', -999),
(244, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'gilave@inarco.com.pe', -999),
(245, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'ddionicio@inarco.com.pe', -999),
(246, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'ronaldpaucar@inarco.com.pe', -999),
(247, 35, 34, '0', 2, '2024-02-16 12:12:44', NULL, 2, 'jmory@inarco.com.pe', -999),
(248, 35, 34, '0', 2, '2024-02-16 12:12:44', NULL, 2, 'mtumay@inarco.com.pe', -999),
(249, 35, 34, '0', 3, '2024-02-16 12:12:44', NULL, 3, 'fguerrero@inarco.com.pe', -999),
(250, 35, 34, '0', 2, '2024-02-16 12:12:44', NULL, 2, 'jftorres@inarco.com.pe', -999),
(251, 35, 34, '0', 2, '2024-02-16 12:12:44', NULL, 2, 'trea@inarco.com.pe', -999),
(252, 35, 34, '', 2, '2024-02-16 12:12:44', '2024-02-16 13:00:32', 2, 'emendoza@inarco.com.pe', 94),
(253, 35, 34, '1', 3, '2024-02-16 12:12:44', '2024-02-16 12:55:50', 2, 'mramirez@inarco.com.pe', 93),
(254, 35, 34, '0', 5, '2024-02-16 12:12:44', NULL, 2, 'mmarino@inarco.com.pe', -999),
(255, 35, 34, '0', 4, '2024-02-16 12:12:44', NULL, 2, 'yramirez@inarco.com.pe', -999),
(256, 35, 34, '0', 6, '2024-02-16 12:12:44', NULL, 2, 'knunez@inarco.com.pe', -999),
(257, 35, 34, '0', 9, '2024-02-16 12:12:44', NULL, 2, 'coord-penaloza@inarco.com.pe', -999),
(258, 31, 34, '1', 3, '2024-02-19 14:49:24', '2024-02-19 15:06:36', 3, 'vsaune@inarco.com.pe', 97),
(259, 31, 34, '1', 3, '2024-03-20 09:28:44', '2024-03-20 10:03:04', 3, 'lluyo@inarco.com.pe', 99),
(260, 4, 32, '1', 10, '2024-03-27 15:41:20', '2024-04-02 15:52:39', 3, 'xflores@inarco.com.pe', 101),
(261, 22, 34, '1', 10, '2024-03-27 17:34:27', '2024-03-28 08:26:15', 3, 'xberrocal@inarco.com.pe', 100),
(262, 31, 34, '1', 3, '2024-04-04 14:33:18', '2024-04-06 09:26:48', 3, 'ghernandez@inarco.com.pe', 103),
(263, 28, 34, '1', 10, '2024-04-04 14:36:40', '2024-04-04 14:37:38', 3, 'xberrocal@inarco.com.pe', 100),
(264, 31, 34, '1', 10, '2024-04-04 14:37:13', '2024-04-04 14:37:38', 3, 'xberrocal@inarco.com.pe', 100),
(265, 31, 34, '1', 10, '2024-04-04 14:44:27', '2024-04-04 14:48:41', 3, 'aprado@inarco.com.pe', 102),
(267, 28, 34, '1', 10, '2024-04-09 11:21:29', '2024-04-09 11:30:49', 3, 'xflores@inarco.com.pe', 101),
(270, 37, 34, '1', 7, '2024-04-19 10:52:25', '2024-04-23 08:24:33', 3, 'jlcollantes@inarco.com.pe', 108),
(271, 37, 34, '1', 1, '2024-04-19 10:52:25', '2024-04-19 11:46:55', 3, 'ddiaz@inarco.com.pe', 105),
(272, 37, 34, '1', 3, '2024-04-19 10:52:25', '2024-04-22 10:09:29', 3, 'jpucuhuayla@inarco.com.pe', 67),
(273, 37, 34, '1', 3, '2024-04-19 10:52:25', '2024-04-19 11:38:23', 3, 'rparedes@inarco.com.pe', 104),
(274, 37, 34, '1', 2, '2024-04-19 10:52:25', '2024-04-22 07:30:21', 2, 'hdonayre@inarco.com.pe', 54),
(275, 37, 34, '1', 6, '2024-04-19 10:52:25', '2024-04-30 07:47:32', 2, 'gguevara@inarco.com.pe', 109),
(276, 37, 34, '1', 4, '2024-04-19 10:52:25', '2024-04-22 14:53:50', 2, 'calvarez@inarco.com.pe', 106),
(277, 37, 34, '0', 2, '2024-04-19 10:52:25', NULL, 2, 'jfrancisco@inarco.com.pe', 39),
(278, 37, 34, '0', 5, '2024-04-19 10:52:25', NULL, 2, 'ccardenas@inarco.com.pe', -999),
(279, 37, 34, '0', 5, '2024-04-19 10:52:25', NULL, 2, 'rherrera@inarco.com.pe', -999),
(280, 37, 34, '1', 2, '2024-04-19 10:52:25', '2024-04-22 15:10:12', 2, 'rsoto@inarco.com.pe', 107),
(281, 37, 34, '1', 10, '2024-04-19 10:53:43', '2024-04-23 15:17:51', 2, 'vjimenez@inarco.com.pe', 29),
(282, 37, 34, '1', 10, '2024-04-19 10:53:43', '2024-04-22 14:48:02', 2, 'bduelles@inarco.com.pe', 34),
(283, 37, 34, '1', 3, '2024-05-03 15:53:43', '2024-05-03 15:57:27', 3, 'jlvelasquez@inarco.com.pe', 110),
(284, 31, 34, '0', 3, '2024-05-07 15:30:39', NULL, 3, 'aruiz@inarco.com.pe', -999),
(285, 31, 34, '1', 3, '2024-05-07 16:29:32', '2024-05-08 09:22:46', 3, 'jleandro@inarco.com.pe', 111),
(286, 38, 112, '1', 5, '2024-05-17 13:38:47', NULL, 3, 'darien.vr.98@gmail.com', 112);

-- --------------------------------------------------------

--
-- Table structure for table `proy_proyecto`
--

CREATE TABLE `proy_proyecto` (
  `codProyecto` bigint(20) NOT NULL,
  `desNombreProyecto` varchar(250) DEFAULT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `id` bigint(20) NOT NULL,
  `desEmpresa` varchar(100) DEFAULT NULL,
  `numPlazo` int(11) DEFAULT NULL,
  `numAreaTechado` decimal(25,2) DEFAULT NULL,
  `codTipoProyecto` bigint(20) NOT NULL,
  `codUbigeo` int(11) DEFAULT NULL,
  `dayFechaInicio` datetime DEFAULT NULL,
  `numMontoReferencial` varchar(255) DEFAULT NULL,
  `numAreaTechada` decimal(25,2) DEFAULT NULL,
  `numAreaConstruida` decimal(25,2) DEFAULT NULL,
  `desPais` varchar(255) DEFAULT NULL,
  `desDireccion` varchar(255) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` text DEFAULT NULL,
  `codMoneda` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `proy_proyecto`
--

INSERT INTO `proy_proyecto` (`codProyecto`, `desNombreProyecto`, `codEstado`, `id`, `desEmpresa`, `numPlazo`, `numAreaTechado`, `codTipoProyecto`, `codUbigeo`, `dayFechaInicio`, `numMontoReferencial`, `numAreaTechada`, `numAreaConstruida`, `desPais`, `desDireccion`, `dayFechaCreacion`, `desUsuarioCreacion`, `codMoneda`) VALUES
(1, 'Proyecto 001', 0, 19, '1', 12, '0.00', 1, 773, '2023-03-04 00:00:00', '50,200', '0.00', '45.00', 'Perú', NULL, '2024-02-04 23:44:55', 'diegowarthon1190@gmail.com, diegowarthonwh@gmail.com, bduelles@inarco.com.pe,', 3),
(2, 'SAMASS - 020', 0, 30, '20', 21, '23.00', 1, 1322, '2023-03-03 00:00:00', '5,000', '0.00', '454.00', 'Perú', NULL, '2023-03-23 03:58:44', 'diegowarthon1190@gmail.com, carlos@proyectoveremos.com,', 2),
(3, 'REF001 - 02', 0, 30, '23', 45, '12.00', 6, 1699, '2023-03-09 00:00:00', '7,512', '0.00', '48500.00', 'Perú', 'VILLA', '2023-03-23 10:58:14', 'diegowarthon1190@gmail.com,', 1),
(4, '201-MAZ', 0, 29, '22', 7, '0.00', 1, 1285, '2023-03-27 00:00:00', '1000', '0.00', '3500.00', 'Perú', 'Av. Juan Pablo Fernandini 996', '2024-03-27 15:41:20', 'bduelles@inarco.com.pe, jmasias@inarco.com.pe, mmiranda@inarco.com.pe, smalaver@inarco.com.pe, vjimenez@inarco.com.pe, gcondezo@inarco.com.pe, lluyo@inarco.com.pe, lleon@inarco.com.pe, cmorales@inarco.com.pe, cvega@inarco.com.pe, cbacalla@inarco.com.pe, Gsuarez@inarco.com.pe, afarfan@inarco.com.pe, rmeneses@inarco.com.pe, xflores@inarco.com.pe,', 1),
(5, '202-EDIF PRENSA', 1, 29, '22', 3, '1000.00', 3, 1296, '2023-03-27 00:00:00', '2000', '0.00', '2500.00', 'Perú', 'Montero Rosas, 1099, Lima', '2023-03-24 11:02:30', 'bduelles@inarco.com.pe, jmasias@inarco.com.pe, wibanez@inarco.com.pe, mlujan@inarco.com.pe, jfrancisco@inarco.com.pe, rreyes@inarco.com.pe, crobledo@inarco.com.pe, ecalderon@inarco.com.pe, vjimenez@inarco.com.pe,', 1),
(6, 'Proyecto 002', 0, 19, '1', 10, '54.00', 1, 107, '2023-06-08 00:00:00', '50', '0.00', '12.00', 'Perú', 'villa', '2023-06-25 01:10:59', 'diegowarthon1190@gmail.com,', 2),
(7, 'Proyecto Test 005', 0, 50, '1', 12, '0.00', 2, 773, '2023-07-14 00:00:00', '5,000', '0.00', '45.00', 'Perú', 'villa el salvador', '2023-07-01 23:25:41', 'diegowarthonwh@gmail.com, diegowarthon_wh@outlook.com, diegowarthon1190@gmail.com,', 2),
(9, 'proyecto 003', 0, 19, '1', 12, '45.00', 7, 773, '2023-08-10 00:00:00', '4500', '0.00', '45.00', 'Perú', 'nadsa', '2023-08-23 17:05:52', 'diegowarthon1190@gmail.com,', 2),
(10, 'proyecto 004', 0, 19, '1', 12, '45.00', 5, 344, '2023-08-11 00:00:00', '4545', '0.00', '54.00', 'Perú', 'asa', '2023-08-23 17:11:14', 'diegowarthon1190@gmail.com, diegowarthonwh@gmail.com,', 2),
(11, 'asas', 0, 19, '1', 12, '45.00', 6, 772, '2023-08-10 00:00:00', '12', '0.00', '45.00', 'Perú', 'assa', '2023-08-23 21:47:10', 'diegowarthon1190@gmail.com,', 1),
(14, '203 - TORRE PRENSA', 0, 34, '22', 324, '0.00', 7, 1281, '2023-08-07 00:00:00', '33,524,347', '0.00', '11562.00', 'Perú', NULL, '2024-01-22 11:00:11', 'vjimenez@inarco.com.pe, jasto@inarco.com.pe, dsanchez@inarco.com.pe, alarosa@inarco.com.pe, hdonayre@inarco.com.pe, csolis@inarco.com.pe, rreyes@inarco.com.pe, bduelles@inarco.com.pe, mescurra@inarco.com.pe, gcasiano@inarco.com.pe, adiaz@inarco.com.pe, cvega@inarco.com.pe, cliente@gmail.com.pe, kmejia@inarco.com.pe, jtello@inarco.com.pe, egomez@inarco.com.pe, jtello@inarco.com.pe,', 1),
(15, 'Proyecto Testing1', 0, 19, '1', 3, '0.00', 2, 657, '2023-09-06 00:00:00', '5,000', '0.00', '100.00', 'Perú', 'villa el salvador , veremos que tal', '2024-01-25 06:57:27', 'diegowarthonwh@gmail.com, diegowarthon1190@gmail.com,', 2),
(22, '205-SIMON BOLIVAR', 0, 32, '22', 275, '0.00', 2, 1308, '2023-10-02 00:00:00', '1.773.451.768', '0.00', '6797.00', 'Perú', NULL, '2024-04-18 10:32:15', 'gpino@inarco.com.pe, bloayza@inarco.com.pe, eborda@inarco.com.pe, randrade@inarco.com.pe, kaliaga@inarco.com.pe, ranton@inarco.com.pe, mclavijo@inarco.com.pe, jleyva@inarco.com.pe, vjimenez@inarco.com.pe, jmasias@inarco.com.pe, bduelles@inarco.com.pe, lrobles@inarco.com.pe, mlujan@inarco.com.pe, egomez@inarco.com.pe, calvarez@inarco.com.pe, ebeltran@inarco.com.pe, mpoma@inarco.com.pe, gmurillo@inarco.com.pe, avidal@inarco.com.pe, mchacmana@inarco.com.pe, anavarro@inarco.com.pe, cquispe@inarco.com.pe, cdedekind@inarco.com.pe, pcuenca@inarco.com.pe, ncarrion@inarco.com.pe, mroque@inarco.com.pe, mcastillo@inarco.com.pe, csantibañez@inarco.com.pe, dmarin@inarco.com.pe, iarcata@inarco.com.pe, mcolonio@inarco.com.pe, gcardenas@inarco.com.pe, mchacmana@inarco.com.pe, diegowarthon1190@gmail.com, xberrocal@inarco.com.pe,', 1),
(23, '204-ROSA MERINO', 1, 32, '22', 275, '0.00', 2, 1308, '2023-10-02 00:00:00', '20.314.949', '0.00', '7657.00', 'Perú', NULL, '2023-10-09 18:21:39', 'vjimenez@inarco.com.pe, bduelles@inarco.com.pe, jmasias@inarco.com.pe, wibanez@inarco.com.pe, erojas@inarco.com.pe, aore@inarco.com.pe, mlujan@inarco.com.pe, ddionicio@inarco.com.pe, jccolcca@inarco.com.pe, mpena@inarco.com.pe, jangeles@inarco.com.pe,', 1),
(28, '206-HENKO', 0, 34, '22', 14, '0.00', 1, 1302, '2024-01-12 00:00:00', '100,000', '0.00', '1000.00', 'Peru', 'Miraflores, Lima, Lima', '2024-04-09 11:21:29', 'egomez@inarco.com.pe, bduelles@inarco.com.pe, vjimenez@inarco.com.pe, cvega@inarco.com.pe, mpena@inarco.com.pe, pllanos@inarco.com.pe, jtrejo@inarco.com.pe, apaez@inarco.com.pe, lweill@inarco.com.pe, dcortez@inarco.com.pe, gpiscoya@inarco.com.pe, eanamaria@inarco.com.pe, aramirez@inarco.com.pe, phuayhua@inarco.com.pe, xberrocal@inarco.com.pe, xflores@inarco.com.pe,', 1),
(29, 'PROYECTO TEST 5', 0, 19, '1', 2, '45.00', 2, 1322, '2023-12-07 00:00:00', '1500', '0.00', '211.00', 'Perú', 'NADA', '2023-12-13 17:13:04', 'diegowarthonwh@gmail.com,', 2),
(30, 'test--01', 0, 19, '1', 12, '45.00', 1, 1699, '2023-12-13 00:00:00', '5000', '0.00', '45.00', 'Perú', 'villa', '2023-12-14 00:35:36', 'diegowarthonwh@gmail.com,', 3),
(31, '210-FRANCO PERUANO', 0, 34, '22', 8, '0.00', 2, 1320, '2024-01-29 00:00:00', '1', '0.00', '1.00', 'Perú', 'SURCO LIMA', '2024-05-07 16:29:32', 'cvega@inarco.com.pe, bduelles@inarco.com.pe, vjimenez@inarco.com.pe, dperez@inarco.com.pe, ozagazeta@inarco.com.pe, dfigueroa@inarco.com.pe, rtincallpa@inarco.com.pe, lvilla@inarco.com.pe, fochoa@inarco.com.pe, flezama@inarco.com.pe, rmeneses@inarco.com.pe, vsaune@inarco.com.pe, lluyo@inarco.com.pe, ghernandez@inarco.com.pe, xberrocal@inarco.com.pe, aprado@inarco.com.pe, aruiz@inarco.com.pe, jleandro@inarco.com.pe,', 1),
(32, '198-SLM E2', 0, 34, '22', 1, '0.00', 6, 1294, '2024-01-08 00:00:00', '1', '0.00', '1.00', 'Peru', 'La Molina', '2024-02-15 17:26:20', 'vjimenez@inarco.com.pe, jmasias@inarco.com.pe, bduelles@inarco.com.pe, mullauri@inarco.com.pe, mfelix@inarco.com.pe, jvelasquez@inarco.com.pe, mclavijo@inarco.com.pe, nmanrique@inarco.com.pe, smaldonado@inarco.com.pe, oportella@inarco.com.pe, erafael@inarco.com.pe, jfrancisco@inarco.com.pe, dquispe@inarco.com.pe, ahermoza@inarco.com.pe, jrufasto@inarco.com.pe, vquiroz@inarco.com.pe,', 1),
(33, '208-G.PRADA', 0, 34, '22', 306, '0.00', 2, 1283, '2023-11-20 00:00:00', '1', '0.00', '1.00', 'Perú', 'HUAYCAN', '2024-02-16 11:37:56', 'vjimenez@inarco.com.pe, jmasias@inarco.com.pe, bduelles@inarco.com.pe, ejurado@inarco.com.pe, avilchez@inarco.com.pe, wsanchez@inarco.com.pe, cyarleque@inarco.com.pe, jsarmiento@inarco.com.pe, nrea@inarco.com.pe, rfernandez@inarco.com.pe, mtuesta@inarco.com.p, hmendoza@inarco.com.pe, milton@inarco.com.pe, macosta@inarco.com.pe, Yyrigoin@inarco.com.pe, erivas@inarco.com.pe, dcamargo@inarco.com.pe, dhernandez@inarco.com.pe, llopez@inarco.com.pe, ralva@inarco.com.pe, avidal@inarco.com.pe, jccolca@inarco.com.pe, dcucho@inarco.com.pe, jocana@inarco.com.pe, gllamosas@inarco.com.pe, mchacmana@inarco.com.pe, lvivas@inarco.com.pe, vrojas@inarco.com.pe, vlopez@inarco.com.pe, fguerrero@inarco.com.pe,', 1),
(34, '207-G.MOHME', 0, 34, '22', 258, '1.00', 2, 1283, '2023-11-20 00:00:00', '1', '0.00', '1.00', 'Peru', 'HUAYCAN', '2024-02-16 11:44:55', 'vjimenez@inarco.com.pe, jmasias@inarco.com.pe, bduelles@inarco.com.pe, Jose.leyva@inarco.com.pe, enaupac@inarco.com.pe, aore@inarco.com.pe, bgutierrez@inarco.com.pe, paviles@inarco.com.pe, awilbet@inarco.com, bzapata@inarco.com.pe, lbarzola@inarco.com.pe, jportocarrero@inarco.com.pe, agarcia@inarco.com.pe, agarcia@inarco.com.pe, gutierrezsamaluis@gmail.com, adeltorre@inarco.com.pe, mmejia@inarco.com.pe, rtenorio@inarco.com.pe, ing.arveyaldean@gmail.com, jestrada@inarco.com.pe, emogrovejo@inarco.com.pe, jcastro@inarco.com.pe, dgarcia@inarco.com.pe, dbustamante@inarco.com.pe, pmiranda@inarco.com.pe,', 1),
(35, '209-W.PEÑALOZA', 0, 34, '22', 289, '1.00', 2, 1283, '2023-11-20 00:00:00', '1', '0.00', '1.00', 'Perú', 'HUAYCAN', '2024-02-16 12:12:44', 'vjimenez@inarco.com.pe, jmasias@inarco.com.pe, bduelles@inarco.com.pe, jcustodio@inarco.com.pe , jrojas@inarco.com.pe, joseperez@inarco.com.pe, jcastillo@inarco.com.pe, mttica@inarco.com.pe, lasmat@inarco.com.pe, gilave@inarco.com.pe, ddionicio@inarco.com.pe, ronaldpaucar@inarco.com.pe, jmory@inarco.com.pe, mtumay@inarco.com.pe, fguerrero@inarco.com.pe, jftorres@inarco.com.pe, trea@inarco.com.pe, emendoza@inarco.com.pe, mramirez@inarco.com.pe, mmarino@inarco.com.pe, yramirez@inarco.com.pe, knunez@inarco.com.pe, coord-penaloza@inarco.com.pe,', 1),
(37, '211-UPCH', 0, 34, '22', 14, '0.00', 2, 1294, '2024-04-08 00:00:00', '1,000,000', '0.00', '10000.00', 'Perú', 'universidad cayetano heredia', '2024-05-08 15:36:19', 'jlcollantes@inarco.com.pe, ddiaz@inarco.com.pe, jpucuhuayla@inarco.com.pe, rparedes@inarco.com.pe, hdonayre@inarco.com.pe, gguevara@inarco.com.pe, calvarez@inarco.com.pe, jfrancisco@inarco.com.pe, ccardenas@inarco.com.pe, rherrera@inarco.com.pe, rsoto@inarco.com.pe, vjimenez@inarco.com.pe, bduelles@inarco.com.pe, jlvelasquez@inarco.com.pe,', 1),
(38, 'Proyecto 01', 0, 112, '24', 5, '500.00', 3, 1281, '2024-05-20 00:00:00', '50,000', '0.00', '350.00', 'Perú', 'Av. Test 123', '2024-05-17 13:38:47', 'darien.vr.98@gmail.com,', 0);

-- --------------------------------------------------------

--
-- Table structure for table `proy_proyectoconf`
--

CREATE TABLE `proy_proyectoconf` (
  `codProyectoconf` bigint(20) NOT NULL,
  `codProyecto` bigint(20) NOT NULL,
  `codTipoDiaProgramacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proy_proyectoconf`
--

INSERT INTO `proy_proyectoconf` (`codProyectoconf`, `codProyecto`, `codTipoDiaProgramacion`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 2),
(5, 5, 2),
(6, 6, 1),
(7, 7, 1),
(8, 9, 1),
(9, 10, 1),
(10, 11, 2),
(12, 14, 1),
(13, 15, 2),
(14, 22, 2),
(15, 23, 1),
(19, 28, 0),
(20, 29, 1),
(21, 30, 1),
(22, 31, 0),
(23, 32, 0),
(24, 33, 0),
(25, 34, 0),
(26, 35, 0),
(28, 37, 0);

-- --------------------------------------------------------

--
-- Table structure for table `proy_proyectoreportes`
--

CREATE TABLE `proy_proyectoreportes` (
  `codUtilReportes` int(11) NOT NULL,
  `codProyecto` bigint(20) NOT NULL,
  `flagReporteMasivo` int(11) DEFAULT NULL,
  `codTipoFrecuencia` char(2) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `desCorreoEnvios` varchar(255) DEFAULT NULL,
  `codfrecuenciaenvioreporte` int(11) DEFAULT NULL,
  `flagApplyAllStatus` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `proy_proyectoreportes`
--

INSERT INTO `proy_proyectoreportes` (`codUtilReportes`, `codProyecto`, `flagReporteMasivo`, `codTipoFrecuencia`, `dayFechaCreacion`, `desUsuarioCreacion`, `desCorreoEnvios`, `codfrecuenciaenvioreporte`, `flagApplyAllStatus`) VALUES
(147, 2, 1, 'LV', '2023-03-23 03:58:44', '', '', 3, NULL),
(148, 3, 1, 'LS', '2023-03-23 10:58:14', '', '', 3, NULL),
(150, 5, 1, 'LS', '2023-03-24 10:39:28', '', '', 3, NULL),
(151, 6, 1, 'LV', '2023-06-25 01:10:59', '', '', 1, NULL),
(152, 7, 0, 'LV', '2023-07-01 16:05:25', '', NULL, 1, NULL),
(153, 7, 1, 'LV', '2023-07-01 16:05:25', '', '', 1, NULL),
(156, 9, 0, 'LV', '2023-08-23 17:05:52', '', 'diegowarthon1190@gmail.com', 2, NULL),
(157, 10, 1, 'LV', '2023-08-23 17:11:14', '', '', 2, NULL),
(158, 11, 1, 'LS', '2023-08-23 21:47:10', '', '', 2, NULL),
(164, 23, 1, 'LV', '2023-10-05 11:57:40', '', '', 1, NULL),
(168, 29, 1, 'LV', '2023-12-13 17:13:04', '', '', 2, NULL),
(169, 30, 1, 'LV', '2023-12-14 00:35:36', '', '', 1, NULL),
(160, 14, 1, 'LV', '2023-08-29 12:37:21', '', '', 1, NULL),
(161, 15, 1, 'LS', '2023-09-20 09:57:30', '', '', 3, NULL),
(146, 1, 1, 'LV', '2023-03-22 04:07:05', '', '', 3, NULL),
(149, 4, 1, 'LS', '2023-03-23 11:34:54', '', '', 3, NULL),
(163, 22, 1, 'LS', '2023-10-05 11:53:25', '', '', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `proy_rolintegrante`
--

CREATE TABLE `proy_rolintegrante` (
  `codRolIntegrante` int(11) NOT NULL,
  `desRolIntegrante` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `proy_rolintegrante`
--

INSERT INTO `proy_rolintegrante` (`codRolIntegrante`, `desRolIntegrante`) VALUES
(1, 'Visualizador'),
(2, 'Editor'),
(3, 'Administrador'),
(8, 'Cliente');

-- --------------------------------------------------------

--
-- Table structure for table `proy_tipoproyecto`
--

CREATE TABLE `proy_tipoproyecto` (
  `codTipoProyecto` bigint(20) NOT NULL,
  `desTipoProyecto` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proy_tipoproyecto`
--

INSERT INTO `proy_tipoproyecto` (`codTipoProyecto`, `desTipoProyecto`) VALUES
(1, 'Vivienda'),
(2, 'Educativo'),
(3, 'Industrial'),
(4, 'Hospitales'),
(5, 'Hoteleros'),
(6, 'Retails'),
(7, 'Obras Civiles');

-- --------------------------------------------------------

--
-- Table structure for table `rrhh_ingresopersonal`
--

CREATE TABLE `rrhh_ingresopersonal` (
  `codProyecto` bigint(20) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `indNoRetrasados` int(11) DEFAULT NULL,
  `indRetrasados` int(11) DEFAULT NULL,
  `codRrHh` bigint(20) NOT NULL,
  `desColOcultas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `rrhh_ingresopersonal`
--

INSERT INTO `rrhh_ingresopersonal` (`codProyecto`, `codEstado`, `dayFechaCreacion`, `desUsuarioCreacion`, `indNoRetrasados`, `indRetrasados`, `codRrHh`, `desColOcultas`) VALUES
(1, 0, '2024-02-04 23:44:55', 'diego@gmail.com', 0, 0, 159, NULL),
(2, 0, '2023-03-23 03:58:44', 'armando@remasa.com.pe', 0, 0, 160, NULL),
(3, 0, '2023-03-23 10:58:14', 'armando@remasa.com.pe', 0, 0, 161, NULL),
(4, 0, '2024-03-27 15:41:20', 'vjimenez@inarco.com.pe', 0, 0, 162, NULL),
(5, 0, '2023-03-24 11:02:30', 'vjimenez@inarco.com.pe', 0, 0, 163, NULL),
(6, 0, '2023-06-25 01:10:59', 'diego@gmail.com', 0, 0, 164, NULL),
(7, 0, '2023-07-01 23:25:41', 'diegowarthonwh@gmail.com', 0, 0, 165, NULL),
(9, 0, '2023-08-23 17:05:52', 'diego@gmail.com', 0, 0, 166, NULL),
(10, 0, '2023-08-23 17:11:14', 'diego@gmail.com', 0, 0, 167, NULL),
(11, 0, '2023-08-23 21:47:10', 'diego@gmail.com', 0, 0, 168, NULL),
(14, 0, '2024-01-22 11:00:11', 'bduelles@inarco.com.pe', 0, 0, 169, NULL),
(15, 0, '2024-01-25 06:57:27', 'diego@gmail.com', 0, 0, 170, NULL),
(22, 0, '2024-04-18 10:32:15', 'jmasias@inarco.com.pe', 0, 0, 171, NULL),
(23, 0, '2023-10-09 18:21:39', 'jmasias@inarco.com.pe', 0, 0, 172, NULL),
(28, 0, '2024-04-09 11:21:29', 'bduelles@inarco.com.pe', 0, 0, 173, NULL),
(29, 0, '2023-12-13 17:13:04', 'diego@gmail.com', 0, 0, 174, NULL),
(30, 0, '2023-12-14 00:35:36', 'diego@gmail.com', 0, 0, 175, NULL),
(31, 0, '2024-05-07 16:29:32', 'bduelles@inarco.com.pe', 0, 0, 176, NULL),
(32, 0, '2024-02-15 17:26:20', 'bduelles@inarco.com.pe', 0, 0, 177, NULL),
(33, 0, '2024-02-16 11:37:56', 'bduelles@inarco.com.pe', 0, 0, 178, NULL),
(34, 0, '2024-02-16 11:44:55', 'bduelles@inarco.com.pe', 0, 0, 179, NULL),
(35, 0, '2024-02-16 12:12:44', 'bduelles@inarco.com.pe', 0, 0, 180, NULL),
(37, 0, '2024-05-08 15:36:19', 'bduelles@inarco.com.pe', 0, 0, 181, NULL),
(38, 0, '2024-05-17 13:38:47', 'darien.vr.98@gmail.com', 0, 0, 182, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rrhh_integrantes`
--

CREATE TABLE `rrhh_integrantes` (
  `codProyecto` bigint(20) NOT NULL,
  `codRrHh` bigint(20) NOT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `dayFechaCreacion` datetime DEFAULT NULL,
  `desUsuarioCreacion` varchar(255) DEFAULT NULL,
  `codProyIntegrante` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `rrhh_integrantes`
--

INSERT INTO `rrhh_integrantes` (`codProyecto`, `codRrHh`, `codEstado`, `dayFechaCreacion`, `desUsuarioCreacion`, `codProyIntegrante`) VALUES
(1, 159, 1, '2024-02-04 23:44:55', '', NULL),
(2, 160, 1, '2023-03-23 03:58:44', '', NULL),
(3, 161, 1, '2023-03-23 10:58:14', '', NULL),
(4, 162, 1, '2024-03-27 15:41:20', '', NULL),
(5, 163, 1, '2023-03-24 11:02:30', '', NULL),
(6, 164, 1, '2023-06-25 01:10:59', '', NULL),
(7, 165, 1, '2023-07-01 23:25:41', '', NULL),
(9, 166, 1, '2023-08-23 17:05:52', '', NULL),
(10, 167, 1, '2023-08-23 17:11:14', '', NULL),
(11, 168, 1, '2023-08-23 21:47:10', '', NULL),
(14, 169, 1, '2024-01-22 11:00:11', '', NULL),
(15, 170, 1, '2024-01-25 06:57:27', '', NULL),
(22, 171, 1, '2024-04-18 10:32:15', '', NULL),
(23, 172, 1, '2023-10-09 18:21:39', '', NULL),
(28, 173, 1, '2024-04-09 11:21:29', '', NULL),
(29, 174, 1, '2023-12-13 17:13:04', '', NULL),
(30, 175, 1, '2023-12-14 00:35:36', '', NULL),
(31, 176, 1, '2024-05-07 16:29:32', '', NULL),
(32, 177, 1, '2024-02-15 17:26:20', '', NULL),
(33, 178, 1, '2024-02-16 11:37:56', '', NULL),
(34, 179, 1, '2024-02-16 11:44:55', '', NULL),
(35, 180, 1, '2024-02-16 12:12:44', '', NULL),
(37, 181, 1, '2024-05-08 15:36:19', '', NULL),
(38, 182, 1, '2024-05-17 13:38:47', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sec_cargo`
--

CREATE TABLE `sec_cargo` (
  `codCargo` int(11) NOT NULL,
  `nameCargo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `sec_cargo`
--

INSERT INTO `sec_cargo` (`codCargo`, `nameCargo`) VALUES
(1, 'Encargado'),
(2, 'Trabajador'),
(3, 'General');

-- --------------------------------------------------------

--
-- Table structure for table `sec_membresia`
--

CREATE TABLE `sec_membresia` (
  `codMembresia` bigint(20) NOT NULL,
  `desMembresia` varchar(255) DEFAULT NULL,
  `canDiasPrueba` int(11) DEFAULT NULL,
  `desMonto` varchar(255) DEFAULT NULL,
  `canProyectos` int(11) DEFAULT NULL,
  `desFrecuencia` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `sec_membresiausuario`
--

CREATE TABLE `sec_membresiausuario` (
  `codMembresiaUsuario` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  `codMembresia` bigint(20) NOT NULL,
  `dayFechaInicio` datetime DEFAULT NULL,
  `dayFechaFin` datetime DEFAULT NULL,
  `codEstado` int(11) DEFAULT NULL,
  `des_PagoVerificado` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `celular` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `nombreempresa` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `codCargo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `celular`, `lastname`, `nombreempresa`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `codCargo`) VALUES
(19, 'diego', '9875414', 'prueba', 'SODIMAC', 'diego@gmail.com', NULL, '$2y$10$pB.pgzhJ36NxpREl30IFhumBCAOAouupfSP/8EqSzUWFHdub6V/4q', NULL, '2023-03-15 05:59:05', '2023-03-15 05:59:05', 1),
(29, 'Victor', '998842295', 'Jimenez', 'CONSTRUCTORA INARCO PERÚ', 'vjimenez@inarco.com.pe', NULL, '$2y$10$TPXvKCM19VhPfXRiguZCi.W80Q31czRRMSPPdQNK8ElUYBEFZRE0y', NULL, '2023-03-21 15:42:22', '2023-10-02 12:06:35', 3),
(30, 'armando', '986455454', 'jaramillo', 'REMASA', 'armando@remasa.com.pe', NULL, '$2y$10$sBWEop7jE.h6ZOl8zTiBnOjNOMASEluXtPsFuQSEOQaFA5ndodLCG', NULL, '2023-03-23 08:19:55', '2023-03-23 08:19:55', 3),
(31, 'Alvaro Emilio', '947123070', 'Diaz Calderon', 'CONSTRUCTORA INARCO PERÚ', 'adiaz@inarco.com.pe', NULL, '$2y$10$MEiv1RFE2BavkRGARLbGtOj8qmFZJp0w8T.GFRD7qG1iN9bSBb1ky', NULL, '2023-03-23 22:18:58', '2023-03-23 22:18:58', 3),
(32, 'Juan Diego', '945097787', 'Masias', 'CONSTRUCTORA INARCO PERÚ', 'jmasias@inarco.com.pe', NULL, '$2y$10$vhGNdD2B6iUOXBfqfZYTbuUKV.CrR3P.BmvrYgDwdQIujDiCkgw36', NULL, '2023-03-23 23:18:40', '2024-01-18 13:18:43', 3),
(33, 'Martin', '946215490', 'Lujan', 'CONSTRUCTORA INARCO PERÚ', 'mlujan@inarco.com.pe', NULL, '$2y$10$2Z3GpTj2we1IU3kjkQgDyet0atZI6wR1Os5LkL673xnqsnPC.9Z2q', NULL, '2023-03-24 16:10:23', '2023-03-24 16:10:23', 3),
(34, 'Bryan Steve', '945841799', 'Duelles Panta', 'CONSTRUCTORA INARCO PERÚ', 'bduelles@inarco.com.pe', NULL, '$2y$10$FP.5PDgwixoImJnk3btO4eu5KEgjuQRnmE1Zq4gS.D1/fAOh5byDy', NULL, '2023-03-24 16:32:37', '2023-04-24 20:19:39', 3),
(35, 'Walter', '943187915', 'Ibañez Hernandez', 'CONSTRUCTORA INARCO PERÚ', 'wibanez@inarco.com.pe', NULL, '$2y$10$iM4Zc7m/Xrei2u2kE4bXred6tx3/mQv7PDaFGGdgSlMiUgWN9.Nu.', NULL, '2023-03-24 16:44:02', '2023-03-24 16:44:02', 3),
(36, 'Percy', '997401940', 'Humala Barbier', 'CONSTRUCTORA INARCO PERÚ', 'phumala@inarco.com.pe', NULL, '$2y$10$Lnv1U79k87ybBl6QEs8ZOe0ZN53Fcl7qWVc2mlBH504qPJ6c7mFVq', NULL, '2023-03-25 17:00:30', '2023-06-19 10:33:49', 3),
(37, 'MICHEL', '904111693', 'ESCURRA MIO', 'CONSTRUCTORA INARCO PERÚ', 'mescurra@inarco.com.pe', NULL, '$2y$10$A9.sqJhAXex1Er1r4Ru/k.VzBcuwG9FYXOBAdS.LpYYCtrAUHB.pW', NULL, '2023-03-25 17:13:41', '2023-03-25 17:13:41', 3),
(38, 'DIEGO 3', '842454', 'VEREMOA', 'EMPRESA UNO', 'diegowarthon1190@gmail.com', NULL, '$2y$10$w1qZvbQyvLcb5IrliEENseBlrkjss04C7WkJ.1mMPVo/oA5zDYVpu', NULL, '2023-03-26 19:24:03', '2023-04-25 07:16:18', 3),
(39, 'JUAN ARTURO', '940460317', 'FRANCISCO BARBOZA', 'CONSTRUCTORA INARCO PERÚ', 'jfrancisco@inarco.com.pe', NULL, '$2y$10$oCqf18x29dlRyf6cVj7E0ecxJC8cW1WAEIwzyOMk.aGilKHNskHM2', NULL, '2023-04-10 23:01:03', '2023-04-17 13:56:12', 3),
(40, 'cristina', '656456', 'veremoa', 'CONSTRUCTORA INARCO PERÚ', 'reynaevelyn1709@gmail.com', NULL, '$2y$10$8piBxqw9jweJXJ.daMGzbubWXb2ycOWYNtKwAsdaUdUqzdB.cBzgS', NULL, '2023-04-10 23:58:52', '2023-04-10 23:58:52', 3),
(41, 'pepe', '978975454', 'veremos', 'CONSTRUCTORA INARCO PERÚ', 'pepe.silva.merea@gmail.com', NULL, '$2y$10$9FbBnm7rMwcrhTpUXCdEZuD8ZW25xc/zHH7KEV4oRbCjglMEW6Nd2', NULL, '2023-04-11 00:21:17', '2023-04-11 00:21:17', 3),
(42, 'doiego', '454', 'wads', 'SODIMAC', 'diegowarthon1190@gm', NULL, '$2y$10$CThQM6sctHANs9yzjPh/Cu91e6LguJ0Pd/JDdBo27jr4ciWEkCk1S', NULL, '2023-04-11 01:40:56', '2023-04-11 01:40:56', 3),
(43, 'diego', '7878', 'asasa', 'KAYSER', 'diegowarthon1190@gmai', NULL, '$2y$10$nLnCP9Y0KpMuln3iEcAoOuHYQMBXPa0p2DT8j2/FcuVHgIoYRx0rC', NULL, '2023-04-11 20:30:19', '2023-04-11 20:30:19', 3),
(44, 'Rosa Luz', '997208079', 'Reyes Ramos', 'CONSTRUCTORA INARCO PERÚ', 'rreyes@inarco.com.pe', NULL, '$2y$10$JteKWPiQn8p6XtBwhxuTJ.WX2EY65jpMExlFZeQn/M9pH3xxvtvnW', NULL, '2023-04-24 20:39:45', '2023-04-24 20:39:45', 3),
(45, 'Crosvi Rafael', '962374759', 'Robledo Vasquez', 'CONSTRUCTORA INARCO PERÚ', 'crobledo@inarco.com.pe', NULL, '$2y$10$00yCC4RhbJU4WeUh9Zn7Lep1nd01I/UvFN9fCuDfgSm.AljjhssdG', NULL, '2023-05-04 17:58:51', '2023-09-11 10:48:24', 3),
(46, 'Ricardo', '969027746', 'Meneses', 'CONSTRUCTORA INARCO PERÚ', 'rmeneses@inarco.com.pe', NULL, '$2y$10$d6XdNScYxOszpl8xxDjRXOnuBAi0ncBEw.63Gzh2xblbpMc5FjRJu', NULL, '2023-05-23 15:15:00', '2023-05-23 15:15:00', 3),
(47, 'Manuel', '918331536', 'Jaco', 'CONSTRUCTORA INARCO PERÚ', 'mjaco23@gmail.com', NULL, '$2y$10$p37jptYglC0aAobOHbiL/uNUomBazs4y6w/WFFAL4kYMMFXfrykJi', NULL, '2023-05-23 21:15:50', '2023-05-23 21:15:50', 3),
(48, 'Manuel', '918331536', 'Jaco', 'CONSTRUCTORA INARCO PERÚ', 'mmiranda@inarco.com.pe', NULL, '$2y$10$A29jjgwAoJ4e3zc21cLkBON5OIglQPXA5eKqVz.BZRKvMz4bbDhQ2', NULL, '2023-05-30 15:29:15', '2023-05-30 15:29:15', 3),
(49, 'Saul', '997666644', 'Malaver Soto', 'CONSTRUCTORA INARCO PERÚ', 'smalaver@inarco.com.pe', NULL, '$2y$10$KfLNcHbaWkLMIuj2vFmMO.srlb1NDNe6ADj7hFIn8vaYD0MrdC9n.', NULL, '2023-06-06 11:00:54', '2023-06-06 11:00:54', 3),
(50, 'DARMANDO', '989741584', 'WARTHON', 'SODIMAC', 'diegowarthonwh@gmail.com', NULL, '$2y$10$Mn8aS6RjxnqjhDlZQ6b1WOHlzapveNKUP03akteUye8t3J9u/BgEe', NULL, '2023-07-01 15:56:51', '2023-07-01 15:56:51', 3),
(51, 'Dayana', '999127255', 'Sánchez Cuadros', 'CONSTRUCTORA INARCO PERÚ', 'dsanchez@inarco.com.pe', NULL, '$2y$10$/senlkpvf8w/MmdDBFF4HOqGf.UlBv.jRZLF/vezb0Wb10B06cE8C', NULL, '2023-08-23 16:51:19', '2024-05-07 15:50:11', 3),
(52, 'Alexis', '976807733', 'La Rosa', 'CONSTRUCTORA INARCO PERÚ', 'alarosa@inarco.com.pe', NULL, '$2y$10$iGqrML0U5h1Chq5PWZAUl.WDFgrkqOS55TIT7m/1jBPpVaSpH9MuG', NULL, '2023-08-25 18:53:46', '2023-08-25 18:53:46', 3),
(53, 'CESAR', '977155998', 'SOLIS', 'CONSTRUCTORA INARCO PERÚ', 'csolis@inarco.com.pe', NULL, '$2y$10$h/mS52VZ6NClKmSc90Ud8.hBYmiMcuaONEcr4iVVG2IRjrb5Acnsu', NULL, '2023-08-31 14:14:29', '2023-08-31 14:14:29', 3),
(54, 'Harry Dani', '991922469', 'Donayre Hernández', 'CONSTRUCTORA INARCO PERÚ', 'hdonayre@inarco.com.pe', NULL, '$2y$10$nydyRnT81RT2ldp.yk6b5OlxnjE6oSuAsekLXJVtGVNAMssbzmE/i', NULL, '2023-08-31 14:20:39', '2023-08-31 14:20:39', 3),
(55, 'Jhonson', '943800610', 'Asto', 'CONSTRUCTORA INARCO PERÚ', 'jasto@inarco.com.pe', NULL, '$2y$10$wVtDyRdOhcLQ0Q9lW6FUA.7uoDDIZIOpPzEk5IHGFPdsBBXd8l60K', NULL, '2023-08-31 14:27:11', '2023-08-31 14:27:11', 3),
(56, 'Gabriel', '993965870', 'Casiano', 'CONSTRUCTORA INARCO PERÚ', 'gcasiano@inarco.com.pe', NULL, '$2y$10$z2hxdM0VrXDrhuLmg/peh.Zg541lwBSHt1b/KaAyigf5aJVLXdAZW', NULL, '2023-09-01 17:01:17', '2023-09-01 17:01:17', 3),
(57, 'Cesar', '969164623', 'Morales Santos', 'CONSTRUCTORA INARCO PERÚ', 'cmorales@inarco.com.pe', NULL, '$2y$10$80oeePS2O6RL7DJQbbSVV.ZFFVUqNZbVSeFGUNMDXRIbgfPw.b5kq', NULL, '2023-09-20 13:12:41', '2023-09-20 13:12:41', 3),
(58, 'luis', '959683256', 'leon', 'CONSTRUCTORA INARCO PERÚ', 'lleon@inarco.com.pe', NULL, '$2y$10$ChGjyuG0XR7j9MM14LoSbOr4BjPksL2mumMP3TIWvMUpjWqvD8ZBu', NULL, '2023-09-26 10:46:50', '2023-09-26 10:46:50', 3),
(59, 'NORMA', '980669746', 'MANRIQUE', 'CONSTRUCTORA INARCO PERÚ', 'nmanrique@inarco.com.pe', NULL, '$2y$10$BtHk1DjOCIMRgd/J5yRaquABG6QqOzRTWXkdLh.j6EXt6HoM1ujAm', NULL, '2023-09-29 11:04:43', '2023-09-29 11:04:43', 3),
(60, 'GUILLERMO', '965913417', 'CONDEZO', 'CONSTRUCTORA INARCO PERÚ', 'gcondezo@inarco.com.pe', NULL, '$2y$10$XqOTxw3AhtpSSFn90k68/uvq3cDlllyFyVDgL0WOnZhM6VyPSk2nS', NULL, '2023-10-06 10:34:42', '2023-10-06 10:34:42', 3),
(61, 'Gustavo', '966007773', 'Pino', 'CONSTRUCTORA INARCO PERÚ', 'gpino@inarco.com.pe', NULL, '$2y$10$EYDx9oCPsm55dVxlOlhVZOMUh3Kre.J/eZGQncg6ut8fQ5PN2qse.', NULL, '2023-10-07 08:13:20', '2024-01-02 14:53:43', 3),
(62, 'Bryan Kevin', '970377694', 'Loayza Murillo', 'CONSTRUCTORA INARCO PERÚ', 'bloayza@inarco.com.pe', NULL, '$2y$10$fZ/Hl3mc0zWAD0eQGERTP.R6nKTmFdDYDorN2Z95oh1jzMy25cpi6', NULL, '2023-10-07 10:16:21', '2023-10-07 10:16:21', 3),
(63, 'Marisa', '917741003', 'Ríos', 'CONSTRUCTORA INARCO PERÚ', 'mariccsa@hotmail.com', NULL, '$2y$10$X5hnetwX.rWze1lSRQWM9OrHVd1U3wmeh6WDXrdxBt.ImBVG9NYsW', NULL, '2023-10-09 16:15:28', '2023-10-09 16:15:28', 3),
(64, 'Kenji', '959513166', 'Mejia', 'CONSTRUCTORA INARCO PERÚ', 'kmejia@inarco.com.pe', NULL, '$2y$10$ctjLxKhzEyq1zNmPE6P9tedzTO8xYY7eNlQhcya4u4kj/gcBGMjJm', NULL, '2023-11-27 16:25:12', '2023-11-27 16:25:12', 3),
(65, 'Hugo Eduardo', '926272190', 'Gómez Angulo', 'CONSTRUCTORA INARCO PERÚ', 'egomez@inarco.com.pe', NULL, '$2y$10$j5oqOn6NzOdPAbxtd0hiaucboJx/hzOr9pDHWixATGlOzk7QB8AXW', NULL, '2023-12-06 11:10:53', '2024-01-08 17:32:46', 3),
(66, 'Cleydi Arelis', '951708582', 'Bacalla Silva', 'CONSTRUCTORA INARCO PERÚ', 'Cbacalla@inarco.com.pe', NULL, '$2y$10$j93MA8PurVcycmJmeIF5runX8QfI8RumI12xkOyDjwQbZ.kBTphn.', NULL, '2023-12-18 12:21:23', '2023-12-18 12:21:23', 3),
(67, 'Jefferson', '969786420', 'Pucuhuayla', 'CONSTRUCTORA INARCO PERÚ', 'jpucuhuayla@inarco.com.pe', NULL, '$2y$10$zoBct8AgoDj1YOODTmARauivNUSNqNlTExBnSH37c1zxMjtr2Y.oq', NULL, '2024-01-02 15:09:29', '2024-01-02 15:09:29', 3),
(68, 'Estefani', '921724953', 'Beltran', 'CONSTRUCTORA INARCO PERÚ', 'ebeltran@inarco.com.pe', NULL, '$2y$10$SMRP7s1.i3ljJQ7J5lQDMOEyB5Uij5PACg7wV9zVs0pQW8lELCrru', NULL, '2024-01-02 15:15:23', '2024-01-02 15:26:29', 3),
(69, 'MANUEL', '948859122', 'CHACMANA JIMENEZ', 'CONSTRUCTORA INARCO PERÚ', 'mchacmana@inarco.com.pe', NULL, '$2y$10$LPB.1HH9nCi0f3UdmxhMteRePIdz8nPaF2EcgJ9aZkbBs6LyxPx.i', NULL, '2024-01-02 15:20:15', '2024-01-02 15:20:15', 3),
(70, 'LUIS MIGUEL ANGEL', '947525158', 'ROBLES ANCAJIMA', 'CONSTRUCTORA INARCO PERÚ', 'lrobles@inarco.com.pe', NULL, '$2y$10$yw2s3H/vGFnpKeRlxnxoD..vSe7EJY8ax5GmKV5CvXmg1ZOqVOMEe', NULL, '2024-01-03 21:27:49', '2024-01-03 21:27:49', 3),
(71, 'Alejandro', '910615370', 'Vidal', 'CONSTRUCTORA INARCO PERÚ', 'avidal@inarco.com.pe', NULL, '$2y$10$7.h1mg7QkkGDiw/vodD2teZS6RsuL1YIzXKk7jGvLBbbA4faZut4G', NULL, '2024-01-07 10:14:45', '2024-01-07 10:14:45', 3),
(72, 'Diana', '923434889', 'Figueroa Baldeón', 'CONSTRUCTORA INARCO PERÚ', 'dfigueroa@inarco.com.pe', NULL, '$2y$10$Kg3tutrtY4yBJ0EdackkJeE6VTk7hx2eyaeHH3tYk9jVDm2lXYyqK', NULL, '2024-01-12 11:53:21', '2024-01-12 11:53:21', 3),
(73, 'Marino', '997920283', 'Peña', 'CONSTRUCTORA INARCO PERÚ', 'mpena@inarco.com.pe', NULL, '$2y$10$i.y.UwQ62mW.KgllzO.m8OnpenwfKYGym4nN9/YcWJC5Z.FZrrzaS', NULL, '2024-01-12 12:58:57', '2024-01-12 12:58:57', 3),
(74, 'Paul', '993545208', 'Llanos', 'CONSTRUCTORA INARCO PERÚ', 'pllanos@inarco.com.pe', NULL, '$2y$10$Mcj6ZpXQVpBggF91jwFyg.Hy9WjzKn8A4URHXkVcWbzrv1HWyVtBy', NULL, '2024-01-12 12:58:59', '2024-01-12 12:58:59', 3),
(75, 'Alvaro Lucio', '993722857', 'Paez Laureano', 'CONSTRUCTORA INARCO PERÚ', 'apaez@inarco.com.pe', NULL, '$2y$10$yWaQtBb5vF12HrDBhifH/uo2QW4.vWN63ECBSxTZOi13KFprxHnai', NULL, '2024-01-12 13:00:11', '2024-05-11 11:18:06', 3),
(76, 'Daniel', '965909114', 'Cortez', 'CONSTRUCTORA INARCO PERÚ', 'dcortez@inarco.com.pe', NULL, '$2y$10$1bdjH3U7JK/xtzHXQ6m0gemFK5hWwr5OWIR56JWlFCDHcHGmAYiwy', NULL, '2024-01-12 14:49:33', '2024-01-12 14:49:33', 3),
(77, 'Edwin', '978082926', 'Anamaria', 'CONSTRUCTORA INARCO PERÚ', 'eanamaria@inarco.com.pe', NULL, '$2y$10$dWyilwx/8r3PA1wy243iu.6oifRoIBtaDvE4EFY5spVNIAfnTzzJC', NULL, '2024-01-12 14:50:34', '2024-05-11 12:06:52', 3),
(78, 'Juneor', '981504302', 'Trejo', 'CONSTRUCTORA INARCO PERÚ', 'jtrejo@inarco.com.pe', NULL, '$2y$10$X0m3DX198.maCprGIkw2eunPpeN4PDev2ig9BNi17wmb9.ehv3fky', NULL, '2024-01-12 14:51:20', '2024-01-12 14:51:20', 3),
(79, 'Ana Marcela', '976224244', 'Ramirez Preguntegui', 'CONSTRUCTORA INARCO PERÚ', 'aramirez@inarco.com.pe', NULL, '$2y$10$BhGgfk69GlAH7lUO3jJt5Oj1QaYb63NEP.pS6cXrrCfxRYQVVqETu', NULL, '2024-01-12 15:46:24', '2024-02-06 09:04:09', 3),
(80, 'Norma Giannina', '950168380', 'Piscoya Rios', 'CONSTRUCTORA INARCO PERÚ', 'gpiscoya@inarco.com.pe', NULL, '$2y$10$pNPyQlR1f7vNt0KHjwqdgecWUgdbg7HV7a33V.PhENIOU/5iPTDIK', NULL, '2024-01-12 15:46:50', '2024-01-12 15:46:50', 3),
(81, 'Luis', '364467190', 'Weill Marquez', 'CONSTRUCTORA INARCO PERÚ', 'lweill@inarco.com.pe', NULL, '$2y$10$g0rSZxhB8tj9D9UQd3Zu3O2zFH1MmpmP4WGdZYvXlHN4A/3ELCB3e', NULL, '2024-01-12 15:47:19', '2024-01-12 15:47:19', 3),
(82, 'Pedro Enrique', '983267207', 'Huayhua Coronado', 'CONSTRUCTORA INARCO PERÚ', 'phuayhua@inarco.com.pe', NULL, '$2y$10$AJ4G9KKkqgG7qPG8CxGLre4jgrDJOXcBclsoaw4IOY6Jy2YG0v/di', NULL, '2024-01-12 15:49:04', '2024-01-12 15:49:04', 3),
(83, 'Alexander', '987752269', 'Farfán Ascorbe', 'CONSTRUCTORA INARCO PERÚ', 'afarfan@inarco.com.pe', NULL, '$2y$10$C7bn.MRN7jcU4N1r3lyMS.8CeD2GQ3D/33fQJTesiLXd98Uyzk1rO', NULL, '2024-01-13 09:54:30', '2024-01-13 09:54:30', 3),
(84, 'Roberto', '978911220', 'Tincallpa', 'CONSTRUCTORA INARCO PERÚ', 'rtincallpa@inarco.com.pe', NULL, '$2y$10$zE2uRyLSVfYl2F8bYfX7DuBHFkrrcc3C9Eep0yEfQnhTEEcoVJ.0a', NULL, '2024-01-22 13:45:19', '2024-01-22 13:45:19', 3),
(85, 'Daniel', '997403692', 'Pérez', 'CONSTRUCTORA INARCO PERÚ', 'dperez@inarco.com.pe', NULL, '$2y$10$oe1tUzoShLcgFYVJ0uU66eh2XGcX5z4IDpKN1PRfX3ZO/AFdBPzf2', NULL, '2024-01-22 15:12:05', '2024-01-22 15:12:05', 3),
(86, 'LUIS MIGUEL', '989571953', 'VILLA CABALLERO', 'CONSTRUCTORA INARCO PERÚ', 'lvilla@inarco.com.pe', NULL, '$2y$10$G/ROmBalw8nnDslzPqSYAOxZJNcUv8R2pjA.Lfzm.XWylMV6KMuz.', NULL, '2024-01-23 14:12:41', '2024-01-23 14:12:41', 3),
(87, 'Luis Felipe', '985055530', 'Lezama Briceño', 'CONSTRUCTORA INARCO PERÚ', 'flezama@inarco.com.pe', NULL, '$2y$10$jxzLAGnb6xzxEOLszFp01uVcTtAF5HYyRcW9hUqbZu1MjJLxZBwg2', NULL, '2024-01-23 15:29:44', '2024-01-23 15:29:44', 3),
(88, 'Oscar Amador', '984471864', 'Zagazeta Oré', 'CONSTRUCTORA INARCO PERÚ', 'ozagazeta@inarco.com.pe', NULL, '$2y$10$UnBL2esAU5P68QhOJ8d76.9RxpGGGWxSJLi7xG9xqcF.eS9.39/w.', NULL, '2024-02-10 12:52:59', '2024-02-10 12:52:59', 3),
(89, 'Felipein', '963757177', 'Ochoa', 'CONSTRUCTORA INARCO PERÚ', 'fochoa@inarco.com.pe', NULL, '$2y$10$rZ7OSPwxxh7CASuqQVOxD.PCaFP4T8CpMP.SKp2bP90UR2pDxWKAu', NULL, '2024-02-10 14:23:27', '2024-02-10 14:23:27', 3),
(90, 'ALCIDES', '987590211', 'HERMOZA', 'CONSTRUCTORA INARCO PERÚ', 'ahermoza@inarco.com.pe', NULL, '$2y$10$9yhbRQL0xYMzy6YopOz3E.4urxwDbZw08fGSXgfBLwnxd3r1hFiCG', NULL, '2024-02-12 09:53:10', '2024-02-12 09:53:10', 3),
(91, 'PEDRO', '977910512', 'AVILES', 'CONSTRUCTORA INARCO PERÚ', 'paviles@inarco.com.pe', NULL, '$2y$10$iys6JpjlHO1K8SBtRQvxY.W.cYGFEHIsfYB.kOWQZc1UiDF5xBmpm', NULL, '2024-02-16 12:01:21', '2024-02-16 12:01:21', 3),
(92, 'VRENNY', '923857642', 'LOPEZ', 'CONSTRUCTORA INARCO PERÚ', 'vlopez@inarco.com.pe', NULL, '$2y$10$5Z1gHexgOcQ4WyXtHQeTAOHMhsRtbcU8Mi0G80Or5v1LP7WXcKbmq', NULL, '2024-02-16 12:03:15', '2024-02-16 12:03:15', 3),
(93, 'Melissa Alexandra', '994447292', 'Ramirez Zorrilla', 'CONSTRUCTORA INARCO PERÚ', 'mramirez@inarco.com.pe', NULL, '$2y$10$1VEYaPhO4/8raVyXGwVLn.4E0VL9XhC7Vyr5zNpXpbKtRa43X/CFa', NULL, '2024-02-16 12:55:22', '2024-02-16 12:55:22', 3),
(94, 'emerson', '983557118', 'mendoza', 'CONSTRUCTORA INARCO PERÚ', 'emendoza@inarco.com.pe', NULL, '$2y$10$xvmcbIOYry3CTK9wKrtHB.wualmr1qRYWCQkqVzEiVEVglg/qXsmu', NULL, '2024-02-16 13:00:14', '2024-02-16 13:00:14', 3),
(95, 'Arvey', '986780901', 'Aldeán', 'CONSTRUCTORA INARCO PERÚ', 'aaldean@inarco.com.pe', NULL, '$2y$10$xd3Hz.q4ZDbiiTJzfQPVBe1hCF5ILSdDU/GXRo2L.yAqEQIs/C38u', NULL, '2024-02-16 17:45:42', '2024-02-16 17:45:42', 3),
(96, 'Ing. Ricardo', '900207861', 'Alva Caceres', 'CONSTRUCTORA INARCO PERÚ', 'ralva@inarco.com.pe', NULL, '$2y$10$rjRyy6cY9FfnjWj8aBvgyeBxkV72T9/eRQgi04vIi6.Qnxx09fR2a', NULL, '2024-02-19 13:49:55', '2024-02-19 13:49:55', 3),
(97, 'victor rafael', '949366892', 'sauñe quispe', 'CONSTRUCTORA INARCO PERÚ', 'vsaune@inarco.com.pe', NULL, '$2y$10$1OROO.xKJNva4iEOeHYlr.5TgQ.M.jsrTQxe1TY.lHb8wmViUzZmu', NULL, '2024-02-19 15:06:00', '2024-02-19 15:06:00', 3),
(98, 'Miguel', '983274950', 'Felix', 'CONSTRUCTORA INARCO PERÚ', 'mfelix@inarco.com.pe', NULL, '$2y$10$cF5HCWvWUExQJhoXsSWq5uxyDXq/0Ivk2LeH4JdHfT11Rx7e4ozvK', NULL, '2024-03-19 15:46:07', '2024-03-19 15:46:07', 3),
(99, 'Luis', '977141101', 'Luyo', 'CONSTRUCTORA INARCO PERÚ', 'lluyo@inarco.com.pe', NULL, '$2y$10$O13a7V0r.DcdZpgM4YDyJORX4VIXDSVzftJiai6J6PK/Mq4jMsviW', NULL, '2024-03-20 10:02:53', '2024-03-20 10:02:53', 3),
(100, 'Xiomara Alessandra', '917085072', 'Berrocal Sánchez', 'CONSTRUCTORA INARCO PERÚ', 'xberrocal@inarco.com.pe', NULL, '$2y$10$TN6UOylNUFRSMziUK6i/4uCg.wup87V86xAV.aCfP1eE7F7hEK.o.', NULL, '2024-03-28 08:21:41', '2024-03-28 08:21:41', 3),
(101, 'Ximena', '999306476', 'Flores', 'CONSTRUCTORA INARCO PERÚ', 'xflores@inarco.com.pe', NULL, '$2y$10$uKkGY3CrHGcogaBeratUfup0CpvpY/AogoqAVxmgr3tHFtsz69Bk6', NULL, '2024-04-02 15:52:28', '2024-04-02 15:52:28', 3),
(102, 'Arturo', '949193777', 'Prado', 'CONSTRUCTORA INARCO PERÚ', 'aprado@inarco.com.pe', NULL, '$2y$10$OoQtw79yj3wGRTTFPvzBC.Ik5.h0dEbJU/1BKU9vixhl.c30ldLNm', NULL, '2024-04-04 14:48:19', '2024-04-04 14:48:19', 3),
(103, 'Gotardo', '999113412', 'Hernández Ramos', 'CONSTRUCTORA INARCO PERÚ', 'ghernandez@inarco.com.pe', NULL, '$2y$10$.7wxcgAa.lqn5NFIcqzZLe6aUE0q1nwdPBPTCjmyG5Csfu5uAQDIa', NULL, '2024-04-06 09:26:34', '2024-04-06 09:26:34', 3),
(104, 'Rafael', '913513498', 'Paredes', 'CONSTRUCTORA INARCO PERÚ', 'rparedes@inarco.com.pe', NULL, '$2y$10$xweOMDm1WhJwx1f4SknkwubOYbfGlZoRN/IkR8mlxclA19q5qNjii', NULL, '2024-04-19 07:43:37', '2024-04-19 07:43:37', 3),
(105, 'Demel', '997914043', 'Diaz', 'CONSTRUCTORA INARCO PERÚ', 'ddiaz@inarco.com.pe', NULL, '$2y$10$06ZflVCk76vpIR/.B0dumedBIGR0jIhcOMyiYio95HIx4sTpqSyEC', NULL, '2024-04-19 11:46:31', '2024-04-19 11:46:31', 3),
(106, 'CARLOS AUGUSTO', '992741149', 'ALVAREZ RIVERA', 'CONSTRUCTORA INARCO PERÚ', 'calvarez@inarco.com.pe', NULL, '$2y$10$ynXENyLOinLc32A7Cb.aOuo78RS3ryrLLHOGz48u.K0uFlXkI/WOK', NULL, '2024-04-22 14:53:10', '2024-04-22 14:53:10', 3),
(107, 'Rocio', '955955276', 'Soto Huamán', 'CONSTRUCTORA INARCO PERÚ', 'rsoto@inarco.com.pe', NULL, '$2y$10$J8fhMaYJ/JYXG0FCaQeluulm3nXLfxim8Nim2OL91/pJccS2mqvyu', NULL, '2024-04-22 15:03:58', '2024-04-22 15:03:58', 3),
(108, 'José Luis', '920207628', 'Collantes', 'CONSTRUCTORA INARCO PERÚ', 'jlcollantes@inarco.com.pe', NULL, '$2y$10$ybX3yzaLY3MWas4Nz7VQ5uMNO/Vp077kEHaUdeQuNUD7h.mfF6L8q', NULL, '2024-04-23 08:23:36', '2024-04-23 08:23:36', 3),
(109, 'YELENY', '963829702', 'GUEVARA', 'CONSTRUCTORA INARCO PERÚ', 'gguevara@inarco.com.pe', NULL, '$2y$10$MxAZ3xOqcqsWeCr1Ycf/yeiWVBY0g2RYEewTtNt5y9qoEXCFWJG92', NULL, '2024-04-30 07:47:06', '2024-05-06 15:11:11', 3),
(110, 'Jorge Luis', '987822751', 'Velasquez Espinoza', 'CONSTRUCTORA INARCO PERÚ', 'jlvelasquez@inarco.com.pe', NULL, '$2y$10$bep0YRCa.gRz2CR5bfIrEe/RayOLme9gzRLnStK6v3gMHXG5ULIU2', NULL, '2024-05-03 15:51:59', '2024-05-03 15:51:59', 3),
(111, 'JAVIER', '965397859', 'LEANDRO VASQUEZ', 'CONSTRUCTORA INARCO PERÚ', 'jleandro@inarco.com.pe', NULL, '$2y$10$GG8tHVytJWWDt9aN.xRmnO93dJkgOj3SZjhTMuRurGinO33FlhrC.', NULL, '2024-05-08 09:22:26', '2024-05-08 09:22:26', 3),
(112, 'Darien', '987654321', 'Villanueva', 'Test01', 'darien.vr.98@gmail.com', NULL, '$2y$10$05TaBmcyNnxFdYabufm7Ye6ol8dti2MLm51Xu9NH/W.KgIdcXIS/6', NULL, '2024-05-17 13:35:40', '2024-05-17 13:35:40', 3);

-- --------------------------------------------------------

--
-- Table structure for table `util_reportes`
--

CREATE TABLE `util_reportes` (
  `codUtilReportes` int(11) NOT NULL,
  `desUtilReportes` varchar(255) DEFAULT NULL,
  `desDirReporte` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `util_reportes`
--

INSERT INTO `util_reportes` (`codUtilReportes`, `desUtilReportes`, `desDirReporte`) VALUES
(1, 'Reporte de análisis de restricciones', NULL),
(5, 'Reporte de análisis de restricciones', NULL),
(10, 'Reporte de análisis de restricciones', NULL),
(11, 'Reporte de avance gráfico', NULL),
(12, 'Reporte de análisis de restricciones', NULL),
(13, 'Reporte de avance gráfico', NULL),
(14, 'Reporte de análisis de restricciones', NULL),
(15, 'Reporte de avance gráfico', NULL),
(16, 'Reporte de análisis de restricciones', NULL),
(17, 'Reporte de análisis de restricciones', NULL),
(18, 'Reporte de avance gráfico', NULL),
(19, 'Reporte de análisis de restricciones', NULL),
(36, 'Reporte de análisis de restricciones', NULL),
(37, 'Reporte de análisis de restricciones', NULL),
(38, 'Reporte de análisis de restricciones', NULL),
(39, 'Reporte de avance gráfico', NULL),
(40, 'Reporte de análisis de restricciones', NULL),
(41, 'Reporte de análisis de restricciones', NULL),
(42, 'Reporte de análisis de restricciones', NULL),
(43, 'Reporte de análisis de restricciones', NULL),
(44, 'Reporte de análisis de restricciones', NULL),
(45, 'Reporte de análisis de restricciones', NULL),
(46, 'Reporte de análisis de restricciones', NULL),
(47, 'Reporte de análisis de restricciones', NULL),
(48, 'Reporte de análisis de restricciones', NULL),
(49, 'Reporte de análisis de restricciones', NULL),
(50, 'Reporte de análisis de restricciones', NULL),
(51, 'Reporte de análisis de restricciones', NULL),
(52, 'Reporte de análisis de restricciones', NULL),
(53, 'Reporte de análisis de restricciones', NULL),
(54, 'Reporte de análisis de restricciones', NULL),
(55, 'Reporte de análisis de restricciones', NULL),
(56, 'Reporte de análisis de restricciones', NULL),
(57, 'Reporte de análisis de restricciones', NULL),
(58, 'Reporte de análisis de restricciones', NULL),
(59, 'Reporte de análisis de restricciones', NULL),
(60, 'Reporte de análisis de restricciones', NULL),
(61, 'Reporte de análisis de restricciones', NULL),
(62, NULL, NULL),
(63, 'Reporte de análisis de restricciones', NULL),
(64, 'Reporte de análisis de restricciones', NULL),
(65, 'Reporte de análisis de restricciones', NULL),
(66, 'Reporte de análisis de restricciones', NULL),
(67, 'Reporte de análisis de restricciones', NULL),
(68, 'Reporte de análisis de restricciones', NULL),
(69, 'Reporte de análisis de restricciones', NULL),
(70, 'Reporte de análisis de restricciones', NULL),
(71, 'Reporte de análisis de restricciones', NULL),
(72, 'Reporte de análisis de restricciones', NULL),
(73, 'Reporte de análisis de restricciones', NULL),
(74, 'Reporte de análisis de restricciones', NULL),
(75, 'Reporte de análisis de restricciones', NULL),
(76, 'Reporte de análisis de restricciones', NULL),
(77, 'Reporte de análisis de restricciones', NULL),
(78, 'Reporte de avance gráfico', NULL),
(79, 'Reporte de análisis de restricciones', NULL),
(80, 'Reporte de análisis de restricciones', NULL),
(81, 'Reporte de análisis de restricciones', NULL),
(82, 'Reporte de análisis de restricciones', NULL),
(83, 'Reporte de análisis de restricciones', NULL),
(84, 'Reporte de análisis de restricciones', NULL),
(85, 'Reporte de análisis de restricciones', NULL),
(86, 'Reporte de análisis de restricciones', NULL),
(87, NULL, NULL),
(88, 'Reporte de análisis de restricciones', NULL),
(89, 'Reporte de análisis de restricciones', NULL),
(90, 'Reporte de análisis de restricciones', NULL),
(91, 'Reporte de análisis de restricciones', NULL),
(92, 'Reporte de análisis de restricciones', NULL),
(93, 'Reporte de análisis de restricciones', NULL),
(94, 'Reporte de análisis de restricciones', NULL),
(95, 'Reporte de análisis de restricciones', NULL),
(96, 'Reporte de análisis de restricciones', NULL),
(97, 'Reporte de análisis de restricciones', NULL),
(98, 'Reporte de análisis de restricciones', NULL),
(99, 'Reporte de análisis de restricciones', NULL),
(100, 'Reporte de análisis de restricciones', NULL),
(101, 'Reporte de análisis de restricciones', NULL),
(102, 'Reporte de análisis de restricciones', NULL),
(103, 'Reporte de análisis de restricciones', NULL),
(104, 'Reporte de análisis de restricciones', NULL),
(105, 'Reporte de análisis de restricciones', NULL),
(106, 'Reporte de análisis de restricciones', NULL),
(107, 'Reporte de análisis de restricciones', NULL),
(108, 'Reporte de análisis de restricciones', NULL),
(109, NULL, NULL),
(110, 'Reporte de análisis de restricciones', NULL),
(111, 'Reporte de análisis de restricciones', NULL),
(112, 'Reporte de análisis de restricciones', NULL),
(113, 'Reporte de análisis de restricciones', NULL),
(114, 'Reporte de análisis de restricciones', NULL),
(115, 'Reporte de análisis de restricciones', NULL),
(116, 'Reporte de análisis de restricciones', NULL),
(117, 'Reporte de análisis de restricciones', NULL),
(118, 'Reporte de análisis de restricciones', NULL),
(119, 'Reporte de análisis de restricciones', NULL),
(120, 'Reporte de análisis de restricciones', NULL),
(121, 'Reporte de análisis de restricciones', NULL),
(122, 'Reporte de análisis de restricciones', NULL),
(123, 'Reporte de análisis de restricciones', NULL),
(124, 'Reporte de análisis de restricciones', NULL),
(125, 'Reporte de análisis de restricciones', NULL),
(126, 'Reporte de análisis de restricciones', NULL),
(127, 'Reporte de avance gráfico', NULL),
(128, 'Reporte de análisis de restricciones', NULL),
(129, 'Reporte de análisis de restricciones', NULL),
(130, 'Reporte de análisis de restricciones', NULL),
(131, 'Reporte de análisis de restricciones', NULL),
(132, 'Reporte de análisis de restricciones', NULL),
(133, 'Reporte de análisis de restricciones', NULL),
(134, 'Reporte de análisis de restricciones', NULL),
(135, 'Reporte de análisis de restricciones', NULL),
(136, 'Reporte de análisis de restricciones', NULL),
(137, 'Reporte de análisis de restricciones', NULL),
(138, 'Reporte de análisis de restricciones', NULL),
(139, 'Reporte de análisis de restricciones', NULL),
(140, NULL, NULL),
(141, 'Reporte de análisis de restricciones', NULL),
(142, 'Reporte de análisis de restricciones', NULL),
(143, 'Reporte de análisis de restricciones', NULL),
(144, 'Reporte de análisis de restricciones', NULL),
(145, 'Reporte de análisis de restricciones', NULL),
(146, 'Reporte de análisis de restricciones', NULL),
(147, 'Reporte de análisis de restricciones', NULL),
(148, 'Reporte de análisis de restricciones', NULL),
(149, 'Reporte de análisis de restricciones', NULL),
(150, 'Reporte de análisis de restricciones', NULL),
(151, 'Reporte de análisis de restricciones', NULL),
(152, 'Reporte de análisis de restricciones', NULL),
(153, 'Reporte de análisis de restricciones', NULL),
(154, 'Reporte de análisis de restricciones', NULL),
(155, NULL, NULL),
(156, 'Reporte de análisis de restricciones', NULL),
(157, 'Reporte de análisis de restricciones', NULL),
(158, 'Reporte de análisis de restricciones', NULL),
(159, 'Reporte de análisis de restricciones', NULL),
(160, 'Reporte de análisis de restricciones', NULL),
(161, 'Reporte de análisis de restricciones', NULL),
(162, 'Reporte de análisis de restricciones', NULL),
(163, 'Reporte de análisis de restricciones', NULL),
(164, 'Reporte de análisis de restricciones', NULL),
(165, 'Reporte de análisis de restricciones', NULL),
(166, 'Reporte de análisis de restricciones', NULL),
(167, 'Reporte de análisis de restricciones', NULL),
(168, 'Reporte de análisis de restricciones', NULL),
(169, 'Reporte de análisis de restricciones', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anares_actividad`
--
ALTER TABLE `anares_actividad`
  ADD PRIMARY KEY (`codAnaResActividad`);

--
-- Indexes for table `anares_actividad_tracking`
--
ALTER TABLE `anares_actividad_tracking`
  ADD KEY `anares_actividad_tracking_codAnaResActividadTrack_IDX2` (`codAnaResActividadTrack`) USING BTREE;

--
-- Indexes for table `anares_analisisrestricciones`
--
ALTER TABLE `anares_analisisrestricciones`
  ADD PRIMARY KEY (`codAnaRes`) USING BTREE;

--
-- Indexes for table `anares_analisis_tiporestricciones`
--
ALTER TABLE `anares_analisis_tiporestricciones`
  ADD KEY `AnaRes_Analisis_TipoRestricciones_R_01` (`codAnaRes`);

--
-- Indexes for table `anares_fase`
--
ALTER TABLE `anares_fase`
  ADD PRIMARY KEY (`codAnaResFase`) USING BTREE,
  ADD UNIQUE KEY `XPKAnaRes_Fase` (`codAnaResFase`,`codAnaResFrente`,`codProyecto`,`codAnaRes`) USING BTREE,
  ADD KEY `XIF1AnaRes_Fase` (`codAnaResFrente`,`codProyecto`,`codAnaRes`) USING BTREE;

--
-- Indexes for table `anares_frente`
--
ALTER TABLE `anares_frente`
  ADD PRIMARY KEY (`codAnaResFrente`) USING BTREE;

--
-- Indexes for table `conf_colacorreos`
--
ALTER TABLE `conf_colacorreos`
  ADD PRIMARY KEY (`codColaCorreo`);

--
-- Indexes for table `conf_maestro_empresas`
--
ALTER TABLE `conf_maestro_empresas`
  ADD PRIMARY KEY (`cod_Empresa`);

--
-- Indexes for table `conf_moneda`
--
ALTER TABLE `conf_moneda`
  ADD PRIMARY KEY (`codMoneda`);

--
-- Indexes for table `conf_tipodiaprogramacion`
--
ALTER TABLE `conf_tipodiaprogramacion`
  ADD PRIMARY KEY (`codTipoDiaProgramacion`);

--
-- Indexes for table `conf_ubigeo`
--
ALTER TABLE `conf_ubigeo`
  ADD UNIQUE KEY `XPKConf_Ubigeo` (`codUbigeo`) USING BTREE;

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`) USING BTREE;

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `other_notificaciones`
--
ALTER TABLE `other_notificaciones`
  ADD UNIQUE KEY `XPKother_Notificaciones` (`codNotificacion`) USING BTREE;

--
-- Indexes for table `other_notificaciones_usuario`
--
ALTER TABLE `other_notificaciones_usuario`
  ADD PRIMARY KEY (`codNotificacionUsuario`),
  ADD UNIQUE KEY `XPKother_Notificaciones_Usuario` (`id`,`codNotificacion`) USING BTREE,
  ADD KEY `XIF1other_Notificaciones_Usuario` (`id`) USING BTREE,
  ADD KEY `XIF2other_Notificaciones_Usuario` (`codNotificacion`) USING BTREE;

--
-- Indexes for table `other_notificaciones_usuario2`
--
ALTER TABLE `other_notificaciones_usuario2`
  ADD UNIQUE KEY `XPKother_Notificaciones_Usuario` (`codNotificacionUsuario`,`id`,`codNotificacion`) USING BTREE,
  ADD KEY `XIF1other_Notificaciones_Usuario` (`id`) USING BTREE,
  ADD KEY `XIF2other_Notificaciones_Usuario` (`codNotificacion`) USING BTREE,
  ADD KEY `XIF3other_Notificaciones_Usuario` (`codNotificacionUsuario`) USING BTREE;

--
-- Indexes for table `other_notificaciones_usuario4`
--
ALTER TABLE `other_notificaciones_usuario4`
  ADD UNIQUE KEY `XPKother_Notificaciones_Usuario` (`codNotificacionUsuario`,`id`,`codNotificacion`) USING BTREE,
  ADD KEY `XIF1other_Notificaciones_Usuario` (`id`) USING BTREE,
  ADD KEY `XIF2other_Notificaciones_Usuario` (`codNotificacion`) USING BTREE,
  ADD KEY `XIF3other_Notificaciones_Usuario` (`codNotificacionUsuario`) USING BTREE;

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`) USING BTREE;

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`) USING BTREE,
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`) USING BTREE;

--
-- Indexes for table `proy_areaintegrante`
--
ALTER TABLE `proy_areaintegrante`
  ADD PRIMARY KEY (`codArea`);

--
-- Indexes for table `proy_integrantes`
--
ALTER TABLE `proy_integrantes`
  ADD PRIMARY KEY (`codProyIntegrante`) USING BTREE;

--
-- Indexes for table `proy_proyecto`
--
ALTER TABLE `proy_proyecto`
  ADD UNIQUE KEY `XPKProy_Proyecto` (`codProyecto`) USING BTREE,
  ADD KEY `XIF1Proy_Proyecto` (`id`) USING BTREE,
  ADD KEY `XIF2Proy_Proyecto` (`codUbigeo`) USING BTREE;

--
-- Indexes for table `proy_proyectoconf`
--
ALTER TABLE `proy_proyectoconf`
  ADD PRIMARY KEY (`codProyectoconf`);

--
-- Indexes for table `proy_rolintegrante`
--
ALTER TABLE `proy_rolintegrante`
  ADD UNIQUE KEY `XPKProy_RolIntegrante` (`codRolIntegrante`) USING BTREE;

--
-- Indexes for table `proy_tipoproyecto`
--
ALTER TABLE `proy_tipoproyecto`
  ADD PRIMARY KEY (`codTipoProyecto`) USING BTREE;

--
-- Indexes for table `rrhh_ingresopersonal`
--
ALTER TABLE `rrhh_ingresopersonal`
  ADD PRIMARY KEY (`codRrHh`) USING BTREE;

--
-- Indexes for table `sec_cargo`
--
ALTER TABLE `sec_cargo`
  ADD UNIQUE KEY `XPKSec_Cargo` (`codCargo`) USING BTREE;

--
-- Indexes for table `sec_membresia`
--
ALTER TABLE `sec_membresia`
  ADD UNIQUE KEY `XPKSec_Membresia` (`codMembresia`) USING BTREE;

--
-- Indexes for table `sec_membresiausuario`
--
ALTER TABLE `sec_membresiausuario`
  ADD UNIQUE KEY `XPKSec_MembresiaUsuario` (`codMembresiaUsuario`,`id`,`codMembresia`) USING BTREE,
  ADD KEY `XIF1Sec_MembresiaUsuario` (`id`) USING BTREE,
  ADD KEY `XIF2Sec_MembresiaUsuario` (`codMembresia`) USING BTREE;

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `XPKusersidunique` (`id`) USING BTREE,
  ADD UNIQUE KEY `users_email_unique` (`email`) USING BTREE,
  ADD UNIQUE KEY `XPKuseremailunique` (`email`) USING BTREE,
  ADD KEY `XIF1users` (`codCargo`) USING BTREE;

--
-- Indexes for table `util_reportes`
--
ALTER TABLE `util_reportes`
  ADD PRIMARY KEY (`codUtilReportes`) USING BTREE,
  ADD UNIQUE KEY `XPKUtil_Reportes` (`codUtilReportes`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `anares_actividad`
--
ALTER TABLE `anares_actividad`
  MODIFY `codAnaResActividad` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=956;

--
-- AUTO_INCREMENT for table `anares_actividad_tracking`
--
ALTER TABLE `anares_actividad_tracking`
  MODIFY `codAnaResActividadTrack` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2482;

--
-- AUTO_INCREMENT for table `anares_analisisrestricciones`
--
ALTER TABLE `anares_analisisrestricciones`
  MODIFY `codAnaRes` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT for table `anares_fase`
--
ALTER TABLE `anares_fase`
  MODIFY `codAnaResFase` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;

--
-- AUTO_INCREMENT for table `anares_frente`
--
ALTER TABLE `anares_frente`
  MODIFY `codAnaResFrente` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `conf_colacorreos`
--
ALTER TABLE `conf_colacorreos`
  MODIFY `codColaCorreo` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6222;

--
-- AUTO_INCREMENT for table `conf_maestro_empresas`
--
ALTER TABLE `conf_maestro_empresas`
  MODIFY `cod_Empresa` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `conf_moneda`
--
ALTER TABLE `conf_moneda`
  MODIFY `codMoneda` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `conf_tipodiaprogramacion`
--
ALTER TABLE `conf_tipodiaprogramacion`
  MODIFY `codTipoDiaProgramacion` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `conf_ubigeo`
--
ALTER TABLE `conf_ubigeo`
  MODIFY `codUbigeo` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1875;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `other_notificaciones_usuario`
--
ALTER TABLE `other_notificaciones_usuario`
  MODIFY `codNotificacionUsuario` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `other_notificaciones_usuario4`
--
ALTER TABLE `other_notificaciones_usuario4`
  MODIFY `codNotificacionUsuario` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1712;

--
-- AUTO_INCREMENT for table `proy_areaintegrante`
--
ALTER TABLE `proy_areaintegrante`
  MODIFY `codArea` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `proy_integrantes`
--
ALTER TABLE `proy_integrantes`
  MODIFY `codProyIntegrante` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=287;

--
-- AUTO_INCREMENT for table `proy_proyecto`
--
ALTER TABLE `proy_proyecto`
  MODIFY `codProyecto` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `proy_proyectoconf`
--
ALTER TABLE `proy_proyectoconf`
  MODIFY `codProyectoconf` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `rrhh_ingresopersonal`
--
ALTER TABLE `rrhh_ingresopersonal`
  MODIFY `codRrHh` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=183;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT for table `util_reportes`
--
ALTER TABLE `util_reportes`
  MODIFY `codUtilReportes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `anares_analisis_tiporestricciones`
--
ALTER TABLE `anares_analisis_tiporestricciones`
  ADD CONSTRAINT `AnaRes_Analisis_TipoRestricciones_R_01` FOREIGN KEY (`codAnaRes`) REFERENCES `anares_analisisrestricciones` (`codAnaRes`);

--
-- Constraints for table `other_notificaciones_usuario`
--
ALTER TABLE `other_notificaciones_usuario`
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_2` FOREIGN KEY (`codNotificacion`) REFERENCES `other_notificaciones` (`codNotificacion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `other_notificaciones_usuario2`
--
ALTER TABLE `other_notificaciones_usuario2`
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_11` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_21` FOREIGN KEY (`codNotificacion`) REFERENCES `other_notificaciones` (`codNotificacion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `other_notificaciones_usuario4`
--
ALTER TABLE `other_notificaciones_usuario4`
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_111` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `other_notificaciones_usuario_ibfk_211` FOREIGN KEY (`codNotificacion`) REFERENCES `other_notificaciones` (`codNotificacion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `sec_membresiausuario`
--
ALTER TABLE `sec_membresiausuario`
  ADD CONSTRAINT `sec_membresiausuario_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `sec_membresiausuario_ibfk_2` FOREIGN KEY (`codMembresia`) REFERENCES `sec_membresia` (`codMembresia`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`codCargo`) REFERENCES `sec_cargo` (`codCargo`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
