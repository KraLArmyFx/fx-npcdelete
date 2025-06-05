# FX-NPCDELETE

A lightweight and efficient **NPC vehicle cleanup system** for FiveM, supporting all major frameworks: **QBCore**, **ESX**, and **OxCore (Overextended)**.

---

## 🔧 What It Does

This script automatically **removes unoccupied NPC vehicles** inside predefined polygon zones.  
It **protects player-owned vehicles** by checking their plates against your SQL vehicle table.

Use it to:
- Reduce unnecessary vehicle clutter in specific areas (e.g., city center, parking lots).
- Automatically control spawn-heavy zones.
- Improve performance and realism without deleting player assets.

---

## ✅ Framework Support

- ✅ QBCore  
- ✅ ESX (v1 & legacy)  
- ✅ OxCore (Overextended)  
- 🔄 Auto-detects callbacks based on your framework choice in `config.lua`.

---

## ⚙️ Configuration

Edit `config.lua` to match your setup:

```lua
Config.Framework = "qbcore"          -- Options: "qbcore", "esx", "ox"
Config.SQLVehicleTable = "player_vehicles" -- Your vehicle plate table
Config.EnableDeleteZone = true       -- Toggle system on/off
Config.ShowZoneLines = false         -- Visualize zone boundaries (for testing)
