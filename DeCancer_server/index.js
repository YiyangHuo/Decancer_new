// const firebase = require("firebase/app");
// require("firebase/analytics");
// require("firebase/auth");
// require("firebase/firestore");

var firebase = require('firebase-admin');
var serviceAccount = require('./firebase_conf.json');
const bodyParser = require("body-parser");
var firebaseMiddleware = require('express-firebase-middleware');
var tensorflowmodule = require("./tensorflow_model")

var formidable = require("formidable")
//var tensowflowpredict = require("./tensorflow_predict")
var tf  = require('@tensorflow/tfjs');

const express = require('express');
const app = express();
var server = require('http').createServer(app);
var test_response = "bruh";
const saltedMd5=require('salted-md5')
const path=require('path');
const multer=require('multer')
const fs = require("fs")
const upload=multer({storage: multer.memoryStorage()})
var dialogmodeule = require("./dialogflow")
let secret = "decancer-7d19a"
const uuid = require('uuid');
            
const FieldValue = firebase.firestore.FieldValue;

// const storage = multer.diskStorage({
//     destination: function(req, file, callback) {
//       callback(null, './images');
//     },
//     filename: function (req, file, callback) {
//       callback(null, file.fieldname);
//     }
 // });
require('dotenv').config()

app.use(bodyParser.urlencoded({ extended: false , limit: "50mb"}));
app.use(bodyParser.json({limit: "50mb"}));



const{Server}  = require("socket.io")
const io = new Server(server)
// var ios = io.listen(server)
connections = [];
doctor_connection = [];
var guest_message = [
    {Name: "bot", message:"Hi I am a AI chat bot."},
    {Name: "bot", message:"I am powered by NodeJs, Firebase, and Dialogflow."},
    {Name: "bot", message:"How may I serve?"}
]




firebase.initializeApp({
    credential: firebase.credential.cert(serviceAccount),
    storageBucket:process.env.BUCKET_URL
})

var bucket = firebase.storage().bucket()

var db = firebase.firestore();

io.sockets.on('connection', function(socket){
    socket.id = uuid.v4();
    //console.log("yes")
    var connectroom = false

    socket.on("DISCONNECT", function(data){
        connections.splice(connections.indexOf(socket), 1);
        console.log("%s sockets is disconnected", connections.length);
    });
    

    socket.on('SYNCHRONIZATION', function(data){
        connections.push(socket);
        console.log("%s sockets are connected", connections.length);
        socket.join('test room')
        if (data["idToken"] != "guest"){
            firebase.auth().verifyIdToken(data["idToken"]).then((decodedToken) => {
                const uid = decodedToken.uid;
                db.collection('messages').doc(uid).get().then(queryResult => {
                    //console.log(queryResult.data()["message"])
                    if(queryResult.exists) {
                        const response = queryResult.data()["message"];
                        socket.emit('INCOME_MESSAGE', response);
                    } else {
                        socket.emit('INCOME_MESSAGE', guest_message);
                    }
                })
                
              })
        } else {
            socket.emit('INCOME_MESSAGE', guest_message);
        }
    })

    socket.on('MESSAGE_FROM_DOCTOR', function(data){
        var d = new Date();
        var n = d.getTime().toLocaleString();
        const self_back = {
            message: data["message"],
            Name: "bot",
            timestamp: n
          };
        io.sockets.emit('INCOME_MESSAGE', [self_back])
    })

    socket.on('MESSAGE_FROM_CLIENT', function(data){
        var d = new Date();
        var n = d.getTime().toLocaleString();
        if(connectroom) {
            const self_back = {
                message: data["message"],
                Name: "self",
                timestamp: n
              };
              io.sockets.emit('INCOME_MESSAGE', [self_back])
            
        } else {
            var textresponse = dialogmodeule.rundialog("decancer-7d19a", data["message"], socket.id).then(
                (textresponse) => {
                    var d = new Date();
                    var n = d.getTime().toLocaleString();
                    const response = {
                        message: textresponse,
                        Name: "bot",
                        timestamp: n
                    };
    
    
                    if (data["idToken"] != "guest"){
                        firebase.auth().verifyIdToken(data["idToken"]).then((decodedToken) => {
                            var d = new Date();
                            var n = d.getTime().toLocaleString();
                            const uid = decodedToken.uid;
                            const self_back = {
                                message: data["message"],
                                Name: "self",
                                timestamp: n
                              };
                            if (textresponse == "CHAT_DELETE") {
                                deletechathistory(uid).then( (trueresponse) => {
                                    response.message = trueresponse
                                    socket.emit('INCOME_MESSAGE', [self_back]);
                                    socket.emit('INCOME_MESSAGE', [response]);
                                })
    
                            } else if(textresponse == "TALK_DOCTOR"){
                                console.log("yes")
                                const new_back = {
                                    message: "join you to a public chat room",
                                    Name: "bot",
                                    timestamp: n
                                  };
                                connectroom = true
                                socket.emit('INCOME_MESSAGE', [self_back]);
                                socket.emit('INCOME_MESSAGE', [new_back]);
                            }
                            else {
                                const test = db.collection('messages').doc(uid).set(
                                    {message: firebase.firestore.FieldValue.arrayUnion(self_back)},
                                    {merge: true}
                                    ).then(function(){
                                        socket.emit('INCOME_MESSAGE', [self_back]);
                                        var d = new Date();
                                        var n = d.getTime().toLocaleString();
                                        const test2 = db.collection('messages').doc(uid).set(
                                            {message: firebase.firestore.FieldValue.arrayUnion(response)},
                                            {merge: true}
                                        ).then(function() {
                                            socket.emit('INCOME_MESSAGE', [response]);
                                        });
                                        
                                        
                                    })
                                }
                          })
                    } else {
                        const self_back = {
                            message: data["message"],
                            Name: "self",
                            timestamp: n
                          };
                          socket.emit('INCOME_MESSAGE', [self_back]);
                        var d = new Date();
                        var n = d.getTime().toLocaleString();
                        
                        const response = {
                            message: textresponse,
                            Name: "bot",
                            timestamp: n
                          };
                        if(textresponse == "CHAT_DELETE") {
                            deletechathistory("guest").then((trueresonse) => {
                                response.message = trueresonse
                                socket.emit('INCOME_MESSAGE', [response]);
                            })
                        }  else if (textresponse == "TALK_DOCTOR"){
                            console.log("yes")
                            const new_back = {
                                message: "join you to a public chat room",
                                Name: "bot",
                                timestamp: n
                              };
                            connectroom = true
                            socket.emit('INCOME_MESSAGE', [self_back]);
                            socket.emit('INCOME_MESSAGE', [new_back]);
                        } else {
                            socket.emit('INCOME_MESSAGE', [response]);
                        }
                        
                    }      
                }
            )
        } 
        
    })

}); 



