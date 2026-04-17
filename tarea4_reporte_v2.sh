#!/bin/bash
# =====================================================
# Script: tarea4_reporte_v2.sh - Envía reporte del último backup por correo
# =====================================================

set -euo pipefail                                                            # Modo estricto
trap 'echo "Error en línea $LINENO: $BASH_COMMAND"' ERR                      # Muestra línea del error

EMAIL_TO="VV71006012@idat.pe"                                                # Destinatario (correo institucional)
ASUNTO="Reporte Backup $(date +%Y-%m-%d)"                                    # Asunto con fecha
LOG="/var/log/backup.log"                                                    # Archivo de log
TEMP="/tmp/reporte_backup.txt"                                               # Temporal para el reporte
LAST_BACKUP_FILE="/tmp/last_backup.txt"                                      # Ruta del último backup

# -------------------------------------------------
# Función de ayuda
# -------------------------------------------------
ayuda() {                                                                    # Muestra el uso
    echo "Uso: $0 [-e EMAIL] [-s ASUNTO]"
    echo "  -e Dirección de correo destino (por defecto VV71006012@idat.pe)"
    echo "  -s Asunto del mensaje"
    echo "  -h Mostrar esta ayuda"
    exit 0
}

# -------------------------------------------------
# Función de logging (muestra y guarda)
# -------------------------------------------------
log() {                                                                      # Registra eventos
    echo "[$(date)] [$1] $2" | tee -a "$LOG"
}

# -------------------------------------------------
# Verificar que el comando 'mail' esté instalado
# -------------------------------------------------
if ! command -v mail &>/dev/null; then                                       # Si no existe mail
    echo "ERROR: Comando 'mail' no instalado. Instale mailutils:" | tee -a "$LOG"
    echo "Ejecute como root: apt update && apt install mailutils -y" | tee -a "$LOG"
    exit 1
fi

# -------------------------------------------------
# Generar el contenido del reporte
# -------------------------------------------------
generar() {                                                                  # Crea el reporte en un archivo temporal
    if [[ ! -f "$LAST_BACKUP_FILE" ]]; then                                  # Si no hay registro
        log "ERROR" "No hay registro de backup reciente. Ejecute primero tarea3_control_v2.sh"
        exit 2
    fi

    local backup=$(cat "$LAST_BACKUP_FILE")                                  # Leer ruta del último backup
    local size=$(du -sh "$backup" 2>/dev/null | cut -f1)                     # Calcular tamaño legible
    [[ -z "$size" ]] && size="Desconocido"                                   # Si falla, poner "Desconocido"

    # Escribir el reporte en el archivo temporal
    {
        echo "============================================="
        echo "   REPORTE DE BACKUP - $(date)"
        echo "============================================="
        echo "Último backup: $backup"
        echo "Tamaño: $size"
        echo ""
        echo "--- Estado del disco destino ---"
        df -h "$(dirname "$backup")" | awk 'NR==1 {print "Dispositivo\tLibre\tUso%"} NR==2 {print $1 "\t" $4 "\t" $5}'
        echo ""
        echo "--- Últimas líneas del log de backup ---"
        tail -10 "$LOG" | sed 's/^/  /'                                      # Sangría con sed
        echo "============================================="
    } > "$TEMP"
}

# -------------------------------------------------
# Enviar el correo usando el comando 'mail'
# -------------------------------------------------
enviar() {                                                                   # Envía el reporte por correo
    mail -s "$ASUNTO" "$EMAIL_TO" < "$TEMP"                                  # Comando mail
    if [[ $? -eq 0 ]]; then                                                  # Comprobar éxito
        log "INFO" "Correo enviado exitosamente a $EMAIL_TO"
    else
        log "ERROR" "Fallo al enviar el correo"
        exit 3
    fi
    rm -f "$TEMP"                                                            # Borrar archivo temporal
}

# -------------------------------------------------
# Procesar opciones de línea de comandos
# -------------------------------------------------
while getopts "e:s:h" opt; do
    case $opt in
        e) EMAIL_TO="$OPTARG" ;;                                             # Cambiar destinatario
        s) ASUNTO="$OPTARG" ;;                                              # Cambiar asunto
        h) ayuda ;;
        *) ayuda ;;
    esac
done

# -------------------------------------------------
# Ejecución principal
# -------------------------------------------------
generar                                                                      # Generar reporte
enviar                                                                       # Enviar por correo
echo "--------------------------------------------------"
echo "Log completo guardado en: $LOG"
echo "Correo enviado a $EMAIL_TO con el reporte del último backup"
echo "--------------------------------------------------"
exit 0
