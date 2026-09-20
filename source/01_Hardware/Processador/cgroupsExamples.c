// Los ejemplos a continuación han sido extraidos de 'man cgconfig.conf'
// Debe estar instalada la librería 'libcgroup', para que funcione.


// *** EJEMPLO 1 ***

mount {
	cpu = /mnt/cgroups/cpu;
	cpuacct = /mnt/cgroups/cpu;
}

// Crea la jerarquía controlada por dos subsistemas sin ningún grupo dentro.
// Corresponde a las siguientes operaciones:
//
// my@Prompt# mkdir /mnt/cgroups/cpu
// my@Prompt# mount -t cgroup -o cpu,cpuacct cpu /mnt/cgroups/cpu



// *** EJEMPLO 2 ***

mount {
	cpu = /mnt/cgroups/cpu;
	"name=scheduler" = /mnt/cgroups/cpu;
	"name=noctrl" = /mnt/cgroups/noctrl;
}

group daemons {
	cpu {
		cpu.shares = "1000";
	}
}

group test {
	"name=noctrl" {
	}
}

/*	
	Crea dos jerarquías. Una llamada "scheduler" controlada por el subsistema "cpu",
	con el grupo "daemon" dentro. La segunda es llamada "noctrl" y sin ningún 
	controlador, para el grupo "test".
	Corresponde a las siguientes operaciones:
	
	mkdir /mnt/cgroups/cpu
	mount -t cgroup -o cpu,name=scheduler cpu /mnt/cgroups/cpu
	mount -t cgroup -o none,name=noctrl cpu /mnt/cgroups/noctrl
	
	mkdir /mnt/cgroups/cpu/daemons
	echo 1000 > /mnt/cgroups/cpu/daemons/www/cpu.shares
	
	mkdir /mnt/cgroups/noctrl/tests	
*/

// *** EJEMPLO 3 ***

mount {
	cpu = /mnt/cgroups/cpu;
	cpuacct = /mnt/cgroups/cpu;
}

group daemons/www {
	perm {
		task {
			uid = root;
			gid = webmaster;
			fperm = 770;
		}
		admin {
			uid = root;
			gid = root;
			dperm = 775;
			fperm = 744;			
		}
	}
	cpu {
		cpu.shares = "1000";
	}
}

group daemons/ftp {
	perm {
		task {
			uid = root;
			gid = ftpmaster;
			fperm = 774;
		}
		admin {
			uid = root;
			gid = root;
			dperm = 775;
			fperm = 700;			
		}
	}
	cpu {
		cpu.shares = "500";
	}
}

























