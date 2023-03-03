## DCA1000
https://www.ti.com/tool/DCA1000EVM
https://www.ti.com/tool/MMWAVE-STUDIO
https://e2e.ti.com/support/sensors-group/sensors/f/sensors-forum/1085015/dca1000evm-dca1000-schematic-diagram
https://e2e.ti.com/support/sensors-group/sensors/f/sensors-forum/851374/dca1000evm-dca1000-fpga-hdl-source-code

### Command Line Utils
DCA1000EVM_CLI_Control - Software user guide
fpga - configure the fpga using JSON values
start_record - start recording raw data
stop_record - stop recording raw data
query_status - returns system status codes (pg 18)

### Data Capture Steps
1. Disable the SPI and RS232 ports on the DCA1000
```
./disable.sh FPGA 1 # SPI
./disable.sh FPGA 3 # RS232
```

2. Flash the Juno image
```
sudo ./flash.sh FLASH ../../iwrflasher/firmware/xwr68xx_mmw_demo.bin
```
or
```
sudo ./flash.sh SRAM-SPI ../../iwrflasher/firmware/xwr68xx_mmw_demo.bin
```

3. Set the LVDS config on the IWR68XX
connect to the proc
```
minicom -D /dev/ttyUSB2
```
You should see the mmwave CLI: `mmwDemo:/>`
Set the LVDS config:
```
lvdsStreamCfg -1 1 1 1
```

4. Configure the DCA1000 FPGA
  From the mmwave-studio Release build dir:
  `LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control fpga ../../juno-dca1000.json`
  `LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control record ../../juno-dca1000.json`

5. Start recording
  From the mmwave-studio Release build dir:
  `LD_LIBRARY_PATH=. ./DCA1000EVM_CLI_Control start_record ../../juno-dca1000.json`

### Notes
* The DCA1000 can't drive NRST when connected to Juno.

### Build RADAR eval firmware
1. source env script for mmwave SDK
```
cd ~/ti/mmwave_sdk_03_06_00_00-LTS/packages/scripts/unix
source setenv.sh
```

2. build image
```
cd rf-eval-firmware/scripts
./generateMetaImage.sh ../xwr68xx_rf_eval.bin 0x00000006 ../masterss/xwr68xx_masterss.bin ../radarss/xwr68xx_radarss.bin NULL
./generateMetaImage.sh ../xwr68xx_rf_eval.bin 0x00000006 ../masterss/xwr68xx_masterss.bin ../radarss/xwr68xx_radarss.bin ../../../mmwave-firmware/oob-demo-makefile/xwr68xx_mmw_demo_dss.xe674
```

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