app.post('/', (req, res) => {
  res.send('Hello World!')
});

app.use(express.static('public'))

app.post('/test', (req, res) => {
    var response = dialogmodeule.rundialog("decancer-7d19a").then(
        (theresponse) => {
            res.send(theresponse)
        }
    )
    
  });


app.use('/auth', firebaseMiddleware.auth);
//.doc("ndoT2IqOPdVokZRNVaOVYl93uZo2").collection('singledatas')
app.post('/hello', (req, res) => {
    const snapshot = db.collection('predictions').doc('ndoT2IqOPdVokZRNVaOVYl93uZo2').collection('singledatas').get().then((querySnapshot) => {
        const tempDoc = querySnapshot.docs.map((doc) => {
            return { id: doc.id, ...doc.data() }
          })
          //console.log(tempDoc)
          res.status(200).json(tempDoc);
    }).catch((err) => {
        console.log(err);
        res.status(500).send(err)
    });
    

});

app.post('/testupdate', (req, res) => {
    const snapshot = db.collection('predictions').doc('ndoT2IqOPdVokZRNVaOVYl93uZo2').collection('singledatas').doc('4adf62a45df886da87f9b8b712607f19.jpeg').update(
        {
            isfeedback:true
        }
    ).then((querySnapshot) => {
        
        var d = new Date();
        var timestamp = d.getTime().toLocaleString();
        const data_in = {
            timestamp: timestamp,
            photoid: '4adf62a45df886da87f9b8b712607f19.jpeg',
            prediction: 4,
            trueprediction: 5
        }
        const test = db.collection('Feedbacks').doc(timestamp).set(
            {data: data_in},
            {merge: true}
            ).then(function(){
                res.status(200).send("successfull") 
            })

    })
    

});


app.post('/records', (req, res) => {
    thetoken = "guest"
    authorization = req.headers["authorization"];
    if(authorization != undefined) {
        thetoken = authorization
    } else {
        res.status(401).send(err)
    }

    firebase.auth().verifyIdToken(thetoken).then((decodedToken) => {

        const uid = decodedToken.uid;
        const snapshot = db.collection('predictions').doc(uid).collection('singledatas').get().then((querySnapshot) => {
            const tempDoc = querySnapshot.docs.map((doc) => {
                return { id: doc.id, ...doc.data() }
              })
              //console.log("yes")
              res.status(200).send(tempDoc);
        })
        }).catch((err) => {
            console.log(err);
            res.status(500).send(err)
        });
    
});

