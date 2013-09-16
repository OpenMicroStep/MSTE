using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Reflection;

namespace MSTE {
    public partial class FTest : Form {
        public FTest() {
            InitializeComponent();
        }

        private void btnDecode_Click(object sender, EventArgs e) {

           try {

                string res = "[\"MSTE0101\",59,\"CRCC41DBEF3\",1,\"MSTE.Person\",6,\"name\",\"firstName\",\"birthday\",\"maried-to\",\"father\",\"mother\",20,3,50,4,0,5,\"Durand\",1,5,\"Yves\",2,6,-1222131600,3,51,4, 0,9,2,1,5,\"Claire\",2,6,-1185667200,3,27,1,9,5,50,5,0,9,2,1,5,\"Lou\",2,6,-426214800,4,9,1,5,9,5]";
                if (txtDecode.Text != "") {
                    res = txtDecode.Text;
                }

                object theObj = MSTE.decode(res, new Dictionary<string, object>() {
	                {MSTEDecoder.OPT_VALID_CRC, false},
	                {MSTEDecoder.OPT_UNKNOWN_USER_CLASS, true},
	                {MSTEDecoder.OPT_USER_CLASS, new Dictionary<string, string>() { {"Person", "MSTE.Person"}} }
	            });

                txtDecoded.Text = "";
                
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
                //res = encoder.encodeRootObject(testObj);
            }
            catch (Exception ex) {
                Console.WriteLine("Erreur : " + ex.ToString());
            }
        }
    }
}
