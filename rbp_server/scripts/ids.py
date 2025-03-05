import os
import pandas as pd
import numpy as np

import joblib

import tensorflow as tf
import tensorflow.keras as keras
# Change display.max_rows to show all features.
pd.set_option("display.max_rows", 85)


MODEL_DIR_PATH = "/Users/smalih/CICIDS_models/my_model"
PROCESSED_DIR_PATH = "/Users/smalih/CICIDS_models/processed_dataset"

UTILS_PATH = "/home/smalih/iot_monitor/rbp_server/utils"


model = keras.models.load_model(os.path.join(UTILS_PATH, '06_cnn.h5'))
label_encoder = np.load(os.path.join(UTILS_PATH, 'label_encoder.npy'), allow_pickle=True)
scaler = joblib.load(os.path.join(UTILS_PATH, 'x_scaler.pkl'))

with open('/home/smalih/iot_monitor/rbp_server/cicflowmeter/fields.txt', 'r') as fields_file:
    fields = fields_file.read().splitlines()

n = 0

def reshape_dataset_cnn(x: np.ndarray) -> np.ndarray:
    # Add padding columns
    result = np.zeros((x.shape[0], 49)) # changed 81 to 49 as 48 features
    result[:, :-1] = x # changed -3 to -1 as only one column is padding

    # Reshaping dataset
    result = np.reshape(result, (result.shape[0], 7, 7))
    result = result[..., tf.newaxis]
    return result

def get_predictions(data):
    y_pred = model.predict(data, batch_size=1024, verbose=False)
    y_pred = label_encoder[np.argmax(y_pred, axis=1)]
    return y_pred

def classify_data(log_path):
    global n
    try:
        new_data = pd.read_csv(log_path, usecols=fields, skiprows=[i for i in range(1, n)])
    except pd.errors.EmptyDataError:
        return

    if not new_data.empty:
        x = scaler.fit_transform(new_data.iloc[:,2:])
        x = reshape_dataset_cnn(x)
        n += len(new_data)
        preds = get_predictions(x)
        attack_indices = preds[preds != 'BENIGN']
        attack_data = new_data.iloc[np.where(attack_indices)]
        attack_data = attack_data[['src_ip', 'dst_ip']]
        attack_data['LABEL'] = attack_indices

        if not attack_data.empty:
            return attack_data