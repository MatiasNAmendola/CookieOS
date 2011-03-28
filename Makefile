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
	make clean
	# Build
	mkdir -p $(BUILD_DIR)
	$(NASM) $(ASFLAGS) -o start.sso $(SRC_DIR)/bootstrap.s
	$(GCC) -c $(SRC_DIR)/*.c $(CFLAGS)
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/$(KERNEL) *.sso *.o

	# Structure ISO file
	mkdir -p $(ISO_DIR)/boot/grub
	cp $(INTERNAL_DIR)/boot/* $(ISO_DIR)/boot/grub
	cp $(BUILD_DIR)/$(KERNEL) $(ISO_DIR)/boot/$(KERNEL)

	# Create ISO
	mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot \
		-boot-load-size 4 -boot-info-table -o $(ISO) $(ISO_DIR)

qemu:
	make all
	qemu -cdrom $(ISO)

clean:
	rm -f $(BUILD_DIR)/*
	rm -f *.o *.so *.sso
	rm -r -f $(ISO_DIR)
	rm -f $(ISO)
