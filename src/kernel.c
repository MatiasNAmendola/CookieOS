/*
 *
 * kernel.c
 * CookieOS - Joshua Lee Tucker 2011
 *
 */

#include "common.h"
#include "console.h"

void kmain() {
	
	console_clear();
	
	console_write("Running CookieOS...\n");
	console_write("Initializing CookieOS...  ");
	console_write("OK!\n");
	
}

