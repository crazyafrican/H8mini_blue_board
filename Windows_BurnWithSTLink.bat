@echo off
title Burn with ST-Link
"C:\dev\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe" -c SWD -P h8blue.bin 0x08000000 -V -Rst -Run
