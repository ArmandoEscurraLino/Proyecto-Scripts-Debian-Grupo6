#!/bin/bash
# ==========================================================
# TRABAJO PARCIAL - GRUPO 8
# MENÚ LANZADOR DE SCRIPTS EXISTENTES (T1, T3, T4)
# ==========================================================

while true; do
    clear
    echo "=========================================="
    echo "   SISTEMA DE GESTIÓN - GRUPO 8"
    echo "=========================================="
    echo "1) Ejecutar: Información del Sistema (Tarea 1)"
    echo "2) Ejecutar: Lógica de Control (Tarea 3)"
    echo "3) Ejecutar: Generación de Reporte (Tarea 4)"
    echo "4) Salir"
    echo "=========================================="
    
    read -p "Seleccione una opción [1-4]: " OPCION

    case $OPCION in
        1)
            echo "--- LLAMANDO A TAREA 1 ---"
            # Aquí el menú "jala" tu script ya creado
            ./tarea1_info.sh 
            read -p "Presione Enter para volver..."
            ;;
        2)
            echo "--- LLAMANDO A TAREA 3 ---"
            # Aquí el menú "jala" tu script ya creado
            ./tarea3_control.sh
            read -p "Presione Enter para volver..."
            ;;
        3)
            echo "--- LLAMANDO A TAREA 4 ---"
            # Aquí el menú "jala" tu script ya creado
            ./tarea4_reporte.sh
            read -p "Presione Enter para volver..."
            ;;
        4)
            echo "Saliendo del menú..."
            exit 0
            ;;
        *)
            echo "Opción no válida."
            sleep 2
            ;;
    esac
done
