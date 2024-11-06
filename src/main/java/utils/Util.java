package utils;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Util {

    private static final DecimalFormat decimalFormat = new DecimalFormat("##,###");
    private static final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat fullDateTimeFormat = new SimpleDateFormat("yyyy:MM:dd HH:mm");
    
	/**
	 * 객체가 null이면 빈 문자열을 반환한다.
	 * @param value 객체
	 * @return 빈 문자열 혹은 객체
	 */
	public static Object nullToBlank(Object value) {
		if (value == null) {
			return "";
		}
		return value;
	}
    
    /**
     * 정수를 금융통화 형식의 문자열로 반환한다.
     * @param value 정수
     * @return 3자리마다 ,가 포함된 문자열
     */
    public static String toCurrency(int value) {
        return decimalFormat.format(value);
    }

    /**
     * 문자열을 전달받아서 정수로 변환해서 반환한다.
     * @param value 문자열
     * @param defaultValue 기본값
     * @return 정수, 문자열이 null, 빈문자열, 공백문자,
     *               숫자가 아닌 값이 포함된 문자열인 경우 defaultValue가 반환된다.
     */
    public static int toInt(String value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        if (value.isBlank()) {
            return defaultValue;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    /**
     * 문자열을 전달받아서 정수로 변환 후 반환한다.
     * @param value
     * @return 정수. 기본값이 0인 경우다.
     */
    public static int toInt(String value) {
        return toInt(value, 0);
    }

    /**
     * ceil 값을 계산해서 반환한다.
     * @param x 숫자
     * @param y 숫자
     * @return ceil 값
     */
    public static int ceil(int x, int y) {
        final int q = x / y;
        if ((x ^ y) >= 0 && (q * y != x)) {
            return q + 1;
        }
        return q;
    }

    /**
     * 날짜를 포맷하여 문자열로 반환한다.
     * 24시간 이내이면 시간으로, 그 이상이면 날짜로 포맷된다.
     * @param date 날짜
     * @return 포맷된 문자열
     */
    public static String formatDate(Date date) {
        long diffInMillis = new Date().getTime() - date.getTime();
        long diffInHours = TimeUnit.MILLISECONDS.toHours(diffInMillis);

        if (diffInHours < 24) {
            return timeFormat.format(date);
        } else {
            return dateFormat.format(date);
        }
    }
    
    /**
     * 날짜를 yyyy:MM:dd HH:mm 형식으로 변환
     * @param date
     * @return
     */
    public static String formatFullDateTime(Date date) {
        if (date == null) {
            return "";
        }
        return fullDateTimeFormat.format(date);
    }
}
