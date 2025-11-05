

1. El disco duro  
2. [El Mbr][1]  
2. Tabla de particiones  
2. Espacio vacío  
3. Particionado de disco  
	- LVM _versus_ particionado tradicional.
4. Formateo de disco  
5. EXPERIMENTAL  
	- Técnicas de particionado y formateo  
    - Sobre la superficie física de disco  
    - Sobre una imagen creada como archivo  
  6. Agradecimientos  


  __test__ _test_



	> __WARNING!!:__ Los discos duros más actuales -o con mejores prestaciones,  
	acostumbran a incluir una característica que modelos anteriores no incluían.
	_Advanced Format(AF)_,se trata de una característica perteneciente a cualquier
	formato de sector de disco(NTFS, EXT3, BtrFs, etc), que excede de los 512-528 bytes
	por sector.  
	Mayores sectores, facilitan la integración de algoritmos de _corrección de errores_,
	para el mantenimiento de la integridad de datos, en dispositivos de almacenamiento
	de alta densidad.


---
[1]:[mbr.md]
