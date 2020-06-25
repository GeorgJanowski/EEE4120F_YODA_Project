# Binary Coded Decimal Converter (BCDC)

def digit_to_bcd(x):
    """Converts a digit i.e. 0-9 to Binary Coded Decimal."""

    if (type(x) != int): raise TypeError
    if (x < 0 or x > 9): raise ValueError
    bcd = bin(x)[2:]
    bcd = '0' * (4 - len(bcd)) + bcd
    return bcd

def int_to_bcd(x):
    """Converts a positive int to Binary Coded Decimal."""

    if (type(x) != int): raise TypeError
    if (x < 0): raise ValueError
    bcd = ''
    for digit in str(x):
        bcd += digit_to_bcd(int(digit))
    return bcd

def main():
    decimal = 123456789
    binary = bin(decimal)
    bcd = int_to_bcd(decimal)

    print("decimal = ", decimal)
    print("binary = ", binary)
    print("bcd = ", end = '')
    for i in range(len(bcd)):
        print(bcd[i], end = '')
        if ((i + 1) % 4 == 0): print(' ', end = '')
    print()

if __name__ == "__main__":
    main()