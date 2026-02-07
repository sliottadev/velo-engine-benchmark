# test_camunda.ps1 - Ejecuta el benchmark de Camunda (mismo test, sin tocar nada)
# Uso: desde la raiz del proyecto (D:\velo_eng) ejecutar: .\test_camunda.ps1
#      o desde cualquier carpeta: D:\velo_eng\test_camunda.ps1

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $root) { $root = Get-Location.Path }

Set-Location $root

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "  TEST SUMMARY" -ForegroundColor White
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "  ENGINE:     CAMUNDA DMN ENGINE (JAVA / JVM)" -ForegroundColor Yellow
Write-Host "  TEST:       OFFICIAL BENCHMARK - 2000 DECISIONS, 95% VALID INPUTS" -ForegroundColor Yellow
Write-Host "  RULES:      STRESS_MEDIUM.DMN (5000 RULES)" -ForegroundColor Yellow
Write-Host "  OUTPUT:     CAMUNDA_RESULTS.JSON" -ForegroundColor Yellow
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host ""
Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor Cyan
$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""


Write-Host "Proyecto: $root\java_benchmark" -ForegroundColor Gray
Write-Host ""

$javaDir = Join-Path $root "java_benchmark"
if (-not (Test-Path $javaDir)) {
    Write-Host "ERROR: No se encontro la carpeta java_benchmark" -ForegroundColor Red
    exit 1
}

Set-Location $javaDir

if (-not (Test-Path "src\main\resources\stress_medium.dmn")) {
    Write-Host "ERROR: No se encontro stress_medium.dmn en src\main\resources\" -ForegroundColor Red
    exit 1
}

Write-Host "Compilando (Maven)..." -ForegroundColor Yellow
$prevErrPref = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& mvn -q compile 2>&1 | Out-Null
$ErrorActionPreference = $prevErrPref
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Compilacion fallida" -ForegroundColor Red
    exit 1
}

Write-Host "Ejecutando benchmark (2000 inputs, 95% validos)..." -ForegroundColor Green
$prevErrPref = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$benchOutput = & mvn -q exec:java "-Dexec.mainClass=com.velo.BenchmarkCamunda" 2>&1 | Out-String
$ErrorActionPreference = $prevErrPref
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Ejecucion fallida" -ForegroundColor Red
    exit 1
}

$jsonPath = Join-Path $javaDir "camunda_results.json"
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
Write-Host "OK. Resultados en: java_benchmark\camunda_results.json" -ForegroundColor Green
Set-Location $root
