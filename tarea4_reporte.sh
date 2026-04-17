#!/bin/bash
# --- TAREA 4: REPORTE FINAL CONSOLIDADO (Grupo 8) ---

# --- CONFIGURACIÓN ---
REPO_FINAL="/root/reporte_final_grupo8.txt"
LOG_T2="/root/reporte_limpieza.txt"
LOG_T3="/root/reporte_control.txt"

# --- INICIO DEL REPORTE FINAL ---
echo "========================================" > "$REPO_FINAL"
echo "   REPORTE FINAL DE ADMINISTRACIÓN" >> "$REPO_FINAL"
echo "   Grupo 8" >> "$REPO_FINAL"
echo "========================================" >> "$REPO_FINAL"

# Punto 2 y 3: Fecha/Hora y Usuario
echo "Fecha de ejecución: $(date)" >> "$REPO_FINAL"
echo "Usuario ejecutor: $(whoami)" >> "$REPO_FINAL"
echo "----------------------------------------" >> "$REPO_FINAL"

# Punto 4: Resultado de validaciones (Lee de logs anteriores)
echo "--- Resumen de Limpieza (Tarea 2) ---" >> "$REPO_FINAL"
if [ -f "$LOG_T2" ]; then
    echo "Detalle de archivos:" >> "$REPO_FINAL"
    grep -A 100 "Archivos eliminados" "$LOG_T2" | grep -v "Archivos eliminados:" >> "$REPO_FINAL"
else
    echo "Reporte Tarea 2 no encontrado." >> "$REPO_FINAL"
fi

echo -e "\n--- Resumen de Control (Tarea 3) ---" >> "$REPO_FINAL"
if [ -f "$LOG_T3" ]; then
    echo "Estado de validaciones:" >> "$REPO_FINAL"
    grep "ESTADO" "$LOG_T3" >> "$REPO_FINAL"
else
    echo "Reporte Tarea 3 no encontrado." >> "$REPO_FINAL"
fi

# Punto 5: Contador de acciones
echo "----------------------------------------" >> "$REPO_FINAL"
ACCIONES_T2=$(grep -c "/" "$LOG_T2" 2>/dev/null || echo 0) # Cuenta líneas en log t2
ACCIONES_T3=3 # La tarea 3 realizó 3 chequeos principales
TOTAL_ACCIONES=$((ACCIONES_T2 + ACCIONES_T3))

echo "Total de acciones realizadas: $TOTAL_ACCIONES" >> "$REPO_FINAL"
echo "========================================" >> "$REPO_FINAL"

echo "Reporte final generado exitosamente en: $REPO_FINAL"
cat "$REPO_FINAL"
