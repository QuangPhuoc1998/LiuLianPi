OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

STACK_UND_SIZE = 0x10000;
STACK_ABT_SIZE = 0x10000;
STACK_IRQ_SIZE = 0x10000;
STACK_FIQ_SIZE = 0x10000;
STACK_SVC_SIZE = 0x40000;
HEAP_SIZE = 0x00800000;

MEMORY
{
	ram  : org = 0x80000000, len = (32M-16K)
	mmu  : org = 0x83FFC000, len = 16K
}

SECTIONS
{
	.text :
	{
		PROVIDE(__image_start = .);
		PROVIDE(__text_start = .);
		./_arm926_/src/start.o (.text)
		*(.text*)
		PROVIDE(__text_end = .);
	} > ram

	.rodata ALIGN(8) :
	{
		PROVIDE(__rodata_start = .);
		*(SORT_BY_ALIGNMENT(SORT_BY_NAME(.rodata*)))
		PROVIDE(__rodata_end = .);
	} > ram

	.data ALIGN(8) :
	{
		PROVIDE(__data_start = .);	
		*(.data*)
		. = ALIGN(8);
  		PROVIDE(__data_end = .);
  		PROVIDE(__image_end = __data_end);
	} > ram

	.ARM.exidx ALIGN(8) :
	{
		PROVIDE (__exidx_start = .);
		*(.ARM.exidx*)
		PROVIDE (__exidx_end = .);
	} > ram

	.ARM.extab ALIGN(8) :
	{
		PROVIDE (__extab_start = .);
		*(.ARM.extab*)
		PROVIDE (__extab_end = .);
	} > ram

	.bss ALIGN(8) (NOLOAD) :
	{
		PROVIDE(__bss_start = .);
		*(.bss*)
		*(.sbss*)
		*(COMMON)
		PROVIDE(__bss_end = .);
	} > ram
	
	.heap ALIGN(8) (NOLOAD) :
    {
        PROVIDE(__heap_start = .);
        . = . + HEAP_SIZE;
        . = ALIGN(8);
        PROVIDE(__heap_end = .);
    } > ram

	.stack ALIGN(8) (NOLOAD) :
	{
		PROVIDE(__stack_start = .);
		PROVIDE(__stack_und_start = .);
		. += STACK_UND_SIZE;
		PROVIDE(__stack_und_end = .);
		. = ALIGN(8);
		PROVIDE(__stack_abt_start = .);
		. += STACK_ABT_SIZE;
		PROVIDE(__stack_abt_end = .);
		. = ALIGN(8);
		PROVIDE(__stack_irq_start = .);
		. += STACK_IRQ_SIZE;
		PROVIDE(__stack_irq_end = .);
		. = ALIGN(8);
		PROVIDE(__stack_fiq_start = .);
		. += STACK_FIQ_SIZE;
		PROVIDE(__stack_fiq_end = .);
		. = ALIGN(8);
		PROVIDE(__stack_svc_start = .);
		. += STACK_SVC_SIZE;
		PROVIDE(__stack_svc_end = .);
		. = ALIGN(8);
		PROVIDE(__stack_end = .);
	} > ram
	
    .mmu_tbl (NOLOAD) :
    {
        . = ALIGN(8);
        *(.mmu_tbl)
    } >mmu
}
