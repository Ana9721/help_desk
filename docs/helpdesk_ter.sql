-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-06-2024 a las 05:18:23
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `helpdesk`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_ticket` (IN `tick_titulo` VARCHAR(50), IN `cat_id` INT, IN `prio_id` INT)   BEGIN
IF tick_titulo = '' then
SET tick_titulo = null;
END IF; 

IF cat_id = '' then
SET cat_id = null;
END IF;

IF prio_id = '' then
SET prio_id = null;
END IF;

SELECT
             tm_ticket.tick_id,
             tm_ticket.usu_id,
            tm_ticket.cat_id,
             tm_ticket.tick_titulo,
			tm_ticket.tick_descrip,
            tm_ticket.tick_estado,
             tm_ticket.fech_crea,
            tm_ticket.fech_cierre,
             tm_ticket.usu_asig,
             tm_ticket.fech_asig,
             tm_usuario.usu_nom,
            tm_usuario.usu_ape,
            tm_categoria.cat_nom,
             tm_ticket.prio_id,
             tm_prioridad.prio_nom
             FROM
             tm_ticket
             INNER JOIN tm_categoria on tm_ticket.cat_id = tm_categoria.cat_id
             INNER JOIN tm_usuario on tm_ticket.usu_id = tm_usuario.usu_id
            INNER JOIN tm_prioridad on tm_ticket.prio_id = tm_prioridad.prio_id
             WHERE 
             tm_ticket.est = 1
             AND tm_ticket.tick_titulo like IFNULL(tick_titulo, tm_ticket.tick_titulo)
            AND tm_ticket.cat_id = IFNULL(cat_id,tm_ticket.cat_id)
            AND tm_ticket.prio_id = IFNULL(prio_id,tm_ticket.prio_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_d_usuario_01` (IN `xusu_id` INT)   BEGIN
	UPDATE tm_usuario 
	SET 
		est='0',
		fech_elim = now() 
	where usu_id=xusu_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_i_ticketdetalle_01` (IN `xtick_id` INT, IN `xusu_id` INT)   BEGIN
	INSERT INTO td_ticketdetalle 
    (tickd_id,tick_id,usu_id,tickd_descrip,fech_crea,est) 
    VALUES 
    (NULL,xtick_id,xusu_id,'Ticket Cerrado...',now(),'1');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_01` ()   BEGIN
	SELECT * FROM tm_usuario where est='1';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_l_usuario_02` (IN `xusu_id` INT)   BEGIN
	SELECT * FROM tm_usuario where usu_id=xusu_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento`
--

