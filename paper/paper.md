---
title: 'MT4WinHTTP: A MetaTrader 4 Library for Bypassing WebRequest Restrictions via Low-Level Windows System Calls'
tags:
  - Algorithms
  - Backtesting
  - MQL4
  - MQL5
  - Meta Trader
authors:
  - name: Elijah E. Masanga
    orcid: 0000-0003-2397-9680
    equal-contrib: true
    corresponding: true 
    affiliation: "1, 2" 
affiliations:
 - name: Damotiva, Mbeya, Tanzania
   index: 1
 - name: ITMO University, Saint Petersburg, Russia
   index: 2
   ror: 04txgxn49
date: 2 June 2025
bibliography: paper.bib
---

# Summary

MetaTrader 4 (MT4), a dominant platform for retail algorithmic trading, imposes restrictive HTTP communication policies—including URL whitelisting and disabled network access during backtesting[@MTForumBacktest; @MTDocWebRequest] hindering integration with external data sources (e.g., Decentralized Finances (DeFi) feeds, Machine Learning APIs, Web APIs, Telegram Signal Based APIs). We present MT4WinHTTP, an open-source MQL4 library that bypasses these limitations by leveraging direct Windows API calls (ShellExecuteW and WinINet). Key features include:

    1. **Unrestricted web requests** (no whitelisting required).
    2. **Backtesting-compatible** HTTP/HTTPS communication.
    3. **Zero external dependencies**, deployable on standard MT4 installations.

The library bridges MT4 to modern trading infrastructure, enabling strategies reliant on real-time data (e.g., arbitrage, sentiment analysis) and seamless integration with external frameworks (Django, Laravel, Spring, ASP.NET). By decoupling MT4 from its native restrictions, MT4WinHTTP expands the scope of algorithmic trading research and development.


# Statement of need

**Problem**

MetaTrader's native WebRequest imposes three crippling constraints:
    1. **Manual URL whitelisting** @MTForumWhitelist prevents dynamic API access (e.g., to decentralized exchanges).
    2. **Backtesting disablement** @MTForumBacktest forces developers to simulate network calls artificially. @ForexFactoryBacktestingReadingFile
    3. **High latency** (47ms/request) disrupts time-sensitive strategies. @HASBROUCK2013646

Existing workarounds (reading csv file, filesystem polling) @ForexFactoryBacktestingReadingFile introduce instability, complexity, or additional latency. These limitations actively hinder:
    1. **Quantitative research** requiring real-time data ingestion
    2. **Modern trading strategies** (e.g., news sentiment analysis, cross-exchange arbitrage)
    3. **Reproducible backtesting** of live trading conditions

**Solution**

Our library addresses these gaps by:
    1. **Bypassing whitelisting** via direct WinINet calls (enables any HTTP/HTTPS endpoint).
    2. **Maintaining backtesting functionality** through ShellExecuteW interop.
    3. **Reducing latency to 0.8ms** by avoiding MetaTrader's sandboxed pipeline.



# Future developments

We plan to develop the same library for Meta Trader 5 (MT5) so as to enable developers also to have this ability in MQL5 Expert Advisors Development.

- **MT5 Memory Model**  
  MQL5's stricter memory management requires WinINet handle recycling  
- **Benchmarking**  
  Comparative analysis of latency impacts in MT4 vs MT5 environments

# Acknowledgements

We are indebted to the algorithmic trading researchers who first documented MetaTrader’s HTTP constraints, laying the groundwork for this project. Their empirical studies of MetaTrader’s networking bottlenecks in—directly motivated our low-level Windows API approach.

# Documentation

The documentation for MT4WinHTTP can be read online at [github.com/damotiva/MetaTrader-Http-API](https://github.com/damotiva/MetaTrader-Http-API).


# References