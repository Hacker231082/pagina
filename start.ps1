# Ejecutar como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Ejecutando como administrador..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Mantener la ventana abierta en caso de error
$ErrorActionPreference = "Stop"

try {
    Write-Host "=== Iniciando la aplicación ===" -ForegroundColor Green
    Write-Host "Por favor espera..." -ForegroundColor Yellow

    # Crear carpeta uploads si no existe
    if (-not (Test-Path "uploads")) {
        New-Item -ItemType Directory -Path "uploads"
        Write-Host "✓ Carpeta uploads creada" -ForegroundColor Green
    }

    # Verificar Python
    try {
        python --version
        Write-Host "✓ Python encontrado" -ForegroundColor Green
    } 
    catch {
        Write-Host "✕ Error: Python no está instalado o no está en el PATH" -ForegroundColor Red
        throw
    }

    # Verificar Node.js
    try {
        node --version
        Write-Host "✓ Node.js encontrado" -ForegroundColor Green
    } 
    catch {
        Write-Host "✕ Error: Node.js no está instalado o no está en el PATH" -ForegroundColor Red
        throw
    }

    # Iniciar servidor Python
    Write-Host "`nIniciando servidor Python..." -ForegroundColor Yellow
    $pythonProcess = Start-Process python -ArgumentList "app.py" -PassThru -WindowStyle Normal

    # Esperar y verificar servidor Python
    Write-Host "Esperando que el servidor Python esté listo..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5

    # Iniciar servidor React
    Write-Host "`nIniciando servidor React..." -ForegroundColor Yellow
    Set-Location frontend
    Start-Process npm -ArgumentList "start" -WindowStyle Normal
    Set-Location ..

    Write-Host "`nEsperando que los servidores estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10

    Write-Host "`n=== ¡Aplicación iniciada! ===" -ForegroundColor Green
    Write-Host "• Servidor Python: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "• Servidor React: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "`nAbriendo navegador..." -ForegroundColor Yellow
    Start-Process "http://localhost:3000"

    Write-Host "`nPresiona Ctrl+C para detener los servidores" -ForegroundColor Yellow
    Write-Host "Manteniendo servidores activos..." -ForegroundColor DarkGray

    while ($true) {
        Start-Sleep -Seconds 1
    }
} 
catch {
    Write-Host "`n=== Error detectado ===" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} 