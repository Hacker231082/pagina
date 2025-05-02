@echo off
echo Iniciando servidores...

:: Iniciar el backend (Python)
start cmd /k "cd %~dp0 && python app.py"

:: Iniciar el frontend (React)
start cmd /k "cd %~dp0\frontend && npm start"

echo.
echo ===================================================
echo Servidores iniciados correctamente!
echo.
echo La aplicación estará disponible en:
echo.
echo Frontend: http://192.168.1.71:3000
echo Backend: http://192.168.1.71:5000
echo.
echo Para acceder desde otros dispositivos en la misma red:
echo 1. Asegúrate de que el dispositivo esté conectado a la misma red WiFi
echo 2. Abre el navegador y visita: http://192.168.1.71:3000
echo.
echo Si no puedes acceder, verifica que:
echo - El firewall de Windows no esté bloqueando las conexiones
echo - Los dispositivos estén en la misma red
echo ===================================================
echo. 