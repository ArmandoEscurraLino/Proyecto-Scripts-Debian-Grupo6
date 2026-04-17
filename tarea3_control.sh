#!/bin/bash
# --- TAREA 3: ESTRUCTURAS DE CONTROL (Asociada y con Log) ---

# --- CONFIGURACIÓN TAREA 3 ---
ARCHIVO_T1="/root/tarea1" 
LOG_T3="/root/reporte_control.txt" # <--- ARCHIVO LOG DE TAREA 3
UMBRAL=80   # Umbral de uso de disco
MAX_INTENTOS=3 # Número máximo de intentos

# --- INICIO DEL LOG TAREA 3 ---
echo "--- REPORTE DE CONTROL (Fecha: $(date)) ---" > "$LOG_T3"

echo "--- VERIFICACIÓN DE CONTROL ---"

# --- A. EXISTENCIA DE ARCHIVO (if/else) ---
if [ -f "$ARCHIVO_T1" ]; then
    echo "OK: Archivo de reporte '$ARCHIVO_T1' encontrado." >> "$LOG_T3"
else
    echo "ERROR: Archivo $ARCHIVO_T1 no encontrado." >> "$LOG_T3"
    echo "ERROR: Archivo $ARCHIVO_T1 no encontrado."
    exit 1
fi

# --- B. EVALUACIÓN DE DISCO (if/else) ---
USO_ACTUAL=$(grep "Uso de disco" "$ARCHIVO_T1" | awk '{print $5}' | sed 's/%//')

echo "Uso actual de disco (según reporte Tarea 1): $USO_ACTUAL%"
echo "Umbral máximo permitido: $UMBRAL%"

if [ "$USO_ACTUAL" -gt "$UMBRAL" ]; then
    echo "ESTADO: ALERTA - Disco lleno." >> "$LOG_T3"
    echo "ESTADO: ALERTA - Disco lleno."
else
    echo "ESTADO: OK - Espacio suficiente." >> "$LOG_T3"
    echo "ESTADO: OK - Espacio suficiente."
fi

# --- C. BUCLE DE INTENTOS (while/counter) ---
CONTADOR=0 

echo -e "\n--- SIMULACIÓN DE PROCESO ---"
echo "--- RESULTADOS DE SIMULACIÓN ---" >> "$LOG_T3"

while [ $CONTADOR -lt $MAX_INTENTOS ]; do
    ((CONTADOR++))
    echo "Intento de validación $CONTADOR/$MAX_INTENTOS..."
    echo "Intento $CONTADOR: Exitoso" >> "$LOG_T3"
    sleep 0.5 
done

echo "Proceso finalizado. Reporte generado en: $LOG_T3"
