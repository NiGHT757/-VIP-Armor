# [VIP] Armor
Modified version of [[VIP] Armor](https://hlmod.ru/resources/vip-armor.419/)

# Features:
Plugin functionality is disabled on **awp_** , **fy_** , **35hp _** , **aim_** maps and in the first rounds.

# Requirements:
[VIP Core](https://github.com/R1KO/VIP-Core) and [SourceMod](https://www.sourcemod.net/downloads.php?branch=stable) 1.10 or higher

# Instalation
1. Unpack and upload the plugin on the server
2. Add **"Armor" "Value"** in **groups.ini**, replace **Value** with:
    - **100** will set 100 armor on spawn.
    - **++100** will give +100 armor on spawn.
3. Open **vip_modules.phrases.txt** and add
```cpp
    "Armor"
    {
        "ru"        "Бронь"
        "en"        "Armor"
        "fi"        "Suojaliivi"
    }
```
