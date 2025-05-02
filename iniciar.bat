@echo off
echo Creando carpeta public si no existe...
if not exist "frontend\public" mkdir frontend\public

echo Instalando dependencias de Python...
python -m pip install --upgrade pip
python -m pip install flask flask-cors pymongo python-dotenv openai Werkzeug

echo Instalando dependencias de React...
cd frontend
if not exist "node_modules" (
    call npm install
) else (
    echo Las dependencias de React ya están instaladas
)

echo Iniciando servidores...
cd ..
start cmd /k "python app.py"
timeout 5
cd frontend
start cmd /k "npm start"
el bash de ejecucion .\iniciar.bat terminal

