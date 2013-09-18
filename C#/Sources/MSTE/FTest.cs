using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Reflection;

namespace MSTEClasses {
    public partial class FTest : Form {
        public FTest() {
            InitializeComponent();
        }

        private void btnDecode_Click(object sender, EventArgs e) {

           try {
                txtErrors.Text = "";
                // Decodage
                //string res = "[\"MSTE0101\",59,\"CRC74FD101E\",1,\"Person\",6,\"firstname\",\"maried-to\",\"name\",\"birthday\",\"mother\",\"father\",20,3,50,4,0,5,\"Yves\",1,50,4,0,5,\"Claire\",1,9,1,2,5,\"Durand\",3,6,-207360000,2,9,5,3,6,-243820800,9,3,50,5,0,5,\"Lou\",4,9,3,2,9,5,3,6,552096000,5,9,1]";
                string res = "[\"MSTE0101\",57,\"CRCFAFCE14D\",0,12,\"PACT\",\"MID\",\"CARD\",\"RSRC\",\"path\",\"modificationDate\",\"isFolder\",\"basePath\",\"STAT\",\"INAM\",\"OPTS\",\"CTXCLASS\",8,7,0,5,\"home\",1,3,8,2,9,1,3,20,1,8,4,4,5,\"z\",5,6,1349681026,6,3,0,7,5,\"_main_/interfaces/main@home\",8,3,2,9,5,\"main\",10,8,1,11,5,\"XNetInitialContext\"]";
                if (txtDecode.Text == "") {
                    txtDecode.Text = res;
                }

                object theObj = MSTE.decode(res, new Dictionary<string, object>() {
                   {MSTEDecoder.OPT_VALID_CRC, false},
                   {MSTEDecoder.OPT_UNKNOWN_USER_CLASS, true},
                   {MSTEDecoder.OPT_USER_CLASS, new Dictionary<string, string>() { {"Person", "MSTEClasses.Person"}} }
                });

                txtDecoded.Text = "";
                txtErrors.Text += "-----------------------------------" + Environment.NewLine + MSTE.log;

                try {
                   List<object> lstRes = (List<object>)theObj;
                   lstRes.ForEach(delegate(object o) {
                       try {
                           txtDecoded.Text += Environment.NewLine + ((Person)o).ToString();
                       }
                       catch (Exception ex1) {
                           txtDecoded.Text += Environment.NewLine + o.ToString();
                       }
                   });
                   txtDecoded.Text += "Nb Object in list = " + lstRes.Count;
                }
                catch (Exception ex) {
                    if (theObj != null) {
                        txtDecoded.Text += "Object décodé ";
                    }
                    else {
                        txtDecoded.Text += "Object non décodé ";
                    }
                }

                if (theObj != null) {
                    // encodage
                    res = MSTE.encode(theObj);
                    txtEncoded.Text = res;
                    txtErrors.Text += "-----------------------------------" + Environment.NewLine + MSTE.log;
                }
            }
            catch (Exception ex) {
                MSTE.logEvent("Erreur : " + ex.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e) {

        }
    }
}
