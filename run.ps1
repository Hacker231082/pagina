Write-Host "Instalando dependencias de Python..." -ForegroundColor Green
pip install flask flask-cors pymongo python-dotenv openai Werkzeug

Write-Host "Instalando dependencias de React..." -ForegroundColor Green
Set-Location frontend
npm install

Write-Host "Iniciando servidores..." -ForegroundColor Green
Start-Process powershell -ArgumentList "Set-Location $PSScriptRoot; python app.py"
Start-Sleep -Seconds 5
Start-Process powershell -ArgumentList "Set-Location $PSScriptRoot\frontend; npm start"
Start-Sleep -Seconds 5

Write-Host "¡Aplicación iniciada! Abriendo navegador..." -ForegroundColor Green
Start-Process "http://localhost:3000" 