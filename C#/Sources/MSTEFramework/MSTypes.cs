using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework {

    public class UnixEpoch {

        public static DateTime? getDateTime(long unixTimeStamp) {
            try {
                DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
                dt = dt.AddSeconds(Convert.ToDouble(unixTimeStamp));
                return dt;
            }
            catch {
                return null;
            }
        }

        public static long? getEpochTim(DateTime dt) {
            try {
                DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
                TimeSpan diff = dt - origin;
                return (long)Math.Floor(diff.TotalSeconds);
            }
            catch {
                return null;
            }
        }

    }
}
