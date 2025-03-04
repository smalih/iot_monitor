import subprocess


def run_cicflowmeter():
    subprocess.Popen('cd /home/smalih/iot_monitor/rbp_server/cicflowmeter && poetry run cicflowmeter -i wlan0 -c rbp_py.csv', shell=True)