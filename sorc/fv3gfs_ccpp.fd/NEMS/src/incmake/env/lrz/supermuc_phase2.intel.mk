MACHINE_ID=supermuc_phase2
FULL_MACHINE_ID=supermuc_phase2
USE_MODULES=YES
DEFAULT_MODULE=$(FULL_MACHINE_ID)/ESMF_NUOPC
BUILD_TARGET=$(FULL_MACHINE_ID).$(NEMS_COMPILER)
NEMS_COMPILER=intel
MODULE_LOGIC=$(call ULIMIT_MODULE_LOGIC,60000)