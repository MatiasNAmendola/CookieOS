GCC=/usr/local/elf/bin/i386-elf-gcc
LD=/usr/local/elf/bin/i386-elf-ld
NASM=nasm

INTERNAL_DIR=internal
SRC_DIR=src
BUILD_DIR=build
ISO_DIR=iso

KERNEL=kCookieOS
ISO=CookieOS.iso

ASFLAGS=-f elf
CFLAGS=-I $(SRC_DIR)/include -Wall -Wextra -nostdlib -nostartfiles \
	-nodefaultlibs
LDFLAGS=-T$(INTERNAL_DIR)/link.ld

all:
	@echo "Now building CookieOS..."
	@make clean
	@mkdir -p $(BUILD_DIR)
	@$(NASM) $(ASFLAGS) -o bootstrap.sso $(SRC_DIR)/bootstrap.s
	@$(GCC) -c $(SRC_DIR)/*.c $(CFLAGS)
	@$(LD) $(LDFLAGS) -o $(BUILD_DIR)/$(KERNEL) *.sso *.o
	@echo "CookieOS successfully built!"
	@echo ""
	
	@echo "Staging CookieOS ISO directory..."
	@mkdir -p $(ISO_DIR)/boot/grub
	@cp $(INTERNAL_DIR)/boot/* $(ISO_DIR)/boot/grub
	@cp $(BUILD_DIR)/$(KERNEL) $(ISO_DIR)/boot/$(KERNEL)
	
	@echo "Creating CookieOS ISO..."
	@echo ""
	
	@mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot \
		-boot-load-size 4 -boot-info-table -o $(ISO) $(ISO_DIR)
		
	@echo ""
	@echo "CookieOS ISO created!"
	@echo "Use 'make qemu' to run CookieOS in QEMU!"

qemu:
	@qemu -cdrom $(ISO)

clean:
	@rm -f $(BUILD_DIR)/*
	@rm -f *.o *.so *.sso
	@rm -r -f $(ISO_DIR)
	@rm -f $(ISO)
	