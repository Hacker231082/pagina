@echo off
echo Instalando dependencias de Python...
pip install flask flask-cors pymongo python-dotenv openai Werkzeug

echo Instalando dependencias de React...
cd frontend
npm install

echo Iniciando servidores...
start cmd /k "cd .. && python app.py"
timeout /t 5
start cmd /k "cd frontend && npm start"

echo ¡Aplicación iniciada! Abriendo navegador...
timeout /t 5
start http://localhost:3000 