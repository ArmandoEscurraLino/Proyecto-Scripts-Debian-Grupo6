#!/bin/bash
# =====================================================
# Script: menu_grupo6_v2.sh - Menú interactivo del sistema de backups
# =====================================================

set -euo pipefail                                                            # Modo estricto
trap 'echo "Error en línea $LINENO: $BASH_COMMAND"' ERR                      # Muestra línea de error

# -------------------------------------------------
# Función para mostrar el menú principal
# -------------------------------------------------
mostrar_menu() {                                                             # Muestra opciones
    clear
    echo "=========================================="
    echo "   SISTEMA DE BACKUPS - GRUPO 6"
    echo "=========================================="
    echo "1) Realizar backup (tarea3_control_v2.sh)"
    echo "2) Limpiar backups antiguos (tarea2_limpieza_v2.sh)"
    echo "3) Enviar reporte por correo (tarea4_reporte_v2.sh)"
    echo "4) Salir"
    echo "=========================================="
}

# -------------------------------------------------
# Función para ejecutar backup con valores por defecto
# -------------------------------------------------
ejecutar_backup() {                                                          # Solicita origen y destino con defaults
    echo "--- Backup ---"
    read -p "Directorio origen (default /etc): " origen
    origen=${origen:-/etc}                                                   # Si Enter, usa /etc
    read -p "Directorio destino (default /backups): " destino
    destino=${destino:-/backups}                                             # Si Enter, usa /backups
    echo "Ejecutando: ./tarea3_control_v2.sh -d \"$origen\" -o \"$destino\" -c"
    ./tarea3_control_v2.sh -d "$origen" -o "$destino" -c
    read -p "Presione Enter para continuar..."
}

# -------------------------------------------------
# Función para ejecutar limpieza con valores por defecto
# -------------------------------------------------
ejecutar_limpieza() {                                                        # Solicita directorio y días con defaults
    echo "--- Limpieza de backups antiguos ---"
    read -p "Directorio de backups (default /backups): " dir
    dir=${dir:-/backups}                                                     # Si Enter, usa /backups
    read -p "Días de retención (default 7): " dias
    dias=${dias:-7}                                                          # Si Enter, usa 7
    echo "Ejecutando: ./tarea2_limpieza_v2.sh -d \"$dir\" -t $dias"
    ./tarea2_limpieza_v2.sh -d "$dir" -t "$dias"
    read -p "Presione Enter para continuar..."
}

# -------------------------------------------------
# Función para ejecutar reporte con valor por defecto
# -------------------------------------------------
ejecutar_reporte() {                                                         # Solicita correo con default
    echo "--- Envío de reporte por correo ---"
    read -p "Correo destinatario (default VV71006012@idat.pe): " email
    email=${email:-VV71006012@idat.pe}                                       # Si Enter, usa el institucional
    echo "Ejecutando: ./tarea4_reporte_v2.sh -e \"$email\""
    ./tarea4_reporte_v2.sh -e "$email"
    read -p "Presione Enter para continuar..."
}

# -------------------------------------------------
# Bucle principal del menú
# -------------------------------------------------
while true; do
    mostrar_menu
    read -p "Seleccione una opción [1-4]: " opcion
    case $opcion in
        1) ejecutar_backup ;;
        2) ejecutar_limpieza ;;
        3) ejecutar_reporte ;;
        4) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción no válida"; sleep 2 ;;
    esac
done
