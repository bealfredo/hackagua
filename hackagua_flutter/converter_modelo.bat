@echo off
echo ============================================================
echo Conversor de Modelo TensorFlow Lite - HackAgua
echo ============================================================
echo.

REM Verificar se Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Python nao encontrado!
    echo Por favor, instale o Python: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Python detectado!
echo.

REM Verificar/Instalar TensorFlow
echo Verificando dependencias...
python -c "import tensorflow" >nul 2>&1
if %errorlevel% neq 0 (
    echo TensorFlow nao encontrado. Instalando...
    pip install tensorflow numpy
    if %errorlevel% neq 0 (
        echo ERRO: Falha ao instalar TensorFlow
        pause
        exit /b 1
    )
) else (
    echo TensorFlow ja instalado!
)

echo.
echo Iniciando conversao do modelo...
echo.

REM Executar o script de conversão
python convert_model.py

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo Conversao concluida com sucesso!
    echo ============================================================
    echo.
    echo Proximos passos:
    echo 1. Verifique o arquivo: assets\tflite\classificador_agua_hackathon.tflite
    echo 2. Execute: flutter clean
    echo 3. Execute: flutter pub get
    echo 4. Execute: flutter run
    echo.
) else (
    echo.
    echo ============================================================
    echo ERRO durante a conversao!
    echo ============================================================
    echo Verifique a mensagem de erro acima.
    echo.
)

pause
