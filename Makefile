TARGET=h8blue
EXECUTABLE=$(TARGET).hex

CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
CP=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump


DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F031
STARTUP = Libraries/CMSIS/Device/ST/STM32F0xx/Source/Templates/gcc_ride7/startup_stm32f030.s

MCU = cortex-m0
MCFLAGS = -mcpu=$(MCU) -g -ggdb -mthumb -fdata-sections -ffunction-sections -fsingle-precision-constant -ffast-math -nostartfiles   --specs=nano.specs


INCLUDES = -ISilverware/src/ \
	-ILibraries/CMSIS/Device/ST/STM32F0xx/Include/ \
	-ILibraries/CMSIS/Include/ \
	-IUtilities/ \
	-ILibraries/STM32F0xx_StdPeriph_Driver/inc/

OPTIMIZE = -Os

CFLAGS = $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I. -I./ $(INCLUDES)  -Wl,-T,./gcc/flash.ld,-Map,h8blue.map,--gc-sections  -std=gnu99

AFLAGS = $(MCFLAGS)

SRC = Silverware/src/*.c \
	Silverware/src/*.h \
	Silverware/src/*.cpp \
	Libraries/STM32F0xx_StdPeriph_Driver/src/*.c  \
	Utilities/system_stm32f0xx.c \
	gcc/methods.c

OBJDIR = gcc/objects
OBJ = $(patsubst %.c,$(OBJDIR)/%.o,$(filter %.c,$(SRC)))
OBJ += $(patsubst %.cpp,$(OBJDIR)/%.o,$(filter %.cpp,$(SRC)))
OBJ += Startup.o


all: $(TARGET).bin

$(TARGET).hex: $(EXECUTABLE)
	$(CP) -O ihex $^ $@
$(TARGET).bin: $(EXECUTABLE)
	$(CP) -O binary $^ $@

$(EXECUTABLE): $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -lm -o $@


clean:
	rm -f Startup.lst $(TARGET).bin $(TARGET).lst $(OBJ) $(AUTOGEN) \
		$(TARGET).out $(TARGET).hex  $(TARGET).map \
		$(TARGET).dmp $(EXECUTABLE)
