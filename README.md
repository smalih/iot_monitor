# LockMyIoT
## Instructions

### Starting the FastAPI Backend Server
In order to run the start the python backend server, you must first install poetry.
Use their official installer and follow the instructions on their website (https://python-poetry.org/).

Add the poetry installation your .bashrc file and source the .bashrc file
cd into iot_monitor/rbp_server/cicflowmeter and run 'poetry install' (if you are hvaing issues then try clearing your poetry cache, removing the poetry.lock file, and executing 'poetry config keyring.enabled false').

Once the cicflowmeter tool has been installed, cd into iot_monitor/

Create a new python virtual environment "python3 -m venv venv".

Activate the virtual environment by running 'source venv/bin/activate' on Linux or MacOS, and 'venv\Scripts\activate' on Windows.

Next, install the required dependencies by running 'pip install -r requirements.txt'

cd into the rbp_server and run 'sudo -Es' to switch to the root user whilst remaining the env variables of the local user.

To start the server, run 'python server.py'.

### Building the SwiftUI Mobile Application
To build the mobile applications, you must have Xcode Command Line Tools installed on a MacOS machine. Open Xcode, plug your iOS device (ideally running iOS 18 or higher) into your machine running Xcode, select your device as the build target, and press the play button to start the build process.

Once Xcode has finished building the application, you can access it on your phone (ensure the Trust the VPN profile for the application).