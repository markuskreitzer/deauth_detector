import argparse
import configparser
import time
from pushover import init, Client
from ntfy import notify
from scapy.all import *
from scapy.layers.dot11 import Dot11, Dot11Deauth

# Argument parser
parser = argparse.ArgumentParser()
parser.add_argument("interface", help="Name of the interface to sniff on")
parser.add_argument("essid", help="ESSID to watch for deauths")
parser.add_argument("config_path", help="Path to the configuration file")
args = parser.parse_args()

# Config parser
config = configparser.ConfigParser()
config.read(args.config_path)

# Initialize Pushover
init(config.get('Pushover', 'APIToken'))
client = Client(config.get('Pushover', 'UserKey'))

# Last time a notification was sent
last_notification = 0

def handle_packet(packet):
    global last_notification
    # Check if this is a deauth packet
    if packet.haslayer(Dot11Deauth):
        # Check if this is for our ESSID
        if packet.info.decode() == args.essid:
            print("Deauth detected!")
            # Check if it's been at least a minute since the last notification
            if time.time() - last_notification >= 60:
                notify("Deauth detected on " + args.essid, title="Deauth Alert")
                last_notification = time.time()

try:
    sniff(iface=args.interface, prn=handle_packet)
except KeyboardInterrupt:
    print("Stopping sniffing")

