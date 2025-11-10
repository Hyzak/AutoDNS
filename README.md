# AutoDNS

AutoDNS es un script híbrido en Batch y PowerShell que detecta automáticamente los servidores DNS públicos más rápidos disponibles, evaluando su latencia en tiempo real y aplicando los dos mejores al adaptador de red físico activo.

AutoDNS is a hybrid Batch + PowerShell script that automatically detects the fastest public DNS servers, measures their latency in real time, and applies the top two to the active physical network adapter.

---

## Características

- Evaluación de 18 servidores DNS (Cloudflare, Google, Quad9, OpenDNS, Comodo Secure, AdGuard, CleanBrowsing, Level3 y Neustar)
- Selección automática de los dos con menor latencia
- Visualización de estado en el título
- Aplicación directa al adaptador Ethernet o Wi-Fi activo
- Compatible con Windows 8.1/10/11 Sistemas LTSC/LTSB con PowerShell 5+
- Visualización de errores en caso de falla
- Requiere privilegios de administrador

---

## Uso

1. Haz clic derecho en "AutoDNS.bat" y selecciona **"Ejecutar como administrador"**
2. Espera la evaluación de latencia (~10 segundos)
3. El script aplicará los DNS óptimos automáticamente
4. Se mostrará una cuenta regresiva en el título antes de cerrar

---

## Servidores DNS incluidos / Included DNS Servers

- Cloudflare (1.1.1.1 / 1.0.0.1)
- Google (8.8.8.8 / 8.8.4.4)
- Quad9 (9.9.9.9 / 149.112.112.112)
- OpenDNS (208.67.222.222 / 208.67.220.220)
- Comodo Secure (8.26.56.26 / 8.20.247.20)
- AdGuard DNS (94.140.14.14 / 94.140.15.15)
- CleanBrowsing (185.228.168.9 / 185.228.169.9)
- Level3 (209.244.0.3 / 209.244.0.4)
- Neustar UltraDNS (156.154.70.1 / 156.154.71.1)

---

## Requisitos

- PowerShell 5
- Conexión a Internet
- Ejecución como administrador

---

## Distribución

Puedes incluir este script en entornos de mantenimiento, optimización de red, o como parte de paquetes de herramientas para técnicos.

You can include this script in maintenance environments, network optimization kits, or technician toolsets.

---

## Licencia / License

MIT — libre para modificar, distribuir y mejorar.  
MIT — free to modify, distribute, and improve.
