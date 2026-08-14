# Generar la clave privada y el certificado DER directamente
openssl req -new -x509 -newkey rsa:2048 -nodes -days 3650 -subj "/CN=Buildlab Kernel Signing Key/" -keyout buildlab.priv -outform DER -out buildlab.der

# Importar con mokutil (te pedirá una contraseña temporal)
mokutil --import buildlab.der

# Firmar de nuevo el módulo
sudo kmod-sign-file sha256 /etc/secureboot/buildlab.priv /etc/secureboot/buildlab.der hello.ko

# Probar la carga
sudo insmod hello.ko
dmesg | tail -n 5