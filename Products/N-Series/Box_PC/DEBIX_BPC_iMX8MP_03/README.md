# DEBIX BPC-iMX8MP-03 Industrial Computer

<p align="center">
<img  width=60% height=auto src="./Media_Assets/DEBIX_BPC_iMX8MP_03(1).png" alt="DEBIX_BPC_iMX8MP_03(1).png">
</p>

## Overview
BPC-iMX8MP-03 Industrial Computer is a compact and durable box PC designed for industrial applications. It is composed of a DEBIX SOM A core board, a DEBIX SOM A I/O Board carrier board, and a steel and aluminum enclosure.<br>
It's built to withstand harsh environments with a wide operating temperature range of -40℃ to 85℃, and it guarantees more than 50,000 hours of MTBF. All serial ports and GPIO are designed with isolation to improve safety.

## Main Features
- **Durable:** Solid steel and aluminum enclosure, wide temperature (-40°C to 85°C), \>50000 hours of MTBF

- **Modular:** Utilizes DEBIX SOM A core board and DEBIX SOM A I/O Board carrier board for flexibility

- **Multiple boot options:** Support eMMC, Micro SD and SPI Nor Flash(reserved)
  
- **Software Compatibility:** Support Windows, Ubuntu, Yocto, Debian, Android, OpenWRT and FreeRTOS operating systems
  
- **Powerful connectivity:** Include dual Gigabit network, 2.4GHz & 5GHz Wi-Fi 5, Bluetooth 5.0 and one Mini PCIe for 4G module/LoRa module/network card

- **Rich and isolated I/O:** 4 x USB 3.0, 2 x USB 2.0 and isolated interfaces: 4 x RS232, 2 x
RS485/ RS232/ CAN, 4 x DI, 4 x DO

<p align="center">
<img  width=80% height=auto src="./Media_Assets/DEBIX_BPC_iMX8MP_03(2).png" alt="DEBIX_BPC_iMX8MP_03(2).png">
</p>

## Specification
| System          |       |
|-----------------|-------|
| Motherboard | DEBIX SOM A (Core Board) + DEBIX SOM A I/O Board (Carrier Board)  |
| Boot            | (1) Support boot from eMMC on DEBIX SOM A (default)<br>(2) Support boot from Micro SD on carrier board<br>(3) Support boot from SPI Nor Flash on carrier board (reserved)  |
| Memory          | Onboard 2GB LPDDR4 (1GB/4GB/8GB optional)  |
| Storage         | Onboard 16GB eMMC (8GB/32GB/64GB/128GB/256GB optional)  |
| OS              | Win10 IoT Enterprise, Ubuntu 22.04, Yocto-L6.1.22_2.2.0, Debian 12 (also supports Android, OpenWRT and FreeRTOS.) |
|**Communication**|
| Gigabit Ethernet| 2 x Independent MAC Gigabit Ethernet ports with POE power supply (need POE power device module) (one supports TSN) |
| Wi-Fi & Bluetooth| 2.4GHz&5GHz Wi-Fi and Bluetooth 5.0, external SMA antenna for Wi-Fi & BT (4G/LoRa antenna is optional) |
|**Video & Audio**|
| Display | 1 x HDMI output |
| Audio   | 1 x Headphone and mic combo port |
|**External I/O**|
| DC IN   |1 x Power socket for 5.5mm x 2.1mm plug|
| USB 3.0 | 4 x USB 3.0 Host |
| USB 2.0 | 2 x USB 2.0 Host |
| Serial Ports | (1) 4 x Isolated RS232, compatible with UART TTL 3.3V without isolation<br>(2) 2 x Isolated RS232/RS485/CAN (RS485 for default)，compatible with UART TTL 3.3V without isolation |
| GPIO | (1) 4 x Isolated DI, support dry contact and wet contact<br>(2) 4 x Isolated DO, support wet contact, compatible with dry contact of external relay |
| LED & KEY  | (1) 1 x System LED<br>(2) 1 x Power LED<br>(3) 1 x ON/OFF |
|**Internal I/O**|
| SIM Slot | 1 x Built-in Micro SIM slot, push pop-up slot |
| SD Slot | 1 x Built-in Micro SD slot, push pop-up slot |
| Mini PCIe | (1) Support 4G module such as Quectel 4G module, built-in SIM card, etc.<br>(2) Support LoRa module<br>(3) Support other expansion such as network card, SATA and serial port |
|**Power Supply**|
| Power Input | DC 12V/2A power input for default, supports DC 12V~36V |
|**Mechanical & Environmental**|
| Enclosure Material | Steel and aluminum alloy  |
| Dimension | 169.42(W)mm × 38.90(H)mm x 124.00(D)mm (±0.5mm)  |
| Gross Weight | 812g (±0.5g)  |
| Operating Temp. | -20°C to 70°C (-40°C to 85°C optional) |
| Relative Humidity | 10%~90%  |
| MTBF | >50000 hours |
| Shock | 15G half-sine 11ms duration |
|Vibration| 1Grms random 5-500Hz hr/axis

