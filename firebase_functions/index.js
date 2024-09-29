const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('messages/{messageId}')
    .onCreate((snap, context) => {
        const message = snap.data();
        
        const payload = {
            notification: {
                title: 'New Message',
                body: message.text,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return admin.messaging().sendToTopic('all_users', payload);
    });

exports.detectCars = functions.https.onRequest(async (req, res) => {
    try {
        const youtubeUrl = req.body.youtube_url;
        if (!youtubeUrl) {
            return res.status(400).send({ error: 'youtube_url parameter is required' });
        }

        const response = await axios.post('https://car-detection-service-808791551084.europe-west1.run.app/detect-cars', { youtube_url: youtubeUrl });
        return res.status(200).send(response.data);
    } catch (error) {
        return res.status(500).send({ error: error.message });
    }
});