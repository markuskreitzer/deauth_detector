# Deauth Detector

![Python Version](https://img.shields.io/badge/python-3.7+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)

Deauth Detector is a Python program that uses Scapy to sniff for deauthentication packets in WiFi traffic and sends a Pushover alert when detected. It uses [ntfy](https://ntfy.readthedocs.io/en/latest/) to send alerts. [ntfy](https://ntfy.readthedocs.io/en/latest/) can be configured to use many alert systems such as pushover, Slack, etc. to send alerts.

## Introduction

WiFi deauthentication attacks can be a serious threat to wireless networks. This program helps to monitor such attacks. It listens for deauthentication packets on a specified ESSID and sends an alert using ntfy.

Note that this application needs to run as root to have access to the low level packets sent by the wifi interface. 

The target platform is ideally a Raspberry pi with a secondary USB Wifi Dongle.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/markuskreitzer/deauth_detector.git
   cd deauth_detector
   ```
2. Install the necessary Python libraries. The commands below will create a venv environment to install python packages in so that it doesn't conflict with anything in the global scope.

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip3 install -r requirements.txt
   ```

3. Set your WiFi card in monitor mode.

   ```bash
   iw dev wlan0 set type monitor
   ```

4. Create a configuration file named `/root/.ntfy.yml` in root home directory. See [https://ntfy.readthedocs.io/en/latest/](https://ntfy.readthedocs.io/en/latest/) for complete details on this step.

   ```cfg
   ---
   backends:
       - pushover
   pushover:
       user_key: xxxxxxxxxxxxxx
   
   ```


5. Run the install script with your ESSID and the interface you want to monitor as arguments:

   ```bash
   ./install.sh your_essid your_interface
   ```

6. To start the service:

   ```bash
   # Run enable if service isn't automatically enabled by the install.sh script.
   # sudo systemctl enable deauth_detect.service
   sudo systemctl start deauth_detect.service
   ```

## Usage
Once the service is running, it will listen for deauthentication packets on the specified ESSID. If it detects one, it will send a Pushover alert to your mobile device. To view the logs of the service, use the journalctl command:

```bash
journalctl -u deauth_detect.service
```

## Disclaimer
Use of this program for malicious purposes is not endorsed by the developer. It is your responsibility to comply with all applicable local, state, and federal laws.

## License
This project is licensed under the MIT License.

