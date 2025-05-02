const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const { Configuration, OpenAIApi } = require('openai');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/product-listing', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Multer configuration for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

// OpenAI configuration
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

// Product Schema
const productSchema = new mongoose.Schema({
  title: String,
  description: String,
  price: Number,
  mediaUrl: String,
  mediaType: String,
  createdAt: { type: Date, default: Date.now }
});

const Product = mongoose.model('Product', productSchema);

// Routes
app.post('/api/products', upload.single('media'), async (req, res) => {
  try {
    const { title, description, price } = req.body;
    const mediaUrl = req.file ? `/uploads/${req.file.filename}` : null;
    const mediaType = req.file ? req.file.mimetype.startsWith('image/') ? 'image' : 'video' : null;

    const product = new Product({
      title,
      description,
      price,
      mediaUrl,
      mediaType
    });

    await product.save();
    res.status(201).json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/products', async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// AI Support endpoint
app.post('/api/ai-support', async (req, res) => {
  try {
    const { question } = req.body;
    const completion = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a helpful product support assistant."
        },
        {
          role: "user",
          content: question
        }
      ],
    });

    res.json({ response: completion.data.choices[0].message.content });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 