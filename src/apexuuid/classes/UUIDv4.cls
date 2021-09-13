global class UUIDv4 {

    private static final List<String> HEX_CHARS = new List<String> {
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
    };

    // matches any normalized UUID format pattern - with/without bracket or parenthesis, with or without dashes. Does not distinguish between mixed
    // patterns (e.g., open with paranthesis, close with bracket or only some included dashes)
    @TestVisible
    private static final String UUID_REGEX = '^[\\{|\\(]?([A-Fa-f0-9]{8})-?([A-Fa-f0-9]{4})-?([A-Fa-f0-9]{4})-?([A-Fa-f0-9]{4})-?([A-Fa-f0-9]{12})[\\}|\\)]?$';
    // Puts UUID in a standard format WITH parenthesis
    private static final String UUID_FORMAT_STR = '{0}-{1}-{2}-{3}-{4}';

    private static final Pattern matchPattern = Pattern.compile(UUID_REGEX);

    private final String UUIDValue;

    global UUIDv4() {
        UUIDValue = generate();
    }

    private UUIDv4 (String value) {
        UUIDValue = parse(value);
    }

    private static String generate() {

        String rawUUID = EncodingUtil.convertToHex(Crypto.generateAesKey(128));

        // get 7th and 9th bytes
        String byte7 = rawUUID.subString(14, 16);
        String byte9 = rawUUID.substring(18, 20);

        // shift to meet RFC 4122 compliance: https://www.cryptosys.net/pki/uuid-rfc4122.html
        // convert to int, shift bits, then convert back to hex
        String shiftedByte7 = int2hex((hex2int('0x40') | (hex2int(byte7) & hex2int('0xf')))).removeStart('0x');
        String shiftedByte9 = int2hex((hex2int('0x80') | (hex2int(byte9) & hex2int('0x3f')))).removeStart('0x');

        return String.format(UUID_FORMAT_STR, new List<String> {
            rawUUID.substring(0, 8),
            rawUUID.substring(8, 12),
            shiftedByte7 + byte7,
            shiftedByte9 + byte9,
            rawUUID.substring(20)
        }).toUpperCase();
    }

    private static String parse(String value) {

        Matcher UUIDMatcher = matchPattern.matcher(value);

        if (!UUIDMatcher.matches()) {
            throw new UUIDException('Unable to parse UUID: ' + value + '. Please ensure that it is in a format meeting RFC 4122 standards');
        }

        return String.format(UUID_FORMAT_STR, new List<String> {
            UUIDMatcher.group(1),
            UUIDMatcher.group(2),
            UUIDMatcher.group(3),
            UUIDMatcher.group(4),
            UUIDMatcher.group(5)
        }).toUpperCase();
    }

    global static UUIDv4 valueOf(String UUIDString) {
        return new UUIDv4(UUIDString);
    }

    global override String toString() {
        return UUIDValue;
    }

    // integer to hex based on prodecure at
    // https://www.permadi.com/tutorial/numDecToHex/
    @TestVisible
    private static String int2hex(Integer intVal) {

        String hex = '';
        Integer tmp = intVal;

        if (intVal == 0) {
            return '0x0';
        }

        while (tmp > 0) {
            Integer remainder = Math.mod(tmp, 16);
            hex = HEX_CHARS[remainder] + hex;
            tmp = tmp / 16; // integer division
        }


        return '0x' + hex.toUpperCase();
    }

    /**
        hex to integer based on procedure at
        https://www.permadi.com/tutorial/numHexToDec/

        Example: 0x40 = 64
        chars = {4, 0}
        finalIndx = 2 - 1 = 1
        for iter = 0
            base = 16 ^ (1 - 0) =  16 ^ 1 = 16
            value = 0 + HEX_CHARS.indexOf(chars[0]) * base = 0 + HEX_CHARS.indexOf(4) * 16 = 0 + 4 * 16 = 64

        for iter = 1
            base = 16 ^ (1-1) = 16 ^ 0 = 1
            value = 64 + HEX_CHARS.indexOf(chars[1]) * base = 64 + HEX_CHARS.indexOf(0) * 16 = 64 + 0 * 16 = 64

        return 64
    */
    @TestVisible
    private static Integer hex2int(String hex) {

        Integer value = 0;
        String[] chars = hex.toLowerCase().removeStart('0x').split('');
        Integer finalIndx = chars.size() - 1;
        for (Integer iter = 0; iter < chars.size(); iter++) {
            Integer base = (Integer)Math.pow((Double)16, Double.valueOf(finalIndx - iter));
            value += HEX_CHARS.indexOf(chars[iter]) * (Integer)base;
        }


        return value;
    }

    global Boolean equals(Object other) {

        if (other === this) {
            return true;
        }

        if (other instanceof UUIDv4) {
            return equals((UUIDv4)other);
        }

        if (other instanceof String) {
            try {
                return equals((String)other);
            }
            catch (UUIDException ex) {
                return false;
            }
        }

        return false;
    }

    global Boolean equals(UUIDv4 other) {
        if (other === this) {
            return true;
        }

        return this.UUIDValue.equalsIgnoreCase(other.UUIDValue);
    }

    global Boolean equals(String other) {
        return this.equals(UUIDv4.parse(other));
    }

    global Integer hashCode() {
        return this.UUIDValue.hashCode();
    }
}
