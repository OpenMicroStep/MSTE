﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace MSTEDemo {
    static class Program {
        /// <summary>
        /// Point d'entrée principal de l'application.
        /// </summary>
        [STAThread]
        static void Main(string[] args) {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new FTest(args));
        }
    }
}
