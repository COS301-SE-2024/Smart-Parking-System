require('dotenv').config();
const express = require('express');
const { MongoClient } = require('mongodb');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const os = require('os');

const app = express();
app.use(bodyParser.json());
const port = 3000;

// MongoDB URI
const uri = "mongodb://localhost:27017";
const databaseName = 'Smart_Parking_System';

let db;
let bucket;

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// Connect to MongoDB
MongoClient.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(client => {
    db = client.db(databaseName);
    console.log('Connected to MongoDB');
  })
  .catch(error => console.error('Error connecting to MongoDB:', error));


  app.post('/signup', async (req, res) => {
    console.log(req.body);
    const { name, surname, phoneNumber, email, password } = req.body;
  
    if (!name || !surname || !phoneNumber || !email || !password) {
      console.log('Error is 400 because you are missing values');
      return res.status(400).send('Name, Surname, Phone Number, Email, and Password are required.');
    }

    //Now do checks whether the country is correct/etc
  
    try {
      // Check if the user already exists
      const user = await db.collection('users').findOne({ email: email });
      if (user) {
        console.log('Error is 400 email already exsists');
        return res.status(400).send('User with this email already exists.');
      }
  
      // Hash the password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);
  
      // Insert the new user into the database
      await db.collection('users').insertOne({
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        email: email,
        password: hashedPassword
      });
  
      return res.status(201).send('User registered successfully.');
    } catch (error) {
      console.error('Error registering user:', error);
      return res.status(500).send('Internal server error.');
    }
  });
  
  app.post('/verification', (req, res) => {
    const { email, code } = req.body;
  
    if (!email || !code) {
      return res.status(400).send('Email and code are required.');
    }
  
    const mailOptions = {
      from: 'admin@mycompany.co.za',
      to: email,
      subject: 'Verification Code',
      text: `Your verification code is: ${code}`
    };
  
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error('Error sending email:', error);
        return res.status(500).send('Error sending email.');
      }
      console.log('Email sent: ' + info.response);
      return res.status(200).send('Verification email sent.');
    });
  });
  
  app.post('/emailChecker', async (req, res) => {
    const { email } = req.body;
  
    if (!email) {
      return res.status(400).send('Email is required.');
    }
  
    // Check if a user exists with the provided email address
    const user = await db.collection('users').findOne({ email: email });
      if (!user) {
        // User does not exist
        console.log('There isnt a user');
        return res.status(201).send('User not found.'); // Respond with 201
      }
      // User exists
      console.log('We found a user');
      return res.status(400).send('User already exists.'); // Respond with 400
   
  });
  
  app.post('/login', async (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).send('Email and password are required.');
    }
  
    try {
      // Check if the user exists
      const user = await db.collection('users').findOne({ email: email });
      if (!user) {
        return res.status(400).send('Invalid email or password.');
      }
  
      // Compare the provided password with the stored hashed password
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(400).send('Invalid email or password.');
      }

      const userInfo = {
        id: user._id,
        email: user.email,
      };
  
      return res.status(200).json(userInfo);
    } catch (error) {
      console.error('Error signing in user:', error);
      return res.status(500).send('Internal server error.');
    }
  });

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
