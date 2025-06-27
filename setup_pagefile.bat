@echo off
setlocal

:: ---------- CONFIGURATION ----------
set "SIZE_MB=8192"  :: حجم الـ Page File بالميجا (هنا 8GB)
set "DRIVE=C:"      :: على أي قرص يتم إنشاء pagefile.sys
set "AUTOMATIC=0"   :: 1 = تلقائي من Windows, 0 = حجم ثابت
:: -----------------------------------

:: يعرض معلومات البداية
echo.
echo 🔧 Page File Setup Script for Windows
echo ----------------------------------------

:: تشغيل كمسؤول
fltmc >nul 2>&1 || (
    echo ❌ Please run this script as Administrator.
    pause
    exit /b
)

:: تعيين حجم تلقائي
if "%AUTOMATIC%"=="1" (
    echo 🛠️ Setting page file to automatic...
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
) else (
    echo 🛠️ Setting custom page file size: %SIZE_MB% MB
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
    wmic pagefileset where name="%DRIVE%\\pagefile.sys" delete >nul 2>&1
    wmic pagefileset create name="%DRIVE%\\pagefile.sys" InitialSize=%SIZE_MB% MaximumSize=%SIZE_MB%
)

:: عرض الحالة
echo.
echo 📊 Current Page File Status:
wmic pagefileset list full

echo.
echo ✅ Done. A restart may be required to apply changes.
pause
