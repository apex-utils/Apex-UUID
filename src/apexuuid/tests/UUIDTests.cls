@isTest
public class UUIDTests {

    @isTest
    static void test_happyPath() {
        // arrange
        Pattern uuidPattern = Pattern.compile(UUIDv4.UUID_REGEX);

        // act
        UUIDv4 result = new UUIDv4();
        String rStr = result.toString();
        System.debug(rStr);

        // assert
        Matcher matcher = uuidPattern.matcher(result.toString());
        System.assert(matcher.matches());
    }

    @isTest
    static void test_valueOf_happyPath_noBracket() {
        // arrange
        String uuidStr = '35B0DF5D-3564-4737-90D0-25B43E0081BC';
        String expected = '35B0DF5D-3564-4737-90D0-25B43E0081BC';

        // act
        UUIDv4 result = UUIDv4.valueOf(uuidStr);

        // assert
        System.assertEquals(expected, result.toString());
    }

    @isTest
    static void test_valueOf_happyPath_withBracket() {
        // arrange
        String uuidStr = '{35B0DF5D-3564-4737-90D0-25B43E0081BC}';
        String expected = '35B0DF5D-3564-4737-90D0-25B43E0081BC';

        // act
        UUIDv4 result = UUIDv4.valueOf(uuidStr);

        // assert
        System.assertEquals(expected, result.toString());
    }

    @isTest
    static void test_valueOf_happyPath_withParen() {
        // arrange
        String uuidStr = '(35B0DF5D-3564-4737-90D0-25B43E0081BC)';
        String expected = '35B0DF5D-3564-4737-90D0-25B43E0081BC';

        // act
        UUIDv4 result = UUIDv4.valueOf(uuidStr);

        // assert
        System.assertEquals(expected, result.toString());
    }

    @isTest
    static void test_valueOf_happyPath_noDashes() {
        // arrange
        String uuidStr = '35B0DF5D3564473790D025B43E0081BC';
        String expected = '35B0DF5D-3564-4737-90D0-25B43E0081BC';

        // act
        UUIDv4 result = UUIDv4.valueOf(uuidStr);

        // assert
        System.assertEquals(expected, result.toString());
    }

    @isTest
    static void test_valueOf_inputInvalidAgainstRegex() {
        // arrange
        String input = 'askfuhaiwuehfgajxfasjhdf';

        // act
        try {
            UUIDv4.valueOf(input);

            // assert
            System.assert(false, 'exception expected but none thrown');
        }
        catch (UUIDv4.UUIDException UUIDEx) {
            System.assert(true, 'exception expected');
        }
        catch (Exception ex) {
            System.assert(false, 'exception expected, but not this type ' + ex);
        }
    }

    @isTest
    static void test_hex2int_0x40() {
        // arrange
        String hex = '0x40';
        Integer expected = 64;

        // act
        Integer result = UUIDv4.hex2int(hex);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_hex2int_0x00000000000() {
        // arrange
        String hex = '0x00000000000';
        Integer expected = 0;

        // act
        Integer result = UUIDv4.hex2int(hex);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_hex2int_0x12af() {
        // arrange
        String hex = '0x12af';
        Integer expected = 4783;

        // act
        Integer result = UUIDv4.hex2int(hex);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_int2hex_0() {
        // arrange
        Integer value = 0;
        String expected = '0x0';

        // act
        String result = UUIDv4.int2hex(value);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_int2hex_1000() {
        // arrange
        Integer value = 1000;
        String expected = '0x3E8';

        // act
        String result = UUIDv4.int2hex(value);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_int2hex_4783() {
        // arrange
        Integer value = 4783;
        String expected = '0x12AF';

        // act
        String result = UUIDv4.int2hex(value);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_int2hex_2147483646() {
        // arrange
        Integer value = 2147483646;
        String expected = '0x7FFFFFFE';

        // act
        String result = UUIDv4.int2hex(value);

        // assert
        System.assertEquals(expected, result);
    }

    @isTest
    static void test_equality_exactObjectEquality() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        Object g2 = g1;

        // act
        Boolean result = g1.equals(g2);

        // assert
        System.assert(result);
    }

    @isTest
    static void test_equality_exactUUIDEquality() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        UUIDv4 g2 = g1;

        // act
        Boolean result = g1.equals(g2);

        // assert
        System.assert(result);
    }

    @isTest
    static void test_equality_objectNotUUID() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        Object g2 = 'asdhlfkjasdf';

        // act
        Boolean result = g1.equals(g2);

        // assert
        System.assert(!result);
    }

    @isTest
    static void test_equality_objectIsUUID() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        Object g2 = UUIDv4.valueOf(g1.toString());

        // act
        Boolean result = g1.equals(g2);

        // assert
        System.assert(result);
    }

    @isTest
    static void test_equality_UUIDIsEqual() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        UUIDv4 g2 = UUIDv4.valueOf(g1.toString());

        // act
        Boolean result = g1.equals(g2);

        // assert
        System.assert(result);
    }

    @isTest
    static void test_hashCode_UUIDIsEqual() {
        // arrange
        UUIDv4 g1 = new UUIDv4();
        UUIDv4 g2 = UUIDv4.valueOf(g1.toString());

        // act
        Boolean result = g1.hashCode() == g2.hashCode();

        // assert
        System.assert(result);
    }
}
