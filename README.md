
# Windows API Hacks for MetaTrader: Bypassing WebRequest Restrictions via Low-Level System Calls


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MetaTrader 4/5](https://img.shields.io/badge/Platform-MetaTrader%204|5-blue)](https://www.metatrader5.com)
[![MQL4](https://img.shields.io/badge/Language-MQL4-orange)](https://www.mql4.com)
[![MQL5](https://img.shields.io/badge/Language-MQL5-orange)](https://www.mql5.com)

A lightweight MQL library that bypasses MetaTrader's HTTP restrictions using direct Windows API calls (`ShellExecuteW`/`WinINet`), enabling unconstrained web access during live trading and backtesting.

## Key Features
- 📊 **Backtesting-Compatible (Works in Strategy Tester)** - Full network access in historical testing mode
- 🚫 **No URL Whitelisting** - Communicate with any HTTP endpoint without manual approval
- ⏱ **Sub-millisecond Latency** - Bypass MetaTrader's managed WebRequest pipeline

## Installation
1. Clone this repository:
   ```bash
   git clone git@github.com:damotiva/metatrader-http-api.git
   ```

2. Copy the  `lirabry/`  folder to your MetaTrader  `MQL/Include`  directory:
MQL4/
└── Include/
    └── Metatrader4HttpApi.mqh

	MQL5/
	└── Include/
	    └── Metatrader5HttpApi.mqh
        
## Usage

#include <Metatrader4HttpApi.mqh>

// Example 1: GET request (works in backtest)
string url = "https://api.example.com/data";
string params = "a=1&b=2&c=3";
string response = httpGET(url, params);

// Example 2: POST request with headers
string host = "https://api.example.com";
string path = "/get/trade/signal";
string json_body = "{\"symbol\":\"BTCUSD\"}";
int port = 443;
string params = "{}";

string response = httpPOST_JSON(host, path, json_body, port, params);


# Json Parser
You can process parse json response data with Jason https://github.com/vivazzi/JAson


## Benchmark Results

*Test environment: MetaTrader 4 build 1440, Windows 10 (i7-1185G7, 8GB RAM)*

| Test Case                      | Native WebRequest | WinAPI Implementation | Improvement       |
|--------------------------------|------------------:|----------------------:|------------------:|
| **Backtesting Support**        | ❌ Failed         | ✅ Working            | Better than WebRequest               |
| **Whitelist Requirement**      | ❌ Required       | ✅ Bypassed           | Better than WebRequest               |
| **HTTPS Support**              | ✅ Yes            | ✅ Yes                | Equivalent        |