## I/O Interfaces and Dimension:
<p align="center">
<img src="./Media_Assets/Interfaces.png" alt="Interfaces" width=90% height=auto>

## Ordering Codes
| RAM LPDDR4  | eMMC Storage | PN for BPC-iMX8MP-03 -20°C to 70°C | PN for BPC-iMX8MP-03 -40°C to 85°C |
|-------------|--------------|----------------|---------------------|
| **1GB DDR** | 8GB   | BPC-iMX8MP-03-D1E8    | BPC-iMX8MP-03-I-D1E8 |
|             | 16GB  | BPC-iMX8MP-03-D1E16   | BPC-iMX8MP-03-I-D1E16 |
|             | 32GB  | BPC-iMX8MP-03-D1E32   | BPC-iMX8MP-03-I-D1E32 |
|             | 64GB  | BPC-iMX8MP-03-D1E64   | BPC-iMX8MP-03-I-D1E64 |
| **2GB DDR** |  8GB   | BPC-iMX8MP-03-D2E8    | BPC-iMX8MP-03-I-D2E8 |
|             | 16GB  | BPC-iMX8MP-03-D2E16   | BPC-iMX8MP-03-I-D2E16 |
|             | 32GB  | BPC-iMX8MP-03-D2E32   | BPC-iMX8MP-03-I-D2E32 |
|             | 64GB  | BPC-iMX8MP-03-D2E64   | BPC-iMX8MP-03-I-D2E64 |
| **4GB DDR** | 8GB   | BPC-iMX8MP-03-D4E8    | BPC-iMX8MP-03-I-D4E8 |
|             | 16GB  | BPC-iMX8MP-03-D4E16   | BPC-iMX8MP-03-I-D4E16 |
|             | 32GB  | BPC-iMX8MP-03-D4E32   | BPC-iMX8MP-03-I-D4E32 |
|             | 64GB  | BPC-iMX8MP-03-D4E64   | BPC-iMX8MP-03-I-D4E64 |
| **8GB DDR** | 8GB   | BPC-iMX8MP-03-D8E8    |    |
|             | 16GB  | BPC-iMX8MP-03-D8E16   |    |
|             | 32GB  | BPC-iMX8MP-03-D8E32   |    |
|             | 64GB  | BPC-iMX8MP-03-D8E64   |    |

## Compatible with DEBIX's Accessories
| Product                     | Model               |
|-----------------------------|---------------------|
| DEBIX Display Screens      | DEBIX TD050H; DEBIX TD070H; DEBIX TD101H |

## Safety Instructions and Warnings:
- Disconnect the device from the DC power supply before cleaning. Use a damp rag. Do not use liquid detergents or spray-on detergents.
  
- Keep the device away from moisture.

- During installation, put the device on a reliable table. It will be damaged if you drop it.

- Before connecting the power supply, ensure that the voltage is in the required range.

- Put the power cable in place to avoid stepping on it.

- If the device is not used for a long time, power it off to avoid damage caused by sudden overvoltage.

- For safety reasons, the device can only be disassembled by professional personnel.

- Do not place the device in a place where the ambient temperature is below -40℃ or above 85℃. This will damage the machine. It needs to be kept in an environment at controlled temperature.

## Contact Us
- **Headquarters**: DEBIX Technology Inc., 8345 Gold River Ct., Las Vegas, NV 89113, USA  
- **Factory**: 5-6/F., East Zone, Shunheda A2 Building, Liqxiandong Industrial Park, XiLi, Nanshan Dist., Shenzhen, China  <img src="./Media_Assets/Discord_QRcode.png" alt="Discord(QRcode)" width=15% height=auto align="right">
- **Email**: info@debix.io  
- **Website**: [www.debix.io](https://www.debix.io)  
- **Community**: [Discord](https://discord.com/invite/adaHHaDkH2)