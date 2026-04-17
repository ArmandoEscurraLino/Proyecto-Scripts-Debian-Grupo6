#!/bin/bash
# =====================================================
# Script: tarea2_limpieza_v2.sh - Limpia backups antiguos
# =====================================================

set -euo pipefail                                                            # Modo estricto
DIAS=7                                                                       # Días de retención por defecto
LOG="/var/log/backup.log"                                                    # Archivo de log

ayuda() {                                                                    # Muestra el uso
    echo "Uso: $0 -d DIRECTORIO [-t DIAS]"
    echo "  -d Directorio donde están los backups (obligatorio)"
    echo "  -t Días a mantener (default 7)"
    echo "  -h Mostrar esta ayuda"
    exit 0
}

log() {                                                                      # Función de logging
    echo "[$(date)] [$1] $2" | tee -a "$LOG"
}

validar() {                                                                  # Valida parámetros
    [[ -z "${DIR:-}" ]] && { log "ERROR" "Falta -d"; ayuda; }
    [[ ! -d "$DIR" ]] && { log "ERROR" "Directorio $DIR no existe"; exit 1; }
    [[ ! "$DIAS" =~ ^[0-9]+$ ]] && { log "ERROR" "-t debe ser número"; exit 2; }
    return 0                                                                 # Asegura retorno exitoso (CRUCIAL)
}

limpiar() {                                                                  # Elimina backups antiguos
    log "INFO" "Buscando backups con más de $DIAS días en $DIR"
    mapfile -t viejos < <(find "$DIR" -name "backup_*.tar.gz" -type f -mtime +$DIAS 2>/dev/null)
    if [[ ${#viejos[@]} -eq 0 ]]; then
        log "INFO" "No hay backups antiguos"
        return
    fi
    for f in "${viejos[@]}"; do
        rm -f "$f" && log "INFO" "Eliminado $f" || log "ERROR" "Fallo al eliminar $f"
    done
    log "SUCCESS" "Eliminados ${#viejos[@]} archivos"
}

while getopts "d:t:h" opt; do                                                # Procesa opciones
    case $opt in
        d) DIR="$OPTARG" ;;
        t) DIAS="$OPTARG" ;;
        h) ayuda ;;
        *) ayuda ;;
    esac
done
validar                                                                      # Ejecuta validaciones
limpiar                                                                      # Ejecuta limpieza
echo "--------------------------------------------------"
echo "Log completo guardado en: $LOG"
echo "Puede verlo con: cat $LOG   o   tail -f $LOG"
echo "--------------------------------------------------"
exit 0
