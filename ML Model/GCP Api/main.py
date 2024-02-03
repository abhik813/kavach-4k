import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import io
import tensorflow as tf
from tensorflow import keras
import numpy as np
# from PIL import Image
import librosa
from tensorflow.image import resize


from flask import Flask, request, jsonify

model = keras.models.load_model("audio_classification_model.h5")

target_shape = (256, 256)

classes = ['Danger', 'Normal']

# Function to preprocess and classify an audio file
def test_audio(file_path):
    # Load and preprocess the audio file
    audio_data, sample_rate = librosa.load(file_path, sr=None)
    mel_spectrogram = librosa.feature.melspectrogram(y=audio_data, sr=sample_rate)
    mel_spectrogram = resize(np.expand_dims(mel_spectrogram, axis=-1), target_shape)
    mel_spectrogram = tf.reshape(mel_spectrogram, (1,) + target_shape + (1,))

    predictions = model.predict(mel_spectrogram)

    class_probabilities = predictions[0]

    predicted_class_index = np.argmax(class_probabilities)
    predicted_class = classes[predicted_class_index]
    accuracy = class_probabilities[predicted_class_index]*100


    return predicted_class, accuracy


app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        file = request.files.get('file')
        if file is None or file.filename == "":
            return jsonify({"error": "no file"})

        try:
            predicted_class, accuracy = test_audio(file)

            data = {"predicted_class": predicted_class, "accuracy": int(accuracy)}
            return jsonify(data)
        except Exception as e:
            return jsonify({"error": str(e)})

    return "OK"


if __name__ == "__main__":
    app.run(debug=True)