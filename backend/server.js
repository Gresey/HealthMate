import express from 'express';
import fetchdata from './routes/userdatafetch.js';
import postdata from './routes/userdatastore.js';
import cors from 'cors';
import user from './routes/user.js';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();
const app = express();

app.use(cors({
  origin: '*',
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); 

// MongoDB connection URI
const uri = process.env.MONGODB_URI;

// Mongoose connection
mongoose.connect(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('MongoDB connected successfully'))
  .catch(err => console.error('MongoDB connection error:', err));

app.use('/auth', user);
app.use('/getroutes', fetchdata);
app.use('/postroutes', postdata);

app.listen(3000, '0.0.0.0', () => {
  console.log('Server is running on port 3000');
});
