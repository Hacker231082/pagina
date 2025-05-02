# Lista de Productos con Soporte IA

Una aplicación web moderna para listar productos con capacidad de subir imágenes/videos y soporte de IA integrado.

## Características

- Lista de productos con soporte para imágenes y videos
- Interfaz moderna con Material-UI
- Asistente de soporte con IA
- Diseño responsivo
- Manejo de carga de archivos

## Requisitos Previos

- Python 3.8 o superior
- Node.js (v14 o superior)
- MongoDB
- Clave API de OpenAI

## Configuración

1. Clonar el repositorio

2. Instalar dependencias del backend (Python):
   ```bash
   pip install -r requirements.txt
   ```

3. Instalar dependencias del frontend:
   ```bash
   cd frontend
   npm install
   ```

4. Crear un archivo `.env` en el directorio raíz con las siguientes variables:
   ```
   MONGODB_URI=tu_cadena_conexion_mongodb
   OPENAI_API_KEY=tu_clave_api_openai
   PORT=5000
   ```

5. Crear un directorio `uploads` en la carpeta raíz:
   ```bash
   mkdir uploads
   ```

## Ejecutar la Aplicación

1. Iniciar el servidor backend (Python):
   ```bash
   python app.py
   ```

2. En una nueva terminal, iniciar el servidor frontend:
   ```bash
   cd frontend
   npm start
   ```

3. Abrir el navegador y navegar a `http://localhost:3000`

## Uso

1. Hacer clic en "Agregar Producto" para crear un nuevo producto
2. Completar los detalles del producto y subir una imagen o video
3. Hacer clic en "Soporte IA" para acceder al asistente de IA
4. Ver todos los productos en el diseño de cuadrícula principal

## Tecnologías Utilizadas

- React
- Material-UI
- Python (Flask)
- MongoDB
- OpenAI API
- Werkzeug (para carga de archivos) 