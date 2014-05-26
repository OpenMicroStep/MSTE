using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MSTEFramework;


namespace MSTEDemo {
    class XVar : MSTEFramework.MSTEInterface {
        public XVar() {
        }

        #region MSTEInterface Membres

        public void initWithDictionary(Dictionary<string, object> dict) { //<string, object> dict) {
            //string fn = dict.ContainsKey("firstname") ? (string)dict["firstname"] : "";
            //Person mt = dict.ContainsKey("maried-to") ? (Person)dict["maried-to"] : null;
            //string n = dict.ContainsKey("name") ? (string)dict["name"] : "";
            //DateTime bd = dict.ContainsKey("birthday") ? (DateTime)dict["birthday"] : DateTime.MinValue;
            //Person m = dict.ContainsKey("mother") ? (Person)dict["mother"] : null;
            //Person f = dict.ContainsKey("father") ? (Person)dict["father"] : null;
            
            //this.firstName = fn;
            //this.mariedTo = mt;
            //this.name = n;
            //this.birthday = bd;
            //this.mother = m;
            //this.father = f;
        }

        public Dictionary<string, object> Snapshot() {
            Dictionary<string, object> dict = new Dictionary<string, object>();

            //MSCouple cp2 = new MSCouple();
            //cp2.FirstMember = this.firstName;
            //dict["firstname"] = cp2;

            //if (this.mariedTo != null) {
            //    MSCouple cp4 = new MSCouple();
            //    cp4.FirstMember = this.mariedTo;
            //    dict["maried-to"] = cp4;
            //}

            //MSCouple cp1 = new MSCouple();
            //cp1.FirstMember = this.name;
            //dict["name"] = cp1;

            //MSCouple cp3 = new MSCouple();
            //cp3.FirstMember = this.birthday;
            //dict["birthday"] = cp3;

            //if (this.father != null) {
            //    MSCouple cp5 = new MSCouple();
            //    cp5.FirstMember = this.father;
            //    dict["father"] = cp5;
            //}

            //if (this.mother != null) {
            //    MSCouple cp6 = new MSCouple();
            //    cp6.FirstMember = this.mother;
            //    dict["mother"] = cp6;
            //}

            return dict;
        }

        #endregion
    }
}
