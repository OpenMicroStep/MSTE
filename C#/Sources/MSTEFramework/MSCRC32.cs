﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MSTEFramework 
{
    class MSCRC32 
    {
        #region Constructor & Destructor

        public MSCRC32() 
        {
        }
        
        ~MSCRC32() 
        {
        }

        #endregion

        #region Public static methods

        // put your own methods, class methods or constructors here
        public static string getCRC(string theFile) 
        {
            sbyte[] bytes = MSTE.stringToSbyteArray(theFile);
            int crc = unchecked((int)0xffffffff);
            foreach (sbyte b in bytes) 
            {
                crc = ((int)((uint)crc >> 8)) ^ __table[(crc ^ b) & 0xff];
            }
            crc = (int) (crc ^ 0xffffffff);
            return crc.ToString("x").PadLeft(8,'0');
        }

        #endregion

        #region Private attributes

        private static int[] __table = new int[] { 0x00000000, 0x77073096, unchecked((int)0xee0e612c), unchecked((int)0x990951ba), 0x076dc419, 0x706af48f, unchecked((int)0xe963a535), unchecked((int)0x9e6495a3), 0x0edb8832, 0x79dcb8a4, unchecked((int)0xe0d5e91e), unchecked((int)0x97d2d988), 0x09b64c2b, 0x7eb17cbd, unchecked((int)0xe7b82d07), unchecked((int)0x90bf1d91), 0x1db71064, 0x6ab020f2, unchecked((int)0xf3b97148), unchecked((int)0x84be41de), 0x1adad47d, 0x6ddde4eb, unchecked((int)0xf4d4b551), unchecked((int)0x83d385c7), 0x136c9856, 0x646ba8c0, unchecked((int)0xfd62f97a), unchecked((int)0x8a65c9ec), 0x14015c4f, 0x63066cd9, unchecked((int)0xfa0f3d63), unchecked((int)0x8d080df5), 0x3b6e20c8, 0x4c69105e, unchecked((int)0xd56041e4), unchecked((int)0xa2677172), 0x3c03e4d1, 0x4b04d447, unchecked((int)0xd20d85fd), unchecked((int)0xa50ab56b), 0x35b5a8fa, 0x42b2986c, unchecked((int)0xdbbbc9d6), unchecked((int)0xacbcf940), 0x32d86ce3, 0x45df5c75, unchecked((int)0xdcd60dcf), unchecked((int)0xabd13d59), 0x26d930ac, 0x51de003a, unchecked((int)0xc8d75180), unchecked((int)0xbfd06116), 0x21b4f4b5, 0x56b3c423, unchecked((int)0xcfba9599), unchecked((int)0xb8bda50f), 0x2802b89e, 0x5f058808, unchecked((int)0xc60cd9b2), unchecked((int)0xb10be924), 0x2f6f7c87, 0x58684c11, unchecked((int)0xc1611dab), unchecked((int)0xb6662d3d), 0x76dc4190, 0x01db7106, unchecked((int)0x98d220bc), unchecked((int)0xefd5102a), 0x71b18589, 0x06b6b51f, unchecked((int)0x9fbfe4a5), unchecked((int)0xe8b8d433), 0x7807c9a2, 0x0f00f934, unchecked((int)0x9609a88e), unchecked((int)0xe10e9818), 0x7f6a0dbb, 0x086d3d2d, unchecked((int)0x91646c97), unchecked((int)0xe6635c01), 0x6b6b51f4, 0x1c6c6162, unchecked((int)0x856530d8), unchecked((int)0xf262004e), 0x6c0695ed, 0x1b01a57b, unchecked((int)0x8208f4c1), unchecked((int)0xf50fc457), 0x65b0d9c6, 0x12b7e950, unchecked((int)0x8bbeb8ea), unchecked((int)0xfcb9887c), 0x62dd1ddf, 0x15da2d49, unchecked((int)0x8cd37cf3), unchecked((int)0xfbd44c65), 0x4db26158, 0x3ab551ce, unchecked((int)0xa3bc0074), unchecked((int)0xd4bb30e2), 0x4adfa541, 0x3dd895d7, unchecked((int)0xa4d1c46d), unchecked((int)0xd3d6f4fb), 0x4369e96a, 0x346ed9fc, unchecked((int)0xad678846), unchecked((int)0xda60b8d0), 0x44042d73, 0x33031de5, unchecked((int)0xaa0a4c5f), unchecked((int)0xdd0d7cc9), 0x5005713c, 0x270241aa, unchecked((int)0xbe0b1010), unchecked((int)0xc90c2086), 0x5768b525, 0x206f85b3, unchecked((int)0xb966d409), unchecked((int)0xce61e49f), 0x5edef90e, 0x29d9c998, unchecked((int)0xb0d09822), unchecked((int)0xc7d7a8b4), 0x59b33d17, 0x2eb40d81, unchecked((int)0xb7bd5c3b), unchecked((int)0xc0ba6cad), unchecked((int)0xedb88320), unchecked((int)0x9abfb3b6), 0x03b6e20c, 0x74b1d29a, unchecked((int)0xead54739), unchecked((int)0x9dd277af), 0x04db2615, 0x73dc1683, unchecked((int)0xe3630b12), unchecked((int)0x94643b84), 0x0d6d6a3e, 0x7a6a5aa8, unchecked((int)0xe40ecf0b), unchecked((int)0x9309ff9d), 0x0a00ae27, 0x7d079eb1, unchecked((int)0xf00f9344), unchecked((int)0x8708a3d2), 0x1e01f268, 0x6906c2fe, unchecked((int)0xf762575d), unchecked((int)0x806567cb), 0x196c3671, 0x6e6b06e7, unchecked((int)0xfed41b76), unchecked((int)0x89d32be0), 0x10da7a5a, 0x67dd4acc, unchecked((int)0xf9b9df6f), unchecked((int)0x8ebeeff9), 0x17b7be43, 0x60b08ed5, unchecked((int)0xd6d6a3e8), unchecked((int)0xa1d1937e), 0x38d8c2c4, 0x4fdff252, unchecked((int)0xd1bb67f1), unchecked((int)0xa6bc5767), 0x3fb506dd, 0x48b2364b, unchecked((int)0xd80d2bda), unchecked((int)0xaf0a1b4c), 0x36034af6, 0x41047a60, unchecked((int)0xdf60efc3), unchecked((int)0xa867df55), 0x316e8eef, 0x4669be79, unchecked((int)0xcb61b38c), unchecked((int)0xbc66831a), 0x256fd2a0, 0x5268e236, unchecked((int)0xcc0c7795), unchecked((int)0xbb0b4703), 0x220216b9, 0x5505262f, unchecked((int)0xc5ba3bbe), unchecked((int)0xb2bd0b28), 0x2bb45a92, 0x5cb36a04, unchecked((int)0xc2d7ffa7), unchecked((int)0xb5d0cf31), 0x2cd99e8b, 0x5bdeae1d, unchecked((int)0x9b64c2b0), unchecked((int)0xec63f226), 0x756aa39c, 0x026d930a, unchecked((int)0x9c0906a9), unchecked((int)0xeb0e363f), 0x72076785, 0x05005713, unchecked((int)0x95bf4a82), unchecked((int)0xe2b87a14), 0x7bb12bae, 0x0cb61b38, unchecked((int)0x92d28e9b), unchecked((int)0xe5d5be0d), 0x7cdcefb7, 0x0bdbdf21, unchecked((int)0x86d3d2d4), unchecked((int)0xf1d4e242), 0x68ddb3f8, 0x1fda836e, unchecked((int)0x81be16cd), unchecked((int)0xf6b9265b), 0x6fb077e1, 0x18b74777, unchecked((int)0x88085ae6), unchecked((int)0xff0f6a70), 0x66063bca, 0x11010b5c, unchecked((int)0x8f659eff), unchecked((int)0xf862ae69), 0x616bffd3, 0x166ccf45, unchecked((int)0xa00ae278), unchecked((int)0xd70dd2ee), 0x4e048354, 0x3903b3c2, unchecked((int)0xa7672661), unchecked((int)0xd06016f7), 0x4969474d, 0x3e6e77db, unchecked((int)0xaed16a4a), unchecked((int)0xd9d65adc), 0x40df0b66, 0x37d83bf0, unchecked((int)0xa9bcae53), unchecked((int)0xdebb9ec5), 0x47b2cf7f, 0x30b5ffe9, unchecked((int)0xbdbdf21c), unchecked((int)0xcabac28a), 0x53b39330, 0x24b4a3a6, unchecked((int)0xbad03605), unchecked((int)0xcdd70693), 0x54de5729, 0x23d967bf, unchecked((int)0xb3667a2e), unchecked((int)0xc4614ab8), 0x5d681b02, 0x2a6f2b94, unchecked((int)0xb40bbe37), unchecked((int)0xc30c8ea1), 0x5a05df1b, 0x2d02ef8d };

        #endregion
    }
 }
