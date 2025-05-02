@echo off
title Iniciando Aplicacion

echo ===================================
echo Instalando lo necesario...
echo ===================================

python -m pip install flask flask-cors pymongo python-dotenv openai Werkzeug

echo ===================================
echo Iniciando servidores...
echo ===================================

start cmd /k "title Servidor Python && python app.py"
timeout /t 5 /nobreak

cd frontend
start cmd /k "title Servidor React && npm start"

echo ===================================
echo Si no se abre el navegador automaticamente,
echo abre http://localhost:3000 en tu navegador
echo ===================================

pause 