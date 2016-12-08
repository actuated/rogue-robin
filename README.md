# rogue-robin
Rough script for looping through dummy APs with hostapd-wpe, for WIPS evasion.

# Setup
* Set up hostapd-wpe (https://github.com/OpenSecurityResearch/hostapd-wpe).
* Save `rogue-robin.sh` and your hostapd-wpe config file in the same directory.
* Set up your hostapd-wpe config file.
* Configure your apapter and hostapd-wpe path in `rogue-robin.sh`:
  - `varInt` is the variable for your wireless interface.
  - `varHostapdWPEPath` is the path for your hostapd-wpe implementation.
  
# Usage
* This process can be used to keep a WIPS busy with dummy rogue APs, while you run a separate one to attack the wireless clients. This was used in a real-world assessment, where the script was used with a Kali VM and an Alfa card, while a separate VM was used for the actual attack.
* Run the script from the location where it and your hostapd-wpe config file are saved: `./rogue-robin.sh`.
* The script will:
  - Change to your hostapd-wpe implementation directory.
  - Use `rfkill` to make sure the wireless interface is not blocked.
  - Disable the wireless interface.
  - Use `macchanger` to change the wireless interface's MAC.
  - Enable the wireless interface.
  - Use `airmon-ng check kill` to make sure the wireless interface is free.
  - Run hostapd-wpe, referencing the config file stored in the path from which the script was launched.
  - Sleep for 15 seconds (which can be modified by changing the value of `varSleep`.
  - Get the PID for your hostapd-wpe process and kill it.
  - Sleep for 5 seconds.
  - Restart the function that began with `rfkill`.
