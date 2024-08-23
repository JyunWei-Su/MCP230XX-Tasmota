# MCP230XX-Tasmota
This is a tasmota setting guide of MCP230XX (MCP23017 and MCP23008) and also integrate into HomeAssistant

## Read before starting
* This script provides a web interface to show the status of the MCP230XX I2C GPIO expander.
* It's aimed to be used the MCP230XX I2C GPIO expander with `input mode` (so it can be used to read the status of the input pins).
* After that, the device can work with 8 or 16 `reed switches`, `PIR sensors`, `motion sensor`, etc.

## Tasmota firmware
* You need to install a tasmota firmware that supports the MCP230XX I2C GPIO expander.
* For example, install the `Tasmota All Sensors (english)` firmware by using [Install Tasmota](https://tasmota.github.io/install/) website.

## Hardware connections
* Please refer to the Tasmota documentation [MCP23008 / MCP23017 GPIO Expander](https://tasmota.github.io/docs/MCP230xx/) for the hardware connections
* In this guide we will use the MCP230XX I2C GPIO expander with the following connections:
  * MCP230XX SDA: GPIO4
  * MCP230XX SCL: GPIO5
  * MCP230XX Address: 0x20
  * MCP230XX tasmota mode: Mode 1

## Configuration
1. Go to `Configuration` -> `Configure Module` page and select `I2C SDA` and `I2C SCL` pins for the MCP230XX I2C GPIO expander.
2. Go to `Tools` -> `Consoles` and enter the following commands:
  * `I2Cscan`: Check if the MCP230XX I2C GPIO expander is detected (0x20)
  * `Sensor29 Reset2`: Set the MCP230XX I2C GPIO expander to `input mode with pull-up`
  * `SetOption59 1`: Set extra SENSOR status telemetry messages (for HomeAssistnat)
3. You should see the console output similar to the following:
  `stat/tasmota/RESULT = {"Sensor29_D99":{"MODE":2,"PULL_UP":"ON","INT_MODE":"ALL","STATE":""}}`
4. Go to `Configuration` -> `Manage File system` and upload the `MCP230XX_WebUI.be` script. Make sure the file is uploaded successfully.
5. Also in the `Manage File system`, add the following line into `autoexec.be` file (If you don't have this file, create it):
  * `load('MCP23017_WebUI.be')`
6. Reboot the device and you should see the MCP230XX I2C GPIO expander status in the web interface.
  ![](https://raw.githubusercontent.com/JyunWei-Su/MCP230XX-Tasmota/main/img/tasmota_webui.png)
7. If you want to change the state text such as `ON/OFF` or `OPEN/CLOSE`, you can change the line `var state_text = {-1:"NULL", 0:"CLOSE", 1:"OPEN"}` in `MCP23017_WebUI.be`

## Other commands usually used
* `SetOption146 1`: Enable display of ESP32 internal temperature
* `WifiConfig2`: Set Wi-Fi Manager as the current configuration tool

## Integrate with HomeAssistant
### Communication between Tasmota and HomeAssistant
1. You should install the `Mosquitto broker` add-on in HomeAssistant.
2. For the Tasmota device, go to `Configuration` -> `Configure MQTT` and complete the following fields and save the configuration:
  * `Broker`: IP address of the HomeAssistant
  * `Port`: 1883
  * `Username`: Your HomeAssistant MQTT username
  * `Password`: Your HomeAssistant MQTT password (Remember to check the Password box)
3. Back to HomeAssistant, go to `Configuration` -> `Integrations` and add the `MQTT` and `Tasmota` integration.
4. The Tasmota device should be detected by HomeAssistant automatically.
### Using the template to redirect the sensor state
1. In HomeAssistant, go to `Device and Services` -> `Helpers` -> `CREATE HELPER` -> `Template` -> `Template a binary sensor`
2. Enter the following settings:
  * Name: Your sensor name (e.g. `Demo Window`)
  * State template: `{{ states('sensor.tasmota_mcp230xx_d0') }}` (Change the `d0` to `d0`~`d15` depends)
  * Device class: `Window` (depends on your sensor type)
  * Then click `SUBMIT`
  ![](https://raw.githubusercontent.com/JyunWei-Su/MCP230XX-Tasmota/main/img/binary_sensor_template_config.png)
3. You can see the sensor status in the HomeAssistant.
