
import tensorflow as tf
from tensorflow import keras


new_model = tf.keras.models.load_model('model.keras')
def run_model(flow_data):
    