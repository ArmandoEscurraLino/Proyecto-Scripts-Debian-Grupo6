#!/bin/bash

# --- TAREA 1: INFORMACIÓN DEL SISTEMA ---
# Este script usa variables de entorno y comandos de sistema para recopilar datos

# Variables: Almacenan información para ser reutilizada
USUARIO=$(whoami)       # Obtiene el usuario actual
HOST=$(hostname)        # Obtiene el nombre del equipo
FECHA=$(date "+%Y-%m-%d %H:%M:%S") # Obtiene fecha y hora actual

# --- CORRECCIÓN ---
# Redirigimos toda la salida al archivo llamado 'tarea1'
{
    echo "--- GRUPO 8: INFO SISTEMA ---"
    echo "Usuario actual: $USUARIO"
    echo "Nombre del host: $HOST"
    echo "Sistema Operativo: $(cat /etc/debian_version)" # Lee la versión de Debian
    echo "Fecha y hora: $FECHA"
    echo "Tiempo de actividad: $(uptime -p)" # Muestra cuánto tiempo lleva prendido
    echo "Uso de disco: $(df -h / | awk 'NR==2 {print $5}')" # Muestra % de uso en /
    echo "RAM disponible: $(free -h | awk 'NR==2 {print $4}')" # Muestra RAM libre
} | tee tarea1
# ------------------

echo "Información guardada en el archivo 'tarea1'."
