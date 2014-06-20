﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Reflection;
using System.IO;
using MSTEFramework;

namespace MSTEDemo {

    public partial class FTest : Form {

        string projectPath = "";
        public FTest(string[] args) {
            InitializeComponent();
            // Array.IndexOf(arr, var)
            if (args.Contains("DEMO_MODE")){
                btnTest.Visible = true;
            }
        }

        private void processMSTE(string res) {

        }


        private void myToString(ref string res, object o, string step, ref List<object> objRefs) {
                if (o.GetType() == typeof(List<object>)) {
                    List<object> lstObj = (List<object>)o;
                    foreach (object entry in lstObj) {
                        objRefs.Add(entry);
                        res = res + Environment.NewLine + step;
                        this.myToString(ref res, entry, step + step, ref objRefs);
                    }
                }
                else if (o.GetType() == typeof(Dictionary<string, object>)) {
                    Dictionary<string, object> lstObj = (Dictionary<string, object>)o;
                    foreach (KeyValuePair<string, object> entry in lstObj) {

                        res += Environment.NewLine + step;
                        res += entry.Key + " : ";
                        if (entry.Value.GetType() == typeof(Dictionary<string, object>)) {
                            if (objRefs.IndexOf(entry.Value) >= 0) {
                                res += "Referenced Object";
                            }

                        }
                        else {
                            //res += entry.Value.ToString();
                            this.myToString(ref res, entry.Value, step + step, ref objRefs);
                        }
                    }
                }
                else {
                    res += o.ToString();
                }
        }

        private void processMSTE(sbyte[] res) { 
        
           try {
                object theObj = MSTE.decode(res, new Dictionary<string, object>() {
                   {MSTEDecoder.OPT_VALID_CRC, false},
                   {MSTEDecoder.OPT_UNKNOWN_USER_CLASS, true},
                   {MSTEDecoder.OPT_USER_CLASS, new Dictionary<string, string>() { 
                        {"Person", "MSTEDemo.Person"},
                        {"Person2", "MSTEDemo.Person2"},
                        {"XVar", "MSTEDemo.XVar"}
                   }}
                });

                txtDecoded.Text = "";
                txtLog.Text += "---------------------------------------------------------------------------------------------------------" + Environment.NewLine + MSTE.log;

				try {
                    string resToString = "";
                    List<object> objRefs = new List<object>();
                    this.myToString(ref resToString, theObj,"--",ref objRefs);
                    txtDecoded.Text = resToString;

                    //List<object> lstRes = (List<object>)theObj;
                    //lstRes.ForEach(delegate(object o) {
                    //    try {
                    //        txtDecoded.Text += ((Person)o).ToString();
                    //    }
                    //    catch (Exception ex1) {
                    //        Console.WriteLine(ex1.Message);
                    //        txtDecoded.Text += o.ToString();
                    //    }
                    //});
                    //txtDecoded.Text += "Nb Object in list = " + lstRes.Count;
				}
				catch (Exception ex) {
                    Console.WriteLine(ex.Message);
					if (theObj != null) {
						txtDecoded.Text += "Object décodé ";
					}
					else {
						txtDecoded.Text += "Object non décodé ";
					}
				}

                if (theObj != null) {
                    // encodage
                    string eRes = MSTE.encode(theObj);
                    txtEncoded.Text = eRes;
                    txtLog.Text += "---------------------------------------------------------------------------------------------------------" + Environment.NewLine + MSTE.log;
                }
                
               // -------------------------------------------------------------
               // Console Test 
                //Dictionary<string, object> dict = new Dictionary<string, object>();
                //dict["to\to"] = "titi";
                //dict["tutu"] = "tata";
                
                //res = MSTE.encode(dict);
                //Console.WriteLine(res);
            }
            catch (Exception ex) {
                MSTE.logEvent("Erreur : " + ex.ToString());
            }
        }

        private void btnProcess_Click(object sender, EventArgs e) {
            try {
                this.initDisplayForProcess();
                //string filePath = projectPath + "\\MSTE_Example-ASCII7.txt";
                if (txtFilePath.Text == "" || !File.Exists(txtFilePath.Text)) {
                    btnFile_Click(sender, null);
                }
                txtDecode.Text = File.ReadAllText(txtFilePath.Text, Encoding.UTF8);
                byte[] bytes = File.ReadAllBytes(txtFilePath.Text);
                sbyte[] sbytes = new sbyte[bytes.Length];
                for (int i = 0; i < bytes.Length; i++) {
                    sbytes[i] = (sbyte)bytes[i];
                }
                this.processMSTE(sbytes);
            }
            catch (Exception ex) {
                MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message);
            }
        }

