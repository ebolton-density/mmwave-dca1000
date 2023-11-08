## DCA1000


### Data Capture - OA Side
1. Install this image on the OA: https://s3.amazonaws.com/density-linux-artifacts/release/15020-5bea592-HLAB-4-dca-control-oa-internal-ota.swu

2. Use `scp` to transfer both the mmwave firmware and chirp config to `/cache` (if needed).

3. Shell into the OA and edit `/cache/density/config.json` to include the following config block:
```
{
    "algo": {
        "deviceConfigName": "/cache/density/dca1000/juno_calibration_11.cfg",
        "fwpath": "/cache/density/dca1000/juno-firmware-unsigned.bin"
    },
    "override": {
      "lvdsStreamCfg": "-1 1 1 1"
    }
}
```
Set the paths for `deviceConfigName` and `fwpath`.

4. Reboot the OA and shell into it again.

5. Verify that the firmware and chirp config have been loaded correctly with:
```
journalctl -u mmwave-app
```


### Data Capture - Capture Side
1. Shell into the chamber workstation:
```
ssh lab@192.168.11.61
cd ~/oa-data-capture/mmwave-dca1000-trunk
```

2. Set the data capture config (use `./config/juno-dca1000-lab.json` as a start):
```
"ethernetConfig": {
    "DCA1000IPAddress": "192.168.11.250",
    "DCA1000ConfigPort": 4096,
    "DCA1000DataPort": 4098
},
"captureConfig": {
    "fileBasePath": "/home/lab/oa-data-capture/data",
    "filePrefix": "juno-phase",
    "maxRecFileSize_MB": 1024,
    "sequenceNumberEnable": 1,
    "captureStopMode": "duration",
    "bytesToCapture": 50000,
    "durationToCapture_ms": 30000,
    "framesToCapture": 10
}
```
This sets up a 30 second capture using the following params:

* `DCA1000IPAddress` - IP address of the capture board (set in the EEPROM).
* `fileBasePath` : location of the capture data.
* `filePrefix` : prefix of captures files (they're appended with a timestamp).
* `captureStopMode` : determines when the capture stops (can be one of four values):
  * bytes
  * frames
  * duration
  * infinite

8. Start the capture:
```
cd ./install
./start-record.sh ../config/juno-dca1000-lab.json
```

9. Stop the capture (this is **required** even with a duration based capture):
```
./stop-record.sh
```


### Update EEPROM
1. Set SW2.5 to ON (allow SW config)
2. Set SW2.6 to ON (load FPGA defaults for IP config)
3. Use the following JSON config:
```
    "ethernetConfig": {
        "DCA1000IPAddress": "192.168.33.180",
        "DCA1000ConfigPort": 4096,
        "DCA1000DataPort": 4098
    },
    "ethernetConfigUpdate": {
        "systemIPAddress": "NEW_SYSTEM_IP",
        "DCA1000IPAddress": "NEW_DCA_IP",
        "DCA1000MACAddress": "12.34.56.78.90.12",
        "DCA1000ConfigPort": 4096,
        "DCA1000DataPort": 4098
    }
```
4. Update the EEPROM config:
```
update-eeprom.sh <JSON_PATH>
```


### Command Line Utils
* DCA1000EVM_CLI_Control
  * fpga - configure the fpga using JSON values
  * start_record - start recording raw data
  * stop_record - stop recording raw data
  * query_status - returns system status codes


### Suspending the FTDI
1. Find the port number of the FTDI on the DCA1000
```
ebolton@ebolton-XPS-15-9510:~/density/lab-594-mmwave-env/mmwave-studio/src/Release$ sudo dmesg | grep usb | grep Product
[ 3663.602983] usb 5-2.3.1.2: Product: Quad RS232-HS
[ 3663.902677] usb 5-2.3.1.4: New USB device found, idVendor=0451, idProduct=fd03, bcdDevice= 8.00
[ 3663.902687] usb 5-2.3.1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 3663.902691] usb 5-2.3.1.4: Product: AR-DevPack-EVM-012
[ 3684.087185] usb 5-2.3.1.2: New USB device found, idVendor=0403, idProduct=6011, bcdDevice= 8.00
[ 3684.087196] usb 5-2.3.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
```
note the port number: 5-2.3.1.4 (this will be different on each machine)

2. Suspend the FTDI ports on the DCA1000
```
cd src/Release
sudo ./suspend-ftdi-usb.sh <PORT_NUMBER> # 5-2.3.1.4 in the example
```


### References
* https://www.ti.com/tool/DCA1000EVM
* https://www.ti.com/tool/MMWAVE-STUDIO
* https://e2e.ti.com/support/sensors-group/sensors/f/sensors-forum/1085015/dca1000evm-dca1000-schematic-diagram
* https://e2e.ti.com/support/sensors-group/sensors/f/sensors-forum/851374/dca1000evm-dca1000-fpga-hdl-source-code
