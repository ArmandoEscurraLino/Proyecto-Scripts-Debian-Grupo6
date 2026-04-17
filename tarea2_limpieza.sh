#!/bin/bash

# --- TAREA 2: LIMPIEZA AUTOMÁTICA ---
# Este script busca y elimina archivos viejos en una carpeta específica.

DIR="/tmp/pruebas"    # Directorio objetivo
DIAS=7                # Antigüedad de los archivos (días)
ARCHIVO_REPORT="/root/reporte_limpieza.txt" # Archivo de reporte

# Preparamos el entorno para la demostración
mkdir -p "$DIR"
touch -d "10 days ago" "$DIR/archivo_viejo.log" # Crea un archivo simulando ser viejo
touch "$DIR/archivo_nuevo.log"                  # Crea un archivo nuevo

echo "--- Iniciando limpieza en $DIR ---"
echo "Fecha de ejecución: $(date)" > "$ARCHIVO_REPORT"
echo "Criterio de antigüedad: > $DIAS días" >> "$ARCHIVO_REPORT"
echo "Archivos eliminados:" >> "$ARCHIVO_REPORT"

# Buscar (-type f) y eliminar (-delete) archivos con más de 7 días (-mtime +7)
find "$DIR" -type f -mtime +$DIAS -print >> "$ARCHIVO_REPORT" # Registra en reporte
find "$DIR" -type f -mtime +$DIAS -delete                # Elimina

# 1. Registra en el reporte qué archivos se van a borrar
find "$DIR" -type f -mtime +$DIAS -print >> "$ARCHIVO_REPORT"

# 2. Borra físicamente los archivos antiguos
find "$DIR" -type f -mtime +$DIAS -delete

echo "Limpieza completada. Reporte generado en: $ARCHIVO_REPORT"

# Usamos 'wall' para que el mensaje salte en TODAS las pantallas (Moba y VirtualBox)
wall "[AVISO CRON]: La limpieza automática del Grupo 8 se ha ejecutado con éxito. 
Consulte el reporte en: /root/reporte_limpieza.txt"
