using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework {

    public class UnixEpoch {

        protected static DateTime epochBase = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

        // DECODE 
        public static DateTime? getDateTime(long unixTimeStamp) {
            return getDateTime(unixTimeStamp, DateTimeKind.Local);
        }

        public static DateTime? getDateTime(long unixTimeStamp, DateTimeKind dtk) {
            try {
                DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, dtk);
                dt = dt.AddSeconds(Convert.ToDouble(unixTimeStamp));
                return dt;
            }
            catch {
                return null;
            }
        }

        // ENCODE
        public static long? getEpochTime(DateTime dt) {
            return getEpochTime(dt, DateTimeKind.Local);
        }

        public static long? getEpochTime(DateTime dt, DateTimeKind dtk) {
            try {
                // method with DateTime calculation
                DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
                TimeSpan diff = dt - origin;
                return (long)Math.Floor(diff.TotalSeconds);
            }
            catch {
                return null;
            }
        }

    }
}
