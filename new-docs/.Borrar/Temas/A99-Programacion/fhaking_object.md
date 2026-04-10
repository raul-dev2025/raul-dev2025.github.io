#### OCNI - Objeto compilado -naturalmente inyectado.

Tenemos un archivo .txt >>

  `cat fhaking_object.txt`
  

> Hello fhaking world !!(EOF)

  
    # objcopy --input binary \  
          --output elf32-i386 \  
          --binary-architecture i386 fhaking_object.txt text.o  
Compilamos:   

    # gcc main.c text.o
    # ./a.out

> Hello fhaking world !!

This tells objcopy that our input file is in the _binary_ format, that our output file
should be in the _elf32-i386_ format (object files on the x86). The
--binary-architecture option tells objcopy that the output file is meant to __run__ on an
_x86_. This is needed so that __ld__(stands for _the linker_), will accept the file for
linking with other files for the _x86_. One would think that specifying the output format
as _elf32-i386_ would imply this, but it does not.

Now that we have an object file we only need to include it when we run the linker:

    # gcc main.c data.o

When we run the result we get the prayed for output:

    # ./a.out
    Hello world

Of course, I haven't told the whole story yet, nor shown you main.c. When objcopy does
the above conversion it adds some "linker" symbols to the converted object file:

     _binary_data_txt_start
     _binary_data_txt_end

After linking, these symbols specify the start and end of the embedded file. The symbol
names are formed by prepending _"_binary"_ and appending _"_start"_ or _"_end"_ to the
file name.  
If the file name contains any characters that would be invalid in a symbol name they are
converted to underscores (eg data.txt becomes data_txt). If you get unresolved names
when linking using these symbols, do a hexdump -C on the object file and look at the end
of the dump for the names that objcopy chose.

The code to actually use the embedded file should now be reasonably obvious:

    #include <stdio.h>

    extern char _binary_data_txt_start;
    extern char _binary_data_txt_end;

    main() {
        char*  p = &_binary_data_txt_start;
    
        while ( p != &_binary_data_txt_end ) putchar(*p++);
    }

One important and subtle thing to note is that the symbols added to the object file
__aren't variables__. They don't contain any data, rather, their address is their value. I
declare them as type char because it's convenient for this example: the embedded data is
character data. However, you could declare them as anything, as int if the data is an
array of integers, or as struct foo_bar_t if the data were any array of foo bars. If the
embedded data is not uniform, then char is probably the most convenient: take its
address and cast the pointer to the proper type as you traverse the data.


