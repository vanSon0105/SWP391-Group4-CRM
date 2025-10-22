package utils;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtils {
    private static final int WORKLOAD = 12;

    private PasswordUtils() {
    }

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("Password must not be null");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(WORKLOAD));
    }

    public static boolean verifyPassword(String password, String passwordDB) {
        if (password == null || passwordDB == null || passwordDB.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(password, passwordDB);
        } catch (IllegalArgumentException ex) {
            return false;
        }
    }
}
