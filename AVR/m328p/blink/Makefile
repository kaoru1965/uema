MCU     = atmega328p
F_CPU  ?= 1000000UL
TARGET  = main

CC      = avr-gcc
OBJCOPY = avr-objcopy
SIZE    = avr-size
CFLAGS  = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -std=gnu11 \
          -ffunction-sections -fdata-sections
LDFLAGS = -mmcu=$(MCU) -Wl,--gc-sections

all: $(TARGET).hex
	$(SIZE) --format=avr --mcu=$(MCU) $(TARGET).elf

$(TARGET).elf: $(TARGET).c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

flash: $(TARGET).hex
	hidspx $(TARGET).hex

clean:
	rm -f $(TARGET).elf $(TARGET).hex

.PHONY: all flash clean
