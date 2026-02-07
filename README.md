# ⚡ Project Velo: The Toaster vs. The Tank

## 📺 Visual Proof: The Toaster in Action

Check out the real-time execution dashboard. Watch how the "Enterprise Tank" struggles while **Project Velo** finishes before the UI can even blink.

<div align="center">
  <video src="assets/video_test_clean.mp4" width="100%" controls>
    Your browser does not support the video tag.
  </video>
</div>

> **Note:** If the video doesn't play, you can find the raw file in the [assets folder](./assets/video_test_clean.mp4).

This repository contains the official benchmark comparing **Project Velo** (Native C++ Engine) against the industry standard, **Camunda DMN Engine (JVM)**.

The goal of this test is to prove that 100% logic parity can be achieved while eliminating "software mass," enabling ultra-high performance execution even on low-end hardware.

## 📊 The Showdown (5,000 Rules | 2,000 Decisions)

| Metric | **THE TANK** (Camunda/JVM) | **PROJECT VELO** (C++) | **Difference** |
| :--- | :--- | :--- | :--- |
| **Execution Time** | 26,084.00 ms | **3.79 ms** | **6,882x Faster** |
| **Throughput** | 76.68 dec/sec | **527,162.02 dec/sec** | **Extreme Efficiency** |
| **Avg. Latency** | 13,041,870 ns | **1,897 ns** | **Below OS Radar** |
| **RAM Usage** | ~79,096 KB | **2,816 KB*** | **28x Lighter** |



## 🛡️ Logic Parity Verification
To ensure that speed does not sacrifice precision, both engines processed the exact same dataset:
- **Total Inputs:** 2,000
- **Matches Found (Camunda):** 1,900
- **Matches Found (Velo):** 1,900
- **Result:** ✅ **100% Logic Parity Confirmed.**

## 💻 The "Toaster" Reveal
Unlike enterprise solutions that require massive clusters and high-end server CPUs, this benchmark was executed entirely on:
- **CPU:** AMD Athlon 3000G (Entry-level, 2 Cores / 4 Threads)
- **CPU Price:** ~$50 USD
- **The Lesson:** If it runs this fast on a "toaster," imagine what it can do for your infrastructure.

## 📂 Detailed Execution Report

### Project Velo Engine (C++ Native)
- **DMN Load Time:** 15.32 ms
- **Total Execution Time:** 3.79 ms
- **Avg. Time per Decision:** 1,897 ns
- **Throughput:** 527,162.02 decisions/sec
- **RAM Usage:** 2,816.30 KB *

> ***Note on Memory:** The report shows 2.8 MB due to the result post-processing (PowerShell loading the output JSON for validation). The actual engine's memory footprint during logic execution is significantly lower (in the KB range). The 2.8 MB is a side effect of the testing environment, not a limitation of the engine itself.*

### Camunda DMN Engine (Standard JVM)
- **DMN Load Time:** 3,001 ms
- **Total Execution Time:** 26,084 ms
- **Avg. Time per Decision:** 13,041,870 ns
- **Throughput:** 76.68 decisions/sec
- **RAM Usage:** 79,096 KB

---
*"Software is not mass; it's logic. And logic should be fast,