app.post('/handinfeedback', (req, res) => {
    thetoken = "guest"
    authorization = req.headers["authorization"];
    if(authorization != undefined) {
        thetoken = authorization
    } else {
        res.status(401).send(err)
    }
    var feedback = req.body

    firebase.auth().verifyIdToken(thetoken).then((decodedToken) => {

        const uid = decodedToken.uid;
        const snapshot = db.collection('predictions').doc(uid).collection('singledatas').doc(feedback["photoid"]).update(
            {
                isfeedback:true
            }
        ).then((querySnapshot) => {
            
            var d = new Date();
            var timestamp = d.getTime().toLocaleString();
            const data_in = {
                timestamp: timestamp,
                photoid: feedback["photoid"],
                prediction: feedback["old_predict"],
                trueprediction: feedback["true_predicts"]
            }
            const test = db.collection('Feedbacks').doc(timestamp).set(
                {data: data_in},
                {merge: true}
                ).then(function(){
                    res.status(200).send("successfull") 
                })

        })
        }).catch((err) => {
            console.log(err);
            res.status(500).send(err)
        });


});



app.post('/upload',upload.single('file'), async(req,res)=>{
    //console.log(req);
    const name = saltedMd5(req.file.originalname, 'SUPER-S@LT!')

    const fileName = name + path.extname(req.file.originalname)
    //console.log(fileName)

    //var themodel = tensowflowmodule.model

    const blobWriter =  bucket.file(fileName).createWriteStream(
        {metadata: {
            contentType : req.file.mimetype
        }}
    )
    blobWriter.on('error', (err) => {
        console.log(err)
    })
    //req.file.path

    blobWriter.end(req.file.buffer)


    tensorflowmodule.predict(req.file.buffer).then((imageClassification) => {
        thetoken = "guest"
        authorization = req.headers["authorization"];
        if(authorization != undefined) {
            thetoken = authorization
            //console.log(thetoken)
        }
        var max = Math.max.apply(null, imageClassification)
        var max_idx = imageClassification.indexOf(max)
        
        var sum = imageClassification.reduce((a, b) => a + b, 0)
        var prob = (max / sum)
        var d = new Date();
        var timestamp = d.getTime().toLocaleString();
        const thepredict = {
            timestamp: timestamp,
            isfeedback: false,
            photoid: fileName,
            prediction: max_idx,
            probability: prob
          };

        if (thetoken != "guest"){
            
            firebase.auth().verifyIdToken(thetoken).then((decodedToken) => {

                const uid = decodedToken.uid;
                //console.log(uid)
                // const test = db.collection('predictions').doc(uid).set(
                // {data:firebase.firestore.FieldValue.arrayUnion(thepredict)},
                // {merge: true}
                // )
                const test = db.collection('predictions').doc(uid).collection("singledatas").doc(fileName).set(
                    thepredict,
                    {merge: true}
                    )
                .then(function(err){
                    res.status(200).send(thepredict)
                })
                
              })
        } else {
            res.status(200).send(thepredict)
        }
    })
    .catch((err) => {
        console.log(err);
        res.status(500).send(err)
    })


    // blobWriter.on('finish', () => {
    //     res.status(200).send("File uploaded.")
    // })s
    })


app.post('/test/setfirestore', (req, res) => {
    var d = new Date();
    var n = d.getTime().toLocaleString();
    const data = {
        name: 'Los Angeles',
        state: 'CA',
        country: [{"USA": n}]
      };
      
      // Add a new document in collection "cities" with ID 'LA'
      const test = db.collection('messages').doc('123').set(data);
    res.send("aha");
});

app.post('/test/updatefirestore', (req, res) => {
    var d = new Date();
    var n = d.getTime().toLocaleString();
    
      // Add a new document in collection "cities" with ID 'LA'
      const test = db.collection('messages').doc('123').set(
            {country: firebase.firestore.FieldValue.arrayUnion({"N": n})},
            {merge: true}
      );
    res.send("aha");
});




server.listen(8000, "0.0.0.0", () => {
    console.log('Listening on port 8000')
  });

async function deletechathistory(uid) {
    if(uid == "guest"){
        return "No, you cannot delete your chat history because you are a guest. \n Quit and enter the chat room again will clean for you"
    } else {
        const res = await db.collection("messages").doc(uid).update({
            message: FieldValue.delete()
          });
        return "all your chat history is deleted. Quit and enter the room again and you are all set."
    }


}