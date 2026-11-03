#!/bin/bash

# PROYECTO ISL135
# Script de monitoreo del sistema

FECHA=$(date "+%d/%m/%Y %H:%M:%S")
HOST=$(hostname)
USUARIOS=$(who | wc -l)
DISCO=$(df -h / | awk 'NR==2 {print $4}')
MEMORIA=$(free -h | awk '/^Mem:/ {print $7}')

# Comprobar Docker y contar contenedores activos
if command -v docker >/dev/null 2>&1; then
    if docker info >/dev/null 2>&1; then
        CONTENEDORES=$(docker ps -q | wc -l)
    else
        CONTENEDORES="Docker no disponible"
    fi
else
    CONTENEDORES="Docker no instalado"
fi

# Mostrar reporte
echo "==================================================================="
echo "             REPORTE DE MONITOREO DEL SISTEMA"
echo "==================================================================="
echo "Fecha y hora: $FECHA"
echo "Nombre del host: $HOST"
echo "Usuarios conectados: $USUARIOS"
echo "Espacio libre en disco: $DISCO"
echo "Memoria RAM disponible: $MEMORIA"
echo "Contenedores Docker activos: $CONTENEDORES"
echo "==================================================================="
echo ""
