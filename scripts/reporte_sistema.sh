#!/bin/bash

# =========================================================================

# PROYECTO ISL135
# Script de monitoreo del sistema 

# ========================================================================


# Fecha y hora actual 

 FECHA=$(date "+%d/%m/%Y %H:%M:%S")



# Nombre del servidor 

  HOST=$(hostname)



# Numero de usuarios conectados 

  USUARIOS=$(who | wc -l)




# Espacio libre del disco principal 

  dISCO=$(df -h / | awk 'NR==2 {print $4}')



# Memoria Ram disponible 

 MEMORIA=$(free -h | awk '/mem:/ {print $7}') 




# Numero de contenedores Docker activos 

 if command -v docker >/dev/null/ 2>&1; then
      CONTENEDORES=$(docker ps -q 2>/dev/null | wc -l)


 else 
       CONTENEDORES="Docker no instalado" 

 fi 



  # Mostrar reporte 

  echo "==================================================================="
  echo "           REPORTE  DE MONITOREO DEL SISTEMA                       "
  echo "==================================================================="

  echo "Fecha y hora: $FECHA" 

  echo "Nombre del host: $HOST"

  echo "Usuarios conectados: $USUARIOS"

  echo "Espacio libre en disco: $DISCO" 

  echo "Memoria Ram disponible: $MEMORIA"

  echo "Contenedores Docker activos: $CONTENEDORES"

 echo "===================================================================="

 echo ""