CREATE TABLE `td_documento` (
  `doc_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `doc_nom` varchar(400) NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `td_documento`
--

INSERT INTO `td_documento` (`doc_id`, `tick_id`, `doc_nom`, `fech_crea`, `est`) VALUES
(1, 1, 'Imagen1.png', '2024-04-03 12:21:10', 1),
(2, 2, 'Avisos_pnatilla.docx', '2024-04-05 09:46:37', 1),
(3, 3, 'Avisos_pnatilla.docx', '2024-04-08 11:04:25', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_documento_detalle`
--

CREATE TABLE `td_documento_detalle` (
  `det_id` int(11) NOT NULL,
  `tickd_id` int(11) NOT NULL,
  `det_nom` varchar(255) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `td_documento_detalle`
--

INSERT INTO `td_documento_detalle` (`det_id`, `tickd_id`, `det_nom`, `est`) VALUES
(1, 25, 'firma_akrodriguez (1).jpg', 1),
(2, 25, 'firma_oscar.png', 1),
(3, 26, '202302160832419930.xlsm', 1),
(4, 26, 'codigoHelpDes.png', 1),
(5, 27, 'errorHelpD.png', 1),
(6, 28, 'CRUD_php_curso.docx', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `td_ticketdetalle`
--

CREATE TABLE `td_ticketdetalle` (
  `tickd_id` int(11) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `tickd_descrip` mediumtext NOT NULL,
  `fech_crea` datetime NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `td_ticketdetalle`
--

INSERT INTO `td_ticketdetalle` (`tickd_id`, `tick_id`, `usu_id`, `tickd_descrip`, `fech_crea`, `est`) VALUES
(1, 1, 1, '<p>test 2</p>', '2024-04-03 12:21:36', 1),
(2, 1, 1, '<p>test3&nbsp;</p>', '2024-04-03 12:24:35', 1),
(3, 1, 1, '<p>test 4</p>', '2024-04-03 12:26:52', 1),
(4, 1, 1, '<p>test 5&nbsp;</p>', '2024-04-03 12:41:26', 1),
(5, 1, 1, '<p>jkjhkhjk</p>', '2024-04-03 12:42:35', 1),
(6, 1, 1, '<p>tet yt</p>', '2024-04-03 12:46:23', 1),
(7, 1, 1, '<p>test 6</p>', '2024-04-03 12:50:08', 1),
(8, 1, 1, '<p>trtryfgf</p>', '2024-04-03 12:55:20', 1),
(9, 1, 1, '<p>dsadad</p>', '2024-04-03 17:25:21', 1),
(10, 1, 1, '<p>test4</p>', '2024-04-03 17:26:05', 1),
(11, 2, 1, 'Ticket Cerrado...', '2024-04-05 09:47:59', 1),
(12, 1, 1, '<p>test</p>', '2024-04-18 11:41:13', 1),
(13, 1, 1, '<p>test</p>', '2024-04-18 12:16:44', 1),
(14, 1, 1, '<p>test12</p>', '2024-04-18 12:16:51', 1),
(15, 1, 1, '<p>test archivos desc</p>', '2024-04-18 12:17:21', 1),
(16, 1, 1, '<p>tets15</p>', '2024-04-18 12:20:32', 1),
(17, 1, 1, '<p>test15</p>', '2024-04-18 12:23:35', 1),
(18, 1, 1, '<p>test18</p>', '2024-04-18 12:25:16', 1),
(19, 1, 1, '<p>test19</p>', '2024-04-18 12:26:32', 1),
(20, 1, 1, '<p>test20</p>', '2024-04-18 12:29:02', 1),
(21, 1, 1, '<p>test22</p>', '2024-04-18 12:38:53', 1),
(22, 1, 1, '<p>testss23</p>', '2024-04-18 12:40:42', 1),
(23, 1, 1, '<p>test199</p>', '2024-04-18 12:42:27', 1),
(24, 1, 1, '<p>test</p>', '2024-04-18 12:44:24', 1),
(25, 1, 1, '<p>test</p>', '2024-04-18 16:37:36', 1),
(26, 1, 1, '<p>test13</p>', '2024-04-18 16:38:47', 1),
(27, 1, 1, '<p>fdvdfgdfgd</p>', '2024-04-18 16:58:29', 1),
(28, 1, 1, '<p>pdf lector prueba&nbsp;</p>', '2024-04-18 17:04:11', 1),
(29, 1, 2, '<p>test&nbsp;</p>', '2024-04-26 12:04:05', 1),
(30, 1, 2, '<p>test&nbsp;</p>', '2024-04-26 12:05:43', 1),
(31, 1, 2, '<p>test&nbsp;</p>', '2024-04-26 12:10:39', 1),
(32, 1, 2, '<p>test 2</p>', '2024-04-26 12:11:19', 1),
(33, 6, 1, '<p>test&nbsp;</p>', '2024-04-26 13:06:36', 1),
(34, 6, 2, '<p>test fdgdfgfdgdg</p>', '2024-04-26 13:09:21', 1),
(35, 6, 1, '<p>test&nbsp;</p>', '2024-04-26 16:22:49', 1),
(36, 7, 1, '<p>tests</p>', '2024-04-26 16:37:41', 1),
(37, 8, 1, '<p>fsdfsfsf</p>', '2024-04-26 16:39:30', 1),
(38, 7, 1, '<p>prueba&nbsp;</p>', '2024-04-26 16:42:10', 1),
(39, 7, 1, '<p>tesfgdgdg</p>', '2024-04-26 16:42:25', 1),
(40, 8, 1, '<p>test 8&nbsp;</p>', '2024-04-26 17:02:45', 1),
(41, 8, 1, '<p>fdfdfgfdgd</p>', '2024-04-26 17:03:13', 1),
(42, 8, 2, '<p>fdgdfgfdg</p>', '2024-04-26 17:03:51', 1),
(43, 8, 1, '<p>ffdgdfg</p>', '2024-04-26 17:13:49', 1),
(44, 8, 2, '<p>fddgdfg</p>', '2024-04-26 17:14:18', 1),
(45, 8, 1, '<p>FDFDGDG</p>', '2024-04-26 17:22:01', 1),
(46, 8, 2, '<p>DFDFGDG</p>', '2024-04-26 17:22:08', 1),
(47, 8, 1, '<p>FDDFGFDG</p>', '2024-04-26 17:23:13', 1),
(48, 8, 1, '<p>dasdada</p>', '2024-06-06 21:09:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_categoria`
--

CREATE TABLE `tm_categoria` (
  `cat_id` int(11) NOT NULL,
  `cat_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_categoria`
--

INSERT INTO `tm_categoria` (`cat_id`, `cat_nom`, `est`) VALUES
(1, 'Hardware', 1),
(2, 'Software', 1),
(3, 'Incidencia', 1),
(4, 'Petición de Servicio', 1),
(5, 'test2', 0),
(6, 'test', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_notificacion`
--

CREATE TABLE `tm_notificacion` (
  `not_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `not_mensaje` varchar(400) NOT NULL,
  `tick_id` int(11) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tm_notificacion`
--

INSERT INTO `tm_notificacion` (`not_id`, `usu_id`, `not_mensaje`, `tick_id`, `est`) VALUES
(1, 1, 'Tiene una nueva respuesta del ticket Nro : 1', 2, 1),
(2, 1, 'Tiene una nueva respuesta del ticket Nro : 3', 3, 1),
(3, 2, 'Se le ha asignado el ticket Nro : ', 2, 1),
(4, 2, 'Tiene una nueva respuesta del ticket Nro : ', 1, 1),
(5, 2, 'Tiene una nueva respuesta del ticket Nro : ', 1, 1),
(6, 2, 'Se le ha asignado el ticket Nro : ', 6, 1),
(7, 2, 'Tiene una nueva respuesta del usuario con Nro del ticket : ', 6, 1),
(8, 1, 'Tiene una nueva respuesta de soporte del ticket Nro : ', 6, 1),
(9, 1, 'Tiene una nueva respuesta de soporte del ticket Nro : ', 6, 1),
(10, 2, 'Se le ha asignado el ticket Nro : ', 7, 1),
(11, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 7, 1),
(12, 2, 'Se le ha asignado el ticket Nro : ', 8, 1),
(13, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(14, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 7, 1),
(15, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 7, 1),
(16, 2, 'Se le ha asignado el ticket Nro : ', 9, 1),
(17, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(18, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(19, 1, 'Tiene una nueva respuesta de soporte del ticket Nro : ', 8, 1),
(20, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(21, 1, 'Tiene una nueva respuesta de soporte del ticket Nro : ', 8, 1),
(22, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(23, 1, 'Tiene una nueva respuesta de soporte del ticket Nro : ', 8, 1),
(24, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 1),
(25, 2, 'Tiene una nueva respuesta del usuario con nro de ticket : ', 8, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_prioridad`
--

CREATE TABLE `tm_prioridad` (
  `prio_id` int(11) NOT NULL,
  `prio_nom` varchar(50) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tm_prioridad`
--

INSERT INTO `tm_prioridad` (`prio_id`, `prio_nom`, `est`) VALUES
(1, 'Bajo', 1),
(2, 'Medio', 1),
(3, 'Alto', 1),
(4, 'test2', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_subcategoria`
--

CREATE TABLE `tm_subcategoria` (
  `cats_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_nom` varchar(150) NOT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tm_subcategoria`
--

INSERT INTO `tm_subcategoria` (`cats_id`, `cat_id`, `cats_nom`, `est`) VALUES
(1, 1, 'Teclado', 1),
(2, 1, 'Monitor', 1),
(3, 2, 'winrar', 1),
(4, 2, 'office', 1),
(5, 3, 'corte de red', 1),
(6, 3, 'corte de energia', 1),
(7, 4, 'json de software', 1),
(8, 4, 'instalacion de IIS', 1),
(9, 2, 'test2', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_ticket`
--

CREATE TABLE `tm_ticket` (
  `tick_id` int(11) NOT NULL,
  `usu_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `cats_id` int(11) NOT NULL,
  `tick_titulo` varchar(250) NOT NULL,
  `tick_descrip` mediumtext NOT NULL,
  `tick_estado` varchar(15) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `usu_asig` int(11) DEFAULT NULL,
  `fech_asig` datetime DEFAULT NULL,
  `tick_estre` int(11) DEFAULT NULL,
  `tick_coment` varchar(300) DEFAULT NULL,
  `fech_cierre` datetime DEFAULT NULL,
  `prio_id` int(11) DEFAULT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `tm_ticket`
--

INSERT INTO `tm_ticket` (`tick_id`, `usu_id`, `cat_id`, `cats_id`, `tick_titulo`, `tick_descrip`, `tick_estado`, `fech_crea`, `usu_asig`, `fech_asig`, `tick_estre`, `tick_coment`, `fech_cierre`, `prio_id`, `est`) VALUES
(1, 1, 1, 1, 'teste ', '<p>dsdfsfsdff</p>', 'Abierto', '2024-04-03 12:21:10', 2, '2024-04-26 11:45:22', NULL, NULL, NULL, 2, 1),
(2, 1, 1, 1, 'test', '<p>test desc</p>', 'Cerrado', '2024-04-05 09:46:37', 2, '2024-04-26 11:50:06', 4, 'cerrado', '2024-04-05 09:47:59', 2, 1),
(3, 1, 1, 1, 'teste ', '<p>serfdfdf</p>', 'Abierto', '2024-04-08 11:04:25', 2, '2024-04-26 11:44:42', NULL, NULL, NULL, 1, 1),
(4, 1, 1, 1, 'teste ', '<p>tests</p>', 'Abierto', '2024-04-26 11:49:22', NULL, NULL, NULL, NULL, NULL, 2, 1),
(5, 1, 3, 5, 'hhfhf', '<p>hfghfhfh</p>', 'Abierto', '2024-04-26 11:49:43', NULL, NULL, NULL, NULL, NULL, 2, 1),
(6, 1, 1, 2, 'test ', '<p>test&nbsp;</p>', 'Abierto', '2024-04-26 13:04:52', 2, '2024-04-26 13:05:40', NULL, NULL, NULL, 3, 1),
(7, 1, 3, 6, 'tesdfgdgd', '<p>fdsfsdfs</p>', 'Abierto', '2024-04-26 16:24:20', 2, '2024-04-26 16:24:33', NULL, NULL, NULL, 3, 1),
(8, 1, 3, 5, 'dfsdfsdfs', '<p>fdsfsfsf</p>', 'Abierto', '2024-04-26 16:38:52', 2, '2024-04-26 16:39:09', NULL, NULL, NULL, 2, 1),
(9, 1, 2, 3, 'tstr ', '<p>fgdfgdgdg</p>', 'Abierto', '2024-04-26 16:43:31', 2, '2024-04-26 16:44:03', NULL, NULL, NULL, 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tm_usuario`
--

CREATE TABLE `tm_usuario` (
  `usu_id` int(11) NOT NULL,
  `usu_nom` varchar(150) DEFAULT NULL,
  `usu_ape` varchar(150) DEFAULT NULL,
  `usu_correo` varchar(150) NOT NULL,
  `usu_pass` varchar(150) NOT NULL,
  `rol_id` int(11) DEFAULT NULL,
  `fech_crea` datetime DEFAULT NULL,
  `fech_modi` datetime DEFAULT NULL,
  `fech_elim` datetime DEFAULT NULL,
  `est` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla Mantenedor de Usuarios';

--
-- Volcado de datos para la tabla `tm_usuario`
--

INSERT INTO `tm_usuario` (`usu_id`, `usu_nom`, `usu_ape`, `usu_correo`, `usu_pass`, `rol_id`, `fech_crea`, `fech_modi`, `fech_elim`, `est`) VALUES
(1, 'Ana', 'Rodriguez', 'akrodriguez@hermos.com.mx', '202cb962ac59075b964b07152d234b70', 1, '2020-12-14 19:46:22', NULL, NULL, 1),
(2, 'Soporte Karen', 'Vicente', 'karenrdzc3@gmail.com', '202cb962ac59075b964b07152d234b70', 2, '2020-12-14 19:46:22', NULL, NULL, 1),
(3, 'Demo', 'Demo', 'demo12@gmail.com', 'e10adc3949ba59abbe56e057f20f883e', 2, '2020-12-14 19:46:22', NULL, '2021-01-21 22:04:50', 1),
(4, 'qwqweqwe', 'qweqweqwe', 'qweqwe@a.com', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-01-21 22:52:17', NULL, '2024-04-25 16:12:38', 0),
(5, 'eqweqwe', 'ASaws', 'ADAD@ASDASD.COM', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-01-21 22:52:53', NULL, '2021-01-21 22:53:27', 0),
(6, 'ASDASDA', 'ASDASD', 'ASASD@ASDOMC.COM', 'e10adc3949ba59abbe56e057f20f883e', 2, '2021-01-21 22:54:12', NULL, '2024-04-25 16:12:26', 0),
(7, 'asdasdasd', 'asdasdasd', 'asdasdasdasdasd@asdasdasd.com', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-01-21 22:55:12', NULL, '2021-02-05 22:23:09', 0),
(8, 'Test11111', 'Test2111111', 'test@test2.com.pe', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-02-05 22:22:31', NULL, '2021-02-08 21:09:58', 0),
(9, 'Usuario', 'Apellido', 'Correo@correo.com', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-06-13 19:09:17', NULL, '2024-04-25 16:12:55', 0),
(10, 'test1', 'test1', 'testw@correo.com', 'e10adc3949ba59abbe56e057f20f883e', 1, '2021-06-13 19:10:34', NULL, '2024-04-25 16:12:42', 0),
(11, 'Datos', 'Datos2', 'datos@datos.com', 'e10adc3949ba59abbe56e057f20f883e', 2, '2021-06-13 19:16:43', NULL, NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  ADD PRIMARY KEY (`doc_id`);

--
-- Indices de la tabla `td_documento_detalle`
--
ALTER TABLE `td_documento_detalle`
  ADD PRIMARY KEY (`det_id`);

--
-- Indices de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  ADD PRIMARY KEY (`tickd_id`);

--
-- Indices de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indices de la tabla `tm_notificacion`
--
ALTER TABLE `tm_notificacion`
  ADD PRIMARY KEY (`not_id`);

--
-- Indices de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  ADD PRIMARY KEY (`prio_id`);

--
-- Indices de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  ADD PRIMARY KEY (`cats_id`);

--
-- Indices de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  ADD PRIMARY KEY (`tick_id`);

--
-- Indices de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  ADD PRIMARY KEY (`usu_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `td_documento`
--
ALTER TABLE `td_documento`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `td_documento_detalle`
--
ALTER TABLE `td_documento_detalle`
  MODIFY `det_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `td_ticketdetalle`
--
ALTER TABLE `td_ticketdetalle`
  MODIFY `tickd_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `tm_categoria`
--
ALTER TABLE `tm_categoria`
  MODIFY `cat_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tm_notificacion`
--
ALTER TABLE `tm_notificacion`
  MODIFY `not_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `tm_prioridad`
--
ALTER TABLE `tm_prioridad`
  MODIFY `prio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tm_subcategoria`
--
ALTER TABLE `tm_subcategoria`
  MODIFY `cats_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `tm_ticket`
--
ALTER TABLE `tm_ticket`
  MODIFY `tick_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `tm_usuario`
--
ALTER TABLE `tm_usuario`
  MODIFY `usu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
