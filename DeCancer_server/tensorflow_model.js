var tf = require('@tensorflow/tfjs');
var tfcore = require('@tensorflow/tfjs-node')
const mobilenet = require('@tensorflow-models/mobilenet');
var image = require("get-image-data")
var jimp = require("jimp")
//import {loadGraphModel} from '@tensorflow/tfjs-converter';
const MODEL_URL = tfcore.io.fileSystem('./Keras_model/model.json');
const imagesize = 225


async function getmodel() {
    return await tf.loadLayerModel(MODEL_URL);
}

var testmodel = mobilenet.load()

function predict(filepath) {
    
    return new Promise((resolve, reject) => {
        jimp.read(filepath).then(readedimage => {
            readedimage.resize(imagesize, imagesize)
            image(readedimage, async(err, theimage) => {
                if (err) {
                    reject(err);
                } else {
                    const channelCount = 3;
                    //theimage = theimage.resize(275,275)
                    const pixelCount = theimage.width * theimage.height;
                    const vals  = new Float32Array(pixelCount * channelCount);
                    let pixels = theimage.data
                    for (let i = 0; i < pixelCount; i++){
                        for(let k = 0; k < channelCount; k++) {
                            vals[i * channelCount + k] = pixels[i*4 + k]/255;
                        }
                    }
                    //console.log(vals)

                    const outputShape = [theimage.height, theimage.width, channelCount];
                    const input = tf.tensor3d(vals, outputShape, "float32");
                    const axis = 0;
                    inputnew = input.expandDims(axis)

                    const themodel = await tf.loadLayersModel(MODEL_URL);
                    var output = themodel.predict(inputnew).arraySync();
                    var normalizedoutput = normalizearray(output[0]);

                    //console.log(normalizedoutput);
                    resolve(normalizedoutput);
                }
            })
        }).catch(err => {
            reject(err);
        });
                
    })
}

function normalizearray(thearray){
    // console.log(thearray)
    // var max = Math.max.apply(null, thearray);
    // var min = Math.min.apply(null, thearray);
    // console.log(max, min)
    console.log(thearray)
    for (var i = 0; i < thearray.length; i++) {
        var val = thearray[i]
        thearray[i] = val/100
        //Do something
    }
    //console.log(thearray)
    return thearray
}



exports.model = getmodel
exports.predict = predict
exports.testmodel = testmodel