        private void FTest_Load(object sender, EventArgs e) {

            Assembly ass = Assembly.GetExecutingAssembly();
            this.projectPath = System.IO.Path.GetDirectoryName(ass.Location);
#if DEBUG
            this.projectPath = projectPath.Replace("\\bin\\Debug", "");
#endif
            //string filePath = projectPath + "\\MSTE_Example-UTF8.txt";
            //string filePath = projectPath + "\\MSTE_Example-ASCII7.txt";
            //string filePath = projectPath + "\\UTF8-2.txt";
            string filePath = projectPath + "\\MSTE_Example2-UTF8.txt";
            if (File.Exists(filePath)) {
                txtFilePath.Text = filePath;
            }
        }

        private void btnFile_Click(object sender, EventArgs e) {
            //Directory.GetParent(Directory.GetCurrentDirectory()).Parent.FullName;
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            if (!Directory.Exists(this.projectPath)) {
                this.projectPath = Directory.GetCurrentDirectory();
            }
            openFileDialog1.InitialDirectory = this.projectPath;
            openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            openFileDialog1.FilterIndex = 2;
            openFileDialog1.RestoreDirectory = true;

            if (openFileDialog1.ShowDialog() == DialogResult.OK) {
                try {
                    //string filePath = projectPath + "\\MSTE_Example-ASCII7.txt";
                    txtFilePath.Text = openFileDialog1.FileName;
                }
                catch (Exception ex) {
                    MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message);
                }
            }
            this.initDisplayForProcess();
        }

        private void initDisplayForProcess() {
            txtDecoded.Text = "";
            txtEncoded.Text = "";
            txtLog.Text = "";
        }

        private void btnTest_Click(object sender, EventArgs e) {
            //DateTime dtLocal = DateTime.Now;
            //DateTime dtUtc = DateTime.UtcNow;
            //Console.WriteLine("Local : " + DateTime.Now);
            //Console.WriteLine("UTC : " + DateTime.UtcNow);
            //Console.WriteLine("Local Kind : " + dtLocal.Kind);
            //Console.WriteLine("UTC Kind : " + dtUtc.Kind);
            //Console.WriteLine("------ Local ");
            //Console.WriteLine("Local time : " + dtLocal.ToLocalTime());
            //Console.WriteLine("UTC time : " + dtLocal.ToUniversalTime());
            //Console.WriteLine("------ UTC ");
            //Console.WriteLine("Local time : " + dtUtc.ToLocalTime());
            //Console.WriteLine("UTC time : " + dtUtc.ToUniversalTime());
            //Console.WriteLine(UnixEpoch.getEpochTime(DateTime.Now));
            //Console.WriteLine("------ EPOCH ");
            //Console.WriteLine("UTC time : " + UnixEpoch.getEpochTime(new DateTime(2014, 6, 19, 16, 44, 13, DateTimeKind.Utc)));
            //Console.WriteLine("Local time : " + UnixEpoch.getEpochTime(new DateTime(2014, 6, 19, 16, 44, 13, DateTimeKind.Local)));
            //Console.WriteLine("None : " + UnixEpoch.getEpochTime(new DateTime(2014, 6, 19, 16, 44, 13, DateTimeKind.Unspecified)));
            //Console.WriteLine("DT : " + UnixEpoch.getEpochTime(new DateTime(2014, 6, 19, 16, 44, 13)));

            List<object> theObj = new List<object>();
            theObj.Add(new DateTime(2014, 6, 19, 16, 44, 13).ToUniversalTime());
            theObj.Add(new DateTime(2014, 6, 19, 16, 44, 13));
            string eRes ="", eRes2="";
            if (theObj != null) {
                // encodage
                eRes = MSTE.encode(theObj);
                Console.WriteLine(eRes);
            }
            object theObjD= MSTE.decode(eRes, new Dictionary<string, object>() {});
            Console.WriteLine(theObjD);

            if (theObjD != null) {
                // encodage
                eRes2 = MSTE.encode(theObjD);
                Console.WriteLine(eRes2);
            }
        }
    }
    

}
