<?php 
  require_once("../../config/conexion.php");
  session_destroy();
  // if($_SESSION["rol_id"] ==1){
     header("Location:".Conectar::ruta()."index.php");

  // } elseif($_SESSION["rol_id"] == 2){
  //    header("Location:".Conectar::ruta()."view/accesosoporte/index.php");

 // }
 
  exit();
?>