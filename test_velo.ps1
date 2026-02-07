# test_velo.ps1 - Ejecuta el benchmark de paridad Velo (mismo test que Camunda, sin tocar nada)
# Uso: desde la raiz del proyecto (D:\velo_eng) ejecutar: .\test_velo.ps1
#      o desde cualquier carpeta: D:\velo_eng\test_velo.ps1

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location.Path }

Set-Location $root

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  TEST SUMMARY" -ForegroundColor White
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "  ENGINE:     PROJECT VELO ENGINE (C++ NATIVE)" -ForegroundColor Yellow
Write-Host "  TEST:       CAMUNDA PARITY BENCHMARK - 2000 DECISIONS, 95% VALID INPUTS" -ForegroundColor Yellow
Write-Host "  RULES:      STRESS_MEDIUM.CSV (5000 RULES)" -ForegroundColor Yellow
Write-Host "  OUTPUT:     VELO_RESULTS.JSON" -ForegroundColor Yellow
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Proyecto: $root" -ForegroundColor Gray
Write-Host ""

Write-Host ""
Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor Cyan
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""

# Asegurar que existe build y el target
$buildDir = Join-Path $root "build"
$exePath = Join-Path $root "build\bin\velo_benchmark_camunda_parity.exe"

if (-not (Test-Path $buildDir)) {
    Write-Host "Configurando CMake (primera vez)..." -ForegroundColor Yellow
    & cmake -B build -DCMAKE_BUILD_TYPE=Release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: CMake fallo" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Compilando velo_benchmark_camunda_parity..." -ForegroundColor Yellow
& cmake --build build --config Release --target velo_benchmark_camunda_parity
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Compilacion fallida" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $exePath)) {
    Write-Host "ERROR: No se genero el ejecutable" -ForegroundColor Red
    exit 1
}

Write-Host "Ejecutando benchmark (2000 inputs, 95% validos)..." -ForegroundColor Green
$benchOutput = & $exePath 2>&1 | Out-String
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Ejecucion fallida" -ForegroundColor Red
    exit 1
}

$jsonPath = Join-Path $root "velo_results.json"
if (Test-Path $jsonPath) {
    Write-Host ""
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  RESULTS LIST (inputId | output | status)" -ForegroundColor White
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray
    $j = Get-Content -Path $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($r in $j.results) {
        $line = "  [{0,5}] inputId: {1,5}  |  output: {2,-12}  |  " -f $r.inputId, $r.inputId, $r.resultado
        Write-Host $line -NoNewline
        if ($r.hasMatch) { Write-Host "MATCH" -ForegroundColor Green } else { Write-Host "NO_MATCH" -ForegroundColor Red }
    }
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  EXECUTION SUMMARY (below)" -ForegroundColor Cyan
    Write-Host ""
}
$benchOutput | Write-Host
Write-Host "OK. Resultados en: velo_results.json" -ForegroundColor Green
