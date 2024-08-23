################################################################################
# MCP230XX_WebUI.be
# This script provides a web interface for the MCP23017 I2C GPIO expander.
################################################################################
import webserver
import string
import json

class MCP230XX_WebUI
  var addr
  var wire
  var type
  var mcp230xx
  
  def init()
    self.addr = 0x20 # Address of MCP23017
    self.wire = tasmota.wire_scan(self.addr, 22)
  end
  
  def read_mcp230xx()
    #if !self.wire return nil end #- exit if not initialized -#
    var sensors = json.load(tasmota.read_sensors())
    self.mcp230xx = sensors.find('MCP230XX', {})
    if mcp230xx.find('D15', nil)
      self.type = 'MCP23017'
    elif mcp230xx.find('D7', nil)
      self.type = 'MCP23008'
    else
      self.type = 'Unknown'
    end
  end
  
  def every_second()
    #if !self.wire return nil end #- exit if not initialized -#
    self.read_mcp230xx()
  end

  #- display sensor value in the web UI -#
  def web_sensor()
    #if !self.wire return nil end #- exit if not initialized -#

    var state_text = {-1:"NULL", 0:"CLOSE", 1:"OPEN"}
    var msg = string.format(
             "{s}MCP230XX {m}%s @ 0x%02x{e}"..
             "{s}MCP230XX D0{m}%s{e}"..
             "{s}MCP230XX D1{m}%s{e}"..
             "{s}MCP230XX D2{m}%s{e}"..
             "{s}MCP230XX D3{m}%s{e}"..
             "{s}MCP230XX D4{m}%s{e}"..
             "{s}MCP230XX D5{m}%s{e}"..
             "{s}MCP230XX D6{m}%s{e}"..
             "{s}MCP230XX D7{m}%s{e}"..
             "{s}MCP230XX D8{m}%s{e}"..
             "{s}MCP230XX D9{m}%s{e}"..
             "{s}MCP230XX D10{m}%s{e}"..
             "{s}MCP230XX D11{m}%s{e}"..
             "{s}MCP230XX D12{m}%s{e}"..
             "{s}MCP230XX D13{m}%s{e}"..
             "{s}MCP230XX D14{m}%s{e}"..
             "{s}MCP230XX D15{m}%s{e}",
              self.type,
              self.addr,
              state_text[self.mcp230xx.find('D0', -1)],
              state_text[self.mcp230xx.find('D1', -1)],
              state_text[self.mcp230xx.find('D2', -1)],
              state_text[self.mcp230xx.find('D3', -1)],
              state_text[self.mcp230xx.find('D4', -1)],
              state_text[self.mcp230xx.find('D5', -1)],
              state_text[self.mcp230xx.find('D6', -1)],
              state_text[self.mcp230xx.find('D7', -1)],
              state_text[self.mcp230xx.find('D8', -1)],
              state_text[self.mcp230xx.find('D9', -1)],
              state_text[self.mcp230xx.find('D10', -1)],
              state_text[self.mcp230xx.find('D11', -1)],
              state_text[self.mcp230xx.find('D12', -1)],
              state_text[self.mcp230xx.find('D13', -1)],
              state_text[self.mcp230xx.find('D14', -1)],
              state_text[self.mcp230xx.find('D15', -1)])
    tasmota.web_send_decimal(msg)
  end
  
end

mcp230xx_webui = MCP230XX_WebUI()
tasmota.add_driver(mcp230xx_webui)

