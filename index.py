from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from werkzeug.utils import secure_filename
from pymongo import MongoClient
from openai import OpenAI
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

app = Flask(__name__)
CORS(app)

# Configuración de MongoDB
client = MongoClient(os.getenv('MONGODB_URI', 'mongodb://localhost:27017/'))
db = client['lista-productos']
productos = db['productos']

# Configuración de OpenAI
client_openai = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

# Configuración de carga de archivos
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mov', 'avi'}

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/api/productos', methods=['POST'])
def crear_producto():
    try:
        titulo = request.form.get('titulo')
        descripcion = request.form.get('descripcion')
        precio = float(request.form.get('precio'))
        
        if 'media' not in request.files:
            return jsonify({'error': 'No se ha subido ningún archivo'}), 400
            
        archivo = request.files['media']
        if archivo.filename == '':
            return jsonify({'error': 'No se ha seleccionado ningún archivo'}), 400
            
        if archivo and allowed_file(archivo.filename):
            filename = secure_filename(archivo.filename)
            archivo.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            
            tipo_media = 'imagen' if archivo.content_type.startswith('image/') else 'video'
            url_media = f'/uploads/{filename}'
            
            producto = {
                'titulo': titulo,
                'descripcion': descripcion,
                'precio': precio,
                'url_media': url_media,
                'tipo_media': tipo_media
            }
            
            resultado = productos.insert_one(producto)
            producto['_id'] = str(resultado.inserted_id)
            
            return jsonify(producto), 201
            
        return jsonify({'error': 'Tipo de archivo no permitido'}), 400
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/productos', methods=['GET'])
def obtener_productos():
    try:
        lista_productos = list(productos.find())
        for producto in lista_productos:
            producto['_id'] = str(producto['_id'])
        return jsonify(lista_productos)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/soporte-ia', methods=['POST'])
def soporte_ia():
    try:
        pregunta = request.json.get('pregunta')
        if not pregunta:
            return jsonify({'error': 'No se ha proporcionado una pregunta'}), 400
            
        respuesta = client_openai.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "Eres un asistente de soporte de productos amigable y servicial."
                },
                {
                    "role": "user",
                    "content": pregunta
                }
            ]
        )
        
        return jsonify({'respuesta': respuesta.choices[0].message.content})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

# Para desarrollo local
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True) 