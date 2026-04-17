#!/bin/bash
# =====================================================
# Script: tarea3_control_v2.sh - Backup con validaciones
# =====================================================

set -euo pipefail                                                            # Modo estricto
LOG="/var/log/backup.log"                                                    # Archivo de log
FECHA=$(date +"%Y%m%d_%H%M%S")                                               # Marca de tiempo única
COMPRESS=false                                                               # Sin compresión por defecto

ayuda() {                                                                    # Muestra ayuda
    echo "Uso: $0 -d ORIGEN -o DESTINO [-c]"                                 # Forma de uso
    echo "  -d Directorio origen (obligatorio)"                              # Explica -d
    echo "  -o Directorio destino (obligatorio)"                             # Explica -o
    echo "  -c Comprimir con gzip (opcional)"                                # Explica -c
    echo "  -h Mostrar esta ayuda"                                           # Explica -h
    exit 0
}

log() {                                                                      # Función de logging
    echo "[$(date)] [$1] $2" | tee -a "$LOG"                                 # Guarda y muestra
}

validar() {                                                                  # Validaciones
    [[ -z "${ORIGEN:-}" || -z "${DESTINO:-}" ]] && { log "ERROR" "Faltan -d o -o"; ayuda; }
    [[ ! -d "$ORIGEN" ]] && { log "ERROR" "Origen no existe"; exit 1; }
    mkdir -p "$DESTINO" || { log "ERROR" "No se pudo crear destino"; exit 2; }
    
    # Obtener espacio libre (df da KiB, convertir a bytes)
    local libre_kib=$(df --output=avail "$DESTINO" | tail -1)                # Libre en KiB
    local libre_bytes=$((libre_kib * 1024))                                  # Convertir a bytes
    log "INFO" "Espacio libre antes del backup: $((libre_bytes / 1024 / 1024)) MB"
    
    local size_bytes=$(du -sb "$ORIGEN" | cut -f1)                           # Tamaño origen en bytes
    # Necesita al menos el doble del tamaño
    (( libre_bytes < size_bytes * 2 )) && { log "ERROR" "Espacio insuficiente (necesario $((size_bytes*2/1024/1024)) MB, disponible $((libre_bytes/1024/1024)) MB)"; exit 3; }
    command -v tar &>/dev/null || { log "ERROR" "tar no instalado"; exit 4; }
}

backup() {                                                                   # Realiza el backup
    local nombre="backup_$(basename "$ORIGEN")_${FECHA}"                     # Nombre del backup
    local ruta="${DESTINO}/${nombre}"                                        # Ruta completa
    log "INFO" "Iniciando backup de $ORIGEN"
    if $COMPRESS; then                                                       # Con compresión
        ruta="${ruta}.tar.gz"
        tar -czf "$ruta" -C "$(dirname "$ORIGEN")" "$(basename "$ORIGEN")"
        echo "$ruta" > /tmp/last_backup.txt
    else                                                                     # Sin compresión
        cp -r "$ORIGEN" "$ruta"
        echo "$ruta" > /tmp/last_backup.txt
    fi
    log "SUCCESS" "Backup completado en $ruta"
    
    # Calcular espacio después (también en MB)
    local libre_despues_kib=$(df --output=avail "$DESTINO" | tail -1)
    local libre_despues_bytes=$((libre_despues_kib * 1024))
    log "INFO" "Espacio libre después del backup: $((libre_despues_bytes / 1024 / 1024)) MB"
}

while getopts "d:o:ch" opt; do                                               # Procesa argumentos
    case $opt in
        d) ORIGEN="$OPTARG" ;;
        o) DESTINO="$OPTARG" ;;
        c) COMPRESS=true ;;
        h) ayuda ;;
        *) ayuda ;;
    esac
done
validar                                                                      # Ejecuta validaciones
backup                                                                       # Ejecuta backup
echo "--------------------------------------------------"
echo "Log completo guardado en: $LOG"
echo "Puede verlo con: cat $LOG   o   tail -f $LOG"
echo "--------------------------------------------------"
exit 0
