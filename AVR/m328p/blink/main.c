#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    DDRB |= _BV(PB5);               /* PB5(Arduino互換の13番ピン)を出力 */

    for (;;) {
        PORTB ^= _BV(PB5);
        _delay_ms(500);
    }
    return 0;
}
